defmodule Evision.ImwriteGIFCompressionFlags do
  @type enum :: integer()
  @doc enum: true
  def cv_IMWRITE_GIF_FAST_NO_DITHER, do: 1
  @doc enum: true
  def cv_IMWRITE_GIF_FAST_FLOYD_DITHER, do: 2
  @doc enum: true
  def cv_IMWRITE_GIF_COLORTABLE_SIZE_8, do: 3
  @doc enum: true
  def cv_IMWRITE_GIF_COLORTABLE_SIZE_16, do: 4
  @doc enum: true
  def cv_IMWRITE_GIF_COLORTABLE_SIZE_32, do: 5
  @doc enum: true
  def cv_IMWRITE_GIF_COLORTABLE_SIZE_64, do: 6
  @doc enum: true
  def cv_IMWRITE_GIF_COLORTABLE_SIZE_128, do: 7
  @doc enum: true
  def cv_IMWRITE_GIF_COLORTABLE_SIZE_256, do: 8
end
