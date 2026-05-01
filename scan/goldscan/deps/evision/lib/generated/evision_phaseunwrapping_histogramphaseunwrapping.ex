defmodule Evision.PhaseUnwrapping.HistogramPhaseUnwrapping do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `PhaseUnwrapping.HistogramPhaseUnwrapping` struct.

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
  def to_struct({:ok, %{class: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping, ref: ref}) do
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
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_clear()
    |> to_struct()
  end
  @spec clear(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()) :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Constructor
  ##### Keyword Arguments
  - **parameters**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.Params`.

    HistogramPhaseUnwrapping parameters HistogramPhaseUnwrapping::Params: width,height of the phase map and histogram characteristics.

  ##### Return
  - **retval**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

  Python prototype (for reference only):
  ```python3
  create([, parameters]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:parameters])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_create_static()
    |> to_struct()
  end
  @spec create([{:parameters, term()}] | nil) :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:parameters])
    positional = [
    ]
    :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Constructor
  ##### Keyword Arguments
  - **parameters**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.Params`.

    HistogramPhaseUnwrapping parameters HistogramPhaseUnwrapping::Params: width,height of the phase map and histogram characteristics.

  ##### Return
  - **retval**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

  Python prototype (for reference only):
  ```python3
  create([, parameters]) -> retval
  ```
  """
  @spec create() :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

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
    |> :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_empty()
    |> to_struct()
  end
  @spec empty(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

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
    |> :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Get the reliability map computed from the wrapped phase map.

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

  ##### Return
  - **reliabilityMap**: `Evision.Mat.t()`.

    Image where the reliability map is stored.

  Python prototype (for reference only):
  ```python3
  getInverseReliabilityMap([, reliabilityMap]) -> reliabilityMap
  ```
  """
  @spec getInverseReliabilityMap(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def getInverseReliabilityMap(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_getInverseReliabilityMap(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Get the reliability map computed from the wrapped phase map.

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`

  ##### Return
  - **reliabilityMap**: `Evision.Mat.t()`.

    Image where the reliability map is stored.

  Python prototype (for reference only):
  ```python3
  getInverseReliabilityMap([, reliabilityMap]) -> reliabilityMap
  ```
  """
  @spec getInverseReliabilityMap(Keyword.t()) :: any() | {:error, String.t()}
  def getInverseReliabilityMap([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:reliabilityMap])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_getInverseReliabilityMap()
    |> to_struct()
  end
  @spec getInverseReliabilityMap(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getInverseReliabilityMap(self) do
    positional = [
    ]
    :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_getInverseReliabilityMap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), Evision.FileNode.t()) :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), binary()) :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Unwraps a 2D phase map.

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`
  - **wrappedPhaseMap**: `Evision.Mat`.

    The wrapped phase map of type CV_32FC1 that needs to be unwrapped.

  ##### Keyword Arguments
  - **shadowMask**: `Evision.Mat`.

    Optional CV_8UC1 mask image used when some pixels do not hold any phase information in the wrapped phase map.

  ##### Return
  - **unwrappedPhaseMap**: `Evision.Mat.t()`.

    The unwrapped phase map.

  Python prototype (for reference only):
  ```python3
  unwrapPhaseMap(wrappedPhaseMap[, unwrappedPhaseMap[, shadowMask]]) -> unwrappedPhaseMap
  ```
  """
  @spec unwrapPhaseMap(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), Evision.Mat.maybe_mat_in(), [{:shadowMask, term()}] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def unwrapPhaseMap(self, wrappedPhaseMap, opts) when (is_struct(wrappedPhaseMap, Evision.Mat) or is_struct(wrappedPhaseMap, Nx.Tensor) or is_number(wrappedPhaseMap) or is_tuple(wrappedPhaseMap)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:shadowMask])
    positional = [
      wrappedPhaseMap: Evision.Internal.Structurise.from_struct(wrappedPhaseMap)
    ]
    :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_unwrapPhaseMap(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec unwrapPhaseMap(Keyword.t()) :: any() | {:error, String.t()}
  def unwrapPhaseMap([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:unwrappedPhaseMap,:wrappedPhaseMap,:shadowMask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_unwrapPhaseMap()
    |> to_struct()
  end

  @doc """
  Unwraps a 2D phase map.

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`
  - **wrappedPhaseMap**: `Evision.Mat`.

    The wrapped phase map of type CV_32FC1 that needs to be unwrapped.

  ##### Keyword Arguments
  - **shadowMask**: `Evision.Mat`.

    Optional CV_8UC1 mask image used when some pixels do not hold any phase information in the wrapped phase map.

  ##### Return
  - **unwrappedPhaseMap**: `Evision.Mat.t()`.

    The unwrapped phase map.

  Python prototype (for reference only):
  ```python3
  unwrapPhaseMap(wrappedPhaseMap[, unwrappedPhaseMap[, shadowMask]]) -> unwrappedPhaseMap
  ```
  """
  @spec unwrapPhaseMap(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def unwrapPhaseMap(self, wrappedPhaseMap) when (is_struct(wrappedPhaseMap, Evision.Mat) or is_struct(wrappedPhaseMap, Nx.Tensor) or is_number(wrappedPhaseMap) or is_tuple(wrappedPhaseMap))
  do
    positional = [
      wrappedPhaseMap: Evision.Internal.Structurise.from_struct(wrappedPhaseMap)
    ]
    :evision_nif.phase_unwrapping_phase_unwrapping_HistogramPhaseUnwrapping_unwrapPhaseMap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), Evision.FileStorage.t(), binary()) :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t(), Evision.FileStorage.t()) :: Evision.PhaseUnwrapping.HistogramPhaseUnwrapping.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.phase_unwrapping_HistogramPhaseUnwrapping_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
