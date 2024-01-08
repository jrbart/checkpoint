defmodule CheckPoint.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :check_point,
    adapter: Ecto.Adapters.Postgres
end
