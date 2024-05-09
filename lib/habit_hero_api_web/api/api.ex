defmodule HabitHeroApiWeb.API do
  @spec gen_hash(String.t()) :: String.t()
  def gen_hash(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
