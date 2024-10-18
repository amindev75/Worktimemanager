defmodule TimeManagerWeb.SessionController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias Bcrypt  # Si tu utilises bcrypt_elixir
  import Joken

  def login(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by_email(email),
         true <- Bcrypt.verify_pass(password, user.password_hash) do

      extra_claims = %{user_id: user.id}

      # Génération du token avec le signataire par défaut
      {:ok, token, _claims} = Joken.generate_and_sign(extra_claims)

      conn
      |> put_status(:ok)
      |> render(TimeManagerWeb.SessionJSON, "login.json", %{token: token})
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> render(TimeManagerWeb.SessionJSON, "error.json", %{error: "Invalid credentials"})
    end
  end



  # Déconnexion de l'utilisateur
  def delete(conn, _params) do
    conn
    |> delete_resp_cookie("jwt")  # Supprime le cookie contenant le token JWT
    |> json(%{message: "Successfully logged out"})
  end
end
