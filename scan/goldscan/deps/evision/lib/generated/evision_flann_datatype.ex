defmodule Evision.Flann.Datatype do
  @type enum :: integer()
  @doc enum: true
  def cv_FLANN_INT8, do: 0
  @doc enum: true
  def cv_FLANN_INT16, do: 1
  @doc enum: true
  def cv_FLANN_INT32, do: 2
  @doc enum: true
  def cv_FLANN_INT64, do: 3
  @doc enum: true
  def cv_FLANN_UINT8, do: 4
  @doc enum: true
  def cv_FLANN_UINT16, do: 5
  @doc enum: true
  def cv_FLANN_UINT32, do: 6
  @doc enum: true
  def cv_FLANN_UINT64, do: 7
  @doc enum: true
  def cv_FLANN_FLOAT32, do: 8
  @doc enum: true
  def cv_FLANN_FLOAT64, do: 9
end
