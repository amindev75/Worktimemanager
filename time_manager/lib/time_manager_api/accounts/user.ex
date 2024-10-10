defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    has_many :workingtimes, TimeManager.TimeManagement.Workingtime, on_delete: :delete_all
    has_one :clocks, TimeManager.TimeManagement.Clock, on_delete: :delete_all
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end
end
