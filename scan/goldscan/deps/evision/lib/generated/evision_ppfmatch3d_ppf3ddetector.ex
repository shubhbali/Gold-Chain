defmodule Evision.PPFMatch3D.PPF3DDetector do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `PPFMatch3D.PPF3DDetector` struct.

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
  def to_struct({:ok, %{class: Evision.PPFMatch3D.PPF3DDetector, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.PPFMatch3D.PPF3DDetector, ref: ref}) do
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
  PPF3DDetector

  ##### Positional Arguments
  - **relativeSamplingStep**: `double`

  ##### Keyword Arguments
  - **relativeDistanceStep**: `double`.
  - **numAngles**: `double`.

  ##### Return
  - **self**: `Evision.PPFMatch3D.PPF3DDetector.t()`

   Constructor with arguments

  Python prototype (for reference only):
  ```python3
  PPF3DDetector(relativeSamplingStep[, relativeDistanceStep[, numAngles]]) -> <ppf_match_3d_PPF3DDetector object>
  ```
  """
  @spec pPF3DDetector(number(), [{:numAngles, term()} | {:relativeDistanceStep, term()}] | nil) :: Evision.PPFMatch3D.PPF3DDetector.t() | {:error, String.t()}
  def pPF3DDetector(relativeSamplingStep, opts) when is_number(relativeSamplingStep) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:numAngles, :relativeDistanceStep])
    positional = [
      relativeSamplingStep: Evision.Internal.Structurise.from_struct(relativeSamplingStep)
    ]
    :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_PPF3DDetector(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  PPF3DDetector

  ##### Positional Arguments
  - **relativeSamplingStep**: `double`

  ##### Keyword Arguments
  - **relativeDistanceStep**: `double`.
  - **numAngles**: `double`.

  ##### Return
  - **self**: `Evision.PPFMatch3D.PPF3DDetector.t()`

   Constructor with arguments

  Python prototype (for reference only):
  ```python3
  PPF3DDetector(relativeSamplingStep[, relativeDistanceStep[, numAngles]]) -> <ppf_match_3d_PPF3DDetector object>
  ```
  """
  @spec pPF3DDetector(Keyword.t()) :: any() | {:error, String.t()}
  def pPF3DDetector([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:numAngles,:relativeDistanceStep,:relativeSamplingStep])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_PPF3DDetector()
    |> to_struct()
  end
  @spec pPF3DDetector(number()) :: Evision.PPFMatch3D.PPF3DDetector.t() | {:error, String.t()}
  def pPF3DDetector(relativeSamplingStep) when is_number(relativeSamplingStep)
  do
    positional = [
      relativeSamplingStep: Evision.Internal.Structurise.from_struct(relativeSamplingStep)
    ]
    :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_PPF3DDetector(positional)
    |> to_struct()
  end

  @doc """
  PPF3DDetector
  ##### Return
  - **self**: `Evision.PPFMatch3D.PPF3DDetector.t()`

   \\brief Empty constructor. Sets default arguments

  Python prototype (for reference only):
  ```python3
  PPF3DDetector() -> <ppf_match_3d_PPF3DDetector object>
  ```
  """
  @spec pPF3DDetector() :: Evision.PPFMatch3D.PPF3DDetector.t() | {:error, String.t()}
  def pPF3DDetector() do
    positional = [
    ]
    :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_PPF3DDetector(positional)
    |> to_struct()
  end

  @doc """
  match

  ##### Positional Arguments
  - **self**: `Evision.PPFMatch3D.PPF3DDetector.t()`
  - **scene**: `Evision.Mat`

  ##### Keyword Arguments
  - **relativeSceneSampleStep**: `double`.
  - **relativeSceneDistance**: `double`.

  ##### Return
  - **results**: `[Evision.PPFMatch3D.Pose3D]`

    \\brief Matches a trained model across a provided scene.

  Python prototype (for reference only):
  ```python3
  match(scene[, relativeSceneSampleStep[, relativeSceneDistance]]) -> results
  ```
  """
  @spec match(Evision.PPFMatch3D.PPF3DDetector.t(), Evision.Mat.maybe_mat_in(), [{:relativeSceneDistance, term()} | {:relativeSceneSampleStep, term()}] | nil) :: list(Evision.PPFMatch3D.Pose3D.t()) | {:error, String.t()}
  def match(self, scene, opts) when (is_struct(scene, Evision.Mat) or is_struct(scene, Nx.Tensor) or is_number(scene) or is_tuple(scene)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:relativeSceneDistance, :relativeSceneSampleStep])
    positional = [
      scene: Evision.Internal.Structurise.from_struct(scene)
    ]
    :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_match(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec match(Keyword.t()) :: any() | {:error, String.t()}
  def match([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:relativeSceneDistance,:scene,:relativeSceneSampleStep,:results])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_match()
    |> to_struct()
  end

  @doc """
  match

  ##### Positional Arguments
  - **self**: `Evision.PPFMatch3D.PPF3DDetector.t()`
  - **scene**: `Evision.Mat`

  ##### Keyword Arguments
  - **relativeSceneSampleStep**: `double`.
  - **relativeSceneDistance**: `double`.

  ##### Return
  - **results**: `[Evision.PPFMatch3D.Pose3D]`

    \\brief Matches a trained model across a provided scene.

  Python prototype (for reference only):
  ```python3
  match(scene[, relativeSceneSampleStep[, relativeSceneDistance]]) -> results
  ```
  """
  @spec match(Evision.PPFMatch3D.PPF3DDetector.t(), Evision.Mat.maybe_mat_in()) :: list(Evision.PPFMatch3D.Pose3D.t()) | {:error, String.t()}
  def match(self, scene) when (is_struct(scene, Evision.Mat) or is_struct(scene, Nx.Tensor) or is_number(scene) or is_tuple(scene))
  do
    positional = [
      scene: Evision.Internal.Structurise.from_struct(scene)
    ]
    :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_match(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec trainModel(Keyword.t()) :: any() | {:error, String.t()}
  def trainModel([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:Model])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_trainModel()
    |> to_struct()
  end

  @doc """
  trainModel

  ##### Positional Arguments
  - **self**: `Evision.PPFMatch3D.PPF3DDetector.t()`
  - **model**: `Evision.Mat`

    \\brief Trains a new model.

    \\details Uses the parameters set in the constructor to downsample and learn a new model. When the model is learnt, the instance gets ready for calling "match".

  Python prototype (for reference only):
  ```python3
  trainModel(Model) -> None
  ```
  """
  @spec trainModel(Evision.PPFMatch3D.PPF3DDetector.t(), Evision.Mat.maybe_mat_in()) :: Evision.PPFMatch3D.PPF3DDetector.t() | {:error, String.t()}
  def trainModel(self, model) when (is_struct(model, Evision.Mat) or is_struct(model, Nx.Tensor) or is_number(model) or is_tuple(model))
  do
    positional = [
      model: Evision.Internal.Structurise.from_struct(model)
    ]
    :evision_nif.ppf_match_3d_ppf_match_3d_PPF3DDetector_trainModel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
