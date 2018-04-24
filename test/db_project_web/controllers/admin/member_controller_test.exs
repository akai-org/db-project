defmodule DbProjectWeb.Admin.MemberControllerTest do
  use DbProjectWeb.ConnCase

  alias DbProject.Members
  alias DbProject.Members.Member

  @valid_attrs %{github: "some github", name: "some name", surname: "some surname"}
  @update_attrs %{github: "some updated github", name: "some updated name", surname: "some updated surname"}
  @invalid_attrs %{name: nil, surname: nil}

  def fixture(:member) do
    {:ok, member} = Members.create_member(@valid_attrs)
    member
  end

  setup %{conn: conn} do
    Cachex.clear(:members_units_cache)
    Cachex.clear(:members_lists_cache)
    #{:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "get into index", %{conn: conn} do
      #member1 = fixture(:member)
      #member2 = fixture(:member)
      conn = get(conn, admin_member_path(conn, :index))
      assert html_response(conn,200) =~ "New member"
    end
  end


end
