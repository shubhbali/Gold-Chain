defmodule Evision.StructuredLight.SinusoidalPattern do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `StructuredLight.SinusoidalPattern` struct.

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
  def to_struct({:ok, %{class: Evision.StructuredLight.SinusoidalPattern, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.StructuredLight.SinusoidalPattern, ref: ref}) do
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
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_SinusoidalPattern_clear()
    |> to_struct()
  end
  @spec clear(Evision.StructuredLight.SinusoidalPattern.t()) :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.structured_light_SinusoidalPattern_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  compute the data modulation term.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **patternImages**: `[Evision.Mat]`.

    captured images with projected patterns.

  - **shadowMask**: `Evision.Mat`.

    Mask used to discard shadow regions.

  ##### Return
  - **dataModulationTerm**: `Evision.Mat.t()`.

    Mat where the data modulation term is saved.

  Python prototype (for reference only):
  ```python3
  computeDataModulationTerm(patternImages, shadowMask[, dataModulationTerm]) -> dataModulationTerm
  ```
  """
  @spec computeDataModulationTerm(Evision.StructuredLight.SinusoidalPattern.t(), list(Evision.Mat.maybe_mat_in()), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def computeDataModulationTerm(self, patternImages, shadowMask, opts) when is_list(patternImages) and (is_struct(shadowMask, Evision.Mat) or is_struct(shadowMask, Nx.Tensor) or is_number(shadowMask) or is_tuple(shadowMask)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages),
      shadowMask: Evision.Internal.Structurise.from_struct(shadowMask)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_computeDataModulationTerm(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec computeDataModulationTerm(Keyword.t()) :: any() | {:error, String.t()}
  def computeDataModulationTerm([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dataModulationTerm,:patternImages,:shadowMask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_computeDataModulationTerm()
    |> to_struct()
  end

  @doc """
  compute the data modulation term.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **patternImages**: `[Evision.Mat]`.

    captured images with projected patterns.

  - **shadowMask**: `Evision.Mat`.

    Mask used to discard shadow regions.

  ##### Return
  - **dataModulationTerm**: `Evision.Mat.t()`.

    Mat where the data modulation term is saved.

  Python prototype (for reference only):
  ```python3
  computeDataModulationTerm(patternImages, shadowMask[, dataModulationTerm]) -> dataModulationTerm
  ```
  """
  @spec computeDataModulationTerm(Evision.StructuredLight.SinusoidalPattern.t(), list(Evision.Mat.maybe_mat_in()), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def computeDataModulationTerm(self, patternImages, shadowMask) when is_list(patternImages) and (is_struct(shadowMask, Evision.Mat) or is_struct(shadowMask, Nx.Tensor) or is_number(shadowMask) or is_tuple(shadowMask))
  do
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages),
      shadowMask: Evision.Internal.Structurise.from_struct(shadowMask)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_computeDataModulationTerm(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Compute a wrapped phase map from sinusoidal patterns.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **patternImages**: `[Evision.Mat]`.

    Input data to compute the wrapped phase map.

  ##### Keyword Arguments
  - **fundamental**: `Evision.Mat`.

    Fundamental matrix used to compute epipolar lines and ease the matching step.

  ##### Return
  - **wrappedPhaseMap**: `Evision.Mat.t()`.

    Wrapped phase map obtained through one of the three methods.

  - **shadowMask**: `Evision.Mat.t()`.

    Mask used to discard shadow regions.

  Python prototype (for reference only):
  ```python3
  computePhaseMap(patternImages[, wrappedPhaseMap[, shadowMask[, fundamental]]]) -> wrappedPhaseMap, shadowMask
  ```
  """
  @spec computePhaseMap(Evision.StructuredLight.SinusoidalPattern.t(), list(Evision.Mat.maybe_mat_in()), [{:fundamental, term()}] | nil) :: {Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def computePhaseMap(self, patternImages, opts) when is_list(patternImages) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:fundamental])
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_computePhaseMap(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec computePhaseMap(Keyword.t()) :: any() | {:error, String.t()}
  def computePhaseMap([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fundamental,:patternImages,:wrappedPhaseMap,:shadowMask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_computePhaseMap()
    |> to_struct()
  end

  @doc """
  Compute a wrapped phase map from sinusoidal patterns.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **patternImages**: `[Evision.Mat]`.

    Input data to compute the wrapped phase map.

  ##### Keyword Arguments
  - **fundamental**: `Evision.Mat`.

    Fundamental matrix used to compute epipolar lines and ease the matching step.

  ##### Return
  - **wrappedPhaseMap**: `Evision.Mat.t()`.

    Wrapped phase map obtained through one of the three methods.

  - **shadowMask**: `Evision.Mat.t()`.

    Mask used to discard shadow regions.

  Python prototype (for reference only):
  ```python3
  computePhaseMap(patternImages[, wrappedPhaseMap[, shadowMask[, fundamental]]]) -> wrappedPhaseMap, shadowMask
  ```
  """
  @spec computePhaseMap(Evision.StructuredLight.SinusoidalPattern.t(), list(Evision.Mat.maybe_mat_in())) :: {Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def computePhaseMap(self, patternImages) when is_list(patternImages)
  do
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_computePhaseMap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Constructor.
  ##### Keyword Arguments
  - **parameters**: `Evision.StructuredLight.SinusoidalPattern.Params`.

    SinusoidalPattern parameters SinusoidalPattern::Params: width, height of the projector and patterns parameters.

  ##### Return
  - **retval**: `Evision.StructuredLight.SinusoidalPattern.t()`

  Python prototype (for reference only):
  ```python3
  create([, parameters]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:parameters])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_create_static()
    |> to_struct()
  end
  @spec create([{:parameters, term()}] | nil) :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:parameters])
    positional = [
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Constructor.
  ##### Keyword Arguments
  - **parameters**: `Evision.StructuredLight.SinusoidalPattern.Params`.

    SinusoidalPattern parameters SinusoidalPattern::Params: width, height of the projector and patterns parameters.

  ##### Return
  - **retval**: `Evision.StructuredLight.SinusoidalPattern.t()`

  Python prototype (for reference only):
  ```python3
  create([, parameters]) -> retval
  ```
  """
  @spec create() :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_create_static(positional)
    |> to_struct()
  end

  @doc """
  Decodes the structured light pattern, generating a disparity map

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **patternImages**: `[[Evision.Mat]]`.

    The acquired pattern images to decode (vector<vector<Mat>>), loaded as grayscale and previously rectified.

  ##### Keyword Arguments
  - **blackImages**: `[Evision.Mat]`.

    The all-black images needed for shadowMasks computation.

  - **whiteImages**: `[Evision.Mat]`.

    The all-white images needed for shadowMasks computation.

  - **flags**: `integer()`.

    Flags setting decoding algorithms. Default: DECODE_3D_UNDERWORLD.

  ##### Return
  - **retval**: `bool`
  - **disparityMap**: `Evision.Mat.t()`.

    The decoding result: a CV_64F Mat at image resolution, storing the computed disparity map.

  **Note**: All the images must be at the same resolution.

  Python prototype (for reference only):
  ```python3
  decode(patternImages[, disparityMap[, blackImages[, whiteImages[, flags]]]]) -> retval, disparityMap
  ```
  """
  @spec decode(Evision.StructuredLight.SinusoidalPattern.t(), list(list(Evision.Mat.maybe_mat_in())), [{:blackImages, term()} | {:flags, term()} | {:whiteImages, term()}] | nil) :: Evision.Mat.t() | false | {:error, String.t()}
  def decode(self, patternImages, opts) when is_list(patternImages) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:blackImages, :flags, :whiteImages])
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_decode(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec decode(Keyword.t()) :: any() | {:error, String.t()}
  def decode([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:patternImages,:blackImages,:flags,:disparityMap,:whiteImages])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_decode()
    |> to_struct()
  end

  @doc """
  Decodes the structured light pattern, generating a disparity map

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **patternImages**: `[[Evision.Mat]]`.

    The acquired pattern images to decode (vector<vector<Mat>>), loaded as grayscale and previously rectified.

  ##### Keyword Arguments
  - **blackImages**: `[Evision.Mat]`.

    The all-black images needed for shadowMasks computation.

  - **whiteImages**: `[Evision.Mat]`.

    The all-white images needed for shadowMasks computation.

  - **flags**: `integer()`.

    Flags setting decoding algorithms. Default: DECODE_3D_UNDERWORLD.

  ##### Return
  - **retval**: `bool`
  - **disparityMap**: `Evision.Mat.t()`.

    The decoding result: a CV_64F Mat at image resolution, storing the computed disparity map.

  **Note**: All the images must be at the same resolution.

  Python prototype (for reference only):
  ```python3
  decode(patternImages[, disparityMap[, blackImages[, whiteImages[, flags]]]]) -> retval, disparityMap
  ```
  """
  @spec decode(Evision.StructuredLight.SinusoidalPattern.t(), list(list(Evision.Mat.maybe_mat_in()))) :: Evision.Mat.t() | false | {:error, String.t()}
  def decode(self, patternImages) when is_list(patternImages)
  do
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_decode(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`

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
    |> :evision_nif.structured_light_SinusoidalPattern_empty()
    |> to_struct()
  end
  @spec empty(Evision.StructuredLight.SinusoidalPattern.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.structured_light_SinusoidalPattern_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Find correspondences between the two devices thanks to unwrapped phase maps.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **projUnwrappedPhaseMap**: `Evision.Mat`.

    Projector's unwrapped phase map.

  - **camUnwrappedPhaseMap**: `Evision.Mat`.

    Camera's unwrapped phase map.

  ##### Return
  - **matches**: `[Evision.Mat]`.

    Images used to display correspondences map.

  Python prototype (for reference only):
  ```python3
  findProCamMatches(projUnwrappedPhaseMap, camUnwrappedPhaseMap[, matches]) -> matches
  ```
  """
  @spec findProCamMatches(Evision.StructuredLight.SinusoidalPattern.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: list(Evision.Mat.t()) | {:error, String.t()}
  def findProCamMatches(self, projUnwrappedPhaseMap, camUnwrappedPhaseMap, opts) when (is_struct(projUnwrappedPhaseMap, Evision.Mat) or is_struct(projUnwrappedPhaseMap, Nx.Tensor) or is_number(projUnwrappedPhaseMap) or is_tuple(projUnwrappedPhaseMap)) and (is_struct(camUnwrappedPhaseMap, Evision.Mat) or is_struct(camUnwrappedPhaseMap, Nx.Tensor) or is_number(camUnwrappedPhaseMap) or is_tuple(camUnwrappedPhaseMap)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      projUnwrappedPhaseMap: Evision.Internal.Structurise.from_struct(projUnwrappedPhaseMap),
      camUnwrappedPhaseMap: Evision.Internal.Structurise.from_struct(camUnwrappedPhaseMap)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_findProCamMatches(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec findProCamMatches(Keyword.t()) :: any() | {:error, String.t()}
  def findProCamMatches([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:matches,:camUnwrappedPhaseMap,:projUnwrappedPhaseMap])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_findProCamMatches()
    |> to_struct()
  end

  @doc """
  Find correspondences between the two devices thanks to unwrapped phase maps.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **projUnwrappedPhaseMap**: `Evision.Mat`.

    Projector's unwrapped phase map.

  - **camUnwrappedPhaseMap**: `Evision.Mat`.

    Camera's unwrapped phase map.

  ##### Return
  - **matches**: `[Evision.Mat]`.

    Images used to display correspondences map.

  Python prototype (for reference only):
  ```python3
  findProCamMatches(projUnwrappedPhaseMap, camUnwrappedPhaseMap[, matches]) -> matches
  ```
  """
  @spec findProCamMatches(Evision.StructuredLight.SinusoidalPattern.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: list(Evision.Mat.t()) | {:error, String.t()}
  def findProCamMatches(self, projUnwrappedPhaseMap, camUnwrappedPhaseMap) when (is_struct(projUnwrappedPhaseMap, Evision.Mat) or is_struct(projUnwrappedPhaseMap, Nx.Tensor) or is_number(projUnwrappedPhaseMap) or is_tuple(projUnwrappedPhaseMap)) and (is_struct(camUnwrappedPhaseMap, Evision.Mat) or is_struct(camUnwrappedPhaseMap, Nx.Tensor) or is_number(camUnwrappedPhaseMap) or is_tuple(camUnwrappedPhaseMap))
  do
    positional = [
      projUnwrappedPhaseMap: Evision.Internal.Structurise.from_struct(projUnwrappedPhaseMap),
      camUnwrappedPhaseMap: Evision.Internal.Structurise.from_struct(camUnwrappedPhaseMap)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_findProCamMatches(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Generates the structured light pattern to project.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`

  ##### Return
  - **retval**: `bool`
  - **patternImages**: `[Evision.Mat]`.

    The generated pattern: a vector<Mat>, in which each image is a CV_8U Mat at projector's resolution.

  Python prototype (for reference only):
  ```python3
  generate([, patternImages]) -> retval, patternImages
  ```
  """
  @spec generate(Evision.StructuredLight.SinusoidalPattern.t(), [{atom(), term()},...] | nil) :: list(Evision.Mat.t()) | false | {:error, String.t()}
  def generate(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_generate(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Generates the structured light pattern to project.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`

  ##### Return
  - **retval**: `bool`
  - **patternImages**: `[Evision.Mat]`.

    The generated pattern: a vector<Mat>, in which each image is a CV_8U Mat at projector's resolution.

  Python prototype (for reference only):
  ```python3
  generate([, patternImages]) -> retval, patternImages
  ```
  """
  @spec generate(Keyword.t()) :: any() | {:error, String.t()}
  def generate([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:patternImages])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_generate()
    |> to_struct()
  end
  @spec generate(Evision.StructuredLight.SinusoidalPattern.t()) :: list(Evision.Mat.t()) | false | {:error, String.t()}
  def generate(self) do
    positional = [
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_generate(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`

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
    |> :evision_nif.structured_light_SinusoidalPattern_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.StructuredLight.SinusoidalPattern.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.structured_light_SinusoidalPattern_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_SinusoidalPattern_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.StructuredLight.SinusoidalPattern.t(), Evision.FileNode.t()) :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.structured_light_SinusoidalPattern_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_SinusoidalPattern_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.StructuredLight.SinusoidalPattern.t(), binary()) :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.structured_light_SinusoidalPattern_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Unwrap the wrapped phase map to remove phase ambiguities.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **wrappedPhaseMap**: `Evision.Mat`.

    The wrapped phase map computed from the pattern.

  - **camSize**: `Size`.

    Resolution of the camera.

  ##### Keyword Arguments
  - **shadowMask**: `Evision.Mat`.

    Mask used to discard shadow regions.

  ##### Return
  - **unwrappedPhaseMap**: `Evision.Mat.t()`.

    The unwrapped phase map used to find correspondences between the two devices.

  Python prototype (for reference only):
  ```python3
  unwrapPhaseMap(wrappedPhaseMap, camSize[, unwrappedPhaseMap[, shadowMask]]) -> unwrappedPhaseMap
  ```
  """
  @spec unwrapPhaseMap(Evision.StructuredLight.SinusoidalPattern.t(), Evision.Mat.maybe_mat_in(), {number(), number()}, [{:shadowMask, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def unwrapPhaseMap(self, wrappedPhaseMap, camSize, opts) when (is_struct(wrappedPhaseMap, Evision.Mat) or is_struct(wrappedPhaseMap, Nx.Tensor) or is_number(wrappedPhaseMap) or is_tuple(wrappedPhaseMap)) and is_tuple(camSize) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:shadowMask])
    positional = [
      wrappedPhaseMap: Evision.Internal.Structurise.from_struct(wrappedPhaseMap),
      camSize: Evision.Internal.Structurise.from_struct(camSize)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_unwrapPhaseMap(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec unwrapPhaseMap(Keyword.t()) :: any() | {:error, String.t()}
  def unwrapPhaseMap([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:unwrappedPhaseMap,:wrappedPhaseMap,:camSize,:shadowMask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_SinusoidalPattern_unwrapPhaseMap()
    |> to_struct()
  end

  @doc """
  Unwrap the wrapped phase map to remove phase ambiguities.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **wrappedPhaseMap**: `Evision.Mat`.

    The wrapped phase map computed from the pattern.

  - **camSize**: `Size`.

    Resolution of the camera.

  ##### Keyword Arguments
  - **shadowMask**: `Evision.Mat`.

    Mask used to discard shadow regions.

  ##### Return
  - **unwrappedPhaseMap**: `Evision.Mat.t()`.

    The unwrapped phase map used to find correspondences between the two devices.

  Python prototype (for reference only):
  ```python3
  unwrapPhaseMap(wrappedPhaseMap, camSize[, unwrappedPhaseMap[, shadowMask]]) -> unwrappedPhaseMap
  ```
  """
  @spec unwrapPhaseMap(Evision.StructuredLight.SinusoidalPattern.t(), Evision.Mat.maybe_mat_in(), {number(), number()}) :: Evision.Mat.t() | {:error, String.t()}
  def unwrapPhaseMap(self, wrappedPhaseMap, camSize) when (is_struct(wrappedPhaseMap, Evision.Mat) or is_struct(wrappedPhaseMap, Nx.Tensor) or is_number(wrappedPhaseMap) or is_tuple(wrappedPhaseMap)) and is_tuple(camSize)
  do
    positional = [
      wrappedPhaseMap: Evision.Internal.Structurise.from_struct(wrappedPhaseMap),
      camSize: Evision.Internal.Structurise.from_struct(camSize)
    ]
    :evision_nif.structured_light_structured_light_SinusoidalPattern_unwrapPhaseMap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_SinusoidalPattern_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.StructuredLight.SinusoidalPattern.t(), Evision.FileStorage.t(), binary()) :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.structured_light_SinusoidalPattern_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.SinusoidalPattern.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.StructuredLight.SinusoidalPattern.t(), Evision.FileStorage.t()) :: Evision.StructuredLight.SinusoidalPattern.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.structured_light_SinusoidalPattern_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
