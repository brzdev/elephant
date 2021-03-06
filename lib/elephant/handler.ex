defmodule Elephant.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts ">>> Warning #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] =
    request
    |> String.split("\n")
    |> List.first
    |> String.split(" ")
    IO.puts ">>> path is #{path}"
    %{method: method,
      path: path,
      resp_body: "",
      status: nil}
  end
  #
  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  def route(%{method: "GET", path: "/incoming-sms"} = conv) do
    conv = %{ conv | status: 200, text: conv.text}
    IO.puts ">>> received message and data is: #{inspect conv}"
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    conv = %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    conv = %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    file =
      Path.expand("./pages", __DIR__)
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} ->
        conv = %{ conv | status: 200, resp_body: content}
      {:error, :enouent} ->
        conv = %{ conv | status: 404, resp_body: ">>> File not found."}
      {:error, reason} ->
        conv = %{ conv | status: 500, resp_body: ">>> File Error: #{reason}"}
      end
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    conv = %{ conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{method: _method , path: path} = conv) do
    conv = %{ conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end



  request = """
  GET /wildthings HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept: */*
  """

  response = Elephant.Handler.handle(request)

  IO.puts response

  request = """
  GET /bears/1 HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept: */*
  """

  response = Elephant.Handler.handle(request)

  IO.puts response

  request = """
  GET /bigfoot HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept: */*
  """

  response = Elephant.Handler.handle(request)

  IO.puts response

  request = """
  GET /about HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept: */*
  """

  response = Elephant.Handler.handle(request)

  IO.puts response
