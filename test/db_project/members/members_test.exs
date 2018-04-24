defmodule DbProject.MembersTest do
  use DbProject.DataCase

  alias DbProject.Members

  describe "members" do
    alias DbProject.Members.Member

    @valid_attrs %{github: "some github", name: "some name", surname: "some surname"}
    @update_attrs %{github: "some updated github", name: "some updated name", surname: "some updated surname"}
    @invalid_attrs %{name: nil, surname: nil}

    setup do
      Cachex.clear(:members_units_cache)
      Cachex.clear(:members_lists_cache)
      {:ok, %{}}
    end

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Members.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Members.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      assert {:ok, true} == Cachex.empty?(:members_units_cache)

      member = member_fixture()
      assert Members.get_member!(member.id) == member

      assert {:ok, false} == Cachex.empty?(:members_units_cache)
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Members.create_member(@valid_attrs)
      assert member.github == "some github"
      assert member.name == "some name"
      assert member.surname == "some surname"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Members.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, member} = Members.update_member(member, @update_attrs)
      assert %Member{} = member
      assert member.github == "some updated github"
      assert member.name == "some updated name"
      assert member.surname == "some updated surname"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      Members.list_members()
      Members.get_member!(Integer.to_string(member.id))
      assert {:ok, false} == Cachex.empty?(:members_lists_cache)
      assert {:ok, true} == Cachex.exists?(:members_units_cache, Integer.to_string(member.id))

      assert {:error, %Ecto.Changeset{}} = Members.update_member(member, @invalid_attrs)
      assert {:ok, true} == Cachex.exists?(:members_units_cache, Integer.to_string(member.id))
      assert {:ok, false} == Cachex.empty?(:members_lists_cache)

      assert member == Members.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      Members.list_members()
      mem = Members.get_member!(Integer.to_string(member.id))
      assert {:ok, false} == Cachex.empty?(:members_lists_cache)
      assert {:ok, true} == Cachex.exists?(:members_units_cache, Integer.to_string(member.id))

      assert {:ok, mem |> put_meta(state: :deleted)} == Members.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Members.get_member!(member.id) end

      assert {:ok, false} == Cachex.exists?(:members_units_cache, Integer.to_string(member.id))
      assert {:ok, true} == Cachex.empty?(:members_lists_cache)
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Members.change_member(member)
    end
  end
end
