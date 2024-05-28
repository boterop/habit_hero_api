defmodule ImageTest do
  use ExUnit.Case

  setup do
    %{base64: "R0lGODlhAQABAIAAAP///wAAACwAAAAAAQABAAACAkQBADs=", image_name: "white_pixel"}
  end

  test "save_base64_image/2 saves the base64 image", %{base64: base64, image_name: image_name} do
    :ok = Image.save_base64_image(image_name, base64)
    {:ok, _image} = Image.get_image(image_name)
  end

  test "get_image/1 returns the image", %{base64: base64, image_name: image_name} do
    :ok = Image.save_base64_image(image_name, base64)
    {:ok, image} = Image.get_image(image_name)
    assert base64 == Base.encode64(image)
  end

  test "get_image_path/1 returns the correct image path", %{image_name: image_name} do
    expected_path = "images/white_pixel.jpg"
    assert expected_path == Image.get_image_path(image_name)
  end

  test "get_static_path/1 returns the correct static path", %{image_name: image_name} do
    expected_path = "priv/static/images/white_pixel.jpg"
    assert expected_path == Image.get_static_path(image_name)
  end
end
