defmodule Evision.Detail.FeatherBlender do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Detail.FeatherBlender` struct.

  - **ref**. `reference()`

    The underlying erlang resource variable.

  """
  @type t :: %__MODULE__{
    ref: reference()
  }
  @enforce_keys [:ref]
  defstruct [:ref]
  alias __MODULE__, as: T

  @doc false
  def to_struct({:ok, %{class: Evision.Detail.FeatherBlender, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Detail.FeatherBlender, ref: ref}) do
    %T{
      ref: ref
    }
  end

  @doc false
  def to_struct(ret) do
    Evision.Internal.Structurise.to_struct(ret)
  end
  
  @doc false
  def from_struct(%T{ref: ref}) do
    ref
  end

  @doc """
  FeatherBlender
  ##### Keyword Arguments
  - **sharpness**: `float`.

  ##### Return
  - **self**: `Evision.Detail.FeatherBlender.t()`

  Python prototype (for reference only):
  ```python3
  FeatherBlender([, sharpness]) -> <detail_FeatherBlender object>
  ```
  """
  @spec featherBlender(Keyword.t()) :: any() | {:error, String.t()}
  def featherBlender([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:sharpness])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_FeatherBlender()
    |> to_struct()
  end
  @spec featherBlender([{:sharpness, term()}] | nil) :: Evision.Detail.FeatherBlender.t() | {:error, String.t()}
  def featherBlender(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:sharpness])
    positional = [
    ]
    :evision_nif.detail_detail_FeatherBlender_FeatherBlender(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  FeatherBlender
  ##### Keyword Arguments
  - **sharpness**: `float`.

  ##### Return
  - **self**: `Evision.Detail.FeatherBlender.t()`

  Python prototype (for reference only):
  ```python3
  FeatherBlender([, sharpness]) -> <detail_FeatherBlender object>
  ```
  """
  @spec featherBlender() :: Evision.Detail.FeatherBlender.t() | {:error, String.t()}
  def featherBlender() do
    positional = [
    ]
    :evision_nif.detail_detail_FeatherBlender_FeatherBlender(positional)
    |> to_struct()
  end
  @spec blend(Keyword.t()) :: any() | {:error, String.t()}
  def blend([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dst_mask,:dst])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_blend()
    |> to_struct()
  end

  @doc """
  blend

  ##### Positional Arguments
  - **self**: `Evision.Detail.FeatherBlender.t()`

  ##### Return
  - **dst**: `Evision.Mat.t()`
  - **dst_mask**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  blend(dst, dst_mask) -> dst, dst_mask
  ```
  """
  @spec blend(Evision.Detail.FeatherBlender.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def blend(self, dst, dst_mask) when (is_struct(dst, Evision.Mat) or is_struct(dst, Nx.Tensor) or is_number(dst) or is_tuple(dst)) and (is_struct(dst_mask, Evision.Mat) or is_struct(dst_mask, Nx.Tensor) or is_number(dst_mask) or is_tuple(dst_mask))
  do
    positional = [
      dst: Evision.Internal.Structurise.from_struct(dst),
      dst_mask: Evision.Internal.Structurise.from_struct(dst_mask)
    ]
    :evision_nif.detail_detail_FeatherBlender_blend(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec createWeightMaps(Keyword.t()) :: any() | {:error, String.t()}
  def createWeightMaps([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:weight_maps,:corners,:masks])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_createWeightMaps()
    |> to_struct()
  end

  @doc """
  createWeightMaps

  ##### Positional Arguments
  - **self**: `Evision.Detail.FeatherBlender.t()`
  - **masks**: `[Evision.Mat]`
  - **corners**: `[Point]`

  ##### Return
  - **retval**: `Rect`
  - **weight_maps**: `[Evision.Mat]`

  Python prototype (for reference only):
  ```python3
  createWeightMaps(masks, corners, weight_maps) -> retval, weight_maps
  ```
  """
  @spec createWeightMaps(Evision.Detail.FeatherBlender.t(), list(Evision.Mat.maybe_mat_in()), list({number(), number()}), list(Evision.Mat.maybe_mat_in())) :: {{number(), number(), number(), number()}, list(Evision.Mat.t())} | {:error, String.t()}
  def createWeightMaps(self, masks, corners, weight_maps) when is_list(masks) and is_list(corners) and is_list(weight_maps)
  do
    positional = [
      masks: Evision.Internal.Structurise.from_struct(masks),
      corners: Evision.Internal.Structurise.from_struct(corners),
      weight_maps: Evision.Internal.Structurise.from_struct(weight_maps)
    ]
    :evision_nif.detail_detail_FeatherBlender_createWeightMaps(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec feed(Keyword.t()) :: any() | {:error, String.t()}
  def feed([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:tl,:img,:mask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_feed()
    |> to_struct()
  end

  @doc """
  feed

  ##### Positional Arguments
  - **self**: `Evision.Detail.FeatherBlender.t()`
  - **img**: `Evision.Mat`
  - **mask**: `Evision.Mat`
  - **tl**: `Point`

  Python prototype (for reference only):
  ```python3
  feed(img, mask, tl) -> None
  ```
  """
  @spec feed(Evision.Detail.FeatherBlender.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), {number(), number()}) :: Evision.Detail.FeatherBlender.t() | {:error, String.t()}
  def feed(self, img, mask, tl) when (is_struct(img, Evision.Mat) or is_struct(img, Nx.Tensor) or is_number(img) or is_tuple(img)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask)) and is_tuple(tl)
  do
    positional = [
      img: Evision.Internal.Structurise.from_struct(img),
      mask: Evision.Internal.Structurise.from_struct(mask),
      tl: Evision.Internal.Structurise.from_struct(tl)
    ]
    :evision_nif.detail_detail_FeatherBlender_feed(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec prepare(Keyword.t()) :: any() | {:error, String.t()}
  def prepare([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dst_roi])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_prepare()
    |> to_struct()
  end

  @doc """
  prepare

  ##### Positional Arguments
  - **self**: `Evision.Detail.FeatherBlender.t()`
  - **dst_roi**: `Rect`

  Python prototype (for reference only):
  ```python3
  prepare(dst_roi) -> None
  ```
  """
  @spec prepare(Evision.Detail.FeatherBlender.t(), {number(), number(), number(), number()}) :: Evision.Detail.FeatherBlender.t() | {:error, String.t()}
  def prepare(self, dst_roi) when is_tuple(dst_roi)
  do
    positional = [
      dst_roi: Evision.Internal.Structurise.from_struct(dst_roi)
    ]
    :evision_nif.detail_detail_FeatherBlender_prepare(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSharpness(Keyword.t()) :: any() | {:error, String.t()}
  def setSharpness([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:val])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_setSharpness()
    |> to_struct()
  end

  @doc """
  setSharpness

  ##### Positional Arguments
  - **self**: `Evision.Detail.FeatherBlender.t()`
  - **val**: `float`

  Python prototype (for reference only):
  ```python3
  setSharpness(val) -> None
  ```
  """
  @spec setSharpness(Evision.Detail.FeatherBlender.t(), number()) :: Evision.Detail.FeatherBlender.t() | {:error, String.t()}
  def setSharpness(self, val) when is_float(val)
  do
    positional = [
      val: Evision.Internal.Structurise.from_struct(val)
    ]
    :evision_nif.detail_detail_FeatherBlender_setSharpness(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  sharpness

  ##### Positional Arguments
  - **self**: `Evision.Detail.FeatherBlender.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  sharpness() -> retval
  ```
  """
  @spec sharpness(Keyword.t()) :: any() | {:error, String.t()}
  def sharpness([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_FeatherBlender_sharpness()
    |> to_struct()
  end
  @spec sharpness(Evision.Detail.FeatherBlender.t()) :: number() | {:error, String.t()}
  def sharpness(self) do
    positional = [
    ]
    :evision_nif.detail_detail_FeatherBlender_sharpness(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
