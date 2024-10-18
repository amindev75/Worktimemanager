defmodule TimeManager.Token do
  alias Joken.Config
  alias Joken.Signer

  # Fonction pour vérifier et valider le token JWT
  def verify_and_validate_token(token) do
    # Utilise le signer par défaut configuré dans config.exs
    signer = Joken.Signer.parse_config(:default_signer)

    # Vérifier et décoder le token
    case Joken.verify(token, signer) do
      {:ok, claims} ->
        {:ok, claims}  # Retourner les claims si le token est valide

      {:error, reason} ->
        {:error, reason}  # Retourner l'erreur si le token est invalide
    end
  end
end
