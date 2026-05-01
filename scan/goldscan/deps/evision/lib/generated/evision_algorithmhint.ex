defmodule Evision.AlgorithmHint do
  @type enum :: integer()
  @doc enum: true
  def cv_ALGO_HINT_DEFAULT, do: 0
  @doc enum: true
  def cv_ALGO_HINT_ACCURATE, do: 1
  @doc enum: true
  def cv_ALGO_HINT_APPROX, do: 2
end
