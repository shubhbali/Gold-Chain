defmodule Evision.Flann.Algorithm do
  @type enum :: integer()
  @doc enum: true
  def cv_FLANN_INDEX_LINEAR, do: 0
  @doc enum: true
  def cv_FLANN_INDEX_KDTREE, do: 1
  @doc enum: true
  def cv_FLANN_INDEX_KMEANS, do: 2
  @doc enum: true
  def cv_FLANN_INDEX_COMPOSITE, do: 3
  @doc enum: true
  def cv_FLANN_INDEX_KDTREE_SINGLE, do: 4
  @doc enum: true
  def cv_FLANN_INDEX_HIERARCHICAL, do: 5
  @doc enum: true
  def cv_FLANN_INDEX_LSH, do: 6
  @doc enum: true
  def cv_FLANN_INDEX_SAVED, do: 254
  @doc enum: true
  def cv_FLANN_INDEX_AUTOTUNED, do: 255
end
