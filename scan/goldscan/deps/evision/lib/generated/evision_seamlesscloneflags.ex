defmodule Evision.SeamlessCloneFlags do
  @type enum :: integer()
  @doc enum: true
  def cv_NORMAL_CLONE, do: 1
  @doc enum: true
  def cv_MIXED_CLONE, do: 2
  @doc enum: true
  def cv_MONOCHROME_TRANSFER, do: 3
  @doc enum: true
  def cv_NORMAL_CLONE_WIDE, do: 9
  @doc enum: true
  def cv_MIXED_CLONE_WIDE, do: 10
  @doc enum: true
  def cv_MONOCHROME_TRANSFER_WIDE, do: 11
end
