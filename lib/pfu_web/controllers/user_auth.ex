defmodule Pfu.UserAuth do
  import Plug.Conn
  import Phoenix.Controller
  #import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]
  alias Pfu.Accounts
  alias PfuWeb.Router.Helpers, as: Routes

  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_app_auth_test_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  # def init(opts) do
  #   Keyword.fetch!(opts, :repo)
  # end
  # def call(conn, repo) do
  #   user_id = get_session(conn, :user_id)
  #   user = user_id && repo.get(User, user_id) #deve ser user_id e repo.get(User, user_id) nao nulos
  #   assign(conn, :current_user, user)
  # end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
        |> put_flash(:error, "Você deve estar logado para ter acesso na página solicitada. Cadastre-se!!!")
        |> redirect(to: Routes.user_path(conn, :new))#.page_path(conn, :index))
        |> halt()
    end
  end

  def log_in_user(conn, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> renew_session()
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "login:#{Base.url_encode64(token)}")
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    # |> clear_session()
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  defp signed_in_path(_conn), do: "/users"

  def logout(conn) do
    conn |> configure_session(drop: true)
  end

end
