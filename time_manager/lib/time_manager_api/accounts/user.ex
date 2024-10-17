defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles %{employe: 0, manager: 1, admin: 2}
  @valid_roles Map.values(@roles)

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :integer, default: @roles[:employe]

    has_many :workingtimes, TimeManager.TimeManagement.Workingtime, on_delete: :delete_all
    has_one :clock, TimeManager.TimeManagement.Clock, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_inclusion(:role, @valid_roles)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end
end
