defmodule Evision.Detail.BundleAdjusterAffine do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Detail.BundleAdjusterAffine` struct.

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
  def to_struct({:ok, %{class: Evision.Detail.BundleAdjusterAffine, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Detail.BundleAdjusterAffine, ref: ref}) do
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
  @spec bundleAdjusterAffine(Keyword.t()) :: any() | {:error, String.t()}
  def bundleAdjusterAffine([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_BundleAdjusterAffine_BundleAdjusterAffine()
    |> to_struct()
  end

  @doc """
  BundleAdjusterAffine
  ##### Return
  - **self**: `Evision.Detail.BundleAdjusterAffine.t()`

  Python prototype (for reference only):
  ```python3
  BundleAdjusterAffine() -> <detail_BundleAdjusterAffine object>
  ```
  """
  @spec bundleAdjusterAffine() :: Evision.Detail.BundleAdjusterAffine.t() | {:error, String.t()}
  def bundleAdjusterAffine() do
    positional = [
    ]
    :evision_nif.detail_detail_BundleAdjusterAffine_BundleAdjusterAffine(positional)
    |> to_struct()
  end
end
