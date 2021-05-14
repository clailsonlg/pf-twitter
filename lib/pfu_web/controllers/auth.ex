defmodule Pfu.Auth do
  import Plug.Conn
  import Phoenix.Controller
  #import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]
  alias Pfu.User
  alias PfuWeb.Router.Helpers, as: Routes

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id) #deve ser user_id e repo.get(User, user_id) nao nulos
    assign(conn, :current_user, user)
  end

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

  def login(conn, user) do
    conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
      #configure_session(renew: true): gera nova session id para o cookie, previne session fixation attacks
  end

  def logout(conn) do
    conn |> configure_session(drop: true)
  end

end
