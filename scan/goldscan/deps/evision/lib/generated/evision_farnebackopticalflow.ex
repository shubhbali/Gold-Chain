defmodule Evision.FarnebackOpticalFlow do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `FarnebackOpticalFlow` struct.

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
  def to_struct({:ok, %{class: Evision.FarnebackOpticalFlow, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.FarnebackOpticalFlow, ref: ref}) do
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
  create
  ##### Keyword Arguments
  - **numLevels**: `integer()`.
  - **pyrScale**: `double`.
  - **fastPyramids**: `bool`.
  - **winSize**: `integer()`.
  - **numIters**: `integer()`.
  - **polyN**: `integer()`.
  - **polySigma**: `double`.
  - **flags**: `integer()`.

  ##### Return
  - **retval**: `Evision.FarnebackOpticalFlow.t()`

  Python prototype (for reference only):
  ```python3
  create([, numLevels[, pyrScale[, fastPyramids[, winSize[, numIters[, polyN[, polySigma[, flags]]]]]]]]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:polySigma,:flags,:numIters,:pyrScale,:fastPyramids,:numLevels,:polyN,:winSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_create_static()
    |> to_struct()
  end
  @spec create([{:fastPyramids, term()} | {:flags, term()} | {:numIters, term()} | {:numLevels, term()} | {:polyN, term()} | {:polySigma, term()} | {:pyrScale, term()} | {:winSize, term()}] | nil) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:fastPyramids, :flags, :numIters, :numLevels, :polyN, :polySigma, :pyrScale, :winSize])
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  create
  ##### Keyword Arguments
  - **numLevels**: `integer()`.
  - **pyrScale**: `double`.
  - **fastPyramids**: `bool`.
  - **winSize**: `integer()`.
  - **numIters**: `integer()`.
  - **polyN**: `integer()`.
  - **polySigma**: `double`.
  - **flags**: `integer()`.

  ##### Return
  - **retval**: `Evision.FarnebackOpticalFlow.t()`

  Python prototype (for reference only):
  ```python3
  create([, numLevels[, pyrScale[, fastPyramids[, winSize[, numIters[, polyN[, polySigma[, flags]]]]]]]]) -> retval
  ```
  """
  @spec create() :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_create_static(positional)
    |> to_struct()
  end

  @doc """
  getFastPyramids

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  getFastPyramids() -> retval
  ```
  """
  @spec getFastPyramids(Keyword.t()) :: any() | {:error, String.t()}
  def getFastPyramids([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getFastPyramids()
    |> to_struct()
  end
  @spec getFastPyramids(Evision.FarnebackOpticalFlow.t()) :: boolean() | {:error, String.t()}
  def getFastPyramids(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getFastPyramids(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getFlags

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getFlags() -> retval
  ```
  """
  @spec getFlags(Keyword.t()) :: any() | {:error, String.t()}
  def getFlags([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getFlags()
    |> to_struct()
  end
  @spec getFlags(Evision.FarnebackOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getFlags(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getFlags(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNumIters

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNumIters() -> retval
  ```
  """
  @spec getNumIters(Keyword.t()) :: any() | {:error, String.t()}
  def getNumIters([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getNumIters()
    |> to_struct()
  end
  @spec getNumIters(Evision.FarnebackOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getNumIters(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getNumIters(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNumLevels

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNumLevels() -> retval
  ```
  """
  @spec getNumLevels(Keyword.t()) :: any() | {:error, String.t()}
  def getNumLevels([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getNumLevels()
    |> to_struct()
  end
  @spec getNumLevels(Evision.FarnebackOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getNumLevels(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getNumLevels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getPolyN

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getPolyN() -> retval
  ```
  """
  @spec getPolyN(Keyword.t()) :: any() | {:error, String.t()}
  def getPolyN([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getPolyN()
    |> to_struct()
  end
  @spec getPolyN(Evision.FarnebackOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getPolyN(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getPolyN(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getPolySigma

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getPolySigma() -> retval
  ```
  """
  @spec getPolySigma(Keyword.t()) :: any() | {:error, String.t()}
  def getPolySigma([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getPolySigma()
    |> to_struct()
  end
  @spec getPolySigma(Evision.FarnebackOpticalFlow.t()) :: number() | {:error, String.t()}
  def getPolySigma(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getPolySigma(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getPyrScale

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getPyrScale() -> retval
  ```
  """
  @spec getPyrScale(Keyword.t()) :: any() | {:error, String.t()}
  def getPyrScale([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getPyrScale()
    |> to_struct()
  end
  @spec getPyrScale(Evision.FarnebackOpticalFlow.t()) :: number() | {:error, String.t()}
  def getPyrScale(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getPyrScale(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getWinSize

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getWinSize() -> retval
  ```
  """
  @spec getWinSize(Keyword.t()) :: any() | {:error, String.t()}
  def getWinSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_getWinSize()
    |> to_struct()
  end
  @spec getWinSize(Evision.FarnebackOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getWinSize(self) do
    positional = [
    ]
    :evision_nif.farnebackOpticalFlow_getWinSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setFastPyramids(Keyword.t()) :: any() | {:error, String.t()}
  def setFastPyramids([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fastPyramids])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setFastPyramids()
    |> to_struct()
  end

  @doc """
  setFastPyramids

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **fastPyramids**: `bool`

  Python prototype (for reference only):
  ```python3
  setFastPyramids(fastPyramids) -> None
  ```
  """
  @spec setFastPyramids(Evision.FarnebackOpticalFlow.t(), boolean()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setFastPyramids(self, fastPyramids) when is_boolean(fastPyramids)
  do
    positional = [
      fastPyramids: Evision.Internal.Structurise.from_struct(fastPyramids)
    ]
    :evision_nif.farnebackOpticalFlow_setFastPyramids(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setFlags(Keyword.t()) :: any() | {:error, String.t()}
  def setFlags([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:flags])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setFlags()
    |> to_struct()
  end

  @doc """
  setFlags

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **flags**: `integer()`

  Python prototype (for reference only):
  ```python3
  setFlags(flags) -> None
  ```
  """
  @spec setFlags(Evision.FarnebackOpticalFlow.t(), integer()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setFlags(self, flags) when is_integer(flags)
  do
    positional = [
      flags: Evision.Internal.Structurise.from_struct(flags)
    ]
    :evision_nif.farnebackOpticalFlow_setFlags(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNumIters(Keyword.t()) :: any() | {:error, String.t()}
  def setNumIters([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:numIters])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setNumIters()
    |> to_struct()
  end

  @doc """
  setNumIters

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **numIters**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNumIters(numIters) -> None
  ```
  """
  @spec setNumIters(Evision.FarnebackOpticalFlow.t(), integer()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setNumIters(self, numIters) when is_integer(numIters)
  do
    positional = [
      numIters: Evision.Internal.Structurise.from_struct(numIters)
    ]
    :evision_nif.farnebackOpticalFlow_setNumIters(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNumLevels(Keyword.t()) :: any() | {:error, String.t()}
  def setNumLevels([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:numLevels])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setNumLevels()
    |> to_struct()
  end

  @doc """
  setNumLevels

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **numLevels**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNumLevels(numLevels) -> None
  ```
  """
  @spec setNumLevels(Evision.FarnebackOpticalFlow.t(), integer()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setNumLevels(self, numLevels) when is_integer(numLevels)
  do
    positional = [
      numLevels: Evision.Internal.Structurise.from_struct(numLevels)
    ]
    :evision_nif.farnebackOpticalFlow_setNumLevels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPolyN(Keyword.t()) :: any() | {:error, String.t()}
  def setPolyN([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:polyN])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setPolyN()
    |> to_struct()
  end

  @doc """
  setPolyN

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **polyN**: `integer()`

  Python prototype (for reference only):
  ```python3
  setPolyN(polyN) -> None
  ```
  """
  @spec setPolyN(Evision.FarnebackOpticalFlow.t(), integer()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setPolyN(self, polyN) when is_integer(polyN)
  do
    positional = [
      polyN: Evision.Internal.Structurise.from_struct(polyN)
    ]
    :evision_nif.farnebackOpticalFlow_setPolyN(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPolySigma(Keyword.t()) :: any() | {:error, String.t()}
  def setPolySigma([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:polySigma])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setPolySigma()
    |> to_struct()
  end

  @doc """
  setPolySigma

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **polySigma**: `double`

  Python prototype (for reference only):
  ```python3
  setPolySigma(polySigma) -> None
  ```
  """
  @spec setPolySigma(Evision.FarnebackOpticalFlow.t(), number()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setPolySigma(self, polySigma) when is_number(polySigma)
  do
    positional = [
      polySigma: Evision.Internal.Structurise.from_struct(polySigma)
    ]
    :evision_nif.farnebackOpticalFlow_setPolySigma(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setPyrScale(Keyword.t()) :: any() | {:error, String.t()}
  def setPyrScale([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:pyrScale])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setPyrScale()
    |> to_struct()
  end

  @doc """
  setPyrScale

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **pyrScale**: `double`

  Python prototype (for reference only):
  ```python3
  setPyrScale(pyrScale) -> None
  ```
  """
  @spec setPyrScale(Evision.FarnebackOpticalFlow.t(), number()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setPyrScale(self, pyrScale) when is_number(pyrScale)
  do
    positional = [
      pyrScale: Evision.Internal.Structurise.from_struct(pyrScale)
    ]
    :evision_nif.farnebackOpticalFlow_setPyrScale(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setWinSize(Keyword.t()) :: any() | {:error, String.t()}
  def setWinSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:winSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.farnebackOpticalFlow_setWinSize()
    |> to_struct()
  end

  @doc """
  setWinSize

  ##### Positional Arguments
  - **self**: `Evision.FarnebackOpticalFlow.t()`
  - **winSize**: `integer()`

  Python prototype (for reference only):
  ```python3
  setWinSize(winSize) -> None
  ```
  """
  @spec setWinSize(Evision.FarnebackOpticalFlow.t(), integer()) :: Evision.FarnebackOpticalFlow.t() | {:error, String.t()}
  def setWinSize(self, winSize) when is_integer(winSize)
  do
    positional = [
      winSize: Evision.Internal.Structurise.from_struct(winSize)
    ]
    :evision_nif.farnebackOpticalFlow_setWinSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
