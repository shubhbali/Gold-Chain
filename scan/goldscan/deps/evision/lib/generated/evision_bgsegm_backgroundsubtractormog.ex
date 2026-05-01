defmodule Evision.BgSegm.BackgroundSubtractorMOG do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `BgSegm.BackgroundSubtractorMOG` struct.

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
  def to_struct({:ok, %{class: Evision.BgSegm.BackgroundSubtractorMOG, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.BgSegm.BackgroundSubtractorMOG, ref: ref}) do
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
  Computes a foreground mask.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **image**: `Evision.Mat`.

    Next video frame.

  ##### Keyword Arguments
  - **learningRate**: `double`.

    The value between 0 and 1 that indicates how fast the background model is
    learnt. Negative parameter value makes the algorithm to use some automatically chosen learning
    rate. 0 means that the background model is not updated at all, 1 means that the background model
    is completely reinitialized from the last frame.

  ##### Return
  - **fgmask**: `Evision.Mat.t()`.

    The output foreground mask as an 8-bit binary image.

  Python prototype (for reference only):
  ```python3
  apply(image[, fgmask[, learningRate]]) -> fgmask
  ```
  """
  @spec apply(Evision.BgSegm.BackgroundSubtractorMOG.t(), Evision.Mat.maybe_mat_in(), [{:learningRate, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:learningRate])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_apply(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec apply(Keyword.t()) :: any() | {:error, String.t()}
  def apply([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:learningRate,:image,:fgmask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_apply()
    |> to_struct()
  end

  @doc """
  Computes a foreground mask.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **image**: `Evision.Mat`.

    Next video frame.

  ##### Keyword Arguments
  - **learningRate**: `double`.

    The value between 0 and 1 that indicates how fast the background model is
    learnt. Negative parameter value makes the algorithm to use some automatically chosen learning
    rate. 0 means that the background model is not updated at all, 1 means that the background model
    is completely reinitialized from the last frame.

  ##### Return
  - **fgmask**: `Evision.Mat.t()`.

    The output foreground mask as an 8-bit binary image.

  Python prototype (for reference only):
  ```python3
  apply(image[, fgmask[, learningRate]]) -> fgmask
  ```
  """
  @spec apply(Evision.BgSegm.BackgroundSubtractorMOG.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_apply(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_clear()
    |> to_struct()
  end
  @spec clear(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

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
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_empty()
    |> to_struct()
  end
  @spec empty(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Computes a background image.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  ##### Return
  - **backgroundImage**: `Evision.Mat.t()`.

    The output background image.

  **Note**: Sometimes the background image can be very blurry, as it contain the average background
  statistics.

  Python prototype (for reference only):
  ```python3
  getBackgroundImage([, backgroundImage]) -> backgroundImage
  ```
  """
  @spec getBackgroundImage(Evision.BgSegm.BackgroundSubtractorMOG.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Computes a background image.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  ##### Return
  - **backgroundImage**: `Evision.Mat.t()`.

    The output background image.

  **Note**: Sometimes the background image can be very blurry, as it contain the average background
  statistics.

  Python prototype (for reference only):
  ```python3
  getBackgroundImage([, backgroundImage]) -> backgroundImage
  ```
  """
  @spec getBackgroundImage(Keyword.t()) :: any() | {:error, String.t()}
  def getBackgroundImage([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:backgroundImage])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_getBackgroundImage()
    |> to_struct()
  end
  @spec getBackgroundImage(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getBackgroundRatio

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getBackgroundRatio() -> retval
  ```
  """
  @spec getBackgroundRatio(Keyword.t()) :: any() | {:error, String.t()}
  def getBackgroundRatio([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getBackgroundRatio()
    |> to_struct()
  end
  @spec getBackgroundRatio(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: number() | {:error, String.t()}
  def getBackgroundRatio(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getBackgroundRatio(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

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
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getHistory

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getHistory() -> retval
  ```
  """
  @spec getHistory(Keyword.t()) :: any() | {:error, String.t()}
  def getHistory([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getHistory()
    |> to_struct()
  end
  @spec getHistory(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: integer() | {:error, String.t()}
  def getHistory(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getHistory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNMixtures

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNMixtures() -> retval
  ```
  """
  @spec getNMixtures(Keyword.t()) :: any() | {:error, String.t()}
  def getNMixtures([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getNMixtures()
    |> to_struct()
  end
  @spec getNMixtures(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: integer() | {:error, String.t()}
  def getNMixtures(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getNMixtures(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNoiseSigma

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getNoiseSigma() -> retval
  ```
  """
  @spec getNoiseSigma(Keyword.t()) :: any() | {:error, String.t()}
  def getNoiseSigma([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getNoiseSigma()
    |> to_struct()
  end
  @spec getNoiseSigma(Evision.BgSegm.BackgroundSubtractorMOG.t()) :: number() | {:error, String.t()}
  def getNoiseSigma(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_getNoiseSigma(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.BgSegm.BackgroundSubtractorMOG.t(), Evision.FileNode.t()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.BgSegm.BackgroundSubtractorMOG.t(), binary()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setBackgroundRatio(Keyword.t()) :: any() | {:error, String.t()}
  def setBackgroundRatio([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:backgroundRatio])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setBackgroundRatio()
    |> to_struct()
  end

  @doc """
  setBackgroundRatio

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **backgroundRatio**: `double`

  Python prototype (for reference only):
  ```python3
  setBackgroundRatio(backgroundRatio) -> None
  ```
  """
  @spec setBackgroundRatio(Evision.BgSegm.BackgroundSubtractorMOG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def setBackgroundRatio(self, backgroundRatio) when is_number(backgroundRatio)
  do
    positional = [
      backgroundRatio: Evision.Internal.Structurise.from_struct(backgroundRatio)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setBackgroundRatio(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setHistory(Keyword.t()) :: any() | {:error, String.t()}
  def setHistory([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nframes])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setHistory()
    |> to_struct()
  end

  @doc """
  setHistory

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **nframes**: `integer()`

  Python prototype (for reference only):
  ```python3
  setHistory(nframes) -> None
  ```
  """
  @spec setHistory(Evision.BgSegm.BackgroundSubtractorMOG.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def setHistory(self, nframes) when is_integer(nframes)
  do
    positional = [
      nframes: Evision.Internal.Structurise.from_struct(nframes)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setHistory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNMixtures(Keyword.t()) :: any() | {:error, String.t()}
  def setNMixtures([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nmix])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setNMixtures()
    |> to_struct()
  end

  @doc """
  setNMixtures

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **nmix**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNMixtures(nmix) -> None
  ```
  """
  @spec setNMixtures(Evision.BgSegm.BackgroundSubtractorMOG.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def setNMixtures(self, nmix) when is_integer(nmix)
  do
    positional = [
      nmix: Evision.Internal.Structurise.from_struct(nmix)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setNMixtures(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNoiseSigma(Keyword.t()) :: any() | {:error, String.t()}
  def setNoiseSigma([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:noiseSigma])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setNoiseSigma()
    |> to_struct()
  end

  @doc """
  setNoiseSigma

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **noiseSigma**: `double`

  Python prototype (for reference only):
  ```python3
  setNoiseSigma(noiseSigma) -> None
  ```
  """
  @spec setNoiseSigma(Evision.BgSegm.BackgroundSubtractorMOG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def setNoiseSigma(self, noiseSigma) when is_number(noiseSigma)
  do
    positional = [
      noiseSigma: Evision.Internal.Structurise.from_struct(noiseSigma)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorMOG_setNoiseSigma(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorMOG_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.BgSegm.BackgroundSubtractorMOG.t(), Evision.FileStorage.t(), binary()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorMOG.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.BgSegm.BackgroundSubtractorMOG.t(), Evision.FileStorage.t()) :: Evision.BgSegm.BackgroundSubtractorMOG.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorMOG_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
