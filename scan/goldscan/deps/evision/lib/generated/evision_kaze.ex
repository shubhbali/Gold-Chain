defmodule Evision.KAZE do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `KAZE` struct.

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
  def to_struct({:ok, %{class: Evision.KAZE, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.KAZE, ref: ref}) do
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
  #### Variant 1:
  compute

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **images**: `[Evision.Mat]`.

    Image set.

  ##### Return
  - **keypoints**: `[[Evision.KeyPoint]]`.

    Input collection of keypoints. Keypoints for which a descriptor cannot be
    computed are removed. Sometimes new keypoints can be added, for example: SIFT duplicates keypoint
    with several dominant orientations (for each orientation).

  - **descriptors**: `[Evision.Mat]`.

    Computed descriptors. In the second variant of the method descriptors[i] are
    descriptors computed for a keypoints[i]. Row j is the keypoints (or keypoints[i]) is the
    descriptor for keypoint j-th keypoint.

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  compute(images, keypoints[, descriptors]) -> keypoints, descriptors
  ```
  #### Variant 2:
  Computes the descriptors for a set of keypoints detected in an image (first variant) or image set
  (second variant).

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **image**: `Evision.Mat`.

    Image.

  ##### Return
  - **keypoints**: `[Evision.KeyPoint]`.

    Input collection of keypoints. Keypoints for which a descriptor cannot be
    computed are removed. Sometimes new keypoints can be added, for example: SIFT duplicates keypoint
    with several dominant orientations (for each orientation).

  - **descriptors**: `Evision.Mat.t()`.

    Computed descriptors. In the second variant of the method descriptors[i] are
    descriptors computed for a keypoints[i]. Row j is the keypoints (or keypoints[i]) is the
    descriptor for keypoint j-th keypoint.

  Python prototype (for reference only):
  ```python3
  compute(image, keypoints[, descriptors]) -> keypoints, descriptors
  ```

  """
  @spec compute(Evision.KAZE.t(), list(Evision.Mat.maybe_mat_in()), list(list(Evision.KeyPoint.t())), [{atom(), term()},...] | nil) :: {list(list(Evision.KeyPoint.t())), list(Evision.Mat.t())} | {:error, String.t()}
  def compute(self, images, keypoints, opts) when is_list(images) and is_list(keypoints) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.kaze_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Evision.KAZE.t(), Evision.Mat.maybe_mat_in(), list(Evision.KeyPoint.t()), [{atom(), term()},...] | nil) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def compute(self, image, keypoints, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and is_list(keypoints) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.kaze_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Keyword.t()) :: any() | {:error, String.t()}
  def compute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:keypoints,:images,:image,:descriptors])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_compute()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  compute

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **images**: `[Evision.Mat]`.

    Image set.

  ##### Return
  - **keypoints**: `[[Evision.KeyPoint]]`.

    Input collection of keypoints. Keypoints for which a descriptor cannot be
    computed are removed. Sometimes new keypoints can be added, for example: SIFT duplicates keypoint
    with several dominant orientations (for each orientation).

  - **descriptors**: `[Evision.Mat]`.

    Computed descriptors. In the second variant of the method descriptors[i] are
    descriptors computed for a keypoints[i]. Row j is the keypoints (or keypoints[i]) is the
    descriptor for keypoint j-th keypoint.

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  compute(images, keypoints[, descriptors]) -> keypoints, descriptors
  ```
  #### Variant 2:
  Computes the descriptors for a set of keypoints detected in an image (first variant) or image set
  (second variant).

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **image**: `Evision.Mat`.

    Image.

  ##### Return
  - **keypoints**: `[Evision.KeyPoint]`.

    Input collection of keypoints. Keypoints for which a descriptor cannot be
    computed are removed. Sometimes new keypoints can be added, for example: SIFT duplicates keypoint
    with several dominant orientations (for each orientation).

  - **descriptors**: `Evision.Mat.t()`.

    Computed descriptors. In the second variant of the method descriptors[i] are
    descriptors computed for a keypoints[i]. Row j is the keypoints (or keypoints[i]) is the
    descriptor for keypoint j-th keypoint.

  Python prototype (for reference only):
  ```python3
  compute(image, keypoints[, descriptors]) -> keypoints, descriptors
  ```

  """
  @spec compute(Evision.KAZE.t(), list(Evision.Mat.maybe_mat_in()), list(list(Evision.KeyPoint.t()))) :: {list(list(Evision.KeyPoint.t())), list(Evision.Mat.t())} | {:error, String.t()}
  def compute(self, images, keypoints) when is_list(images) and is_list(keypoints)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.kaze_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec compute(Evision.KAZE.t(), Evision.Mat.maybe_mat_in(), list(Evision.KeyPoint.t())) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def compute(self, image, keypoints) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and is_list(keypoints)
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.kaze_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  The KAZE constructor
  ##### Keyword Arguments
  - **extended**: `bool`.

    Set to enable extraction of extended (128-byte) descriptor.

  - **upright**: `bool`.

    Set to enable use of upright descriptors (non rotation-invariant).

  - **threshold**: `float`.

    Detector response threshold to accept point

  - **nOctaves**: `integer()`.

    Maximum octave evolution of the image

  - **nOctaveLayers**: `integer()`.

    Default number of sublevels per scale level

  - **diffusivity**: `KAZE_DiffusivityType`.

    Diffusivity type. DIFF_PM_G1, DIFF_PM_G2, DIFF_WEICKERT or
    DIFF_CHARBONNIER

  ##### Return
  - **retval**: `Evision.KAZE.t()`

  Python prototype (for reference only):
  ```python3
  create([, extended[, upright[, threshold[, nOctaves[, nOctaveLayers[, diffusivity]]]]]]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:upright,:nOctaveLayers,:diffusivity,:extended,:threshold,:nOctaves])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_create_static()
    |> to_struct()
  end
  @spec create([{:diffusivity, term()} | {:extended, term()} | {:nOctaveLayers, term()} | {:nOctaves, term()} | {:threshold, term()} | {:upright, term()}] | nil) :: Evision.KAZE.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:diffusivity, :extended, :nOctaveLayers, :nOctaves, :threshold, :upright])
    positional = [
    ]
    :evision_nif.kaze_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  The KAZE constructor
  ##### Keyword Arguments
  - **extended**: `bool`.

    Set to enable extraction of extended (128-byte) descriptor.

  - **upright**: `bool`.

    Set to enable use of upright descriptors (non rotation-invariant).

  - **threshold**: `float`.

    Detector response threshold to accept point

  - **nOctaves**: `integer()`.

    Maximum octave evolution of the image

  - **nOctaveLayers**: `integer()`.

    Default number of sublevels per scale level

  - **diffusivity**: `KAZE_DiffusivityType`.

    Diffusivity type. DIFF_PM_G1, DIFF_PM_G2, DIFF_WEICKERT or
    DIFF_CHARBONNIER

  ##### Return
  - **retval**: `Evision.KAZE.t()`

  Python prototype (for reference only):
  ```python3
  create([, extended[, upright[, threshold[, nOctaves[, nOctaveLayers[, diffusivity]]]]]]) -> retval
  ```
  """
  @spec create() :: Evision.KAZE.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.kaze_create_static(positional)
    |> to_struct()
  end

  @doc """
  defaultNorm

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  defaultNorm() -> retval
  ```
  """
  @spec defaultNorm(Keyword.t()) :: any() | {:error, String.t()}
  def defaultNorm([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_defaultNorm()
    |> to_struct()
  end
  @spec defaultNorm(Evision.KAZE.t()) :: integer() | {:error, String.t()}
  def defaultNorm(self) do
    positional = [
    ]
    :evision_nif.kaze_defaultNorm(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  descriptorSize

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  descriptorSize() -> retval
  ```
  """
  @spec descriptorSize(Keyword.t()) :: any() | {:error, String.t()}
  def descriptorSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_descriptorSize()
    |> to_struct()
  end
  @spec descriptorSize(Evision.KAZE.t()) :: integer() | {:error, String.t()}
  def descriptorSize(self) do
    positional = [
    ]
    :evision_nif.kaze_descriptorSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  descriptorType

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  descriptorType() -> retval
  ```
  """
  @spec descriptorType(Keyword.t()) :: any() | {:error, String.t()}
  def descriptorType([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_descriptorType()
    |> to_struct()
  end
  @spec descriptorType(Evision.KAZE.t()) :: integer() | {:error, String.t()}
  def descriptorType(self) do
    positional = [
    ]
    :evision_nif.kaze_descriptorType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  detect

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **images**: `[Evision.Mat]`.

    Image set.

  ##### Keyword Arguments
  - **masks**: `[Evision.Mat]`.

    Masks for each input image specifying where to look for keypoints (optional).
    masks[i] is a mask for images[i].

  ##### Return
  - **keypoints**: `[[Evision.KeyPoint]]`.

    The detected keypoints. In the second variant of the method keypoints[i] is a set
    of keypoints detected in images[i] .

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  detect(images[, masks]) -> keypoints
  ```
  #### Variant 2:
  Detects keypoints in an image (first variant) or image set (second variant).

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **image**: `Evision.Mat`.

    Image.

  ##### Keyword Arguments
  - **mask**: `Evision.Mat`.

    Mask specifying where to look for keypoints (optional). It must be a 8-bit integer
    matrix with non-zero values in the region of interest.

  ##### Return
  - **keypoints**: `[Evision.KeyPoint]`.

    The detected keypoints. In the second variant of the method keypoints[i] is a set
    of keypoints detected in images[i] .

  Python prototype (for reference only):
  ```python3
  detect(image[, mask]) -> keypoints
  ```

  """
  @spec detect(Evision.KAZE.t(), list(Evision.Mat.maybe_mat_in()), [{:masks, term()}] | nil) :: list(list(Evision.KeyPoint.t())) | {:error, String.t()}
  def detect(self, images, opts) when is_list(images) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:masks])
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.kaze_detect(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec detect(Evision.KAZE.t(), Evision.Mat.maybe_mat_in(), [{:mask, term()}] | nil) :: list(Evision.KeyPoint.t()) | {:error, String.t()}
  def detect(self, image, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:mask])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.kaze_detect(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec detect(Keyword.t()) :: any() | {:error, String.t()}
  def detect([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:images,:image,:keypoints,:mask,:masks])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_detect()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  detect

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **images**: `[Evision.Mat]`.

    Image set.

  ##### Keyword Arguments
  - **masks**: `[Evision.Mat]`.

    Masks for each input image specifying where to look for keypoints (optional).
    masks[i] is a mask for images[i].

  ##### Return
  - **keypoints**: `[[Evision.KeyPoint]]`.

    The detected keypoints. In the second variant of the method keypoints[i] is a set
    of keypoints detected in images[i] .

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  detect(images[, masks]) -> keypoints
  ```
  #### Variant 2:
  Detects keypoints in an image (first variant) or image set (second variant).

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **image**: `Evision.Mat`.

    Image.

  ##### Keyword Arguments
  - **mask**: `Evision.Mat`.

    Mask specifying where to look for keypoints (optional). It must be a 8-bit integer
    matrix with non-zero values in the region of interest.

  ##### Return
  - **keypoints**: `[Evision.KeyPoint]`.

    The detected keypoints. In the second variant of the method keypoints[i] is a set
    of keypoints detected in images[i] .

  Python prototype (for reference only):
  ```python3
  detect(image[, mask]) -> keypoints
  ```

  """
  @spec detect(Evision.KAZE.t(), list(Evision.Mat.maybe_mat_in())) :: list(list(Evision.KeyPoint.t())) | {:error, String.t()}
  def detect(self, images) when is_list(images)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.kaze_detect(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec detect(Evision.KAZE.t(), Evision.Mat.maybe_mat_in()) :: list(Evision.KeyPoint.t()) | {:error, String.t()}
  def detect(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.kaze_detect(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  detectAndCompute

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **image**: `Evision.Mat`
  - **mask**: `Evision.Mat`

  ##### Keyword Arguments
  - **useProvidedKeypoints**: `bool`.

  ##### Return
  - **keypoints**: `[Evision.KeyPoint]`
  - **descriptors**: `Evision.Mat.t()`.

  Detects keypoints and computes the descriptors

  Python prototype (for reference only):
  ```python3
  detectAndCompute(image, mask[, descriptors[, useProvidedKeypoints]]) -> keypoints, descriptors
  ```
  """
  @spec detectAndCompute(Evision.KAZE.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{:useProvidedKeypoints, term()}] | nil) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def detectAndCompute(self, image, mask, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:useProvidedKeypoints])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.kaze_detectAndCompute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec detectAndCompute(Keyword.t()) :: any() | {:error, String.t()}
  def detectAndCompute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:image,:keypoints,:mask,:descriptors,:useProvidedKeypoints])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_detectAndCompute()
    |> to_struct()
  end

  @doc """
  detectAndCompute

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **image**: `Evision.Mat`
  - **mask**: `Evision.Mat`

  ##### Keyword Arguments
  - **useProvidedKeypoints**: `bool`.

  ##### Return
  - **keypoints**: `[Evision.KeyPoint]`
  - **descriptors**: `Evision.Mat.t()`.

  Detects keypoints and computes the descriptors

  Python prototype (for reference only):
  ```python3
  detectAndCompute(image, mask[, descriptors[, useProvidedKeypoints]]) -> keypoints, descriptors
  ```
  """
  @spec detectAndCompute(Evision.KAZE.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def detectAndCompute(self, image, mask) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.kaze_detectAndCompute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  empty

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

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
    |> :evision_nif.kaze_empty()
    |> to_struct()
  end
  @spec empty(Evision.KAZE.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.kaze_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  getDefaultName() -> retval
  ```
  """
  @spec getDefaultName(Keyword.t()) :: any() | {:error, String.t()}
  def getDefaultName([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.KAZE.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.kaze_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDiffusivity

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `KAZE::DiffusivityType`

  Python prototype (for reference only):
  ```python3
  getDiffusivity() -> retval
  ```
  """
  @spec getDiffusivity(Keyword.t()) :: any() | {:error, String.t()}
  def getDiffusivity([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getDiffusivity()
    |> to_struct()
  end
  @spec getDiffusivity(Evision.KAZE.t()) :: Evision.KAZE.DiffusivityType.enum() | {:error, String.t()}
  def getDiffusivity(self) do
    positional = [
    ]
    :evision_nif.kaze_getDiffusivity(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getExtended

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  getExtended() -> retval
  ```
  """
  @spec getExtended(Keyword.t()) :: any() | {:error, String.t()}
  def getExtended([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getExtended()
    |> to_struct()
  end
  @spec getExtended(Evision.KAZE.t()) :: boolean() | {:error, String.t()}
  def getExtended(self) do
    positional = [
    ]
    :evision_nif.kaze_getExtended(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNOctaveLayers

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNOctaveLayers() -> retval
  ```
  """
  @spec getNOctaveLayers(Keyword.t()) :: any() | {:error, String.t()}
  def getNOctaveLayers([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getNOctaveLayers()
    |> to_struct()
  end
  @spec getNOctaveLayers(Evision.KAZE.t()) :: integer() | {:error, String.t()}
  def getNOctaveLayers(self) do
    positional = [
    ]
    :evision_nif.kaze_getNOctaveLayers(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNOctaves

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNOctaves() -> retval
  ```
  """
  @spec getNOctaves(Keyword.t()) :: any() | {:error, String.t()}
  def getNOctaves([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getNOctaves()
    |> to_struct()
  end
  @spec getNOctaves(Evision.KAZE.t()) :: integer() | {:error, String.t()}
  def getNOctaves(self) do
    positional = [
    ]
    :evision_nif.kaze_getNOctaves(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getThreshold

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getThreshold() -> retval
  ```
  """
  @spec getThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getThreshold()
    |> to_struct()
  end
  @spec getThreshold(Evision.KAZE.t()) :: number() | {:error, String.t()}
  def getThreshold(self) do
    positional = [
    ]
    :evision_nif.kaze_getThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getUpright

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  getUpright() -> retval
  ```
  """
  @spec getUpright(Keyword.t()) :: any() | {:error, String.t()}
  def getUpright([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_getUpright()
    |> to_struct()
  end
  @spec getUpright(Evision.KAZE.t()) :: boolean() | {:error, String.t()}
  def getUpright(self) do
    positional = [
    ]
    :evision_nif.kaze_getUpright(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fileName,:arg1])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_read()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  read

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **arg1**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(arg1) -> None
  ```
  #### Variant 2:
  read

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **fileName**: `String`

  Python prototype (for reference only):
  ```python3
  read(fileName) -> None
  ```

  """
  @spec read(Evision.KAZE.t(), Evision.FileNode.t()) :: Evision.KAZE.t() | {:error, String.t()}
  def read(self, arg1) when is_struct(arg1, Evision.FileNode)
  do
    positional = [
      arg1: Evision.Internal.Structurise.from_struct(arg1)
    ]
    :evision_nif.kaze_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Evision.KAZE.t(), binary()) :: Evision.KAZE.t() | {:error, String.t()}
  def read(self, fileName) when is_binary(fileName)
  do
    positional = [
      fileName: Evision.Internal.Structurise.from_struct(fileName)
    ]
    :evision_nif.kaze_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDiffusivity(Keyword.t()) :: any() | {:error, String.t()}
  def setDiffusivity([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:diff])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_setDiffusivity()
    |> to_struct()
  end

  @doc """
  setDiffusivity

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **diff**: `KAZE_DiffusivityType`

  Python prototype (for reference only):
  ```python3
  setDiffusivity(diff) -> None
  ```
  """
  @spec setDiffusivity(Evision.KAZE.t(), Evision.KAZE.DiffusivityType.enum()) :: Evision.KAZE.t() | {:error, String.t()}
  def setDiffusivity(self, diff) when is_integer(diff)
  do
    positional = [
      diff: Evision.Internal.Structurise.from_struct(diff)
    ]
    :evision_nif.kaze_setDiffusivity(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setExtended(Keyword.t()) :: any() | {:error, String.t()}
  def setExtended([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:extended])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_setExtended()
    |> to_struct()
  end

  @doc """
  setExtended

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **extended**: `bool`

  Python prototype (for reference only):
  ```python3
  setExtended(extended) -> None
  ```
  """
  @spec setExtended(Evision.KAZE.t(), boolean()) :: Evision.KAZE.t() | {:error, String.t()}
  def setExtended(self, extended) when is_boolean(extended)
  do
    positional = [
      extended: Evision.Internal.Structurise.from_struct(extended)
    ]
    :evision_nif.kaze_setExtended(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNOctaveLayers(Keyword.t()) :: any() | {:error, String.t()}
  def setNOctaveLayers([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:octaveLayers])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_setNOctaveLayers()
    |> to_struct()
  end

  @doc """
  setNOctaveLayers

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **octaveLayers**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNOctaveLayers(octaveLayers) -> None
  ```
  """
  @spec setNOctaveLayers(Evision.KAZE.t(), integer()) :: Evision.KAZE.t() | {:error, String.t()}
  def setNOctaveLayers(self, octaveLayers) when is_integer(octaveLayers)
  do
    positional = [
      octaveLayers: Evision.Internal.Structurise.from_struct(octaveLayers)
    ]
    :evision_nif.kaze_setNOctaveLayers(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNOctaves(Keyword.t()) :: any() | {:error, String.t()}
  def setNOctaves([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:octaves])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_setNOctaves()
    |> to_struct()
  end

  @doc """
  setNOctaves

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **octaves**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNOctaves(octaves) -> None
  ```
  """
  @spec setNOctaves(Evision.KAZE.t(), integer()) :: Evision.KAZE.t() | {:error, String.t()}
  def setNOctaves(self, octaves) when is_integer(octaves)
  do
    positional = [
      octaves: Evision.Internal.Structurise.from_struct(octaves)
    ]
    :evision_nif.kaze_setNOctaves(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:threshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_setThreshold()
    |> to_struct()
  end

  @doc """
  setThreshold

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **threshold**: `double`

  Python prototype (for reference only):
  ```python3
  setThreshold(threshold) -> None
  ```
  """
  @spec setThreshold(Evision.KAZE.t(), number()) :: Evision.KAZE.t() | {:error, String.t()}
  def setThreshold(self, threshold) when is_number(threshold)
  do
    positional = [
      threshold: Evision.Internal.Structurise.from_struct(threshold)
    ]
    :evision_nif.kaze_setThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setUpright(Keyword.t()) :: any() | {:error, String.t()}
  def setUpright([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:upright])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_setUpright()
    |> to_struct()
  end

  @doc """
  setUpright

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **upright**: `bool`

  Python prototype (for reference only):
  ```python3
  setUpright(upright) -> None
  ```
  """
  @spec setUpright(Evision.KAZE.t(), boolean()) :: Evision.KAZE.t() | {:error, String.t()}
  def setUpright(self, upright) when is_boolean(upright)
  do
    positional = [
      upright: Evision.Internal.Structurise.from_struct(upright)
    ]
    :evision_nif.kaze_setUpright(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fileName,:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.kaze_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.KAZE.t(), Evision.FileStorage.t(), binary()) :: Evision.KAZE.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.kaze_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.KAZE.t()`
  - **fileName**: `String`

  Python prototype (for reference only):
  ```python3
  write(fileName) -> None
  ```
  """
  @spec write(Evision.KAZE.t(), binary()) :: Evision.KAZE.t() | {:error, String.t()}
  def write(self, fileName) when is_binary(fileName)
  do
    positional = [
      fileName: Evision.Internal.Structurise.from_struct(fileName)
    ]
    :evision_nif.kaze_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
