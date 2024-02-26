defmodule WaveletFM.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WaveletFMWeb.Telemetry,
      WaveletFM.Repo,
      {DNSCluster, query: Application.get_env(:waveletfm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WaveletFM.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WaveletFM.Finch},
      # Start a worker by calling: WaveletFM.Worker.start_link(arg)
      # {WaveletFM.Worker, arg},
      # Start to serve requests, typically the last entry
      WaveletFMWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WaveletFM.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WaveletFMWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
