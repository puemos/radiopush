defmodule RadiopushWeb.TermsAndConditionsController do
  use RadiopushWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end
end
