defmodule Evision.TrackerNano do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `TrackerNano` struct.

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
  def to_struct({:ok, %{class: Evision.TrackerNano, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.TrackerNano, ref: ref}) do
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
  Constructor
  ##### Keyword Arguments
  - **parameters**: `Evision.TrackerNano.Params`.

    NanoTrack parameters TrackerNano::Params

  ##### Return
  - **retval**: `Evision.TrackerNano.t()`

  Python prototype (for reference only):
  ```python3
  create([, parameters]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:parameters])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.trackerNano_create_static()
    |> to_struct()
  end
  @spec create([{:parameters, term()}] | nil) :: Evision.TrackerNano.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:parameters])
    positional = [
    ]
    :evision_nif.trackerNano_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Constructor
  ##### Keyword Arguments
  - **parameters**: `Evision.TrackerNano.Params`.

    NanoTrack parameters TrackerNano::Params

  ##### Return
  - **retval**: `Evision.TrackerNano.t()`

  Python prototype (for reference only):
  ```python3
  create([, parameters]) -> retval
  ```
  """
  @spec create() :: Evision.TrackerNano.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.trackerNano_create_static(positional)
    |> to_struct()
  end

  @doc """
  Return tracking score

  ##### Positional Arguments
  - **self**: `Evision.TrackerNano.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getTrackingScore() -> retval
  ```
  """
  @spec getTrackingScore(Keyword.t()) :: any() | {:error, String.t()}
  def getTrackingScore([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.trackerNano_getTrackingScore()
    |> to_struct()
  end
  @spec getTrackingScore(Evision.TrackerNano.t()) :: number() | {:error, String.t()}
  def getTrackingScore(self) do
    positional = [
    ]
    :evision_nif.trackerNano_getTrackingScore(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
