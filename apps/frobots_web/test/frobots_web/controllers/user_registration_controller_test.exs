defmodule FrobotsWeb.UserRegistrationControllerTest do
  use FrobotsWeb.ConnCase, async: true

  import Frobots.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      {:ok, user} = user_fixture()
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)

      assert response =~
               "<section style=\"background-image: linear-gradient(179.29deg, #000000 0.64%, #161C24 99.44%)\" class=\"flex items-center justify-center flex-col md:flex-row h-screen items-center\">\n\n  <div class=\"mt-8 sm:mx-auto sm:w-full sm:max-w-md\">\n    <div class=\"py-8 px-4 shadow border-frobots-green sm:rounded-lg sm:px-10\">\n        <form action=\"https://register.google.com/\" method=\"get\">\n  \n  \n  \n            <div>\n              <div class=\"sm:mx-auto sm:w-full sm:max-w-md \">\n                  <h2 class=\"py-8 text-center text-3xl leading-9 font-bold text-white\">Register </h2>\n              </div>\n        \n                <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc text-white border border-gray-600 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-frobots-login-in-bgc-light focus:border-green-300 \" id=\"user_email\" name=\"user[email]\" placeholder=\"Enter your email\" required type=\"email\">\n                </div>\n\n            </div>\n            <div class=\"mt-6\">\n                  <span class=\"block w-full rounded-md shadow-sm\">\n                    <button type=\"submit\" class=\"w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-frobots-green-bgc hover:bg-frobots-green-dark focus:outline-none focus:border-indigo-700 focus:ring-indigo active:bg-frobots-green-dark transition duration-150 ease-in-out\">\n                      Register to Frobots\n                    </button>\n                  </span>\n            </div>\n          \n</form>\n    \n        <div class=\"mt-6\">\n          <div class=\"text-sm leading-5 w-full inline-flex  justify-center\">\n            <a href=\"/users/log_in\" class=\"font-medium text-frobots-green hover:text-frobots-green-dark focus:outline-none focus:underline transition ease-in-out duration-150\">\n              Already have an account ? Login\n            </a>\n          </div>\n        </div>\n      </div>\n  </div>\n</section>"

      assert response =~
               "<section style=\"background-image: linear-gradient(179.29deg, #000000 0.64%, #161C24 99.44%)\" class=\"flex items-center justify-center flex-col md:flex-row h-screen items-center\">\n\n  <div class=\"mt-8 sm:mx-auto sm:w-full sm:max-w-md\">\n    <div class=\"py-8 px-4 shadow border-frobots-green sm:rounded-lg sm:px-10\">\n        <form action=\"https://register.google.com/\" method=\"get\">\n  \n  \n  \n            <div>\n              <div class=\"sm:mx-auto sm:w-full sm:max-w-md \">\n                  <h2 class=\"py-8 text-center text-3xl leading-9 font-bold text-white\">Register </h2>\n              </div>\n        \n                <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc text-white border border-gray-600 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-frobots-login-in-bgc-light focus:border-green-300 \" id=\"user_email\" name=\"user[email]\" placeholder=\"Enter your email\" required type=\"email\">\n                </div>\n\n            </div>\n            <div class=\"mt-6\">\n                  <span class=\"block w-full rounded-md shadow-sm\">\n                    <button type=\"submit\" class=\"w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-frobots-green-bgc hover:bg-frobots-green-dark focus:outline-none focus:border-indigo-700 focus:ring-indigo active:bg-frobots-green-dark transition duration-150 ease-in-out\">\n                      Register to Frobots\n                    </button>\n                  </span>\n            </div>\n          \n</form>\n    \n        <div class=\"mt-6\">\n          <div class=\"text-sm leading-5 w-full inline-flex  justify-center\">\n            <a href=\"/users/log_in\" class=\"font-medium text-frobots-green hover:text-frobots-green-dark focus:outline-none focus:underline transition ease-in-out duration-150\">\n              Already have an account ? Login\n            </a>\n          </div>\n        </div>\n      </div>\n  </div>\n</section>"

      assert response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn} do
      {:ok, user} = user_fixture()
      conn = conn |> log_in_user(user) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/home"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Garage</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "short"}
        })

      response = html_response(conn, 200)

      assert response =~
               "<section style=\"background-image: linear-gradient(179.29deg, #000000 0.64%, #161C24 99.44%)\" class=\"flex items-center justify-center flex-col md:flex-row h-screen items-center\">\n\n  <div class=\"mt-8 sm:mx-auto sm:w-full sm:max-w-md\">\n    <div class=\"py-8 px-4 shadow border-frobots-green sm:rounded-lg sm:px-10\">\n        <form action=\"https://register.google.com/\" method=\"get\">\n  \n  \n  \n            <div>\n              <div class=\"sm:mx-auto sm:w-full sm:max-w-md \">\n                  <h2 class=\"py-8 text-center text-3xl leading-9 font-bold text-white\">Register </h2>\n              </div>\n        \n                <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc text-white border border-gray-600 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-frobots-login-in-bgc-light focus:border-green-300 \" id=\"user_email\" name=\"user[email]\" placeholder=\"Enter your email\" required type=\"email\">\n                </div>\n\n            </div>\n            <div class=\"mt-6\">\n                  <span class=\"block w-full rounded-md shadow-sm\">\n                    <button type=\"submit\" class=\"w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-frobots-green-bgc hover:bg-frobots-green-dark focus:outline-none focus:border-indigo-700 focus:ring-indigo active:bg-frobots-green-dark transition duration-150 ease-in-out\">\n                      Register to Frobots\n                    </button>\n                  </span>\n            </div>\n          \n</form>\n    \n        <div class=\"mt-6\">\n          <div class=\"text-sm leading-5 w-full inline-flex  justify-center\">\n            <a href=\"/users/log_in\" class=\"font-medium text-frobots-green hover:text-frobots-green-dark focus:outline-none focus:underline transition ease-in-out duration-150\">\n              Already have an account ? Login\n            </a>\n          </div>\n        </div>\n      </div>\n  </div>\n</section>"

      assert response =~
               "<section style=\"background-image: linear-gradient(179.29deg, #000000 0.64%, #161C24 99.44%)\" class=\"flex items-center justify-center flex-col md:flex-row h-screen items-center\">\n\n  <div class=\"mt-8 sm:mx-auto sm:w-full sm:max-w-md\">\n    <div class=\"py-8 px-4 shadow border-frobots-green sm:rounded-lg sm:px-10\">\n        <form action=\"https://register.google.com/\" method=\"get\">\n  \n  \n  \n            <div>\n              <div class=\"sm:mx-auto sm:w-full sm:max-w-md \">\n                  <h2 class=\"py-8 text-center text-3xl leading-9 font-bold text-white\">Register </h2>\n              </div>\n        \n                <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc text-white border border-gray-600 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-frobots-login-in-bgc-light focus:border-green-300 \" id=\"user_email\" name=\"user[email]\" placeholder=\"Enter your email\" required type=\"email\">\n                </div>\n\n            </div>\n            <div class=\"mt-6\">\n                  <span class=\"block w-full rounded-md shadow-sm\">\n                    <button type=\"submit\" class=\"w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-frobots-green-bgc hover:bg-frobots-green-dark focus:outline-none focus:border-indigo-700 focus:ring-indigo active:bg-frobots-green-dark transition duration-150 ease-in-out\">\n                      Register to Frobots\n                    </button>\n                  </span>\n            </div>\n          \n</form>\n    \n        <div class=\"mt-6\">\n          <div class=\"text-sm leading-5 w-full inline-flex  justify-center\">\n            <a href=\"/users/log_in\" class=\"font-medium text-frobots-green hover:text-frobots-green-dark focus:outline-none focus:underline transition ease-in-out duration-150\">\n              Already have an account ? Login\n            </a>\n          </div>\n        </div>\n      </div>\n  </div>\n</section>"

      assert response =~
               "<section style=\"background-image: linear-gradient(179.29deg, #000000 0.64%, #161C24 99.44%)\" class=\"flex items-center justify-center flex-col md:flex-row h-screen items-center\">\n\n  <div class=\"mt-8 sm:mx-auto sm:w-full sm:max-w-md\">\n    <div class=\"py-8 px-4 shadow border-frobots-green sm:rounded-lg sm:px-10\">\n        <form action=\"https://register.google.com/\" method=\"get\">\n  \n  \n  \n            <div>\n              <div class=\"sm:mx-auto sm:w-full sm:max-w-md \">\n                  <h2 class=\"py-8 text-center text-3xl leading-9 font-bold text-white\">Register </h2>\n              </div>\n        \n                <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc text-white border border-gray-600 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-frobots-login-in-bgc-light focus:border-green-300 \" id=\"user_email\" name=\"user[email]\" placeholder=\"Enter your email\" required type=\"email\">\n                </div>\n\n            </div>\n            <div class=\"mt-6\">\n                  <span class=\"block w-full rounded-md shadow-sm\">\n                    <button type=\"submit\" class=\"w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-frobots-green-bgc hover:bg-frobots-green-dark focus:outline-none focus:border-indigo-700 focus:ring-indigo active:bg-frobots-green-dark transition duration-150 ease-in-out\">\n                      Register to Frobots\n                    </button>\n                  </span>\n            </div>\n          \n</form>\n    \n        <div class=\"mt-6\">\n          <div class=\"text-sm leading-5 w-full inline-flex  justify-center\">\n            <a href=\"/users/log_in\" class=\"font-medium text-frobots-green hover:text-frobots-green-dark focus:outline-none focus:underline transition ease-in-out duration-150\">\n              Already have an account ? Login\n            </a>\n          </div>\n        </div>\n      </div>\n  </div>\n</section>"
    end
  end
end
