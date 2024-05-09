defmodule HabitHeroApiWeb.API do
  @moduledoc """
  This module contains functions related to API operations in the Habit Hero application.
  """

  @spec gen_hash(String.t()) :: String.t()
  def gen_hash(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
