defmodule TimeManagerWeb.SessionController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts
  alias TimeManager.Authentication
  alias Bcrypt  # Si tu utilises bcrypt_elixir

  def create(conn, %{"email" => email, "password" => password}) do
    IO.puts("Authentification avec email: #{email}")

    case Accounts.list_users_with_params(email, "") do
      {:ok, [user]} ->  # On s'attend à trouver un seul utilisateur correspondant
        IO.puts("Utilisateur trouvé : #{inspect(user)}")

        if Bcrypt.check_pass(user, password) do  # Modifié ici
          token = Authentication.generate_token(user)  # Génère le token JWT
          xsrf_token = Phoenix.Controller.get_csrf_token()  # Génère un token XSRF pour la protection CSRF

          # Renvoie le JWT dans un cookie sécurisé et le token XSRF dans la réponse JSON
          conn
          |> put_resp_cookie("jwt", token, http_only: true)  # Stocke le token JWT dans un cookie HTTP Only
          |> json(%{xsrf_token: xsrf_token})  # Retourne le token XSRF
        else
          IO.puts("Mot de passe incorrect.")
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid credentials"})
        end

      {:ok, []} ->  # Aucun utilisateur trouvé avec l'email
        IO.puts("Aucun utilisateur trouvé avec l'email.")
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def create(conn, %{"username" => username, "password" => password}) do
    IO.puts("Authentification avec username: #{username}")

    case Accounts.list_users_with_params("", username) do
      {:ok, [user]} ->  # On s'attend à trouver un seul utilisateur correspondant
        IO.puts("Utilisateur trouvé : #{inspect(user)}")

        if Bcrypt.check_pass(user, password) do  # Modifié ici
          token = Authentication.generate_token(user)
          xsrf_token = Phoenix.Controller.get_csrf_token()

          conn
          |> put_resp_cookie("jwt", token, http_only: true)
          |> json(%{xsrf_token: xsrf_token})
        else
          IO.puts("Mot de passe incorrect.")
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid credentials"})
        end

      {:ok, []} ->  # Aucun utilisateur trouvé avec le nom d'utilisateur
        IO.puts("Aucun utilisateur trouvé avec le nom d'utilisateur.")
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  # Déconnexion de l'utilisateur
  def delete(conn, _params) do
    conn
    |> delete_resp_cookie("jwt")  # Supprime le cookie contenant le token JWT
    |> json(%{message: "Successfully logged out"})
  end
end
