defmodule Evision.Flann.CentersInit do
  @type enum :: integer()
  @doc enum: true
  def cv_FLANN_CENTERS_RANDOM, do: 0
  @doc enum: true
  def cv_FLANN_CENTERS_GONZALES, do: 1
  @doc enum: true
  def cv_FLANN_CENTERS_KMEANSPP, do: 2
  @doc enum: true
  def cv_FLANN_CENTERS_GROUPWISE, do: 3
end
