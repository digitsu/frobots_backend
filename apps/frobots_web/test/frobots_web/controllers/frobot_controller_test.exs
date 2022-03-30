defmodule FrobotsWeb.FrobotControllerTest do
  use FrobotsWeb.ConnCase, async: true

  @create_attrs %{brain_code: "some brain_code", class: "some class", name: "some name", xp: 42}
  @update_attrs %{
    brain_code: "some updated brain_code",
    class: "some updated class",
    name: "some updated name",
    xp: 43
  }
  @invalid_attrs %{brain_code: nil, class: nil, name: nil, xp: nil}

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.frobot_path(conn, :new)),
        get(conn, Routes.frobot_path(conn, :index)),
        get(conn, Routes.frobot_path(conn, :show, "123")),
        get(conn, Routes.frobot_path(conn, :edit, "123")),
        put(conn, Routes.frobot_path(conn, :update, "123", %{})),
        post(conn, Routes.frobot_path(conn, :create, %{})),
        delete(conn, Routes.frobot_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  test "authorizes actions against access by other users", %{conn: conn} do
    owner = user_fixture(username: "owner")
    frobot = frobot_fixture(owner, @create_attrs)
    non_owner = user_fixture(username: "sneaky")
    conn = assign(conn, :current_user, non_owner)

    assert_error_sent :not_found, fn ->
      get(conn, Routes.frobot_path(conn, :show, frobot))
    end

    assert_error_sent :not_found, fn ->
      get(conn, Routes.frobot_path(conn, :edit, frobot))
    end

    assert_error_sent :not_found, fn ->
      put(conn, Routes.frobot_path(conn, :update, frobot, frobot: @create_attrs))
    end

    assert_error_sent :not_found, fn ->
      delete(conn, Routes.frobot_path(conn, :delete, frobot))
    end
  end

  describe "with a logged-in user" do
    alias Frobots.Assets

    setup [:login]

    @tag login_as: "max"
    test "lists all user's frobots on index", %{conn: conn, user: user} do
      user_frobot = frobot_fixture(user, name: "buttbasher")

      other_frobot =
        frobot_fixture(
          user_fixture(username: "other"),
          name: "facemasher"
        )

      conn = get(conn, Routes.frobot_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ ~r/Listing Frobots/
      assert response =~ user_frobot.name
      refute response =~ other_frobot.name
    end

    defp frobot_count, do: Enum.count(Assets.list_frobots())

    @tag login_as: "max"
    test "creates user frobot and redirects", %{conn: conn, user: user} do
      create_conn = post conn, Routes.frobot_path(conn, :create), frobot: @create_attrs

      assert %{id: id} = redirected_params(create_conn)

      assert redirected_to(create_conn) ==
               Routes.frobot_path(create_conn, :show, id)

      conn = get(conn, Routes.frobot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Frobot"

      assert Assets.get_frobot!(id).user_id == user.id
    end

    @tag login_as: "max"
    test "does not create frobot, renders errors when invalid", %{conn: conn} do
      count_before = frobot_count()
      conn = post conn, Routes.frobot_path(conn, :create), frobot: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
      assert frobot_count() == count_before
    end
  end

  describe "with logged-in user and existing frobot" do
    setup [:login, :create_frobot]

    @tag login_as: "max"
    test "renders form for editing chosen frobot", %{conn: conn, frobot: frobot} do
      conn = get(conn, Routes.frobot_path(conn, :edit, frobot))
      assert html_response(conn, 200) =~ "Edit Frobot"
    end

    @tag login_as: "max"
    test "redirects when data is valid", %{conn: conn, frobot: frobot} do
      update_conn = put(conn, Routes.frobot_path(conn, :update, frobot), frobot: @update_attrs)
      assert redirected_to(update_conn) == Routes.frobot_path(update_conn, :show, frobot)

      conn = get(conn, Routes.frobot_path(conn, :show, frobot))
      assert html_response(conn, 200) =~ "some updated brain_code"
    end

    @tag login_as: "max"
    test "renders errors when data is invalid", %{conn: conn, frobot: frobot} do
      conn = put(conn, Routes.frobot_path(conn, :update, frobot), frobot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Frobot"
    end

    @tag login_as: "max"
    test "deletes chosen frobot", %{conn: conn, frobot: frobot} do
      delete_conn = delete(conn, Routes.frobot_path(conn, :delete, frobot))
      assert redirected_to(delete_conn) == Routes.frobot_path(delete_conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.frobot_path(conn, :show, frobot))
      end
    end
  end

  defp create_frobot(%{conn: conn}) do
    frobot = frobot_fixture(conn.assigns.current_user)
    %{conn: conn, frobot: frobot}
  end

  defp login(%{conn: conn, login_as: username}) do
    user = user_fixture(username: username)
    conn = assign(conn, :current_user, user)
    %{conn: conn, user: user}
  end
end
