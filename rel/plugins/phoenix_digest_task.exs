defmodule DbProject.PhoenixDigestTask do
  use Mix.Releases.Plugin

  def before_assembly(%Release{} = _release) do
    Mix.Task.run("phx.digest")
    nil
  end
end
