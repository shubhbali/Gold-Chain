defmodule Evision.MCC.CChecker do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `MCC.CChecker` struct.

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
  def to_struct({:ok, %{class: Evision.MCC.CChecker, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.MCC.CChecker, ref: ref}) do
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
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_create_static()
    |> to_struct()
  end

  @doc """
  create
  ##### Return
  - **retval**: `CChecker`

  \\brief Create a new CChecker object.
   \\return A pointer to the implementation of the CChecker

  Python prototype (for reference only):
  ```python3
  create() -> retval
  ```
  """
  @spec create() :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_create_static(positional)
    |> to_struct()
  end

  @doc """
  getBox

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `[Point2f]`

  Python prototype (for reference only):
  ```python3
  getBox() -> retval
  ```
  """
  @spec getBox(Keyword.t()) :: any() | {:error, String.t()}
  def getBox([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getBox()
    |> to_struct()
  end
  @spec getBox(Evision.MCC.CChecker.t()) :: list({number(), number()}) | {:error, String.t()}
  def getBox(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getBox(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getCenter

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `Point2f`

  Python prototype (for reference only):
  ```python3
  getCenter() -> retval
  ```
  """
  @spec getCenter(Keyword.t()) :: any() | {:error, String.t()}
  def getCenter([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getCenter()
    |> to_struct()
  end
  @spec getCenter(Evision.MCC.CChecker.t()) :: {number(), number()} | {:error, String.t()}
  def getCenter(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getCenter(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getChartsRGB

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  getChartsRGB() -> retval
  ```
  """
  @spec getChartsRGB(Keyword.t()) :: any() | {:error, String.t()}
  def getChartsRGB([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getChartsRGB()
    |> to_struct()
  end
  @spec getChartsRGB(Evision.MCC.CChecker.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getChartsRGB(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getChartsRGB(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getChartsYCbCr

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  getChartsYCbCr() -> retval
  ```
  """
  @spec getChartsYCbCr(Keyword.t()) :: any() | {:error, String.t()}
  def getChartsYCbCr([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getChartsYCbCr()
    |> to_struct()
  end
  @spec getChartsYCbCr(Evision.MCC.CChecker.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getChartsYCbCr(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getChartsYCbCr(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Computes and returns the coordinates of the central parts of the charts modules.

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `[Point2f]`

   This method computes transformation matrix from the checkers's coordinates (`cv::mcc::CChecker::getBox()`)
   and find by this the coordinates of the central parts of the charts modules.
   It is used in `cv::mcc::CCheckerDraw::draw()` and in `ChartsRGB` calculation.

  Python prototype (for reference only):
  ```python3
  getColorCharts() -> retval
  ```
  """
  @spec getColorCharts(Keyword.t()) :: any() | {:error, String.t()}
  def getColorCharts([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getColorCharts()
    |> to_struct()
  end
  @spec getColorCharts(Evision.MCC.CChecker.t()) :: list({number(), number()}) | {:error, String.t()}
  def getColorCharts(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getColorCharts(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getCost

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getCost() -> retval
  ```
  """
  @spec getCost(Keyword.t()) :: any() | {:error, String.t()}
  def getCost([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getCost()
    |> to_struct()
  end
  @spec getCost(Evision.MCC.CChecker.t()) :: number() | {:error, String.t()}
  def getCost(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getCost(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTarget

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`

  ##### Return
  - **retval**: `TYPECHART`

  Python prototype (for reference only):
  ```python3
  getTarget() -> retval
  ```
  """
  @spec getTarget(Keyword.t()) :: any() | {:error, String.t()}
  def getTarget([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_getTarget()
    |> to_struct()
  end
  @spec getTarget(Evision.MCC.CChecker.t()) :: Evision.MCC.TYPECHART.enum() | {:error, String.t()}
  def getTarget(self) do
    positional = [
    ]
    :evision_nif.mcc_mcc_CChecker_getTarget(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setBox(Keyword.t()) :: any() | {:error, String.t()}
  def setBox([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_box])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_setBox()
    |> to_struct()
  end

  @doc """
  setBox

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`
  - **box**: `[Point2f]`

  Python prototype (for reference only):
  ```python3
  setBox(_box) -> None
  ```
  """
  @spec setBox(Evision.MCC.CChecker.t(), list({number(), number()})) :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def setBox(self, box) when is_list(box)
  do
    positional = [
      box: Evision.Internal.Structurise.from_struct(box)
    ]
    :evision_nif.mcc_mcc_CChecker_setBox(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setCenter(Keyword.t()) :: any() | {:error, String.t()}
  def setCenter([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_center])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_setCenter()
    |> to_struct()
  end

  @doc """
  setCenter

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`
  - **center**: `Point2f`

  Python prototype (for reference only):
  ```python3
  setCenter(_center) -> None
  ```
  """
  @spec setCenter(Evision.MCC.CChecker.t(), {number(), number()}) :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def setCenter(self, center) when is_tuple(center)
  do
    positional = [
      center: Evision.Internal.Structurise.from_struct(center)
    ]
    :evision_nif.mcc_mcc_CChecker_setCenter(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setChartsRGB(Keyword.t()) :: any() | {:error, String.t()}
  def setChartsRGB([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_chartsRGB])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_setChartsRGB()
    |> to_struct()
  end

  @doc """
  setChartsRGB

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`
  - **chartsRGB**: `Evision.Mat`

  Python prototype (for reference only):
  ```python3
  setChartsRGB(_chartsRGB) -> None
  ```
  """
  @spec setChartsRGB(Evision.MCC.CChecker.t(), Evision.Mat.maybe_mat_in()) :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def setChartsRGB(self, chartsRGB) when (is_struct(chartsRGB, Evision.Mat) or is_struct(chartsRGB, Nx.Tensor) or is_number(chartsRGB) or is_tuple(chartsRGB))
  do
    positional = [
      chartsRGB: Evision.Internal.Structurise.from_struct(chartsRGB)
    ]
    :evision_nif.mcc_mcc_CChecker_setChartsRGB(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setChartsYCbCr(Keyword.t()) :: any() | {:error, String.t()}
  def setChartsYCbCr([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_chartsYCbCr])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_setChartsYCbCr()
    |> to_struct()
  end

  @doc """
  setChartsYCbCr

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`
  - **chartsYCbCr**: `Evision.Mat`

  Python prototype (for reference only):
  ```python3
  setChartsYCbCr(_chartsYCbCr) -> None
  ```
  """
  @spec setChartsYCbCr(Evision.MCC.CChecker.t(), Evision.Mat.maybe_mat_in()) :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def setChartsYCbCr(self, chartsYCbCr) when (is_struct(chartsYCbCr, Evision.Mat) or is_struct(chartsYCbCr, Nx.Tensor) or is_number(chartsYCbCr) or is_tuple(chartsYCbCr))
  do
    positional = [
      chartsYCbCr: Evision.Internal.Structurise.from_struct(chartsYCbCr)
    ]
    :evision_nif.mcc_mcc_CChecker_setChartsYCbCr(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setCost(Keyword.t()) :: any() | {:error, String.t()}
  def setCost([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_cost])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_setCost()
    |> to_struct()
  end

  @doc """
  setCost

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`
  - **cost**: `float`

  Python prototype (for reference only):
  ```python3
  setCost(_cost) -> None
  ```
  """
  @spec setCost(Evision.MCC.CChecker.t(), number()) :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def setCost(self, cost) when is_float(cost)
  do
    positional = [
      cost: Evision.Internal.Structurise.from_struct(cost)
    ]
    :evision_nif.mcc_mcc_CChecker_setCost(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setTarget(Keyword.t()) :: any() | {:error, String.t()}
  def setTarget([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:_target])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.mcc_mcc_CChecker_setTarget()
    |> to_struct()
  end

  @doc """
  setTarget

  ##### Positional Arguments
  - **self**: `Evision.MCC.CChecker.t()`
  - **target**: `TYPECHART`

  Python prototype (for reference only):
  ```python3
  setTarget(_target) -> None
  ```
  """
  @spec setTarget(Evision.MCC.CChecker.t(), Evision.MCC.TYPECHART.enum()) :: Evision.MCC.CChecker.t() | {:error, String.t()}
  def setTarget(self, target) when is_integer(target)
  do
    positional = [
      target: Evision.Internal.Structurise.from_struct(target)
    ]
    :evision_nif.mcc_mcc_CChecker_setTarget(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
