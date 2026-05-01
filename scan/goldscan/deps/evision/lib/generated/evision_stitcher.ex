defmodule Evision.Stitcher do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Stitcher` struct.

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
  def to_struct({:ok, %{class: Evision.Stitcher, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Stitcher, ref: ref}) do
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
  cameras

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `[cv::detail::CameraParams]`

  Returns estimated camera parameters for all stitched images

  Python prototype (for reference only):
  ```python3
  cameras() -> retval
  ```
  """
  @spec cameras(Keyword.t()) :: any() | {:error, String.t()}
  def cameras([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_cameras()
    |> to_struct()
  end
  @spec cameras(Evision.Stitcher.t()) :: list(term()) | {:error, String.t()}
  def cameras(self) do
    positional = [
    ]
    :evision_nif.stitcher_cameras(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns indeces of input images used in panorama stitching

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `[integer()]`

  Python prototype (for reference only):
  ```python3
  component() -> retval
  ```
  """
  @spec component(Keyword.t()) :: any() | {:error, String.t()}
  def component([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_component()
    |> to_struct()
  end
  @spec component(Evision.Stitcher.t()) :: list(integer()) | {:error, String.t()}
  def component(self) do
    positional = [
    ]
    :evision_nif.stitcher_component(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  These functions try to compose the given images (or images stored internally from the other function
  calls) into the final pano under the assumption that the image transformations were estimated
  before.

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`.

    Input images.

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

    Final pano.

  **Note**: Use the functions only if you're aware of the stitching pipeline, otherwise use
  Stitcher::stitch.
  @return Status code.

  Python prototype (for reference only):
  ```python3
  composePanorama(images[, pano]) -> retval, pano
  ```
  """
  @spec composePanorama(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in()), [{atom(), term()},...] | nil) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def composePanorama(self, images, opts) when is_list(images) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.stitcher_composePanorama(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  composePanorama

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  composePanorama([, pano]) -> retval, pano
  ```
  """
  @spec composePanorama(Keyword.t()) :: any() | {:error, String.t()}
  def composePanorama([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:images,:pano])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_composePanorama()
    |> to_struct()
  end
  @spec composePanorama(Evision.Stitcher.t()) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def composePanorama(self) do
    positional = [
    ]
    :evision_nif.stitcher_composePanorama(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  These functions try to compose the given images (or images stored internally from the other function
  calls) into the final pano under the assumption that the image transformations were estimated
  before.

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`.

    Input images.

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

    Final pano.

  **Note**: Use the functions only if you're aware of the stitching pipeline, otherwise use
  Stitcher::stitch.
  @return Status code.

  Python prototype (for reference only):
  ```python3
  composePanorama(images[, pano]) -> retval, pano
  ```
  #### Variant 2:
  composePanorama

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  composePanorama([, pano]) -> retval, pano
  ```

  """
  @spec composePanorama(Evision.Stitcher.t(), [{atom(), term()},...] | nil) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def composePanorama(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.stitcher_composePanorama(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec composePanorama(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in())) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def composePanorama(self, images) when is_list(images)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.stitcher_composePanorama(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  compositingResol

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  compositingResol() -> retval
  ```
  """
  @spec compositingResol(Keyword.t()) :: any() | {:error, String.t()}
  def compositingResol([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_compositingResol()
    |> to_struct()
  end
  @spec compositingResol(Evision.Stitcher.t()) :: number() | {:error, String.t()}
  def compositingResol(self) do
    positional = [
    ]
    :evision_nif.stitcher_compositingResol(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Creates a Stitcher configured in one of the stitching modes.
  ##### Keyword Arguments
  - **mode**: `Mode`.

    Scenario for stitcher operation. This is usually determined by source of images
    to stitch and their transformation. Default parameters will be chosen for operation in given
    scenario.

  ##### Return
  - **retval**: `Evision.Stitcher.t()`

  @return Stitcher class instance.

  Python prototype (for reference only):
  ```python3
  create([, mode]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:mode])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_create_static()
    |> to_struct()
  end
  @spec create([{:mode, term()}] | nil) :: Evision.Stitcher.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:mode])
    positional = [
    ]
    :evision_nif.stitcher_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Creates a Stitcher configured in one of the stitching modes.
  ##### Keyword Arguments
  - **mode**: `Mode`.

    Scenario for stitcher operation. This is usually determined by source of images
    to stitch and their transformation. Default parameters will be chosen for operation in given
    scenario.

  ##### Return
  - **retval**: `Evision.Stitcher.t()`

  @return Stitcher class instance.

  Python prototype (for reference only):
  ```python3
  create([, mode]) -> retval
  ```
  """
  @spec create() :: Evision.Stitcher.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.stitcher_create_static(positional)
    |> to_struct()
  end

  @doc """
  These functions try to match the given images and to estimate rotations of each camera.

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`.

    Input images.

  ##### Keyword Arguments
  - **masks**: `[Evision.Mat]`.

    Masks for each input image specifying where to look for keypoints (optional).

  ##### Return
  - **retval**: `Status`

  **Note**: Use the functions only if you're aware of the stitching pipeline, otherwise use
  Stitcher::stitch.
  @return Status code.

  Python prototype (for reference only):
  ```python3
  estimateTransform(images[, masks]) -> retval
  ```
  """
  @spec estimateTransform(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in()), [{:masks, term()}] | nil) :: integer() | {:error, String.t()}
  def estimateTransform(self, images, opts) when is_list(images) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:masks])
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.stitcher_estimateTransform(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec estimateTransform(Keyword.t()) :: any() | {:error, String.t()}
  def estimateTransform([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:images,:masks])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_estimateTransform()
    |> to_struct()
  end

  @doc """
  These functions try to match the given images and to estimate rotations of each camera.

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`.

    Input images.

  ##### Keyword Arguments
  - **masks**: `[Evision.Mat]`.

    Masks for each input image specifying where to look for keypoints (optional).

  ##### Return
  - **retval**: `Status`

  **Note**: Use the functions only if you're aware of the stitching pipeline, otherwise use
  Stitcher::stitch.
  @return Status code.

  Python prototype (for reference only):
  ```python3
  estimateTransform(images[, masks]) -> retval
  ```
  """
  @spec estimateTransform(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in())) :: integer() | {:error, String.t()}
  def estimateTransform(self, images) when is_list(images)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.stitcher_estimateTransform(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  interpolationFlags

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `InterpolationFlags`

  Python prototype (for reference only):
  ```python3
  interpolationFlags() -> retval
  ```
  """
  @spec interpolationFlags(Keyword.t()) :: any() | {:error, String.t()}
  def interpolationFlags([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_interpolationFlags()
    |> to_struct()
  end
  @spec interpolationFlags(Evision.Stitcher.t()) :: Evision.InterpolationFlags.enum() | {:error, String.t()}
  def interpolationFlags(self) do
    positional = [
    ]
    :evision_nif.stitcher_interpolationFlags(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  panoConfidenceThresh

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  panoConfidenceThresh() -> retval
  ```
  """
  @spec panoConfidenceThresh(Keyword.t()) :: any() | {:error, String.t()}
  def panoConfidenceThresh([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_panoConfidenceThresh()
    |> to_struct()
  end
  @spec panoConfidenceThresh(Evision.Stitcher.t()) :: number() | {:error, String.t()}
  def panoConfidenceThresh(self) do
    positional = [
    ]
    :evision_nif.stitcher_panoConfidenceThresh(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  registrationResol

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  registrationResol() -> retval
  ```
  """
  @spec registrationResol(Keyword.t()) :: any() | {:error, String.t()}
  def registrationResol([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_registrationResol()
    |> to_struct()
  end
  @spec registrationResol(Evision.Stitcher.t()) :: number() | {:error, String.t()}
  def registrationResol(self) do
    positional = [
    ]
    :evision_nif.stitcher_registrationResol(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  seamEstimationResol

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  seamEstimationResol() -> retval
  ```
  """
  @spec seamEstimationResol(Keyword.t()) :: any() | {:error, String.t()}
  def seamEstimationResol([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_seamEstimationResol()
    |> to_struct()
  end
  @spec seamEstimationResol(Evision.Stitcher.t()) :: number() | {:error, String.t()}
  def seamEstimationResol(self) do
    positional = [
    ]
    :evision_nif.stitcher_seamEstimationResol(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setCompositingResol(Keyword.t()) :: any() | {:error, String.t()}
  def setCompositingResol([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:resol_mpx])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_setCompositingResol()
    |> to_struct()
  end

  @doc """
  setCompositingResol

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **resol_mpx**: `double`

  Python prototype (for reference only):
  ```python3
  setCompositingResol(resol_mpx) -> None
  ```
  """
  @spec setCompositingResol(Evision.Stitcher.t(), number()) :: Evision.Stitcher.t() | {:error, String.t()}
  def setCompositingResol(self, resol_mpx) when is_number(resol_mpx)
  do
    positional = [
      resol_mpx: Evision.Internal.Structurise.from_struct(resol_mpx)
    ]
    :evision_nif.stitcher_setCompositingResol(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setInterpolationFlags(Keyword.t()) :: any() | {:error, String.t()}
  def setInterpolationFlags([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:interp_flags])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_setInterpolationFlags()
    |> to_struct()
  end

  @doc """
  setInterpolationFlags

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **interp_flags**: `InterpolationFlags`

  Python prototype (for reference only):
  ```python3
  setInterpolationFlags(interp_flags) -> None
  ```
  """
  @spec setInterpolationFlags(Evision.Stitcher.t(), Evision.InterpolationFlags.enum()) :: Evision.Stitcher.t() | {:error, String.t()}
  def setInterpolationFlags(self, interp_flags) when is_integer(interp_flags)
  do
    positional = [
      interp_flags: Evision.Internal.Structurise.from_struct(interp_flags)
    ]
    :evision_nif.stitcher_setInterpolationFlags(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPanoConfidenceThresh(Keyword.t()) :: any() | {:error, String.t()}
  def setPanoConfidenceThresh([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:conf_thresh])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_setPanoConfidenceThresh()
    |> to_struct()
  end

  @doc """
  setPanoConfidenceThresh

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **conf_thresh**: `double`

  Python prototype (for reference only):
  ```python3
  setPanoConfidenceThresh(conf_thresh) -> None
  ```
  """
  @spec setPanoConfidenceThresh(Evision.Stitcher.t(), number()) :: Evision.Stitcher.t() | {:error, String.t()}
  def setPanoConfidenceThresh(self, conf_thresh) when is_number(conf_thresh)
  do
    positional = [
      conf_thresh: Evision.Internal.Structurise.from_struct(conf_thresh)
    ]
    :evision_nif.stitcher_setPanoConfidenceThresh(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setRegistrationResol(Keyword.t()) :: any() | {:error, String.t()}
  def setRegistrationResol([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:resol_mpx])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_setRegistrationResol()
    |> to_struct()
  end

  @doc """
  setRegistrationResol

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **resol_mpx**: `double`

  Python prototype (for reference only):
  ```python3
  setRegistrationResol(resol_mpx) -> None
  ```
  """
  @spec setRegistrationResol(Evision.Stitcher.t(), number()) :: Evision.Stitcher.t() | {:error, String.t()}
  def setRegistrationResol(self, resol_mpx) when is_number(resol_mpx)
  do
    positional = [
      resol_mpx: Evision.Internal.Structurise.from_struct(resol_mpx)
    ]
    :evision_nif.stitcher_setRegistrationResol(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSeamEstimationResol(Keyword.t()) :: any() | {:error, String.t()}
  def setSeamEstimationResol([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:resol_mpx])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_setSeamEstimationResol()
    |> to_struct()
  end

  @doc """
  setSeamEstimationResol

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **resol_mpx**: `double`

  Python prototype (for reference only):
  ```python3
  setSeamEstimationResol(resol_mpx) -> None
  ```
  """
  @spec setSeamEstimationResol(Evision.Stitcher.t(), number()) :: Evision.Stitcher.t() | {:error, String.t()}
  def setSeamEstimationResol(self, resol_mpx) when is_number(resol_mpx)
  do
    positional = [
      resol_mpx: Evision.Internal.Structurise.from_struct(resol_mpx)
    ]
    :evision_nif.stitcher_setSeamEstimationResol(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setWaveCorrection(Keyword.t()) :: any() | {:error, String.t()}
  def setWaveCorrection([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:flag])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_setWaveCorrection()
    |> to_struct()
  end

  @doc """
  setWaveCorrection

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **flag**: `bool`

  Python prototype (for reference only):
  ```python3
  setWaveCorrection(flag) -> None
  ```
  """
  @spec setWaveCorrection(Evision.Stitcher.t(), boolean()) :: Evision.Stitcher.t() | {:error, String.t()}
  def setWaveCorrection(self, flag) when is_boolean(flag)
  do
    positional = [
      flag: Evision.Internal.Structurise.from_struct(flag)
    ]
    :evision_nif.stitcher_setWaveCorrection(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  These functions try to stitch the given images.

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`.

    Input images.

  - **masks**: `[Evision.Mat]`.

    Masks for each input image specifying where to look for keypoints (optional).

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

    Final pano.

  @return Status code.

  Python prototype (for reference only):
  ```python3
  stitch(images, masks[, pano]) -> retval, pano
  ```
  """
  @spec stitch(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in()), list(Evision.Mat.maybe_mat_in()), [{atom(), term()},...] | nil) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def stitch(self, images, masks, opts) when is_list(images) and is_list(masks) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images),
      masks: Evision.Internal.Structurise.from_struct(masks)
    ]
    :evision_nif.stitcher_stitch(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec stitch(Keyword.t()) :: any() | {:error, String.t()}
  def stitch([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:images,:masks,:pano])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_stitch()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  These functions try to stitch the given images.

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`.

    Input images.

  - **masks**: `[Evision.Mat]`.

    Masks for each input image specifying where to look for keypoints (optional).

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

    Final pano.

  @return Status code.

  Python prototype (for reference only):
  ```python3
  stitch(images, masks[, pano]) -> retval, pano
  ```
  #### Variant 2:
  stitch

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  stitch(images[, pano]) -> retval, pano
  ```

  """
  @spec stitch(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in()), [{atom(), term()},...] | nil) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def stitch(self, images, opts) when is_list(images) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.stitcher_stitch(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec stitch(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in()), list(Evision.Mat.maybe_mat_in())) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def stitch(self, images, masks) when is_list(images) and is_list(masks)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images),
      masks: Evision.Internal.Structurise.from_struct(masks)
    ]
    :evision_nif.stitcher_stitch(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  stitch

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`
  - **images**: `[Evision.Mat]`

  ##### Return
  - **retval**: `Status`
  - **pano**: `Evision.Mat.t()`.

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  stitch(images[, pano]) -> retval, pano
  ```
  """
  @spec stitch(Evision.Stitcher.t(), list(Evision.Mat.maybe_mat_in())) :: {integer(), Evision.Mat.t()} | {:error, String.t()}
  def stitch(self, images) when is_list(images)
  do
    positional = [
      images: Evision.Internal.Structurise.from_struct(images)
    ]
    :evision_nif.stitcher_stitch(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  waveCorrection

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  waveCorrection() -> retval
  ```
  """
  @spec waveCorrection(Keyword.t()) :: any() | {:error, String.t()}
  def waveCorrection([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_waveCorrection()
    |> to_struct()
  end
  @spec waveCorrection(Evision.Stitcher.t()) :: boolean() | {:error, String.t()}
  def waveCorrection(self) do
    positional = [
    ]
    :evision_nif.stitcher_waveCorrection(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  workScale

  ##### Positional Arguments
  - **self**: `Evision.Stitcher.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  workScale() -> retval
  ```
  """
  @spec workScale(Keyword.t()) :: any() | {:error, String.t()}
  def workScale([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.stitcher_workScale()
    |> to_struct()
  end
  @spec workScale(Evision.Stitcher.t()) :: number() | {:error, String.t()}
  def workScale(self) do
    positional = [
    ]
    :evision_nif.stitcher_workScale(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
