defmodule HabitHeroApi.HabitsTest do
  use HabitHeroApi.DataCase

  alias HabitHeroApi.Habits

  describe "habits" do
    alias HabitHeroApi.Habits.Habit

    import HabitHeroApi.HabitsFixtures

    @invalid_attrs %{description: nil, difficulty: nil, done_image: nil, done_today: nil, end_date: nil, name: nil, notification_date: nil, notify: nil, order_index: nil, status: nil, times_done: nil, type: nil}

    test "list_habits/0 returns all habits" do
      habit = habit_fixture()
      assert Habits.list_habits() == [habit]
    end

    test "get_habit!/1 returns the habit with given id" do
      habit = habit_fixture()
      assert Habits.get_habit!(habit.id) == habit
    end

    test "create_habit/1 with valid data creates a habit" do
      valid_attrs = %{description: "some description", difficulty: :easy, done_image: "some done_image", done_today: true, end_date: ~N[2024-04-23 19:13:00], name: "some name", notification_date: ~N[2024-04-23 19:13:00], notify: :hourly, order_index: 42, status: :done, times_done: 42, type: :good}

      assert {:ok, %Habit{} = habit} = Habits.create_habit(valid_attrs)
      assert habit.description == "some description"
      assert habit.difficulty == :easy
      assert habit.done_image == "some done_image"
      assert habit.done_today == true
      assert habit.end_date == ~N[2024-04-23 19:13:00]
      assert habit.name == "some name"
      assert habit.notification_date == ~N[2024-04-23 19:13:00]
      assert habit.notify == :hourly
      assert habit.order_index == 42
      assert habit.status == :done
      assert habit.times_done == 42
      assert habit.type == :good
    end

    test "create_habit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Habits.create_habit(@invalid_attrs)
    end

    test "update_habit/2 with valid data updates the habit" do
      habit = habit_fixture()
      update_attrs = %{description: "some updated description", difficulty: :medium, done_image: "some updated done_image", done_today: false, end_date: ~N[2024-04-24 19:13:00], name: "some updated name", notification_date: ~N[2024-04-24 19:13:00], notify: :daily, order_index: 43, status: :canceled, times_done: 43, type: :bad}

      assert {:ok, %Habit{} = habit} = Habits.update_habit(habit, update_attrs)
      assert habit.description == "some updated description"
      assert habit.difficulty == :medium
      assert habit.done_image == "some updated done_image"
      assert habit.done_today == false
      assert habit.end_date == ~N[2024-04-24 19:13:00]
      assert habit.name == "some updated name"
      assert habit.notification_date == ~N[2024-04-24 19:13:00]
      assert habit.notify == :daily
      assert habit.order_index == 43
      assert habit.status == :canceled
      assert habit.times_done == 43
      assert habit.type == :bad
    end

    test "update_habit/2 with invalid data returns error changeset" do
      habit = habit_fixture()
      assert {:error, %Ecto.Changeset{}} = Habits.update_habit(habit, @invalid_attrs)
      assert habit == Habits.get_habit!(habit.id)
    end

    test "delete_habit/1 deletes the habit" do
      habit = habit_fixture()
      assert {:ok, %Habit{}} = Habits.delete_habit(habit)
      assert_raise Ecto.NoResultsError, fn -> Habits.get_habit!(habit.id) end
    end

    test "change_habit/1 returns a habit changeset" do
      habit = habit_fixture()
      assert %Ecto.Changeset{} = Habits.change_habit(habit)
    end
  end
end
