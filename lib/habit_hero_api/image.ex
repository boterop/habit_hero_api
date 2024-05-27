defmodule Image do
  @moduledoc """
  Module for image operations.
  """

  @spec save_base64_image(binary(), binary()) :: :ok | {:error, atom()}
  def save_base64_image(path, base64) do
    {:ok, binary} = Base.decode64(base64)
    File.mkdir_p(path |> Path.dirname())
    File.write(path, binary)
  end
end
