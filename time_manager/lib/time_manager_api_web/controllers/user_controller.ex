defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    IO.puts("Params reçus : #{inspect(params)}")

    case params do
      %{"email" => email, "username" => username} ->
        IO.puts("Filtrage par email : #{email} et username : #{username}")

        case Accounts.list_users_with_params(email, username) do
          {:ok, users} ->
            IO.puts("Nombre d'utilisateurs trouvés : #{length(users)}")
            render(conn, "index.json", users: users)

          {:error, message} ->
            IO.puts("Erreur : #{message}")
            conn
            |> put_status(:not_found)
            |> json(%{error: message})
        end

      _ ->
        IO.puts("Aucun paramètre de filtrage fourni. Récupération de tous les utilisateurs avec leurs clocks.")
        users = Accounts.list_users_with_clocks()
        IO.puts("Nombre d'utilisateurs récupérés : #{length(users)}")
        render(conn, "index.json", users: users)
    end
  end





  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)


    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
