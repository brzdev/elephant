defmodule Elephant.MainEntry do
  require Logger
  require Poison

  def handle_message(data) do
    data
    |> format_data
    |> bot_response
  end

  def format_data(map) do
    # Logger.info "formatting #{inspect json}"
    IO.puts ">>> data is #{inspect map}"
    case Elephant.Patient.find_patient(map["From"]) |> Elephant.Repo.one do
      nil ->
        new_user = true
      _ ->
        new_user = false
    end
    %{
      user_number: map["From"],
      body: map["Body"],
      new_user: new_user,
      twilio_number: map["To"],
      bot_step: "prompt_reply"
    }
    #take individual pieces from data ie the response packet from programmable sms and pass down the pipe
  end

  def bot_response(%{bot_step: "prompt_reply", new_user: true} = map) do
    # if map["From"] exists in DB, send them message of main menu
    # else send them a message and also start onboarding bot_response
    IO.puts ">>> formatted data is #{inspect map}"
    welcome_message = "Welcome to Elephant. Are you a provider or a patient?"
    Elephant.Twilex.Messenger.create("#{map.twilio_number}", "#{map.user_number}", welcome_message )
    %{map | bot_step: "onboarding"}
  end

  def bot_response(%{bot_step: "prompt_reply", new_user: false} = map) do
    # if map["From"] exists in DB, send them message of main menu
    # else send them a message and also start onboarding bot_response
    IO.puts ">>> formatted data is #{inspect map}"
    #bring in user's name from DB in line below and interpolate to add a more personal feel. also check if provider or patient and add a case

    welcome_message = "Welcome back to Elephant. What would you like to do? You can say 'New' to add a new patient, or 'Manage' to view existing patients."
    Elephant.Twilex.Messenger.create("#{map.twilio_number}", "#{map.user_number}", welcome_message )
  end

  @provider_or_patient ["provider", "patient", "Provider", "Patient"]

  def bot_response(%{bot_step: "onboarding", body: response} = map) when response in @provider_or_patient do
    # if map["From"] exists in DB, send them message of main menu
    # else send them a message and also start onboarding bot_response
    case response.downcase do
      "provider" ->
        #stuff
        message = "Terrific. What is your name?"
        Elephant.Twilex.Messenger.create("#{map.twilio_number}", "#{map.user_number}", message )
      "patient" ->
        #TODO more stuff, might not even need to exist. If a provider creates a patient, they should add patients number and that should be checked on welcome
    end
  end

end
