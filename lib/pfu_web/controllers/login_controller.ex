defmodule PfuWeb.LoginController do
  use PfuWeb, :controller

  alias Pfu.Accounts
  # alias Pfu.Auth
  alias PfuWeb.UserAuth

  def new(conn, _params) do
    render(conn, "login.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"username" => username, "password" => password} = user_params

    if user = Accounts.get_user_by_username_and_password(username, password) do
      IO.inspect(user)
      Pfu.UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "login.html", error_message: "Invalid username or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
