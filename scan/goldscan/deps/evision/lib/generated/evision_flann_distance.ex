defmodule Evision.Flann.Distance do
  @type enum :: integer()
  @doc enum: true
  def cv_FLANN_DIST_EUCLIDEAN, do: 1
  @doc enum: true
  def cv_FLANN_DIST_L2, do: 1
  @doc enum: true
  def cv_FLANN_DIST_MANHATTAN, do: 2
  @doc enum: true
  def cv_FLANN_DIST_L1, do: 2
  @doc enum: true
  def cv_FLANN_DIST_MINKOWSKI, do: 3
  @doc enum: true
  def cv_FLANN_DIST_MAX, do: 4
  @doc enum: true
  def cv_FLANN_DIST_HIST_INTERSECT, do: 5
  @doc enum: true
  def cv_FLANN_DIST_HELLINGER, do: 6
  @doc enum: true
  def cv_FLANN_DIST_CHI_SQUARE, do: 7
  @doc enum: true
  def cv_FLANN_DIST_CS, do: 7
  @doc enum: true
  def cv_FLANN_DIST_KULLBACK_LEIBLER, do: 8
  @doc enum: true
  def cv_FLANN_DIST_KL, do: 8
  @doc enum: true
  def cv_FLANN_DIST_HAMMING, do: 9
  @doc enum: true
  def cv_FLANN_DIST_DNAMMING, do: 10
end
