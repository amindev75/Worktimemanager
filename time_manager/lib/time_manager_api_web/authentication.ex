defmodule TimeManager.Authentication do
  use Joken.Config

  @doc """
  Génère un JWT pour l'utilisateur avec son ID et son rôle.
  """
  def generate_token(user) do
    claims = %{
      "user_id" => user.id,
      "role" => user.role
    }

    # Utiliser le signataire par défaut configuré dans config.exs
    Joken.generate_and_sign!(claims)
  end

  @doc """
  Vérifie la validité d'un token JWT et renvoie les données (claims) s'il est valide.
  """
  def verify_token(token) do
    # Utiliser le signataire par défaut configuré dans config.exs
    Joken.decode_and_verify(token)
  end
end
