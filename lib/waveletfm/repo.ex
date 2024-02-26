defmodule WaveletFM.Repo do
  use Ecto.Repo,
    otp_app: :waveletfm,
    adapter: Ecto.Adapters.Postgres
end
