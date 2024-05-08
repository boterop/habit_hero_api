defmodule HabitHeroApiWeb.API.ErrorResponse.InvalidKey do
  defexception plug_status: 401, message: "Invalid API key"
end
