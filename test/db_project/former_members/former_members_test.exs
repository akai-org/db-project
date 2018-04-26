defmodule DbProject.FormerMembersTest do
  use DbProject.DataCase

  alias DbProject.FormerMembers

  describe "former_members" do
    alias DbProject.FormerMembers.FormerMember

    @valid_attrs %{github: "some github", name: "some name", surname: "some surname"}
    @update_attrs %{github: "some updated github", name: "some updated name", surname: "some updated surname"}
    @invalid_attrs %{name: nil, surname: nil}

    setup do
      Cachex.clear(:former_members_units_cache)
      Cachex.clear(:former_members_lists_cache)
      {:ok, %{}}
    end

    def former_member_fixture(attrs \\ %{}) do
      {:ok, former_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FormerMembers.create_former_member()

      former_member
    end

    test "list_former_members/0 returns all former_members" do
      former_member = former_member_fixture()
      assert FormerMembers.list_former_members() == [former_member]
    end

    test "get_former_member!/1 returns the former_member with given id" do
      assert {:ok, true} == Cachex.empty?(:former_members_units_cache)

      former_member = former_member_fixture()
      assert FormerMembers.get_former_member!(former_member.id) == former_member

      assert {:ok, false} == Cachex.empty?(:former_members_units_cache)
    end

    test "create_former_member/1 with valid data creates a former_member" do
      assert {:ok, %FormerMember{} = former_member} = FormerMembers.create_former_member(@valid_attrs)
      assert former_member.github == "some github"
      assert former_member.name == "some name"
      assert former_member.surname == "some surname"
    end

    test "create_former_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FormerMembers.create_former_member(@invalid_attrs)
    end

    test "update_former_member/2 with valid data updates the former_member" do
      former_member = former_member_fixture()
      assert {:ok, former_member} = FormerMembers.update_former_member(former_member, @update_attrs)
      assert %FormerMember{} = former_member
      assert former_member.github == "some updated github"
      assert former_member.name == "some updated name"
      assert former_member.surname == "some updated surname"
    end

    test "update_former_member/2 with invalid data returns error changeset" do
      former_member = former_member_fixture()
      FormerMembers.list_former_members()
      FormerMembers.get_former_member!(Integer.to_string(former_member.id))
      assert {:ok, false} == Cachex.empty?(:former_members_lists_cache)
      assert {:ok, true} == Cachex.exists?(:former_members_units_cache, Integer.to_string(former_member.id))

      assert {:error, %Ecto.Changeset{}} = FormerMembers.update_former_member(former_member, @invalid_attrs)
      assert {:ok, true} == Cachex.exists?(:former_members_units_cache, Integer.to_string(former_member.id))
      assert {:ok, false} == Cachex.empty?(:former_members_lists_cache)

      assert former_member == FormerMembers.get_former_member!(former_member.id)
    end

    test "delete_former_member/1 deletes the former_member" do
      former_member = former_member_fixture()
      FormerMembers.list_former_members()
      mem = FormerMembers.get_former_member!(Integer.to_string(former_member.id))
      assert {:ok, false} == Cachex.empty?(:former_members_lists_cache)
      assert {:ok, true} == Cachex.exists?(:former_members_units_cache, Integer.to_string(former_member.id))

      assert {:ok, mem |> put_meta(state: :deleted)} == FormerMembers.delete_former_member(former_member)
      assert_raise Ecto.NoResultsError, fn -> FormerMembers.get_former_member!(former_member.id) end

      assert {:ok, false} == Cachex.exists?(:former_members_units_cache, Integer.to_string(former_member.id))
      assert {:ok, true} == Cachex.empty?(:former_members_lists_cache)
    end

    test "change_former_member/1 returns a former_member changeset" do
      former_member = former_member_fixture()
      assert %Ecto.Changeset{} = FormerMembers.change_former_member(former_member)
    end
  end
end
