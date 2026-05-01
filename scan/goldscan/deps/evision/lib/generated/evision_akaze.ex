defmodule Evision.AKAZE do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `AKAZE` struct.

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
  def to_struct({:ok, %{class: Evision.AKAZE, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.AKAZE, ref: ref}) do
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
  - **self**: `Evision.AKAZE.t()`
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
  - **self**: `Evision.AKAZE.t()`
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
  @spec compute(Evision.AKAZE.t(), list(Evision.Mat.maybe_mat_in()), list(list(Evision.KeyPoint.t())), [{atom(), term()},...] | nil) :: {list(list(Evision.KeyPoint.t())), list(Evision.Mat.t())} | {:error, String.t()}
  def compute(self, images, keypoints, opts) when is_list(images) and is_list(keypoints) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.akaze_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Evision.AKAZE.t(), Evision.Mat.maybe_mat_in(), list(Evision.KeyPoint.t()), [{atom(), term()},...] | nil) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def compute(self, image, keypoints, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and is_list(keypoints) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.akaze_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Keyword.t()) :: any() | {:error, String.t()}
  def compute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:keypoints,:images,:image,:descriptors])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_compute()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  compute

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
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
  - **self**: `Evision.AKAZE.t()`
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
  @spec compute(Evision.AKAZE.t(), list(Evision.Mat.maybe_mat_in()), list(list(Evision.KeyPoint.t()))) :: {list(list(Evision.KeyPoint.t())), list(Evision.Mat.t())} | {:error, String.t()}
  def compute(self, images, keypoints) when is_list(images) and is_list(keypoints)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.akaze_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec compute(Evision.AKAZE.t(), Evision.Mat.maybe_mat_in(), list(Evision.KeyPoint.t())) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def compute(self, image, keypoints) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and is_list(keypoints)
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      keypoints: Evision.Internal.Structurise.from_struct(keypoints)
    ]
    :evision_nif.akaze_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  The AKAZE constructor
  ##### Keyword Arguments
  - **descriptor_type**: `AKAZE_DescriptorType`.

    Type of the extracted descriptor: DESCRIPTOR_KAZE,
    DESCRIPTOR_KAZE_UPRIGHT, DESCRIPTOR_MLDB or DESCRIPTOR_MLDB_UPRIGHT.

  - **descriptor_size**: `integer()`.

    Size of the descriptor in bits. 0 -\\> Full size

  - **descriptor_channels**: `integer()`.

    Number of channels in the descriptor (1, 2, 3)

  - **threshold**: `float`.

    Detector response threshold to accept point

  - **nOctaves**: `integer()`.

    Maximum octave evolution of the image

  - **nOctaveLayers**: `integer()`.

    Default number of sublevels per scale level

  - **diffusivity**: `KAZE_DiffusivityType`.

    Diffusivity type. DIFF_PM_G1, DIFF_PM_G2, DIFF_WEICKERT or
    DIFF_CHARBONNIER

  - **max_points**: `integer()`.

    Maximum amount of returned points. In case if image contains
    more features, then the features with highest response are returned.
    Negative value means no limitation.

  ##### Return
  - **retval**: `Evision.AKAZE.t()`

  Python prototype (for reference only):
  ```python3
  create([, descriptor_type[, descriptor_size[, descriptor_channels[, threshold[, nOctaves[, nOctaveLayers[, diffusivity[, max_points]]]]]]]]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:descriptor_type,:nOctaveLayers,:descriptor_size,:descriptor_channels,:diffusivity,:threshold,:nOctaves,:max_points])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_create_static()
    |> to_struct()
  end
  @spec create([{:descriptor_channels, term()} | {:descriptor_size, term()} | {:descriptor_type, term()} | {:diffusivity, term()} | {:max_points, term()} | {:nOctaveLayers, term()} | {:nOctaves, term()} | {:threshold, term()}] | nil) :: Evision.AKAZE.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:descriptor_channels, :descriptor_size, :descriptor_type, :diffusivity, :max_points, :nOctaveLayers, :nOctaves, :threshold])
    positional = [
    ]
    :evision_nif.akaze_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  The AKAZE constructor
  ##### Keyword Arguments
  - **descriptor_type**: `AKAZE_DescriptorType`.

    Type of the extracted descriptor: DESCRIPTOR_KAZE,
    DESCRIPTOR_KAZE_UPRIGHT, DESCRIPTOR_MLDB or DESCRIPTOR_MLDB_UPRIGHT.

  - **descriptor_size**: `integer()`.

    Size of the descriptor in bits. 0 -\\> Full size

  - **descriptor_channels**: `integer()`.

    Number of channels in the descriptor (1, 2, 3)

  - **threshold**: `float`.

    Detector response threshold to accept point

  - **nOctaves**: `integer()`.

    Maximum octave evolution of the image

  - **nOctaveLayers**: `integer()`.

    Default number of sublevels per scale level

  - **diffusivity**: `KAZE_DiffusivityType`.

    Diffusivity type. DIFF_PM_G1, DIFF_PM_G2, DIFF_WEICKERT or
    DIFF_CHARBONNIER

  - **max_points**: `integer()`.

    Maximum amount of returned points. In case if image contains
    more features, then the features with highest response are returned.
    Negative value means no limitation.

  ##### Return
  - **retval**: `Evision.AKAZE.t()`

  Python prototype (for reference only):
  ```python3
  create([, descriptor_type[, descriptor_size[, descriptor_channels[, threshold[, nOctaves[, nOctaveLayers[, diffusivity[, max_points]]]]]]]]) -> retval
  ```
  """
  @spec create() :: Evision.AKAZE.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.akaze_create_static(positional)
    |> to_struct()
  end

  @doc """
  defaultNorm

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_defaultNorm()
    |> to_struct()
  end
  @spec defaultNorm(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def defaultNorm(self) do
    positional = [
    ]
    :evision_nif.akaze_defaultNorm(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  descriptorSize

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_descriptorSize()
    |> to_struct()
  end
  @spec descriptorSize(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def descriptorSize(self) do
    positional = [
    ]
    :evision_nif.akaze_descriptorSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  descriptorType

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_descriptorType()
    |> to_struct()
  end
  @spec descriptorType(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def descriptorType(self) do
    positional = [
    ]
    :evision_nif.akaze_descriptorType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  detect

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
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
  - **self**: `Evision.AKAZE.t()`
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
  @spec detect(Evision.AKAZE.t(), list(Evision.Mat.maybe_mat_in()), [{:masks, term()}] | nil) :: list(list(Evision.KeyPoint.t())) | {:error, String.t()}
  def detect(self, images, opts) when is_list(images) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:masks])
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.akaze_detect(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec detect(Evision.AKAZE.t(), Evision.Mat.maybe_mat_in(), [{:mask, term()}] | nil) :: list(Evision.KeyPoint.t()) | {:error, String.t()}
  def detect(self, image, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:mask])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.akaze_detect(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec detect(Keyword.t()) :: any() | {:error, String.t()}
  def detect([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:images,:image,:keypoints,:mask,:masks])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_detect()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  detect

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
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
  - **self**: `Evision.AKAZE.t()`
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
  @spec detect(Evision.AKAZE.t(), list(Evision.Mat.maybe_mat_in())) :: list(list(Evision.KeyPoint.t())) | {:error, String.t()}
  def detect(self, images) when is_list(images)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.akaze_detect(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec detect(Evision.AKAZE.t(), Evision.Mat.maybe_mat_in()) :: list(Evision.KeyPoint.t()) | {:error, String.t()}
  def detect(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.akaze_detect(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  detectAndCompute

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
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
  @spec detectAndCompute(Evision.AKAZE.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{:useProvidedKeypoints, term()}] | nil) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def detectAndCompute(self, image, mask, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:useProvidedKeypoints])
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.akaze_detectAndCompute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec detectAndCompute(Keyword.t()) :: any() | {:error, String.t()}
  def detectAndCompute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:image,:keypoints,:mask,:descriptors,:useProvidedKeypoints])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_detectAndCompute()
    |> to_struct()
  end

  @doc """
  detectAndCompute

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
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
  @spec detectAndCompute(Evision.AKAZE.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {list(Evision.KeyPoint.t()), Evision.Mat.t()} | {:error, String.t()}
  def detectAndCompute(self, image, mask) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.akaze_detectAndCompute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  empty

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_empty()
    |> to_struct()
  end
  @spec empty(Evision.AKAZE.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.akaze_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.AKAZE.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.akaze_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDescriptorChannels

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getDescriptorChannels() -> retval
  ```
  """
  @spec getDescriptorChannels(Keyword.t()) :: any() | {:error, String.t()}
  def getDescriptorChannels([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_getDescriptorChannels()
    |> to_struct()
  end
  @spec getDescriptorChannels(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def getDescriptorChannels(self) do
    positional = [
    ]
    :evision_nif.akaze_getDescriptorChannels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDescriptorSize

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getDescriptorSize() -> retval
  ```
  """
  @spec getDescriptorSize(Keyword.t()) :: any() | {:error, String.t()}
  def getDescriptorSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_getDescriptorSize()
    |> to_struct()
  end
  @spec getDescriptorSize(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def getDescriptorSize(self) do
    positional = [
    ]
    :evision_nif.akaze_getDescriptorSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDescriptorType

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

  ##### Return
  - **retval**: `AKAZE::DescriptorType`

  Python prototype (for reference only):
  ```python3
  getDescriptorType() -> retval
  ```
  """
  @spec getDescriptorType(Keyword.t()) :: any() | {:error, String.t()}
  def getDescriptorType([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_getDescriptorType()
    |> to_struct()
  end
  @spec getDescriptorType(Evision.AKAZE.t()) :: Evision.AKAZE.DescriptorType.enum() | {:error, String.t()}
  def getDescriptorType(self) do
    positional = [
    ]
    :evision_nif.akaze_getDescriptorType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDiffusivity

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_getDiffusivity()
    |> to_struct()
  end
  @spec getDiffusivity(Evision.AKAZE.t()) :: Evision.KAZE.DiffusivityType.enum() | {:error, String.t()}
  def getDiffusivity(self) do
    positional = [
    ]
    :evision_nif.akaze_getDiffusivity(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMaxPoints

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMaxPoints() -> retval
  ```
  """
  @spec getMaxPoints(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxPoints([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_getMaxPoints()
    |> to_struct()
  end
  @spec getMaxPoints(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def getMaxPoints(self) do
    positional = [
    ]
    :evision_nif.akaze_getMaxPoints(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNOctaveLayers

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_getNOctaveLayers()
    |> to_struct()
  end
  @spec getNOctaveLayers(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def getNOctaveLayers(self) do
    positional = [
    ]
    :evision_nif.akaze_getNOctaveLayers(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNOctaves

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_getNOctaves()
    |> to_struct()
  end
  @spec getNOctaves(Evision.AKAZE.t()) :: integer() | {:error, String.t()}
  def getNOctaves(self) do
    positional = [
    ]
    :evision_nif.akaze_getNOctaves(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getThreshold

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`

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
    |> :evision_nif.akaze_getThreshold()
    |> to_struct()
  end
  @spec getThreshold(Evision.AKAZE.t()) :: number() | {:error, String.t()}
  def getThreshold(self) do
    positional = [
    ]
    :evision_nif.akaze_getThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fileName,:arg1])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_read()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  read

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **arg1**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(arg1) -> None
  ```
  #### Variant 2:
  read

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **fileName**: `String`

  Python prototype (for reference only):
  ```python3
  read(fileName) -> None
  ```

  """
  @spec read(Evision.AKAZE.t(), Evision.FileNode.t()) :: Evision.AKAZE.t() | {:error, String.t()}
  def read(self, arg1) when is_struct(arg1, Evision.FileNode)
  do
    positional = [
      arg1: Evision.Internal.Structurise.from_struct(arg1)
    ]
    :evision_nif.akaze_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Evision.AKAZE.t(), binary()) :: Evision.AKAZE.t() | {:error, String.t()}
  def read(self, fileName) when is_binary(fileName)
  do
    positional = [
      fileName: Evision.Internal.Structurise.from_struct(fileName)
    ]
    :evision_nif.akaze_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDescriptorChannels(Keyword.t()) :: any() | {:error, String.t()}
  def setDescriptorChannels([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dch])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setDescriptorChannels()
    |> to_struct()
  end

  @doc """
  setDescriptorChannels

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **dch**: `integer()`

  Python prototype (for reference only):
  ```python3
  setDescriptorChannels(dch) -> None
  ```
  """
  @spec setDescriptorChannels(Evision.AKAZE.t(), integer()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setDescriptorChannels(self, dch) when is_integer(dch)
  do
    positional = [
      dch: Evision.Internal.Structurise.from_struct(dch)
    ]
    :evision_nif.akaze_setDescriptorChannels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDescriptorSize(Keyword.t()) :: any() | {:error, String.t()}
  def setDescriptorSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dsize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setDescriptorSize()
    |> to_struct()
  end

  @doc """
  setDescriptorSize

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **dsize**: `integer()`

  Python prototype (for reference only):
  ```python3
  setDescriptorSize(dsize) -> None
  ```
  """
  @spec setDescriptorSize(Evision.AKAZE.t(), integer()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setDescriptorSize(self, dsize) when is_integer(dsize)
  do
    positional = [
      dsize: Evision.Internal.Structurise.from_struct(dsize)
    ]
    :evision_nif.akaze_setDescriptorSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDescriptorType(Keyword.t()) :: any() | {:error, String.t()}
  def setDescriptorType([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dtype])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setDescriptorType()
    |> to_struct()
  end

  @doc """
  setDescriptorType

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **dtype**: `AKAZE_DescriptorType`

  Python prototype (for reference only):
  ```python3
  setDescriptorType(dtype) -> None
  ```
  """
  @spec setDescriptorType(Evision.AKAZE.t(), Evision.AKAZE.DescriptorType.enum()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setDescriptorType(self, dtype) when is_integer(dtype)
  do
    positional = [
      dtype: Evision.Internal.Structurise.from_struct(dtype)
    ]
    :evision_nif.akaze_setDescriptorType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDiffusivity(Keyword.t()) :: any() | {:error, String.t()}
  def setDiffusivity([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:diff])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setDiffusivity()
    |> to_struct()
  end

  @doc """
  setDiffusivity

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **diff**: `KAZE_DiffusivityType`

  Python prototype (for reference only):
  ```python3
  setDiffusivity(diff) -> None
  ```
  """
  @spec setDiffusivity(Evision.AKAZE.t(), Evision.KAZE.DiffusivityType.enum()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setDiffusivity(self, diff) when is_integer(diff)
  do
    positional = [
      diff: Evision.Internal.Structurise.from_struct(diff)
    ]
    :evision_nif.akaze_setDiffusivity(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxPoints(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxPoints([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:max_points])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setMaxPoints()
    |> to_struct()
  end

  @doc """
  setMaxPoints

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **max_points**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMaxPoints(max_points) -> None
  ```
  """
  @spec setMaxPoints(Evision.AKAZE.t(), integer()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setMaxPoints(self, max_points) when is_integer(max_points)
  do
    positional = [
      max_points: Evision.Internal.Structurise.from_struct(max_points)
    ]
    :evision_nif.akaze_setMaxPoints(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNOctaveLayers(Keyword.t()) :: any() | {:error, String.t()}
  def setNOctaveLayers([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:octaveLayers])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setNOctaveLayers()
    |> to_struct()
  end

  @doc """
  setNOctaveLayers

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **octaveLayers**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNOctaveLayers(octaveLayers) -> None
  ```
  """
  @spec setNOctaveLayers(Evision.AKAZE.t(), integer()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setNOctaveLayers(self, octaveLayers) when is_integer(octaveLayers)
  do
    positional = [
      octaveLayers: Evision.Internal.Structurise.from_struct(octaveLayers)
    ]
    :evision_nif.akaze_setNOctaveLayers(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNOctaves(Keyword.t()) :: any() | {:error, String.t()}
  def setNOctaves([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:octaves])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setNOctaves()
    |> to_struct()
  end

  @doc """
  setNOctaves

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **octaves**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNOctaves(octaves) -> None
  ```
  """
  @spec setNOctaves(Evision.AKAZE.t(), integer()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setNOctaves(self, octaves) when is_integer(octaves)
  do
    positional = [
      octaves: Evision.Internal.Structurise.from_struct(octaves)
    ]
    :evision_nif.akaze_setNOctaves(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:threshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_setThreshold()
    |> to_struct()
  end

  @doc """
  setThreshold

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **threshold**: `double`

  Python prototype (for reference only):
  ```python3
  setThreshold(threshold) -> None
  ```
  """
  @spec setThreshold(Evision.AKAZE.t(), number()) :: Evision.AKAZE.t() | {:error, String.t()}
  def setThreshold(self, threshold) when is_number(threshold)
  do
    positional = [
      threshold: Evision.Internal.Structurise.from_struct(threshold)
    ]
    :evision_nif.akaze_setThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fileName,:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.akaze_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.AKAZE.t(), Evision.FileStorage.t(), binary()) :: Evision.AKAZE.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.akaze_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.AKAZE.t()`
  - **fileName**: `String`

  Python prototype (for reference only):
  ```python3
  write(fileName) -> None
  ```
  """
  @spec write(Evision.AKAZE.t(), binary()) :: Evision.AKAZE.t() | {:error, String.t()}
  def write(self, fileName) when is_binary(fileName)
  do
    positional = [
      fileName: Evision.Internal.Structurise.from_struct(fileName)
    ]
    :evision_nif.akaze_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
