defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  import Joken


  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    case params do
      %{"email" => email, "username" => username} ->
        case Accounts.list_users_with_params(email, username) do
          {:ok, users} ->
            render(conn, "index.json", users: users)
          {:error, message} ->
            conn
            |> put_status(:not_found)
            |> json(%{error: message})
        end
      _ ->
        users = Accounts.list_users_with_clocks()

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

  def me(conn, _params) do
    # Récupérer le token JWT des en-têtes de la requête
    token = get_req_header(conn, "authorization")
            |> List.first()
            |> String.replace("Bearer ", "")


    signer = Joken.Signer.create("HS256", "your_secret_key")

    # Décoder et vérifier le token
    case Joken.verify_and_validate(token, signer) do
      {:ok, claims} ->
        user_id = claims["user_id"]
        user = Accounts.get_user!(user_id)

        conn
        |> put_status(:ok)
        |> json(%{user: user})

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid token", reason: reason})
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
