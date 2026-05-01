defmodule Evision.HistogramCostExtractor do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `HistogramCostExtractor` struct.

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
  def to_struct({:ok, %{class: Evision.HistogramCostExtractor, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.HistogramCostExtractor, ref: ref}) do
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
  buildCostMatrix

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **descriptors1**: `Evision.Mat`
  - **descriptors2**: `Evision.Mat`

  ##### Return
  - **costMatrix**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  buildCostMatrix(descriptors1, descriptors2[, costMatrix]) -> costMatrix
  ```
  """
  @spec buildCostMatrix(Evision.HistogramCostExtractor.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def buildCostMatrix(self, descriptors1, descriptors2, opts) when (is_struct(descriptors1, Evision.Mat) or is_struct(descriptors1, Nx.Tensor) or is_number(descriptors1) or is_tuple(descriptors1)) and (is_struct(descriptors2, Evision.Mat) or is_struct(descriptors2, Nx.Tensor) or is_number(descriptors2) or is_tuple(descriptors2)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      descriptors1: Evision.Internal.Structurise.from_struct(descriptors1),
      descriptors2: Evision.Internal.Structurise.from_struct(descriptors2)
    ]
    :evision_nif.histogramCostExtractor_buildCostMatrix(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec buildCostMatrix(Keyword.t()) :: any() | {:error, String.t()}
  def buildCostMatrix([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:descriptors2,:descriptors1,:costMatrix])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_buildCostMatrix()
    |> to_struct()
  end

  @doc """
  buildCostMatrix

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **descriptors1**: `Evision.Mat`
  - **descriptors2**: `Evision.Mat`

  ##### Return
  - **costMatrix**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  buildCostMatrix(descriptors1, descriptors2[, costMatrix]) -> costMatrix
  ```
  """
  @spec buildCostMatrix(Evision.HistogramCostExtractor.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def buildCostMatrix(self, descriptors1, descriptors2) when (is_struct(descriptors1, Evision.Mat) or is_struct(descriptors1, Nx.Tensor) or is_number(descriptors1) or is_tuple(descriptors1)) and (is_struct(descriptors2, Evision.Mat) or is_struct(descriptors2, Nx.Tensor) or is_number(descriptors2) or is_tuple(descriptors2))
  do
    positional = [
      descriptors1: Evision.Internal.Structurise.from_struct(descriptors1),
      descriptors2: Evision.Internal.Structurise.from_struct(descriptors2)
    ]
    :evision_nif.histogramCostExtractor_buildCostMatrix(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_clear()
    |> to_struct()
  end
  @spec clear(Evision.HistogramCostExtractor.t()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.histogramCostExtractor_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  empty() -> retval
  ```
  """
  @spec empty(Keyword.t()) :: any() | {:error, String.t()}
  def empty([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_empty()
    |> to_struct()
  end
  @spec empty(Evision.HistogramCostExtractor.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.histogramCostExtractor_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultCost

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getDefaultCost() -> retval
  ```
  """
  @spec getDefaultCost(Keyword.t()) :: any() | {:error, String.t()}
  def getDefaultCost([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_getDefaultCost()
    |> to_struct()
  end
  @spec getDefaultCost(Evision.HistogramCostExtractor.t()) :: number() | {:error, String.t()}
  def getDefaultCost(self) do
    positional = [
    ]
    :evision_nif.histogramCostExtractor_getDefaultCost(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`

  ##### Return
  - **retval**: `String`

  Returns the algorithm string identifier.
  This string is used as top level xml/yml node tag when the object is saved to a file or string.

  Python prototype (for reference only):
  ```python3
  getDefaultName() -> retval
  ```
  """
  @spec getDefaultName(Keyword.t()) :: any() | {:error, String.t()}
  def getDefaultName([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.HistogramCostExtractor.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.histogramCostExtractor_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNDummies

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNDummies() -> retval
  ```
  """
  @spec getNDummies(Keyword.t()) :: any() | {:error, String.t()}
  def getNDummies([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_getNDummies()
    |> to_struct()
  end
  @spec getNDummies(Evision.HistogramCostExtractor.t()) :: integer() | {:error, String.t()}
  def getNDummies(self) do
    positional = [
    ]
    :evision_nif.histogramCostExtractor_getNDummies(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.HistogramCostExtractor.t(), Evision.FileNode.t()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.histogramCostExtractor_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.HistogramCostExtractor.t(), binary()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.histogramCostExtractor_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setDefaultCost(Keyword.t()) :: any() | {:error, String.t()}
  def setDefaultCost([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:defaultCost])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_setDefaultCost()
    |> to_struct()
  end

  @doc """
  setDefaultCost

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **defaultCost**: `float`

  Python prototype (for reference only):
  ```python3
  setDefaultCost(defaultCost) -> None
  ```
  """
  @spec setDefaultCost(Evision.HistogramCostExtractor.t(), number()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def setDefaultCost(self, defaultCost) when is_float(defaultCost)
  do
    positional = [
      defaultCost: Evision.Internal.Structurise.from_struct(defaultCost)
    ]
    :evision_nif.histogramCostExtractor_setDefaultCost(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNDummies(Keyword.t()) :: any() | {:error, String.t()}
  def setNDummies([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nDummies])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_setNDummies()
    |> to_struct()
  end

  @doc """
  setNDummies

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **nDummies**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNDummies(nDummies) -> None
  ```
  """
  @spec setNDummies(Evision.HistogramCostExtractor.t(), integer()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def setNDummies(self, nDummies) when is_integer(nDummies)
  do
    positional = [
      nDummies: Evision.Internal.Structurise.from_struct(nDummies)
    ]
    :evision_nif.histogramCostExtractor_setNDummies(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.histogramCostExtractor_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.HistogramCostExtractor.t(), Evision.FileStorage.t(), binary()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.histogramCostExtractor_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.HistogramCostExtractor.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.HistogramCostExtractor.t(), Evision.FileStorage.t()) :: Evision.HistogramCostExtractor.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.histogramCostExtractor_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
