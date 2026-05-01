defmodule Evision.BgSegm.BackgroundSubtractorGMG do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `BgSegm.BackgroundSubtractorGMG` struct.

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
  def to_struct({:ok, %{class: Evision.BgSegm.BackgroundSubtractorGMG, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.BgSegm.BackgroundSubtractorGMG, ref: ref}) do
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
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **image**: `Evision.Mat`.

    Next video frame of type CV_8UC(n),CV_8SC(n),CV_16UC(n),CV_16SC(n),CV_32SC(n),CV_32FC(n),CV_64FC(n), where n is 1,2,3,4.

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
  @spec apply(Evision.BgSegm.BackgroundSubtractorGMG.t(), Evision.Mat.maybe_mat_in(), [{:learningRate, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:learningRate])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_apply(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec apply(Keyword.t()) :: any() | {:error, String.t()}
  def apply([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:learningRate,:image,:fgmask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_apply()
    |> to_struct()
  end

  @doc """
  Computes a foreground mask.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **image**: `Evision.Mat`.

    Next video frame of type CV_8UC(n),CV_8SC(n),CV_16UC(n),CV_16SC(n),CV_32SC(n),CV_32FC(n),CV_64FC(n), where n is 1,2,3,4.

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
  @spec apply(Evision.BgSegm.BackgroundSubtractorGMG.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_apply(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorGMG_clear()
    |> to_struct()
  end
  @spec clear(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

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
    |> :evision_nif.bgsegm_BackgroundSubtractorGMG_empty()
    |> to_struct()
  end
  @spec empty(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getBackgroundImage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **backgroundImage**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  getBackgroundImage([, backgroundImage]) -> backgroundImage
  ```
  """
  @spec getBackgroundImage(Evision.BgSegm.BackgroundSubtractorGMG.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  getBackgroundImage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

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
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getBackgroundImage()
    |> to_struct()
  end
  @spec getBackgroundImage(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getBackgroundImage(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getBackgroundImage(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the prior probability that each individual pixel is a background pixel.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getBackgroundPrior() -> retval
  ```
  """
  @spec getBackgroundPrior(Keyword.t()) :: any() | {:error, String.t()}
  def getBackgroundPrior([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getBackgroundPrior()
    |> to_struct()
  end
  @spec getBackgroundPrior(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: number() | {:error, String.t()}
  def getBackgroundPrior(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getBackgroundPrior(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the value of decision threshold.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `double`

  Decision value is the value above which pixel is determined to be FG.

  Python prototype (for reference only):
  ```python3
  getDecisionThreshold() -> retval
  ```
  """
  @spec getDecisionThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getDecisionThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getDecisionThreshold()
    |> to_struct()
  end
  @spec getDecisionThreshold(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: number() | {:error, String.t()}
  def getDecisionThreshold(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getDecisionThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the learning rate of the algorithm.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `double`

  It lies between 0.0 and 1.0. It determines how quickly features are "forgotten" from
  histograms.

  Python prototype (for reference only):
  ```python3
  getDefaultLearningRate() -> retval
  ```
  """
  @spec getDefaultLearningRate(Keyword.t()) :: any() | {:error, String.t()}
  def getDefaultLearningRate([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getDefaultLearningRate()
    |> to_struct()
  end
  @spec getDefaultLearningRate(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: number() | {:error, String.t()}
  def getDefaultLearningRate(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getDefaultLearningRate(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

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
    |> :evision_nif.bgsegm_BackgroundSubtractorGMG_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns total number of distinct colors to maintain in histogram.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMaxFeatures() -> retval
  ```
  """
  @spec getMaxFeatures(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxFeatures([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getMaxFeatures()
    |> to_struct()
  end
  @spec getMaxFeatures(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: integer() | {:error, String.t()}
  def getMaxFeatures(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getMaxFeatures(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the maximum value taken on by pixels in image sequence. e.g. 1.0 or 255.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getMaxVal() -> retval
  ```
  """
  @spec getMaxVal(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxVal([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getMaxVal()
    |> to_struct()
  end
  @spec getMaxVal(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: number() | {:error, String.t()}
  def getMaxVal(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getMaxVal(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the minimum value taken on by pixels in image sequence. Usually 0.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getMinVal() -> retval
  ```
  """
  @spec getMinVal(Keyword.t()) :: any() | {:error, String.t()}
  def getMinVal([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getMinVal()
    |> to_struct()
  end
  @spec getMinVal(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: number() | {:error, String.t()}
  def getMinVal(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getMinVal(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the number of frames used to initialize background model.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNumFrames() -> retval
  ```
  """
  @spec getNumFrames(Keyword.t()) :: any() | {:error, String.t()}
  def getNumFrames([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getNumFrames()
    |> to_struct()
  end
  @spec getNumFrames(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: integer() | {:error, String.t()}
  def getNumFrames(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getNumFrames(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the parameter used for quantization of color-space.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `integer()`

  It is the number of discrete levels in each channel to be used in histograms.

  Python prototype (for reference only):
  ```python3
  getQuantizationLevels() -> retval
  ```
  """
  @spec getQuantizationLevels(Keyword.t()) :: any() | {:error, String.t()}
  def getQuantizationLevels([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getQuantizationLevels()
    |> to_struct()
  end
  @spec getQuantizationLevels(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: integer() | {:error, String.t()}
  def getQuantizationLevels(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getQuantizationLevels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the kernel radius used for morphological operations

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getSmoothingRadius() -> retval
  ```
  """
  @spec getSmoothingRadius(Keyword.t()) :: any() | {:error, String.t()}
  def getSmoothingRadius([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getSmoothingRadius()
    |> to_struct()
  end
  @spec getSmoothingRadius(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: integer() | {:error, String.t()}
  def getSmoothingRadius(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getSmoothingRadius(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the status of background model update

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  getUpdateBackgroundModel() -> retval
  ```
  """
  @spec getUpdateBackgroundModel(Keyword.t()) :: any() | {:error, String.t()}
  def getUpdateBackgroundModel([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getUpdateBackgroundModel()
    |> to_struct()
  end
  @spec getUpdateBackgroundModel(Evision.BgSegm.BackgroundSubtractorGMG.t()) :: boolean() | {:error, String.t()}
  def getUpdateBackgroundModel(self) do
    positional = [
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_getUpdateBackgroundModel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorGMG_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.BgSegm.BackgroundSubtractorGMG.t(), Evision.FileNode.t()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorGMG_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.BgSegm.BackgroundSubtractorGMG.t(), binary()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setBackgroundPrior(Keyword.t()) :: any() | {:error, String.t()}
  def setBackgroundPrior([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:bgprior])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setBackgroundPrior()
    |> to_struct()
  end

  @doc """
  Sets the prior probability that each individual pixel is a background pixel.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **bgprior**: `double`

  Python prototype (for reference only):
  ```python3
  setBackgroundPrior(bgprior) -> None
  ```
  """
  @spec setBackgroundPrior(Evision.BgSegm.BackgroundSubtractorGMG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setBackgroundPrior(self, bgprior) when is_number(bgprior)
  do
    positional = [
      bgprior: Evision.Internal.Structurise.from_struct(bgprior)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setBackgroundPrior(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDecisionThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setDecisionThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:thresh])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setDecisionThreshold()
    |> to_struct()
  end

  @doc """
  Sets the value of decision threshold.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **thresh**: `double`

  Python prototype (for reference only):
  ```python3
  setDecisionThreshold(thresh) -> None
  ```
  """
  @spec setDecisionThreshold(Evision.BgSegm.BackgroundSubtractorGMG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setDecisionThreshold(self, thresh) when is_number(thresh)
  do
    positional = [
      thresh: Evision.Internal.Structurise.from_struct(thresh)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setDecisionThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDefaultLearningRate(Keyword.t()) :: any() | {:error, String.t()}
  def setDefaultLearningRate([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:lr])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setDefaultLearningRate()
    |> to_struct()
  end

  @doc """
  Sets the learning rate of the algorithm.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **lr**: `double`

  Python prototype (for reference only):
  ```python3
  setDefaultLearningRate(lr) -> None
  ```
  """
  @spec setDefaultLearningRate(Evision.BgSegm.BackgroundSubtractorGMG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setDefaultLearningRate(self, lr) when is_number(lr)
  do
    positional = [
      lr: Evision.Internal.Structurise.from_struct(lr)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setDefaultLearningRate(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxFeatures(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxFeatures([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:maxFeatures])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setMaxFeatures()
    |> to_struct()
  end

  @doc """
  Sets total number of distinct colors to maintain in histogram.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **maxFeatures**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMaxFeatures(maxFeatures) -> None
  ```
  """
  @spec setMaxFeatures(Evision.BgSegm.BackgroundSubtractorGMG.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setMaxFeatures(self, maxFeatures) when is_integer(maxFeatures)
  do
    positional = [
      maxFeatures: Evision.Internal.Structurise.from_struct(maxFeatures)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setMaxFeatures(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxVal(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxVal([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:val])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setMaxVal()
    |> to_struct()
  end

  @doc """
  Sets the maximum value taken on by pixels in image sequence.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **val**: `double`

  Python prototype (for reference only):
  ```python3
  setMaxVal(val) -> None
  ```
  """
  @spec setMaxVal(Evision.BgSegm.BackgroundSubtractorGMG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setMaxVal(self, val) when is_number(val)
  do
    positional = [
      val: Evision.Internal.Structurise.from_struct(val)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setMaxVal(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinVal(Keyword.t()) :: any() | {:error, String.t()}
  def setMinVal([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:val])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setMinVal()
    |> to_struct()
  end

  @doc """
  Sets the minimum value taken on by pixels in image sequence.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **val**: `double`

  Python prototype (for reference only):
  ```python3
  setMinVal(val) -> None
  ```
  """
  @spec setMinVal(Evision.BgSegm.BackgroundSubtractorGMG.t(), number()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setMinVal(self, val) when is_number(val)
  do
    positional = [
      val: Evision.Internal.Structurise.from_struct(val)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setMinVal(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNumFrames(Keyword.t()) :: any() | {:error, String.t()}
  def setNumFrames([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nframes])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setNumFrames()
    |> to_struct()
  end

  @doc """
  Sets the number of frames used to initialize background model.

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **nframes**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNumFrames(nframes) -> None
  ```
  """
  @spec setNumFrames(Evision.BgSegm.BackgroundSubtractorGMG.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setNumFrames(self, nframes) when is_integer(nframes)
  do
    positional = [
      nframes: Evision.Internal.Structurise.from_struct(nframes)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setNumFrames(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setQuantizationLevels(Keyword.t()) :: any() | {:error, String.t()}
  def setQuantizationLevels([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nlevels])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setQuantizationLevels()
    |> to_struct()
  end

  @doc """
  Sets the parameter used for quantization of color-space

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **nlevels**: `integer()`

  Python prototype (for reference only):
  ```python3
  setQuantizationLevels(nlevels) -> None
  ```
  """
  @spec setQuantizationLevels(Evision.BgSegm.BackgroundSubtractorGMG.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setQuantizationLevels(self, nlevels) when is_integer(nlevels)
  do
    positional = [
      nlevels: Evision.Internal.Structurise.from_struct(nlevels)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setQuantizationLevels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSmoothingRadius(Keyword.t()) :: any() | {:error, String.t()}
  def setSmoothingRadius([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:radius])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setSmoothingRadius()
    |> to_struct()
  end

  @doc """
  Sets the kernel radius used for morphological operations

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **radius**: `integer()`

  Python prototype (for reference only):
  ```python3
  setSmoothingRadius(radius) -> None
  ```
  """
  @spec setSmoothingRadius(Evision.BgSegm.BackgroundSubtractorGMG.t(), integer()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setSmoothingRadius(self, radius) when is_integer(radius)
  do
    positional = [
      radius: Evision.Internal.Structurise.from_struct(radius)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setSmoothingRadius(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setUpdateBackgroundModel(Keyword.t()) :: any() | {:error, String.t()}
  def setUpdateBackgroundModel([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:update])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setUpdateBackgroundModel()
    |> to_struct()
  end

  @doc """
  Sets the status of background model update

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **update**: `bool`

  Python prototype (for reference only):
  ```python3
  setUpdateBackgroundModel(update) -> None
  ```
  """
  @spec setUpdateBackgroundModel(Evision.BgSegm.BackgroundSubtractorGMG.t(), boolean()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def setUpdateBackgroundModel(self, update) when is_boolean(update)
  do
    positional = [
      update: Evision.Internal.Structurise.from_struct(update)
    ]
    :evision_nif.bgsegm_bgsegm_BackgroundSubtractorGMG_setUpdateBackgroundModel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.bgsegm_BackgroundSubtractorGMG_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.BgSegm.BackgroundSubtractorGMG.t(), Evision.FileStorage.t(), binary()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.BgSegm.BackgroundSubtractorGMG.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.BgSegm.BackgroundSubtractorGMG.t(), Evision.FileStorage.t()) :: Evision.BgSegm.BackgroundSubtractorGMG.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.bgsegm_BackgroundSubtractorGMG_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
