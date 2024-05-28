defmodule Image do
  @moduledoc """
  Module for image operations.
  """
  @image_path "images/"
  @static_path "priv/static/" <> @image_path

  @spec save_base64_image(binary(), binary()) :: :ok | {:error, atom()}
  def save_base64_image(image_name, base64) do
    {:ok, binary} = Base.decode64(base64)
    path = get_static_path(image_name)
    mkdir(@static_path)
    File.write(path, binary)
  end

  @spec mkdir(binary()) :: :ok | {:error, atom()}
  def mkdir(path) do
    path
    |> String.split("/")
    |> Enum.reduce("", fn dir, acc ->
      dir_path = acc <> dir <> "/"
      File.mkdir_p(dir_path)
      dir_path
    end)
  end

  @spec get_image(binary()) :: {:error, atom()} | {:ok, binary()}
  def get_image(image_name), do: image_name |> get_static_path() |> File.read()

  @spec get_image_path(binary()) :: binary()
  def get_image_path(image_name), do: @image_path <> image_name <> ".jpg"

  @spec get_static_path(binary()) :: binary()
  def get_static_path(image_name), do: @static_path <> image_name <> ".jpg"
end
