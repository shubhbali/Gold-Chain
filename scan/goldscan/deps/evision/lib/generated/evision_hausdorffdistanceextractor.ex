defmodule Evision.HausdorffDistanceExtractor do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `HausdorffDistanceExtractor` struct.

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
  def to_struct({:ok, %{class: Evision.HausdorffDistanceExtractor, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.HausdorffDistanceExtractor, ref: ref}) do
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
  getDistanceFlag

  ##### Positional Arguments
  - **self**: `Evision.HausdorffDistanceExtractor.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getDistanceFlag() -> retval
  ```
  """
  @spec getDistanceFlag(Keyword.t()) :: any() | {:error, String.t()}
  def getDistanceFlag([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hausdorffDistanceExtractor_getDistanceFlag()
    |> to_struct()
  end
  @spec getDistanceFlag(Evision.HausdorffDistanceExtractor.t()) :: integer() | {:error, String.t()}
  def getDistanceFlag(self) do
    positional = [
    ]
    :evision_nif.hausdorffDistanceExtractor_getDistanceFlag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getRankProportion

  ##### Positional Arguments
  - **self**: `Evision.HausdorffDistanceExtractor.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getRankProportion() -> retval
  ```
  """
  @spec getRankProportion(Keyword.t()) :: any() | {:error, String.t()}
  def getRankProportion([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hausdorffDistanceExtractor_getRankProportion()
    |> to_struct()
  end
  @spec getRankProportion(Evision.HausdorffDistanceExtractor.t()) :: number() | {:error, String.t()}
  def getRankProportion(self) do
    positional = [
    ]
    :evision_nif.hausdorffDistanceExtractor_getRankProportion(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDistanceFlag(Keyword.t()) :: any() | {:error, String.t()}
  def setDistanceFlag([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:distanceFlag])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hausdorffDistanceExtractor_setDistanceFlag()
    |> to_struct()
  end

  @doc """
  Set the norm used to compute the Hausdorff value between two shapes. It can be L1 or L2 norm.

  ##### Positional Arguments
  - **self**: `Evision.HausdorffDistanceExtractor.t()`
  - **distanceFlag**: `integer()`.

    Flag indicating which norm is used to compute the Hausdorff distance
    (NORM_L1, NORM_L2).

  Python prototype (for reference only):
  ```python3
  setDistanceFlag(distanceFlag) -> None
  ```
  """
  @spec setDistanceFlag(Evision.HausdorffDistanceExtractor.t(), integer()) :: Evision.HausdorffDistanceExtractor.t() | {:error, String.t()}
  def setDistanceFlag(self, distanceFlag) when is_integer(distanceFlag)
  do
    positional = [
      distanceFlag: Evision.Internal.Structurise.from_struct(distanceFlag)
    ]
    :evision_nif.hausdorffDistanceExtractor_setDistanceFlag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setRankProportion(Keyword.t()) :: any() | {:error, String.t()}
  def setRankProportion([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:rankProportion])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.hausdorffDistanceExtractor_setRankProportion()
    |> to_struct()
  end

  @doc """
  This method sets the rank proportion (or fractional value) that establish the Kth ranked value of
  the partial Hausdorff distance. Experimentally had been shown that 0.6 is a good value to compare
  shapes.

  ##### Positional Arguments
  - **self**: `Evision.HausdorffDistanceExtractor.t()`
  - **rankProportion**: `float`.

    fractional value (between 0 and 1).

  Python prototype (for reference only):
  ```python3
  setRankProportion(rankProportion) -> None
  ```
  """
  @spec setRankProportion(Evision.HausdorffDistanceExtractor.t(), number()) :: Evision.HausdorffDistanceExtractor.t() | {:error, String.t()}
  def setRankProportion(self, rankProportion) when is_float(rankProportion)
  do
    positional = [
      rankProportion: Evision.Internal.Structurise.from_struct(rankProportion)
    ]
    :evision_nif.hausdorffDistanceExtractor_setRankProportion(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
