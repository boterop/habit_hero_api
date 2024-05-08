defmodule HabitHeroApi.ApplicationTest do
  use ExUnit.Case, async: true
  alias HabitHeroApi.Application

  describe "config_change/3" do
    test "updates the endpoint configuration" do
      changed = %{some_key: "some_value"}
      removed = []

      :ok = Application.config_change(changed, %{}, removed)
    end

    test "handles empty changes and removals" do
      changed = %{}
      removed = []

      :ok = Application.config_change(changed, %{}, removed)
    end
  end
end
