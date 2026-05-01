defmodule Evision.BackgroundSubtractorKNN do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `BackgroundSubtractorKNN` struct.

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
  def to_struct({:ok, %{class: Evision.BackgroundSubtractorKNN, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.BackgroundSubtractorKNN, ref: ref}) do
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
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
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
  @spec apply(Evision.BackgroundSubtractorKNN.t(), Evision.Mat.maybe_mat_in(), [{:learningRate, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:learningRate])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.backgroundSubtractorKNN_apply(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec apply(Keyword.t()) :: any() | {:error, String.t()}
  def apply([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:learningRate,:image,:fgmask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_apply()
    |> to_struct()
  end

  @doc """
  Computes a foreground mask.

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
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
  @spec apply(Evision.BackgroundSubtractorKNN.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.backgroundSubtractorKNN_apply(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_clear()
    |> to_struct()
  end
  @spec clear(Evision.BackgroundSubtractorKNN.t()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

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
    |> :evision_nif.backgroundSubtractorKNN_empty()
    |> to_struct()
  end
  @spec empty(Evision.BackgroundSubtractorKNN.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Computes a background image.

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

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
  @spec getBackgroundImage(Evision.BackgroundSubtractorKNN.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Computes a background image.

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

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
    |> :evision_nif.backgroundSubtractorKNN_getBackgroundImage()
    |> to_struct()
  end
  @spec getBackgroundImage(Evision.BackgroundSubtractorKNN.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

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
    |> :evision_nif.backgroundSubtractorKNN_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.BackgroundSubtractorKNN.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the shadow detection flag

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  ##### Return
  - **retval**: `bool`

  If true, the algorithm detects shadows and marks them. See createBackgroundSubtractorKNN for
  details.

  Python prototype (for reference only):
  ```python3
  getDetectShadows() -> retval
  ```
  """
  @spec getDetectShadows(Keyword.t()) :: any() | {:error, String.t()}
  def getDetectShadows([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_getDetectShadows()
    |> to_struct()
  end
  @spec getDetectShadows(Evision.BackgroundSubtractorKNN.t()) :: boolean() | {:error, String.t()}
  def getDetectShadows(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getDetectShadows(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the threshold on the squared distance between the pixel and the sample

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  ##### Return
  - **retval**: `double`

  The threshold on the squared distance between the pixel and the sample to decide whether a pixel is
  close to a data sample.

  Python prototype (for reference only):
  ```python3
  getDist2Threshold() -> retval
  ```
  """
  @spec getDist2Threshold(Keyword.t()) :: any() | {:error, String.t()}
  def getDist2Threshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_getDist2Threshold()
    |> to_struct()
  end
  @spec getDist2Threshold(Evision.BackgroundSubtractorKNN.t()) :: number() | {:error, String.t()}
  def getDist2Threshold(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getDist2Threshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the number of last frames that affect the background model

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

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
    |> :evision_nif.backgroundSubtractorKNN_getHistory()
    |> to_struct()
  end
  @spec getHistory(Evision.BackgroundSubtractorKNN.t()) :: integer() | {:error, String.t()}
  def getHistory(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getHistory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the number of data samples in the background model

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNSamples() -> retval
  ```
  """
  @spec getNSamples(Keyword.t()) :: any() | {:error, String.t()}
  def getNSamples([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_getNSamples()
    |> to_struct()
  end
  @spec getNSamples(Evision.BackgroundSubtractorKNN.t()) :: integer() | {:error, String.t()}
  def getNSamples(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getNSamples(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the shadow threshold

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  ##### Return
  - **retval**: `double`

  A shadow is detected if pixel is a darker version of the background. The shadow threshold (Tau in
  the paper) is a threshold defining how much darker the shadow can be. Tau= 0.5 means that if a pixel
  is more than twice darker then it is not shadow. See Prati, Mikic, Trivedi and Cucchiara,
  Detecting Moving Shadows...*, IEEE PAMI,2003.

  Python prototype (for reference only):
  ```python3
  getShadowThreshold() -> retval
  ```
  """
  @spec getShadowThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getShadowThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_getShadowThreshold()
    |> to_struct()
  end
  @spec getShadowThreshold(Evision.BackgroundSubtractorKNN.t()) :: number() | {:error, String.t()}
  def getShadowThreshold(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getShadowThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the shadow value

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  ##### Return
  - **retval**: `integer()`

  Shadow value is the value used to mark shadows in the foreground mask. Default value is 127. Value 0
  in the mask always means background, 255 means foreground.

  Python prototype (for reference only):
  ```python3
  getShadowValue() -> retval
  ```
  """
  @spec getShadowValue(Keyword.t()) :: any() | {:error, String.t()}
  def getShadowValue([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_getShadowValue()
    |> to_struct()
  end
  @spec getShadowValue(Evision.BackgroundSubtractorKNN.t()) :: integer() | {:error, String.t()}
  def getShadowValue(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getShadowValue(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the number of neighbours, the k in the kNN.

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`

  ##### Return
  - **retval**: `integer()`

  K is the number of samples that need to be within dist2Threshold in order to decide that that
  pixel is matching the kNN background model.

  Python prototype (for reference only):
  ```python3
  getkNNSamples() -> retval
  ```
  """
  @spec getkNNSamples(Keyword.t()) :: any() | {:error, String.t()}
  def getkNNSamples([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_getkNNSamples()
    |> to_struct()
  end
  @spec getkNNSamples(Evision.BackgroundSubtractorKNN.t()) :: integer() | {:error, String.t()}
  def getkNNSamples(self) do
    positional = [
    ]
    :evision_nif.backgroundSubtractorKNN_getkNNSamples(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.BackgroundSubtractorKNN.t(), Evision.FileNode.t()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.backgroundSubtractorKNN_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.BackgroundSubtractorKNN.t(), binary()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.backgroundSubtractorKNN_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDetectShadows(Keyword.t()) :: any() | {:error, String.t()}
  def setDetectShadows([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:detectShadows])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setDetectShadows()
    |> to_struct()
  end

  @doc """
  Enables or disables shadow detection

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **detectShadows**: `bool`

  Python prototype (for reference only):
  ```python3
  setDetectShadows(detectShadows) -> None
  ```
  """
  @spec setDetectShadows(Evision.BackgroundSubtractorKNN.t(), boolean()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setDetectShadows(self, detectShadows) when is_boolean(detectShadows)
  do
    positional = [
      detectShadows: Evision.Internal.Structurise.from_struct(detectShadows)
    ]
    :evision_nif.backgroundSubtractorKNN_setDetectShadows(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDist2Threshold(Keyword.t()) :: any() | {:error, String.t()}
  def setDist2Threshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_dist2Threshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setDist2Threshold()
    |> to_struct()
  end

  @doc """
  Sets the threshold on the squared distance

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **dist2Threshold**: `double`

  Python prototype (for reference only):
  ```python3
  setDist2Threshold(_dist2Threshold) -> None
  ```
  """
  @spec setDist2Threshold(Evision.BackgroundSubtractorKNN.t(), number()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setDist2Threshold(self, dist2Threshold) when is_number(dist2Threshold)
  do
    positional = [
      dist2Threshold: Evision.Internal.Structurise.from_struct(dist2Threshold)
    ]
    :evision_nif.backgroundSubtractorKNN_setDist2Threshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setHistory(Keyword.t()) :: any() | {:error, String.t()}
  def setHistory([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:history])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setHistory()
    |> to_struct()
  end

  @doc """
  Sets the number of last frames that affect the background model

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **history**: `integer()`

  Python prototype (for reference only):
  ```python3
  setHistory(history) -> None
  ```
  """
  @spec setHistory(Evision.BackgroundSubtractorKNN.t(), integer()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setHistory(self, history) when is_integer(history)
  do
    positional = [
      history: Evision.Internal.Structurise.from_struct(history)
    ]
    :evision_nif.backgroundSubtractorKNN_setHistory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNSamples(Keyword.t()) :: any() | {:error, String.t()}
  def setNSamples([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_nN])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setNSamples()
    |> to_struct()
  end

  @doc """
  Sets the number of data samples in the background model.

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **nN**: `integer()`

  The model needs to be reinitalized to reserve memory.

  Python prototype (for reference only):
  ```python3
  setNSamples(_nN) -> None
  ```
  """
  @spec setNSamples(Evision.BackgroundSubtractorKNN.t(), integer()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setNSamples(self, nN) when is_integer(nN)
  do
    positional = [
      nN: Evision.Internal.Structurise.from_struct(nN)
    ]
    :evision_nif.backgroundSubtractorKNN_setNSamples(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setShadowThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setShadowThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:threshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setShadowThreshold()
    |> to_struct()
  end

  @doc """
  Sets the shadow threshold

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **threshold**: `double`

  Python prototype (for reference only):
  ```python3
  setShadowThreshold(threshold) -> None
  ```
  """
  @spec setShadowThreshold(Evision.BackgroundSubtractorKNN.t(), number()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setShadowThreshold(self, threshold) when is_number(threshold)
  do
    positional = [
      threshold: Evision.Internal.Structurise.from_struct(threshold)
    ]
    :evision_nif.backgroundSubtractorKNN_setShadowThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setShadowValue(Keyword.t()) :: any() | {:error, String.t()}
  def setShadowValue([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setShadowValue()
    |> to_struct()
  end

  @doc """
  Sets the shadow value

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **value**: `integer()`

  Python prototype (for reference only):
  ```python3
  setShadowValue(value) -> None
  ```
  """
  @spec setShadowValue(Evision.BackgroundSubtractorKNN.t(), integer()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setShadowValue(self, value) when is_integer(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.backgroundSubtractorKNN_setShadowValue(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setkNNSamples(Keyword.t()) :: any() | {:error, String.t()}
  def setkNNSamples([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_nkNN])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_setkNNSamples()
    |> to_struct()
  end

  @doc """
  Sets the k in the kNN. How many nearest neighbours need to match.

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **nkNN**: `integer()`

  Python prototype (for reference only):
  ```python3
  setkNNSamples(_nkNN) -> None
  ```
  """
  @spec setkNNSamples(Evision.BackgroundSubtractorKNN.t(), integer()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def setkNNSamples(self, nkNN) when is_integer(nkNN)
  do
    positional = [
      nkNN: Evision.Internal.Structurise.from_struct(nkNN)
    ]
    :evision_nif.backgroundSubtractorKNN_setkNNSamples(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.backgroundSubtractorKNN_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.BackgroundSubtractorKNN.t(), Evision.FileStorage.t(), binary()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.backgroundSubtractorKNN_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.BackgroundSubtractorKNN.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.BackgroundSubtractorKNN.t(), Evision.FileStorage.t()) :: Evision.BackgroundSubtractorKNN.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.backgroundSubtractorKNN_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
