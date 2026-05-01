defmodule Evision.Flann.LogLevel do
  @type enum :: integer()
  @doc enum: true
  def cv_FLANN_LOG_NONE, do: 0
  @doc enum: true
  def cv_FLANN_LOG_FATAL, do: 1
  @doc enum: true
  def cv_FLANN_LOG_ERROR, do: 2
  @doc enum: true
  def cv_FLANN_LOG_WARN, do: 3
  @doc enum: true
  def cv_FLANN_LOG_INFO, do: 4
end
