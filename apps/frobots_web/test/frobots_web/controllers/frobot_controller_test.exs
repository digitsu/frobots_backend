defmodule FrobotsWeb.FrobotControllerTest do
  use FrobotsWeb.ConnCase, async: true
  alias FrobotsWeb.UserAuth

  @create_attrs %{brain_code: "some brain_code", class: "some class", name: "some name", xp: 42}
  @update_attrs %{
    brain_code: "some updated brain_code",
    class: "some updated class",
    name: "some updated name",
    xp: 43
  }
  @invalid_attrs %{brain_code: nil, class: nil, name: nil, xp: nil}

  setup %{conn: conn} do
    {:ok, user} = user_fixture()

    conn =
      conn
      |> Map.replace!(:secret_key_base, FrobotsWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{user: user, conn: conn}
  end

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

  test "authorizes actions against access by other users", %{conn: _conn} do
    {:ok, owner} = user_fixture(email: "owner@mail.com")
    frobot = frobot_fixture(owner, @create_attrs)
    {:ok, non_owner} = user_fixture(email: "sneaky@mail.com")

    conn = build_conn() |> log_in_user(non_owner)

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

    @tag login_as: "max@mail.com"
    test "lists all user's frobots on index", %{conn: conn, user: user} do
      user_frobot = frobot_fixture(user, name: "buttbasher")

      {:ok, other_user} = user_fixture(email: "other@mail.com")
      other_frobot = frobot_fixture(other_user, name: "facemasher")

      conn = conn |> log_in_user(user)

      conn = get(conn, Routes.frobot_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ ~r/Listing Frobots/
      assert response =~ user_frobot.name
      refute response =~ other_frobot.name
    end

    defp frobot_count, do: Enum.count(Assets.list_frobots())

    @tag login_as: "max@mail.com"
    test "creates user frobot and redirects", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      create_conn = post conn, Routes.frobot_path(conn, :create), frobot: @create_attrs
      assert %{id: id} = redirected_params(create_conn)

      assert redirected_to(create_conn) ==
               Routes.frobot_path(create_conn, :show, id)

      conn = get(conn, Routes.frobot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Frobot"
      assert frobot = Assets.get_frobot!(String.to_integer(id))
      assert frobot.user_id == user.id
    end

    @tag login_as: "max@mail.com"
    test "does not create frobot, renders errors when invalid", %{conn: conn, user: user} do
      count_before = frobot_count()
      conn = conn |> log_in_user(user)
      conn = post conn, Routes.frobot_path(conn, :create), frobot: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
      assert frobot_count() == count_before
    end
  end

  describe "with logged-in user and existing frobot" do
    setup [:login, :create_frobot]

    @tag login_as: "max@mail.com"
    test "renders form for editing chosen frobot", %{conn: conn, user: user, frobot: frobot} do
      conn = conn |> log_in_user(user)
      conn = get(conn, Routes.frobot_path(conn, :edit, frobot))
      assert html_response(conn, 200) =~ "Edit Frobot"
    end

    @tag login_as: "max@mail.com"
    test "redirects when data is valid", %{conn: conn, frobot: frobot, user: user} do
      conn = conn |> log_in_user(user)

      redirected_conn =
        put(conn, Routes.frobot_path(conn, :update, frobot), frobot: @update_attrs)

      assert redirected_to(redirected_conn) == Routes.frobot_path(redirected_conn, :show, frobot)

      conn = get(conn, Routes.frobot_path(conn, :show, frobot))
      assert html_response(conn, 200) =~ "some updated brain_code"
    end

    @tag login_as: "max@mail.com"
    test "renders errors when data is invalid", %{conn: conn, frobot: frobot, user: user} do
      conn = conn |> log_in_user(user)
      conn = put(conn, Routes.frobot_path(conn, :update, frobot), frobot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Frobot"
    end

    @tag login_as: "max@mail.com"
    test "deletes chosen frobot", %{conn: conn, frobot: frobot, user: user} do
      conn = conn |> log_in_user(user)
      redirected_conn = delete(conn, Routes.frobot_path(conn, :delete, frobot))
      assert redirected_to(redirected_conn) == Routes.frobot_path(redirected_conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.frobot_path(conn, :show, frobot))
      end
    end
  end
end
