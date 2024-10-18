defmodule TimeManagerWeb.Plugs.Authenticate do
  import Plug.Conn  # Plug.Conn contient `put_status/2` et `send_resp/3`
  alias TimeManager.Token  # Importer le module Token

  def init(default), do: default

  def call(conn, _opts) do
    # Vérification du token JWT dans l'en-tête Authorization
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Token.verify_and_validate_token(token) do
      # Si le token est valide, assigner les informations de l'utilisateur
      conn
      |> assign(:current_user, claims)
    else
      # Si le token est invalide ou absent, renvoyer une réponse 401 Unauthorized
      _ ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("application/json")  # Définir le type de contenu comme JSON
        |> send_resp(401, ~s({"error": "Unauthorized access"}))  # Envoyer une réponse JSON
        |> halt()  # Stopper la requête
    end
  end
end
