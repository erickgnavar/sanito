defmodule MyRouter do
  use Plug.Router

  match _ do
    send_resp(conn, 404, "oops")
  end
end

ExUnit.start()
