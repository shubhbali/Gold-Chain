defmodule Evision.EMDHistogramCostExtractor do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `EMDHistogramCostExtractor` struct.

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
  def to_struct({:ok, %{class: Evision.EMDHistogramCostExtractor, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.EMDHistogramCostExtractor, ref: ref}) do
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
  getNormFlag

  ##### Positional Arguments
  - **self**: `Evision.EMDHistogramCostExtractor.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNormFlag() -> retval
  ```
  """
  @spec getNormFlag(Keyword.t()) :: any() | {:error, String.t()}
  def getNormFlag([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.emdHistogramCostExtractor_getNormFlag()
    |> to_struct()
  end
  @spec getNormFlag(Evision.EMDHistogramCostExtractor.t()) :: integer() | {:error, String.t()}
  def getNormFlag(self) do
    positional = [
    ]
    :evision_nif.emdHistogramCostExtractor_getNormFlag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNormFlag(Keyword.t()) :: any() | {:error, String.t()}
  def setNormFlag([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:flag])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.emdHistogramCostExtractor_setNormFlag()
    |> to_struct()
  end

  @doc """
  setNormFlag

  ##### Positional Arguments
  - **self**: `Evision.EMDHistogramCostExtractor.t()`
  - **flag**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNormFlag(flag) -> None
  ```
  """
  @spec setNormFlag(Evision.EMDHistogramCostExtractor.t(), integer()) :: Evision.EMDHistogramCostExtractor.t() | {:error, String.t()}
  def setNormFlag(self, flag) when is_integer(flag)
  do
    positional = [
      flag: Evision.Internal.Structurise.from_struct(flag)
    ]
    :evision_nif.emdHistogramCostExtractor_setNormFlag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
