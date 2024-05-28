defmodule HabitHeroApi.AccountTest do
  use HabitHeroApi.DataCase

  alias HabitHeroApi.Account

  describe "users" do
    alias HabitHeroApi.Account.User

    import HabitHeroApi.AccountFixtures

    @invalid_attrs %{email: nil, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      %User{id: user_id} = user_fixture()
      %User{id: ^user_id} = Account.get_user!(user_id)
    end

    test "get_user_by_email!/1 returns the user with given email" do
      %User{id: user_id, email: email} = user_fixture()
      %User{id: ^user_id} = Account.get_user_by_email!(email)
    end

    test "create_user/1 with valid data creates a user" do
      email = "some_email@mail.com"
      password = "some password"
      valid_attrs = %{email: email, password: password}

      {:ok, %User{email: ^email, password: user_password}} = Account.create_user(valid_attrs)

      assert Bcrypt.verify_pass(password, user_password)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Account.create_user(%{email: "some invalid email", password: "some password"})
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      email = "some_updated_email@mail.com"
      password = "some updated password"
      update_attrs = %{email: email, password: password}

      {:ok, %User{email: ^email} = user} = Account.update_user(user, update_attrs)
      assert Bcrypt.verify_pass(password, user.password)
    end

    test "update_user/2 with invalid data returns error changeset" do
      %User{id: user_id} = user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user_id)
    end

    test "delete_user/1 deletes the user" do
      %User{id: user_id} = user = user_fixture()
      {:ok, %User{id: ^user_id}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user_id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
