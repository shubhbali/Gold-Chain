defmodule Evision.Detail.AffineBasedEstimator do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Detail.AffineBasedEstimator` struct.

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
  def to_struct({:ok, %{class: Evision.Detail.AffineBasedEstimator, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Detail.AffineBasedEstimator, ref: ref}) do
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
  @spec affineBasedEstimator(Keyword.t()) :: any() | {:error, String.t()}
  def affineBasedEstimator([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_AffineBasedEstimator_AffineBasedEstimator()
    |> to_struct()
  end

  @doc """
  AffineBasedEstimator
  ##### Return
  - **self**: `Evision.Detail.AffineBasedEstimator.t()`

  Python prototype (for reference only):
  ```python3
  AffineBasedEstimator() -> <detail_AffineBasedEstimator object>
  ```
  """
  @spec affineBasedEstimator() :: Evision.Detail.AffineBasedEstimator.t() | {:error, String.t()}
  def affineBasedEstimator() do
    positional = [
    ]
    :evision_nif.detail_detail_AffineBasedEstimator_AffineBasedEstimator(positional)
    |> to_struct()
  end
end
