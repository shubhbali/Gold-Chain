defmodule Evision.HFS.HfsSegment do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `HFS.HfsSegment` struct.

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
  def to_struct({:ok, %{class: Evision.HFS.HfsSegment, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.HFS.HfsSegment, ref: ref}) do
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
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_HfsSegment_clear()
    |> to_struct()
  end
  @spec clear(Evision.HFS.HfsSegment.t()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.hfs_HfsSegment_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  : create a hfs object

  ##### Positional Arguments
  - **height**: `integer()`.

    the height of the input image

  - **width**: `integer()`.

    the width of the input image

  ##### Keyword Arguments
  - **segEgbThresholdI**: `float`.

    parameter segEgbThresholdI

  - **minRegionSizeI**: `integer()`.

    parameter minRegionSizeI

  - **segEgbThresholdII**: `float`.

    parameter segEgbThresholdII

  - **minRegionSizeII**: `integer()`.

    parameter minRegionSizeII

  - **spatialWeight**: `float`.

    parameter spatialWeight

  - **slicSpixelSize**: `integer()`.

    parameter slicSpixelSize

  - **numSlicIter**: `integer()`.

    parameter numSlicIter

  ##### Return
  - **retval**: `HfsSegment`

  Python prototype (for reference only):
  ```python3
  create(height, width[, segEgbThresholdI[, minRegionSizeI[, segEgbThresholdII[, minRegionSizeII[, spatialWeight[, slicSpixelSize[, numSlicIter]]]]]]]) -> retval
  ```
  """
  @spec create(integer(), integer(), [{:minRegionSizeI, term()} | {:minRegionSizeII, term()} | {:numSlicIter, term()} | {:segEgbThresholdI, term()} | {:segEgbThresholdII, term()} | {:slicSpixelSize, term()} | {:spatialWeight, term()}] | nil) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def create(height, width, opts) when is_integer(height) and is_integer(width) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:minRegionSizeI, :minRegionSizeII, :numSlicIter, :segEgbThresholdI, :segEgbThresholdII, :slicSpixelSize, :spatialWeight])
    positional = [
      height: Evision.Internal.Structurise.from_struct(height),
      width: Evision.Internal.Structurise.from_struct(width)
    ]
    :evision_nif.hfs_hfs_HfsSegment_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:minRegionSizeII,:slicSpixelSize,:width,:segEgbThresholdI,:height,:spatialWeight,:segEgbThresholdII,:numSlicIter,:minRegionSizeI])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_create_static()
    |> to_struct()
  end

  @doc """
  : create a hfs object

  ##### Positional Arguments
  - **height**: `integer()`.

    the height of the input image

  - **width**: `integer()`.

    the width of the input image

  ##### Keyword Arguments
  - **segEgbThresholdI**: `float`.

    parameter segEgbThresholdI

  - **minRegionSizeI**: `integer()`.

    parameter minRegionSizeI

  - **segEgbThresholdII**: `float`.

    parameter segEgbThresholdII

  - **minRegionSizeII**: `integer()`.

    parameter minRegionSizeII

  - **spatialWeight**: `float`.

    parameter spatialWeight

  - **slicSpixelSize**: `integer()`.

    parameter slicSpixelSize

  - **numSlicIter**: `integer()`.

    parameter numSlicIter

  ##### Return
  - **retval**: `HfsSegment`

  Python prototype (for reference only):
  ```python3
  create(height, width[, segEgbThresholdI[, minRegionSizeI[, segEgbThresholdII[, minRegionSizeII[, spatialWeight[, slicSpixelSize[, numSlicIter]]]]]]]) -> retval
  ```
  """
  @spec create(integer(), integer()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def create(height, width) when is_integer(height) and is_integer(width)
  do
    positional = [
      height: Evision.Internal.Structurise.from_struct(height),
      width: Evision.Internal.Structurise.from_struct(width)
    ]
    :evision_nif.hfs_hfs_HfsSegment_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  empty() -> retval
  ```
  """
  @spec empty(Keyword.t()) :: any() | {:error, String.t()}
  def empty([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_HfsSegment_empty()
    |> to_struct()
  end
  @spec empty(Evision.HFS.HfsSegment.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.hfs_HfsSegment_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `String`

  Returns the algorithm string identifier.
  This string is used as top level xml/yml node tag when the object is saved to a file or string.

  Python prototype (for reference only):
  ```python3
  getDefaultName() -> retval
  ```
  """
  @spec getDefaultName(Keyword.t()) :: any() | {:error, String.t()}
  def getDefaultName([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_HfsSegment_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.HFS.HfsSegment.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.hfs_HfsSegment_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMinRegionSizeI

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMinRegionSizeI() -> retval
  ```
  """
  @spec getMinRegionSizeI(Keyword.t()) :: any() | {:error, String.t()}
  def getMinRegionSizeI([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getMinRegionSizeI()
    |> to_struct()
  end
  @spec getMinRegionSizeI(Evision.HFS.HfsSegment.t()) :: integer() | {:error, String.t()}
  def getMinRegionSizeI(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getMinRegionSizeI(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMinRegionSizeII

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMinRegionSizeII() -> retval
  ```
  """
  @spec getMinRegionSizeII(Keyword.t()) :: any() | {:error, String.t()}
  def getMinRegionSizeII([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getMinRegionSizeII()
    |> to_struct()
  end
  @spec getMinRegionSizeII(Evision.HFS.HfsSegment.t()) :: integer() | {:error, String.t()}
  def getMinRegionSizeII(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getMinRegionSizeII(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNumSlicIter

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNumSlicIter() -> retval
  ```
  """
  @spec getNumSlicIter(Keyword.t()) :: any() | {:error, String.t()}
  def getNumSlicIter([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getNumSlicIter()
    |> to_struct()
  end
  @spec getNumSlicIter(Evision.HFS.HfsSegment.t()) :: integer() | {:error, String.t()}
  def getNumSlicIter(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getNumSlicIter(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSegEgbThresholdI

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getSegEgbThresholdI() -> retval
  ```
  """
  @spec getSegEgbThresholdI(Keyword.t()) :: any() | {:error, String.t()}
  def getSegEgbThresholdI([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getSegEgbThresholdI()
    |> to_struct()
  end
  @spec getSegEgbThresholdI(Evision.HFS.HfsSegment.t()) :: number() | {:error, String.t()}
  def getSegEgbThresholdI(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getSegEgbThresholdI(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSegEgbThresholdII

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getSegEgbThresholdII() -> retval
  ```
  """
  @spec getSegEgbThresholdII(Keyword.t()) :: any() | {:error, String.t()}
  def getSegEgbThresholdII([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getSegEgbThresholdII()
    |> to_struct()
  end
  @spec getSegEgbThresholdII(Evision.HFS.HfsSegment.t()) :: number() | {:error, String.t()}
  def getSegEgbThresholdII(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getSegEgbThresholdII(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSlicSpixelSize

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getSlicSpixelSize() -> retval
  ```
  """
  @spec getSlicSpixelSize(Keyword.t()) :: any() | {:error, String.t()}
  def getSlicSpixelSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getSlicSpixelSize()
    |> to_struct()
  end
  @spec getSlicSpixelSize(Evision.HFS.HfsSegment.t()) :: integer() | {:error, String.t()}
  def getSlicSpixelSize(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getSlicSpixelSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSpatialWeight

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getSpatialWeight() -> retval
  ```
  """
  @spec getSpatialWeight(Keyword.t()) :: any() | {:error, String.t()}
  def getSpatialWeight([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_getSpatialWeight()
    |> to_struct()
  end
  @spec getSpatialWeight(Evision.HFS.HfsSegment.t()) :: number() | {:error, String.t()}
  def getSpatialWeight(self) do
    positional = [
    ]
    :evision_nif.hfs_hfs_HfsSegment_getSpatialWeight(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  do segmentation with cpu
  This method is only implemented for reference.
  It is highly NOT recommanded to use it.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **src**: `Evision.Mat`

  ##### Keyword Arguments
  - **ifDraw**: `bool`.

  ##### Return
  - **retval**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  performSegmentCpu(src[, ifDraw]) -> retval
  ```
  """
  @spec performSegmentCpu(Evision.HFS.HfsSegment.t(), Evision.Mat.maybe_mat_in(), [{:ifDraw, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def performSegmentCpu(self, src, opts) when (is_struct(src, Evision.Mat) or is_struct(src, Nx.Tensor) or is_number(src) or is_tuple(src)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:ifDraw])
    positional = [
      src: Evision.Internal.Structurise.from_struct(src)
    ]
    :evision_nif.hfs_hfs_HfsSegment_performSegmentCpu(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec performSegmentCpu(Keyword.t()) :: any() | {:error, String.t()}
  def performSegmentCpu([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:src,:ifDraw])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_performSegmentCpu()
    |> to_struct()
  end

  @doc """
  do segmentation with cpu
  This method is only implemented for reference.
  It is highly NOT recommanded to use it.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **src**: `Evision.Mat`

  ##### Keyword Arguments
  - **ifDraw**: `bool`.

  ##### Return
  - **retval**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  performSegmentCpu(src[, ifDraw]) -> retval
  ```
  """
  @spec performSegmentCpu(Evision.HFS.HfsSegment.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def performSegmentCpu(self, src) when (is_struct(src, Evision.Mat) or is_struct(src, Nx.Tensor) or is_number(src) or is_tuple(src))
  do
    positional = [
      src: Evision.Internal.Structurise.from_struct(src)
    ]
    :evision_nif.hfs_hfs_HfsSegment_performSegmentCpu(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  do segmentation gpu

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **src**: `Evision.Mat`.

    the input image

  ##### Keyword Arguments
  - **ifDraw**: `bool`.

    if draw the image in the returned Mat. if this parameter is false,
    then the content of the returned Mat is a matrix of index, describing the region
    each pixel belongs to. And it's data type is CV_16U. If this parameter is true,
    then the returned Mat is a segmented picture, and color of each region is the
    average color of all pixels in that region. And it's data type is the same as
    the input image

  ##### Return
  - **retval**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  performSegmentGpu(src[, ifDraw]) -> retval
  ```
  """
  @spec performSegmentGpu(Evision.HFS.HfsSegment.t(), Evision.Mat.maybe_mat_in(), [{:ifDraw, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def performSegmentGpu(self, src, opts) when (is_struct(src, Evision.Mat) or is_struct(src, Nx.Tensor) or is_number(src) or is_tuple(src)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:ifDraw])
    positional = [
      src: Evision.Internal.Structurise.from_struct(src)
    ]
    :evision_nif.hfs_hfs_HfsSegment_performSegmentGpu(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec performSegmentGpu(Keyword.t()) :: any() | {:error, String.t()}
  def performSegmentGpu([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:src,:ifDraw])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_performSegmentGpu()
    |> to_struct()
  end

  @doc """
  do segmentation gpu

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **src**: `Evision.Mat`.

    the input image

  ##### Keyword Arguments
  - **ifDraw**: `bool`.

    if draw the image in the returned Mat. if this parameter is false,
    then the content of the returned Mat is a matrix of index, describing the region
    each pixel belongs to. And it's data type is CV_16U. If this parameter is true,
    then the returned Mat is a segmented picture, and color of each region is the
    average color of all pixels in that region. And it's data type is the same as
    the input image

  ##### Return
  - **retval**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  performSegmentGpu(src[, ifDraw]) -> retval
  ```
  """
  @spec performSegmentGpu(Evision.HFS.HfsSegment.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def performSegmentGpu(self, src) when (is_struct(src, Evision.Mat) or is_struct(src, Nx.Tensor) or is_number(src) or is_tuple(src))
  do
    positional = [
      src: Evision.Internal.Structurise.from_struct(src)
    ]
    :evision_nif.hfs_hfs_HfsSegment_performSegmentGpu(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_HfsSegment_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.HFS.HfsSegment.t(), Evision.FileNode.t()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.hfs_HfsSegment_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_HfsSegment_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.HFS.HfsSegment.t(), binary()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.hfs_HfsSegment_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinRegionSizeI(Keyword.t()) :: any() | {:error, String.t()}
  def setMinRegionSizeI([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:n])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setMinRegionSizeI()
    |> to_struct()
  end

  @doc """
  : set and get the parameter minRegionSizeI.
  This parameter is used in the second stage
  mentioned above. After the EGB segmentation, regions that have fewer
  pixels then this parameter will be merged into it's adjacent region.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **n**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMinRegionSizeI(n) -> None
  ```
  """
  @spec setMinRegionSizeI(Evision.HFS.HfsSegment.t(), integer()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setMinRegionSizeI(self, n) when is_integer(n)
  do
    positional = [
      n: Evision.Internal.Structurise.from_struct(n)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setMinRegionSizeI(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinRegionSizeII(Keyword.t()) :: any() | {:error, String.t()}
  def setMinRegionSizeII([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:n])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setMinRegionSizeII()
    |> to_struct()
  end

  @doc """
  : set and get the parameter minRegionSizeII.
  This parameter is used in the third stage
  mentioned above. It serves the same purpose as minRegionSizeI

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **n**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMinRegionSizeII(n) -> None
  ```
  """
  @spec setMinRegionSizeII(Evision.HFS.HfsSegment.t(), integer()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setMinRegionSizeII(self, n) when is_integer(n)
  do
    positional = [
      n: Evision.Internal.Structurise.from_struct(n)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setMinRegionSizeII(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNumSlicIter(Keyword.t()) :: any() | {:error, String.t()}
  def setNumSlicIter([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:n])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setNumSlicIter()
    |> to_struct()
  end

  @doc """
  : set and get the parameter numSlicIter.
  This parameter is used in the first stage. It
  describes how many iteration to perform when executing SLIC.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **n**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNumSlicIter(n) -> None
  ```
  """
  @spec setNumSlicIter(Evision.HFS.HfsSegment.t(), integer()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setNumSlicIter(self, n) when is_integer(n)
  do
    positional = [
      n: Evision.Internal.Structurise.from_struct(n)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setNumSlicIter(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSegEgbThresholdI(Keyword.t()) :: any() | {:error, String.t()}
  def setSegEgbThresholdI([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:c])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setSegEgbThresholdI()
    |> to_struct()
  end

  @doc """
  : set and get the parameter segEgbThresholdI.
  This parameter is used in the second stage mentioned above.
  It is a constant used to threshold weights of the edge when merging
  adjacent nodes when applying EGB algorithm. The segmentation result
  tends to have more regions remained if this value is large and vice versa.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **c**: `float`

  Python prototype (for reference only):
  ```python3
  setSegEgbThresholdI(c) -> None
  ```
  """
  @spec setSegEgbThresholdI(Evision.HFS.HfsSegment.t(), number()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setSegEgbThresholdI(self, c) when is_float(c)
  do
    positional = [
      c: Evision.Internal.Structurise.from_struct(c)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setSegEgbThresholdI(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSegEgbThresholdII(Keyword.t()) :: any() | {:error, String.t()}
  def setSegEgbThresholdII([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:c])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setSegEgbThresholdII()
    |> to_struct()
  end

  @doc """
  : set and get the parameter segEgbThresholdII.
  This parameter is used in the third stage
  mentioned above. It serves the same purpose as segEgbThresholdI.
  The segmentation result tends to have more regions remained if
  this value is large and vice versa.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **c**: `float`

  Python prototype (for reference only):
  ```python3
  setSegEgbThresholdII(c) -> None
  ```
  """
  @spec setSegEgbThresholdII(Evision.HFS.HfsSegment.t(), number()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setSegEgbThresholdII(self, c) when is_float(c)
  do
    positional = [
      c: Evision.Internal.Structurise.from_struct(c)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setSegEgbThresholdII(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSlicSpixelSize(Keyword.t()) :: any() | {:error, String.t()}
  def setSlicSpixelSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:n])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setSlicSpixelSize()
    |> to_struct()
  end

  @doc """
  : set and get the parameter slicSpixelSize.
  This parameter is used in the first stage mentioned
  above(the SLIC stage). It describes the size of each
  superpixel when initializing SLIC. Every superpixel
  approximately has \\f$slicSpixelSize \\times slicSpixelSize\\f$
  pixels in the beginning.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **n**: `integer()`

  Python prototype (for reference only):
  ```python3
  setSlicSpixelSize(n) -> None
  ```
  """
  @spec setSlicSpixelSize(Evision.HFS.HfsSegment.t(), integer()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setSlicSpixelSize(self, n) when is_integer(n)
  do
    positional = [
      n: Evision.Internal.Structurise.from_struct(n)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setSlicSpixelSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSpatialWeight(Keyword.t()) :: any() | {:error, String.t()}
  def setSpatialWeight([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:w])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_hfs_HfsSegment_setSpatialWeight()
    |> to_struct()
  end

  @doc """
  : set and get the parameter spatialWeight.
  This parameter is used in the first stage
  mentioned above(the SLIC stage). It describes how important is the role
  of position when calculating the distance between each pixel and it's
  center. The exact formula to calculate the distance is
  \\f$colorDistance + spatialWeight \\times spatialDistance\\f$.
  The segmentation result tends to have more local consistency
  if this value is larger.

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **w**: `float`

  Python prototype (for reference only):
  ```python3
  setSpatialWeight(w) -> None
  ```
  """
  @spec setSpatialWeight(Evision.HFS.HfsSegment.t(), number()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def setSpatialWeight(self, w) when is_float(w)
  do
    positional = [
      w: Evision.Internal.Structurise.from_struct(w)
    ]
    :evision_nif.hfs_hfs_HfsSegment_setSpatialWeight(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hfs_HfsSegment_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.HFS.HfsSegment.t(), Evision.FileStorage.t(), binary()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.hfs_HfsSegment_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.HFS.HfsSegment.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.HFS.HfsSegment.t(), Evision.FileStorage.t()) :: Evision.HFS.HfsSegment.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.hfs_HfsSegment_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
