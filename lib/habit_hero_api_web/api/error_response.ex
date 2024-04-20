defmodule HabitHeroApiWeb.API.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end
