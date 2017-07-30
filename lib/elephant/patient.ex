defmodule Elephant.Patient do
  use Ecto.Schema
  import Ecto.Query

  schema "patient" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
    field :phone_number, :string
  end

  def changeset(patient, params \\ %{}) do
  patient
  |> Ecto.Changeset.cast(params, [:first_name, :last_name, :age])
  |> Ecto.Changeset.validate_required([:first_name, :last_name])
  end

  def find_patient(query \\ Elephant.Patient, phone_number) do
    from u in query,
    where: u.phone_number == ^phone_number,
    select: u
  end

end
