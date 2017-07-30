defmodule Elephant.Router do
  use Plug.Router
  use Plug.Debugger, otp_app: :elephant
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json, :urlencoded]
  plug :match
  plug :dispatch

  get "/incoming-sms" do
    message = Elephant.MainEntry.handle_message(conn.params)
    # IO.puts ">>> params are #{inspect conn.params}"
    send_resp(conn, 200, "All good here!")
  end

  match _ do
    send_resp(conn, 404, "not_found")
  end
end
