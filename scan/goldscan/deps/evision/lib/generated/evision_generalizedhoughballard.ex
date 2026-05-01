defmodule Evision.GeneralizedHoughBallard do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `GeneralizedHoughBallard` struct.

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
  def to_struct({:ok, %{class: Evision.GeneralizedHoughBallard, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.GeneralizedHoughBallard, ref: ref}) do
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
  getLevels

  ##### Positional Arguments
  - **self**: `Evision.GeneralizedHoughBallard.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getLevels() -> retval
  ```
  """
  @spec getLevels(Keyword.t()) :: any() | {:error, String.t()}
  def getLevels([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.generalizedHoughBallard_getLevels()
    |> to_struct()
  end
  @spec getLevels(Evision.GeneralizedHoughBallard.t()) :: integer() | {:error, String.t()}
  def getLevels(self) do
    positional = [
    ]
    :evision_nif.generalizedHoughBallard_getLevels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getVotesThreshold

  ##### Positional Arguments
  - **self**: `Evision.GeneralizedHoughBallard.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getVotesThreshold() -> retval
  ```
  """
  @spec getVotesThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getVotesThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.generalizedHoughBallard_getVotesThreshold()
    |> to_struct()
  end
  @spec getVotesThreshold(Evision.GeneralizedHoughBallard.t()) :: integer() | {:error, String.t()}
  def getVotesThreshold(self) do
    positional = [
    ]
    :evision_nif.generalizedHoughBallard_getVotesThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setLevels(Keyword.t()) :: any() | {:error, String.t()}
  def setLevels([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:levels])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.generalizedHoughBallard_setLevels()
    |> to_struct()
  end

  @doc """
  setLevels

  ##### Positional Arguments
  - **self**: `Evision.GeneralizedHoughBallard.t()`
  - **levels**: `integer()`

  Python prototype (for reference only):
  ```python3
  setLevels(levels) -> None
  ```
  """
  @spec setLevels(Evision.GeneralizedHoughBallard.t(), integer()) :: Evision.GeneralizedHoughBallard.t() | {:error, String.t()}
  def setLevels(self, levels) when is_integer(levels)
  do
    positional = [
      levels: Evision.Internal.Structurise.from_struct(levels)
    ]
    :evision_nif.generalizedHoughBallard_setLevels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setVotesThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setVotesThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:votesThreshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.generalizedHoughBallard_setVotesThreshold()
    |> to_struct()
  end

  @doc """
  setVotesThreshold

  ##### Positional Arguments
  - **self**: `Evision.GeneralizedHoughBallard.t()`
  - **votesThreshold**: `integer()`

  Python prototype (for reference only):
  ```python3
  setVotesThreshold(votesThreshold) -> None
  ```
  """
  @spec setVotesThreshold(Evision.GeneralizedHoughBallard.t(), integer()) :: Evision.GeneralizedHoughBallard.t() | {:error, String.t()}
  def setVotesThreshold(self, votesThreshold) when is_integer(votesThreshold)
  do
    positional = [
      votesThreshold: Evision.Internal.Structurise.from_struct(votesThreshold)
    ]
    :evision_nif.generalizedHoughBallard_setVotesThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
