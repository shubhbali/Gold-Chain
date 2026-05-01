defmodule Evision.StereoBM do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `StereoBM` struct.

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
  def to_struct({:ok, %{class: Evision.StereoBM, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.StereoBM, ref: ref}) do
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
  @type enum :: integer()
  @doc enum: true
  def cv_PREFILTER_NORMALIZED_RESPONSE, do: 0
  @doc enum: true
  def cv_PREFILTER_XSOBEL, do: 1


  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_clear()
    |> to_struct()
  end
  @spec clear(Evision.StereoBM.t()) :: Evision.StereoBM.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.stereoBM_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Computes disparity map for the specified stereo pair

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **left**: `Evision.Mat`.

    Left 8-bit single-channel image.

  - **right**: `Evision.Mat`.

    Right image of the same size and the same type as the left one.

  ##### Return
  - **disparity**: `Evision.Mat.t()`.

    Output disparity map. It has the same size as the input images. Some algorithms,
    like StereoBM or StereoSGBM compute 16-bit fixed-point disparity map (where each disparity value
    has 4 fractional bits), whereas other algorithms output 32-bit floating-point disparity map.

  Python prototype (for reference only):
  ```python3
  compute(left, right[, disparity]) -> disparity
  ```
  """
  @spec compute(Evision.StereoBM.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def compute(self, left, right, opts) when (is_struct(left, Evision.Mat) or is_struct(left, Nx.Tensor) or is_number(left) or is_tuple(left)) and (is_struct(right, Evision.Mat) or is_struct(right, Nx.Tensor) or is_number(right) or is_tuple(right)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      left: Evision.Internal.Structurise.from_struct(left),
      right: Evision.Internal.Structurise.from_struct(right)
    ]
    :evision_nif.stereoBM_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Keyword.t()) :: any() | {:error, String.t()}
  def compute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:left,:disparity,:right])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_compute()
    |> to_struct()
  end

  @doc """
  Computes disparity map for the specified stereo pair

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **left**: `Evision.Mat`.

    Left 8-bit single-channel image.

  - **right**: `Evision.Mat`.

    Right image of the same size and the same type as the left one.

  ##### Return
  - **disparity**: `Evision.Mat.t()`.

    Output disparity map. It has the same size as the input images. Some algorithms,
    like StereoBM or StereoSGBM compute 16-bit fixed-point disparity map (where each disparity value
    has 4 fractional bits), whereas other algorithms output 32-bit floating-point disparity map.

  Python prototype (for reference only):
  ```python3
  compute(left, right[, disparity]) -> disparity
  ```
  """
  @spec compute(Evision.StereoBM.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def compute(self, left, right) when (is_struct(left, Evision.Mat) or is_struct(left, Nx.Tensor) or is_number(left) or is_tuple(left)) and (is_struct(right, Evision.Mat) or is_struct(right, Nx.Tensor) or is_number(right) or is_tuple(right))
  do
    positional = [
      left: Evision.Internal.Structurise.from_struct(left),
      right: Evision.Internal.Structurise.from_struct(right)
    ]
    :evision_nif.stereoBM_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Creates StereoBM object
  ##### Keyword Arguments
  - **numDisparities**: `integer()`.

    the disparity search range. For each pixel algorithm will find the best
    disparity from 0 (default minimum disparity) to numDisparities. The search range can then be
    shifted by changing the minimum disparity.

  - **blockSize**: `integer()`.

    the linear size of the blocks compared by the algorithm. The size should be odd
    (as the block is centered at the current pixel). Larger block size implies smoother, though less
    accurate disparity map. Smaller block size gives more detailed disparity map, but there is higher
    chance for algorithm to find a wrong correspondence.

  ##### Return
  - **retval**: `Evision.StereoBM.t()`

  The function create StereoBM object. You can then call StereoBM::compute() to compute disparity for
  a specific stereo pair.

  Python prototype (for reference only):
  ```python3
  create([, numDisparities[, blockSize]]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:numDisparities,:blockSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_create_static()
    |> to_struct()
  end
  @spec create([{:blockSize, term()} | {:numDisparities, term()}] | nil) :: Evision.StereoBM.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:blockSize, :numDisparities])
    positional = [
    ]
    :evision_nif.stereoBM_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Creates StereoBM object
  ##### Keyword Arguments
  - **numDisparities**: `integer()`.

    the disparity search range. For each pixel algorithm will find the best
    disparity from 0 (default minimum disparity) to numDisparities. The search range can then be
    shifted by changing the minimum disparity.

  - **blockSize**: `integer()`.

    the linear size of the blocks compared by the algorithm. The size should be odd
    (as the block is centered at the current pixel). Larger block size implies smoother, though less
    accurate disparity map. Smaller block size gives more detailed disparity map, but there is higher
    chance for algorithm to find a wrong correspondence.

  ##### Return
  - **retval**: `Evision.StereoBM.t()`

  The function create StereoBM object. You can then call StereoBM::compute() to compute disparity for
  a specific stereo pair.

  Python prototype (for reference only):
  ```python3
  create([, numDisparities[, blockSize]]) -> retval
  ```
  """
  @spec create() :: Evision.StereoBM.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.stereoBM_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

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
    |> :evision_nif.stereoBM_empty()
    |> to_struct()
  end
  @spec empty(Evision.StereoBM.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.stereoBM_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getBlockSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getBlockSize() -> retval
  ```
  """
  @spec getBlockSize(Keyword.t()) :: any() | {:error, String.t()}
  def getBlockSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getBlockSize()
    |> to_struct()
  end
  @spec getBlockSize(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getBlockSize(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getBlockSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

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
    |> :evision_nif.stereoBM_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.StereoBM.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDisp12MaxDiff

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getDisp12MaxDiff() -> retval
  ```
  """
  @spec getDisp12MaxDiff(Keyword.t()) :: any() | {:error, String.t()}
  def getDisp12MaxDiff([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getDisp12MaxDiff()
    |> to_struct()
  end
  @spec getDisp12MaxDiff(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getDisp12MaxDiff(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getDisp12MaxDiff(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMinDisparity

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMinDisparity() -> retval
  ```
  """
  @spec getMinDisparity(Keyword.t()) :: any() | {:error, String.t()}
  def getMinDisparity([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getMinDisparity()
    |> to_struct()
  end
  @spec getMinDisparity(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getMinDisparity(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getMinDisparity(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNumDisparities

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNumDisparities() -> retval
  ```
  """
  @spec getNumDisparities(Keyword.t()) :: any() | {:error, String.t()}
  def getNumDisparities([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getNumDisparities()
    |> to_struct()
  end
  @spec getNumDisparities(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getNumDisparities(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getNumDisparities(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getPreFilterCap

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getPreFilterCap() -> retval
  ```
  """
  @spec getPreFilterCap(Keyword.t()) :: any() | {:error, String.t()}
  def getPreFilterCap([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getPreFilterCap()
    |> to_struct()
  end
  @spec getPreFilterCap(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getPreFilterCap(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getPreFilterCap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getPreFilterSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getPreFilterSize() -> retval
  ```
  """
  @spec getPreFilterSize(Keyword.t()) :: any() | {:error, String.t()}
  def getPreFilterSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getPreFilterSize()
    |> to_struct()
  end
  @spec getPreFilterSize(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getPreFilterSize(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getPreFilterSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getPreFilterType

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getPreFilterType() -> retval
  ```
  """
  @spec getPreFilterType(Keyword.t()) :: any() | {:error, String.t()}
  def getPreFilterType([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getPreFilterType()
    |> to_struct()
  end
  @spec getPreFilterType(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getPreFilterType(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getPreFilterType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getROI1

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `Rect`

  Python prototype (for reference only):
  ```python3
  getROI1() -> retval
  ```
  """
  @spec getROI1(Keyword.t()) :: any() | {:error, String.t()}
  def getROI1([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getROI1()
    |> to_struct()
  end
  @spec getROI1(Evision.StereoBM.t()) :: {number(), number(), number(), number()} | {:error, String.t()}
  def getROI1(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getROI1(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getROI2

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `Rect`

  Python prototype (for reference only):
  ```python3
  getROI2() -> retval
  ```
  """
  @spec getROI2(Keyword.t()) :: any() | {:error, String.t()}
  def getROI2([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getROI2()
    |> to_struct()
  end
  @spec getROI2(Evision.StereoBM.t()) :: {number(), number(), number(), number()} | {:error, String.t()}
  def getROI2(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getROI2(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSmallerBlockSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getSmallerBlockSize() -> retval
  ```
  """
  @spec getSmallerBlockSize(Keyword.t()) :: any() | {:error, String.t()}
  def getSmallerBlockSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getSmallerBlockSize()
    |> to_struct()
  end
  @spec getSmallerBlockSize(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getSmallerBlockSize(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getSmallerBlockSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSpeckleRange

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getSpeckleRange() -> retval
  ```
  """
  @spec getSpeckleRange(Keyword.t()) :: any() | {:error, String.t()}
  def getSpeckleRange([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getSpeckleRange()
    |> to_struct()
  end
  @spec getSpeckleRange(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getSpeckleRange(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getSpeckleRange(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSpeckleWindowSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getSpeckleWindowSize() -> retval
  ```
  """
  @spec getSpeckleWindowSize(Keyword.t()) :: any() | {:error, String.t()}
  def getSpeckleWindowSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getSpeckleWindowSize()
    |> to_struct()
  end
  @spec getSpeckleWindowSize(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getSpeckleWindowSize(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getSpeckleWindowSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTextureThreshold

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getTextureThreshold() -> retval
  ```
  """
  @spec getTextureThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getTextureThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getTextureThreshold()
    |> to_struct()
  end
  @spec getTextureThreshold(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getTextureThreshold(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getTextureThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getUniquenessRatio

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getUniquenessRatio() -> retval
  ```
  """
  @spec getUniquenessRatio(Keyword.t()) :: any() | {:error, String.t()}
  def getUniquenessRatio([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_getUniquenessRatio()
    |> to_struct()
  end
  @spec getUniquenessRatio(Evision.StereoBM.t()) :: integer() | {:error, String.t()}
  def getUniquenessRatio(self) do
    positional = [
    ]
    :evision_nif.stereoBM_getUniquenessRatio(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.StereoBM.t(), Evision.FileNode.t()) :: Evision.StereoBM.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.stereoBM_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.StereoBM.t(), binary()) :: Evision.StereoBM.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.stereoBM_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setBlockSize(Keyword.t()) :: any() | {:error, String.t()}
  def setBlockSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:blockSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setBlockSize()
    |> to_struct()
  end

  @doc """
  setBlockSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **blockSize**: `integer()`

  Python prototype (for reference only):
  ```python3
  setBlockSize(blockSize) -> None
  ```
  """
  @spec setBlockSize(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setBlockSize(self, blockSize) when is_integer(blockSize)
  do
    positional = [
      blockSize: Evision.Internal.Structurise.from_struct(blockSize)
    ]
    :evision_nif.stereoBM_setBlockSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDisp12MaxDiff(Keyword.t()) :: any() | {:error, String.t()}
  def setDisp12MaxDiff([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:disp12MaxDiff])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setDisp12MaxDiff()
    |> to_struct()
  end

  @doc """
  setDisp12MaxDiff

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **disp12MaxDiff**: `integer()`

  Python prototype (for reference only):
  ```python3
  setDisp12MaxDiff(disp12MaxDiff) -> None
  ```
  """
  @spec setDisp12MaxDiff(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setDisp12MaxDiff(self, disp12MaxDiff) when is_integer(disp12MaxDiff)
  do
    positional = [
      disp12MaxDiff: Evision.Internal.Structurise.from_struct(disp12MaxDiff)
    ]
    :evision_nif.stereoBM_setDisp12MaxDiff(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinDisparity(Keyword.t()) :: any() | {:error, String.t()}
  def setMinDisparity([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:minDisparity])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setMinDisparity()
    |> to_struct()
  end

  @doc """
  setMinDisparity

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **minDisparity**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMinDisparity(minDisparity) -> None
  ```
  """
  @spec setMinDisparity(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setMinDisparity(self, minDisparity) when is_integer(minDisparity)
  do
    positional = [
      minDisparity: Evision.Internal.Structurise.from_struct(minDisparity)
    ]
    :evision_nif.stereoBM_setMinDisparity(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNumDisparities(Keyword.t()) :: any() | {:error, String.t()}
  def setNumDisparities([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:numDisparities])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setNumDisparities()
    |> to_struct()
  end

  @doc """
  setNumDisparities

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **numDisparities**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNumDisparities(numDisparities) -> None
  ```
  """
  @spec setNumDisparities(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setNumDisparities(self, numDisparities) when is_integer(numDisparities)
  do
    positional = [
      numDisparities: Evision.Internal.Structurise.from_struct(numDisparities)
    ]
    :evision_nif.stereoBM_setNumDisparities(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPreFilterCap(Keyword.t()) :: any() | {:error, String.t()}
  def setPreFilterCap([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:preFilterCap])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setPreFilterCap()
    |> to_struct()
  end

  @doc """
  setPreFilterCap

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **preFilterCap**: `integer()`

  Python prototype (for reference only):
  ```python3
  setPreFilterCap(preFilterCap) -> None
  ```
  """
  @spec setPreFilterCap(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setPreFilterCap(self, preFilterCap) when is_integer(preFilterCap)
  do
    positional = [
      preFilterCap: Evision.Internal.Structurise.from_struct(preFilterCap)
    ]
    :evision_nif.stereoBM_setPreFilterCap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPreFilterSize(Keyword.t()) :: any() | {:error, String.t()}
  def setPreFilterSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:preFilterSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setPreFilterSize()
    |> to_struct()
  end

  @doc """
  setPreFilterSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **preFilterSize**: `integer()`

  Python prototype (for reference only):
  ```python3
  setPreFilterSize(preFilterSize) -> None
  ```
  """
  @spec setPreFilterSize(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setPreFilterSize(self, preFilterSize) when is_integer(preFilterSize)
  do
    positional = [
      preFilterSize: Evision.Internal.Structurise.from_struct(preFilterSize)
    ]
    :evision_nif.stereoBM_setPreFilterSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPreFilterType(Keyword.t()) :: any() | {:error, String.t()}
  def setPreFilterType([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:preFilterType])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setPreFilterType()
    |> to_struct()
  end

  @doc """
  setPreFilterType

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **preFilterType**: `integer()`

  Python prototype (for reference only):
  ```python3
  setPreFilterType(preFilterType) -> None
  ```
  """
  @spec setPreFilterType(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setPreFilterType(self, preFilterType) when is_integer(preFilterType)
  do
    positional = [
      preFilterType: Evision.Internal.Structurise.from_struct(preFilterType)
    ]
    :evision_nif.stereoBM_setPreFilterType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setROI1(Keyword.t()) :: any() | {:error, String.t()}
  def setROI1([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:roi1])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setROI1()
    |> to_struct()
  end

  @doc """
  setROI1

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **roi1**: `Rect`

  Python prototype (for reference only):
  ```python3
  setROI1(roi1) -> None
  ```
  """
  @spec setROI1(Evision.StereoBM.t(), {number(), number(), number(), number()}) :: Evision.StereoBM.t() | {:error, String.t()}
  def setROI1(self, roi1) when is_tuple(roi1)
  do
    positional = [
      roi1: Evision.Internal.Structurise.from_struct(roi1)
    ]
    :evision_nif.stereoBM_setROI1(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setROI2(Keyword.t()) :: any() | {:error, String.t()}
  def setROI2([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:roi2])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setROI2()
    |> to_struct()
  end

  @doc """
  setROI2

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **roi2**: `Rect`

  Python prototype (for reference only):
  ```python3
  setROI2(roi2) -> None
  ```
  """
  @spec setROI2(Evision.StereoBM.t(), {number(), number(), number(), number()}) :: Evision.StereoBM.t() | {:error, String.t()}
  def setROI2(self, roi2) when is_tuple(roi2)
  do
    positional = [
      roi2: Evision.Internal.Structurise.from_struct(roi2)
    ]
    :evision_nif.stereoBM_setROI2(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSmallerBlockSize(Keyword.t()) :: any() | {:error, String.t()}
  def setSmallerBlockSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:blockSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setSmallerBlockSize()
    |> to_struct()
  end

  @doc """
  setSmallerBlockSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **blockSize**: `integer()`

  Python prototype (for reference only):
  ```python3
  setSmallerBlockSize(blockSize) -> None
  ```
  """
  @spec setSmallerBlockSize(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setSmallerBlockSize(self, blockSize) when is_integer(blockSize)
  do
    positional = [
      blockSize: Evision.Internal.Structurise.from_struct(blockSize)
    ]
    :evision_nif.stereoBM_setSmallerBlockSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSpeckleRange(Keyword.t()) :: any() | {:error, String.t()}
  def setSpeckleRange([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:speckleRange])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setSpeckleRange()
    |> to_struct()
  end

  @doc """
  setSpeckleRange

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **speckleRange**: `integer()`

  Python prototype (for reference only):
  ```python3
  setSpeckleRange(speckleRange) -> None
  ```
  """
  @spec setSpeckleRange(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setSpeckleRange(self, speckleRange) when is_integer(speckleRange)
  do
    positional = [
      speckleRange: Evision.Internal.Structurise.from_struct(speckleRange)
    ]
    :evision_nif.stereoBM_setSpeckleRange(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSpeckleWindowSize(Keyword.t()) :: any() | {:error, String.t()}
  def setSpeckleWindowSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:speckleWindowSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setSpeckleWindowSize()
    |> to_struct()
  end

  @doc """
  setSpeckleWindowSize

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **speckleWindowSize**: `integer()`

  Python prototype (for reference only):
  ```python3
  setSpeckleWindowSize(speckleWindowSize) -> None
  ```
  """
  @spec setSpeckleWindowSize(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setSpeckleWindowSize(self, speckleWindowSize) when is_integer(speckleWindowSize)
  do
    positional = [
      speckleWindowSize: Evision.Internal.Structurise.from_struct(speckleWindowSize)
    ]
    :evision_nif.stereoBM_setSpeckleWindowSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setTextureThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setTextureThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:textureThreshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setTextureThreshold()
    |> to_struct()
  end

  @doc """
  setTextureThreshold

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **textureThreshold**: `integer()`

  Python prototype (for reference only):
  ```python3
  setTextureThreshold(textureThreshold) -> None
  ```
  """
  @spec setTextureThreshold(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setTextureThreshold(self, textureThreshold) when is_integer(textureThreshold)
  do
    positional = [
      textureThreshold: Evision.Internal.Structurise.from_struct(textureThreshold)
    ]
    :evision_nif.stereoBM_setTextureThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setUniquenessRatio(Keyword.t()) :: any() | {:error, String.t()}
  def setUniquenessRatio([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:uniquenessRatio])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_setUniquenessRatio()
    |> to_struct()
  end

  @doc """
  setUniquenessRatio

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **uniquenessRatio**: `integer()`

  Python prototype (for reference only):
  ```python3
  setUniquenessRatio(uniquenessRatio) -> None
  ```
  """
  @spec setUniquenessRatio(Evision.StereoBM.t(), integer()) :: Evision.StereoBM.t() | {:error, String.t()}
  def setUniquenessRatio(self, uniquenessRatio) when is_integer(uniquenessRatio)
  do
    positional = [
      uniquenessRatio: Evision.Internal.Structurise.from_struct(uniquenessRatio)
    ]
    :evision_nif.stereoBM_setUniquenessRatio(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stereoBM_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.StereoBM.t(), Evision.FileStorage.t(), binary()) :: Evision.StereoBM.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.stereoBM_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.StereoBM.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.StereoBM.t(), Evision.FileStorage.t()) :: Evision.StereoBM.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.stereoBM_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
