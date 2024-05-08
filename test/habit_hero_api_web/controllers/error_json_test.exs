defmodule HabitHeroApiWeb.ErrorJSONTest do
  use HabitHeroApiWeb.ConnCase, async: true

  test "renders 404" do
    %{errors: %{detail: "Not Found"}} = HabitHeroApiWeb.ErrorJSON.render("404.json", %{})
  end

  test "renders 500" do
    %{errors: %{detail: "Internal Server Error"}} =
      HabitHeroApiWeb.ErrorJSON.render("500.json", %{})
  end
end
