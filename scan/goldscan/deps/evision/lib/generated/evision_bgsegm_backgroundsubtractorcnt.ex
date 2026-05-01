defmodule Evision.BgSegm.BackgroundSubtractorCNT do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `BgSegm.BackgroundSubtractorCNT` struct.

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
  def to_struct({:ok, %{class: Evision.BgSegm.BackgroundSubtractorCNT, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.BgSegm.BackgroundSubtractorCNT, ref: ref}) do
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
  apply

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **image**: `Evision.Mat`

  ##### Keyword Arguments
  - **learningRate**: `double`.

  ##### Return
  - **fgmask**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  apply(image[, fgmask[, learningRate]]) -> fgmask
  ```
  """
  @spec apply(Evision.BgSegm.BackgroundSubtractorCNT.t(), Evision.Mat.maybe_mat_in(), [{:learningRate, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:learningRate])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_apply(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec apply(Keyword.t()) :: any() | {:error, String.t()}
  def apply([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:learningRate,:image,:fgmask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_apply()
    |> to_struct()
  end

  @doc """
  apply

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **image**: `Evision.Mat`

  ##### Keyword Arguments
  - **learningRate**: `double`.

  ##### Return
  - **fgmask**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  apply(image[, fgmask[, learningRate]]) -> fgmask
  ```
  """
  @spec apply(Evision.BgSegm.BackgroundSubtractorCNT.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_apply(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorCNT_clear()
    |> to_struct()
  end
  @spec clear(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

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
    |> :evision_nif.bgsegm_BackgroundSubtractorCNT_empty()
    |> to_struct()
  end
  @spec empty(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getBackgroundImage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  ##### Return
  - **backgroundImage**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  getBackgroundImage([, backgroundImage]) -> backgroundImage
  ```
  """
  @spec getBackgroundImage(Evision.BgSegm.BackgroundSubtractorCNT.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  getBackgroundImage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  ##### Return
  - **backgroundImage**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  getBackgroundImage([, backgroundImage]) -> backgroundImage
  ```
  """
  @spec getBackgroundImage(Keyword.t()) :: any() | {:error, String.t()}
  def getBackgroundImage([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:backgroundImage])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getBackgroundImage()
    |> to_struct()
  end
  @spec getBackgroundImage(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

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
    |> :evision_nif.bgsegm_BackgroundSubtractorCNT_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns if we're parallelizing the algorithm.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  getIsParallel() -> retval
  ```
  """
  @spec getIsParallel(Keyword.t()) :: any() | {:error, String.t()}
  def getIsParallel([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getIsParallel()
    |> to_struct()
  end
  @spec getIsParallel(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: boolean() | {:error, String.t()}
  def getIsParallel(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getIsParallel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns maximum allowed credit for a pixel in history.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMaxPixelStability() -> retval
  ```
  """
  @spec getMaxPixelStability(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxPixelStability([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getMaxPixelStability()
    |> to_struct()
  end
  @spec getMaxPixelStability(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: integer() | {:error, String.t()}
  def getMaxPixelStability(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getMaxPixelStability(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns number of frames with same pixel color to consider stable.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMinPixelStability() -> retval
  ```
  """
  @spec getMinPixelStability(Keyword.t()) :: any() | {:error, String.t()}
  def getMinPixelStability([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getMinPixelStability()
    |> to_struct()
  end
  @spec getMinPixelStability(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: integer() | {:error, String.t()}
  def getMinPixelStability(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getMinPixelStability(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns if we're giving a pixel credit for being stable for a long time.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  getUseHistory() -> retval
  ```
  """
  @spec getUseHistory(Keyword.t()) :: any() | {:error, String.t()}
  def getUseHistory([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getUseHistory()
    |> to_struct()
  end
  @spec getUseHistory(Evision.BgSegm.BackgroundSubtractorCNT.t()) :: boolean() | {:error, String.t()}
  def getUseHistory(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_getUseHistory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorCNT_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.BgSegm.BackgroundSubtractorCNT.t(), Evision.FileNode.t()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorCNT_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.BgSegm.BackgroundSubtractorCNT.t(), binary()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setIsParallel(Keyword.t()) :: any() | {:error, String.t()}
  def setIsParallel([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setIsParallel()
    |> to_struct()
  end

  @doc """
  Sets if we're parallelizing the algorithm.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **value**: `bool`

  Python prototype (for reference only):
  ```python3
  setIsParallel(value) -> None
  ```
  """
  @spec setIsParallel(Evision.BgSegm.BackgroundSubtractorCNT.t(), boolean()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def setIsParallel(self, value) when is_boolean(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setIsParallel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxPixelStability(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxPixelStability([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setMaxPixelStability()
    |> to_struct()
  end

  @doc """
  Sets the maximum allowed credit for a pixel in history.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **value**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMaxPixelStability(value) -> None
  ```
  """
  @spec setMaxPixelStability(Evision.BgSegm.BackgroundSubtractorCNT.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def setMaxPixelStability(self, value) when is_integer(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setMaxPixelStability(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinPixelStability(Keyword.t()) :: any() | {:error, String.t()}
  def setMinPixelStability([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setMinPixelStability()
    |> to_struct()
  end

  @doc """
  Sets the number of frames with same pixel color to consider stable.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **value**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMinPixelStability(value) -> None
  ```
  """
  @spec setMinPixelStability(Evision.BgSegm.BackgroundSubtractorCNT.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def setMinPixelStability(self, value) when is_integer(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setMinPixelStability(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setUseHistory(Keyword.t()) :: any() | {:error, String.t()}
  def setUseHistory([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setUseHistory()
    |> to_struct()
  end

  @doc """
  Sets if we're giving a pixel credit for being stable for a long time.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **value**: `bool`

  Python prototype (for reference only):
  ```python3
  setUseHistory(value) -> None
  ```
  """
  @spec setUseHistory(Evision.BgSegm.BackgroundSubtractorCNT.t(), boolean()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def setUseHistory(self, value) when is_boolean(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorCNT_setUseHistory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorCNT_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.BgSegm.BackgroundSubtractorCNT.t(), Evision.FileStorage.t(), binary()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorCNT.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.BgSegm.BackgroundSubtractorCNT.t(), Evision.FileStorage.t()) :: Evision.BgSegm.BackgroundSubtractorCNT.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorCNT_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
