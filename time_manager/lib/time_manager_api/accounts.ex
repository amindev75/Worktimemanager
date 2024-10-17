defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.User
  alias TimeManager.TimeManagement.{Clock, Workingtime}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """


def list_users_with_clocks do
  User
  |> preload(:clock)  # Précharge la clock unique pour chaque utilisateur
  |> Repo.all()
end





  def list_users_with_params(email, username) do
    IO.puts("Recherche de l'utilisateur avec email: #{email} ou username: #{username}")

    users = Repo.all(
      from u in User,
      where: u.email == ^email or u.username == ^username
    )
    # Affiche la clé secrète
secret_key_base = Application.get_env(:time_manager, TimeManagerWeb.Endpoint)[:secret_key_base]
IO.puts("Secret Key Base: #{secret_key_base}")

# Affiche la clé de signature
signing_key = Application.get_env(:time_manager_api, TimeManager.Authentication)[:signing_key]
IO.puts("Default Signer: #{signing_key}")


    IO.puts("Résultat de la requête: #{inspect(users)}")

    case users do
      [] ->
        IO.puts("Aucun utilisateur trouvé.")
        {:error, "Aucun utilisateur trouvé avec cet email ou nom d'utilisateur."}
      _ ->
        IO.puts("Utilisateurs trouvés : #{inspect(users)}")
        {:ok, users}
    end
  end



  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
def create_user(attrs \\ %{}, clock_attrs \\ %{}) do
  Repo.transaction(fn ->
    {:ok, %User{} = user} =
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()

    clock_attrs = Map.put(clock_attrs, :time, DateTime.utc_now())

    case create_clock(Map.put(clock_attrs, :user_id, user.id)) do
      {:ok, _clock} ->
        IO.puts("Horloge créée avec succès pour l'utilisateur avec ID: #{user.id}")
      {:error, changeset} ->
        IO.puts("Échec de la création de l'horloge : #{inspect(changeset)}")
    end

    user
  end)
end

defp create_clock(attrs \\ %{}) do
  %Clock{}
  |> Clock.changeset(attrs)
  |> Repo.insert()
end



  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
