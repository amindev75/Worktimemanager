defmodule TimeManagerWeb.Plugs.Authenticate do
  import Plug.Conn
  alias TimeManager.Token

  def init(default), do: default

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Token.verify_and_validate_token(token) do
      conn
      |> assign(:current_user, claims)
    else
      # Si le token est invalide ou absent, renvoyer une réponse 401 Unauthorized
      _ ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("application/json")
        |> send_resp(401, ~s({"error": "Unauthorized access"}))
        |> halt()
    end
  end
end
