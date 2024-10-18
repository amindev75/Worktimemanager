defmodule TimeManager.Authentication do
  @doc """
  Génère un JWT pour l'utilisateur avec son ID et son rôle.
  """
  def generate_token(user) do
    claims = %{
      "user_id" => user.id,
      "role" => user.role
    }

    IO.puts("Génération du token pour l'utilisateur : #{user.id} avec le rôle : #{user.role}")

    # Création du signataire avec la clé directement dans le code
    signer = Joken.Signer.create("HS256", "WNnRq60fyH/BLMWMUjNnS1IxMyjhV7UofMnGCyHfmUmEAZAxUiyiGbbhaR9flryW")

    IO.puts("Signataire créé avec l'algorithme HS256 et la clé : WNnRq60fyH/BLMWMUjNnS1IxMyjhV7UofMnGCyHfmUmEAZAxUiyiGbbhaR9flryW")

    # Générer et signer le token avec le signataire
    token = Joken.encode_and_sign!(claims, signer)

    IO.puts("Token JWT généré : #{token}")

    token
  end
end
