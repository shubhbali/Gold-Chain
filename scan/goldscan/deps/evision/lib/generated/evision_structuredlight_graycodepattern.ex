defmodule Evision.StructuredLight.GrayCodePattern do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `StructuredLight.GrayCodePattern` struct.

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
  def to_struct({:ok, %{class: Evision.StructuredLight.GrayCodePattern, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.StructuredLight.GrayCodePattern, ref: ref}) do
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
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_GrayCodePattern_clear()
    |> to_struct()
  end
  @spec clear(Evision.StructuredLight.GrayCodePattern.t()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.structured_light_GrayCodePattern_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:width,:height])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_create_static()
    |> to_struct()
  end

  @doc """
  Constructor

  ##### Positional Arguments
  - **width**: `integer()`
  - **height**: `integer()`

  ##### Return
  - **retval**: `Evision.StructuredLight.GrayCodePattern.t()`

  Python prototype (for reference only):
  ```python3
  create(width, height) -> retval
  ```
  """
  @spec create(integer(), integer()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def create(width, height) when is_integer(width) and is_integer(height)
  do
    positional = [
      width: Evision.Internal.Structurise.from_struct(width),
      height: Evision.Internal.Structurise.from_struct(height)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_create_static(positional)
    |> to_struct()
  end

  @doc """
  Decodes the structured light pattern, generating a disparity map

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
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
  @spec decode(Evision.StructuredLight.GrayCodePattern.t(), list(list(Evision.Mat.maybe_mat_in())), [{:blackImages, term()} | {:flags, term()} | {:whiteImages, term()}] | nil) :: Evision.Mat.t() | false | {:error, String.t()}
  def decode(self, patternImages, opts) when is_list(patternImages) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:blackImages, :flags, :whiteImages])
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_decode(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec decode(Keyword.t()) :: any() | {:error, String.t()}
  def decode([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:patternImages,:blackImages,:flags,:disparityMap,:whiteImages])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_decode()
    |> to_struct()
  end

  @doc """
  Decodes the structured light pattern, generating a disparity map

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
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
  @spec decode(Evision.StructuredLight.GrayCodePattern.t(), list(list(Evision.Mat.maybe_mat_in()))) :: Evision.Mat.t() | false | {:error, String.t()}
  def decode(self, patternImages) when is_list(patternImages)
  do
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_decode(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

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
    |> :evision_nif.structured_light_GrayCodePattern_empty()
    |> to_struct()
  end
  @spec empty(Evision.StructuredLight.GrayCodePattern.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.structured_light_GrayCodePattern_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Generates the structured light pattern to project.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

  ##### Return
  - **retval**: `bool`
  - **patternImages**: `[Evision.Mat]`.

    The generated pattern: a vector<Mat>, in which each image is a CV_8U Mat at projector's resolution.

  Python prototype (for reference only):
  ```python3
  generate([, patternImages]) -> retval, patternImages
  ```
  """
  @spec generate(Evision.StructuredLight.GrayCodePattern.t(), [{atom(), term()},...] | nil) :: list(Evision.Mat.t()) | false | {:error, String.t()}
  def generate(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_generate(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Generates the structured light pattern to project.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

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
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_generate()
    |> to_struct()
  end
  @spec generate(Evision.StructuredLight.GrayCodePattern.t()) :: list(Evision.Mat.t()) | false | {:error, String.t()}
  def generate(self) do
    positional = [
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_generate(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

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
    |> :evision_nif.structured_light_GrayCodePattern_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.StructuredLight.GrayCodePattern.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.structured_light_GrayCodePattern_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec getImagesForShadowMasks(Keyword.t()) :: any() | {:error, String.t()}
  def getImagesForShadowMasks([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:whiteImage,:blackImage])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_getImagesForShadowMasks()
    |> to_struct()
  end

  @doc """
  Generates the all-black and all-white images needed for shadowMasks computation.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

  ##### Return
  - **blackImage**: `Evision.Mat.t()`.

    The generated all-black CV_8U image, at projector's resolution.

  - **whiteImage**: `Evision.Mat.t()`.

    The generated all-white CV_8U image, at projector's resolution.

    To identify shadow regions, the regions of two images where the pixels are not lit by projector's light and thus where there is not coded information,
    the 3DUNDERWORLD algorithm computes a shadow mask for the two cameras views, starting from a white and a black images captured by each camera.
    This method generates these two additional images to project.

  Python prototype (for reference only):
  ```python3
  getImagesForShadowMasks(blackImage, whiteImage) -> blackImage, whiteImage
  ```
  """
  @spec getImagesForShadowMasks(Evision.StructuredLight.GrayCodePattern.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def getImagesForShadowMasks(self, blackImage, whiteImage) when (is_struct(blackImage, Evision.Mat) or is_struct(blackImage, Nx.Tensor) or is_number(blackImage) or is_tuple(blackImage)) and (is_struct(whiteImage, Evision.Mat) or is_struct(whiteImage, Nx.Tensor) or is_number(whiteImage) or is_tuple(whiteImage))
  do
    positional = [
      blackImage: Evision.Internal.Structurise.from_struct(blackImage),
      whiteImage: Evision.Internal.Structurise.from_struct(whiteImage)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_getImagesForShadowMasks(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Get the number of pattern images needed for the graycode pattern.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`

  ##### Return
  - **retval**: `size_t`

  @return The number of pattern images needed for the graycode pattern.

  Python prototype (for reference only):
  ```python3
  getNumberOfPatternImages() -> retval
  ```
  """
  @spec getNumberOfPatternImages(Keyword.t()) :: any() | {:error, String.t()}
  def getNumberOfPatternImages([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_getNumberOfPatternImages()
    |> to_struct()
  end
  @spec getNumberOfPatternImages(Evision.StructuredLight.GrayCodePattern.t()) :: integer() | {:error, String.t()}
  def getNumberOfPatternImages(self) do
    positional = [
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_getNumberOfPatternImages(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec getProjPixel(Keyword.t()) :: any() | {:error, String.t()}
  def getProjPixel([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:y,:patternImages,:x,:projPix])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_getProjPixel()
    |> to_struct()
  end

  @doc """
  For a (x,y) pixel of a camera returns the corresponding projector pixel.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **patternImages**: `[Evision.Mat]`.

    The pattern images acquired by the camera, stored in a grayscale vector < Mat >.

  - **x**: `integer()`.

    x coordinate of the image pixel.

  - **y**: `integer()`.

    y coordinate of the image pixel.

  ##### Return
  - **retval**: `bool`
  - **projPix**: `Point`.

    Projector's pixel corresponding to the camera's pixel: projPix.x and projPix.y are the image coordinates of the projector's pixel corresponding to the pixel being decoded in a camera.

    The function decodes each pixel in the pattern images acquired by a camera into their corresponding decimal numbers representing the projector's column and row,
    providing a mapping between camera's and projector's pixel.

  Python prototype (for reference only):
  ```python3
  getProjPixel(patternImages, x, y) -> retval, projPix
  ```
  """
  @spec getProjPixel(Evision.StructuredLight.GrayCodePattern.t(), list(Evision.Mat.maybe_mat_in()), integer(), integer()) :: {number(), number()} | false | {:error, String.t()}
  def getProjPixel(self, patternImages, x, y) when is_list(patternImages) and is_integer(x) and is_integer(y)
  do
    positional = [
      patternImages: Evision.Internal.Structurise.from_struct(patternImages),
      x: Evision.Internal.Structurise.from_struct(x),
      y: Evision.Internal.Structurise.from_struct(y)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_getProjPixel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_GrayCodePattern_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.StructuredLight.GrayCodePattern.t(), Evision.FileNode.t()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.structured_light_GrayCodePattern_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_GrayCodePattern_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.StructuredLight.GrayCodePattern.t(), binary()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.structured_light_GrayCodePattern_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setBlackThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setBlackThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_setBlackThreshold()
    |> to_struct()
  end

  @doc """
  Sets the value for black threshold, needed for decoding (shadowsmasks computation).

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **value**: `size_t`.

    The desired black threshold value.

    Black threshold is a number between 0-255 that represents the minimum brightness difference required for valid pixels, between the fully illuminated (white) and the not illuminated images (black); used in computeShadowMasks method.

  Python prototype (for reference only):
  ```python3
  setBlackThreshold(value) -> None
  ```
  """
  @spec setBlackThreshold(Evision.StructuredLight.GrayCodePattern.t(), integer()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def setBlackThreshold(self, value) when is_integer(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_setBlackThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setWhiteThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setWhiteThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_structured_light_GrayCodePattern_setWhiteThreshold()
    |> to_struct()
  end

  @doc """
  Sets the value for white threshold, needed for decoding.

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **value**: `size_t`.

    The desired white threshold value.

    White threshold is a number between 0-255 that represents the minimum brightness difference required for valid pixels, between the graycode pattern and its inverse images; used in getProjPixel method.

  Python prototype (for reference only):
  ```python3
  setWhiteThreshold(value) -> None
  ```
  """
  @spec setWhiteThreshold(Evision.StructuredLight.GrayCodePattern.t(), integer()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def setWhiteThreshold(self, value) when is_integer(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.structured_light_structured_light_GrayCodePattern_setWhiteThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.structured_light_GrayCodePattern_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.StructuredLight.GrayCodePattern.t(), Evision.FileStorage.t(), binary()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.structured_light_GrayCodePattern_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.StructuredLight.GrayCodePattern.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.StructuredLight.GrayCodePattern.t(), Evision.FileStorage.t()) :: Evision.StructuredLight.GrayCodePattern.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.structured_light_GrayCodePattern_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
