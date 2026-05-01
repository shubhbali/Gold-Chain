defmodule Evision.SparsePyrLKOpticalFlow do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `SparsePyrLKOpticalFlow` struct.

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
  def to_struct({:ok, %{class: Evision.SparsePyrLKOpticalFlow, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.SparsePyrLKOpticalFlow, ref: ref}) do
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
  Calculates a sparse optical flow.

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **prevImg**: `Evision.Mat`.

    First input image.

  - **nextImg**: `Evision.Mat`.

    Second input image of the same size and the same type as prevImg.

  - **prevPts**: `Evision.Mat`.

    Vector of 2D points for which the flow needs to be found.

  ##### Return
  - **nextPts**: `Evision.Mat.t()`.

    Output vector of 2D points containing the calculated new positions of input features in the second image.

  - **status**: `Evision.Mat.t()`.

    Output status vector. Each element of the vector is set to 1 if the
    flow for the corresponding features has been found. Otherwise, it is set to 0.

  - **err**: `Evision.Mat.t()`.

    Optional output vector that contains error response for each point (inverse confidence).

  Python prototype (for reference only):
  ```python3
  calc(prevImg, nextImg, prevPts, nextPts[, status[, err]]) -> nextPts, status, err
  ```
  """
  @spec calc(Evision.SparsePyrLKOpticalFlow.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: {Evision.Mat.t(), Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def calc(self, prevImg, nextImg, prevPts, nextPts, opts) when (is_struct(prevImg, Evision.Mat) or is_struct(prevImg, Nx.Tensor) or is_number(prevImg) or is_tuple(prevImg)) and (is_struct(nextImg, Evision.Mat) or is_struct(nextImg, Nx.Tensor) or is_number(nextImg) or is_tuple(nextImg)) and (is_struct(prevPts, Evision.Mat) or is_struct(prevPts, Nx.Tensor) or is_number(prevPts) or is_tuple(prevPts)) and (is_struct(nextPts, Evision.Mat) or is_struct(nextPts, Nx.Tensor) or is_number(nextPts) or is_tuple(nextPts)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      prevImg: Evision.Internal.Structurise.from_struct(prevImg),
      nextImg: Evision.Internal.Structurise.from_struct(nextImg),
      prevPts: Evision.Internal.Structurise.from_struct(prevPts),
      nextPts: Evision.Internal.Structurise.from_struct(nextPts)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_calc(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec calc(Keyword.t()) :: any() | {:error, String.t()}
  def calc([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:err,:status,:prevImg,:nextImg,:nextPts,:prevPts])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_calc()
    |> to_struct()
  end

  @doc """
  Calculates a sparse optical flow.

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **prevImg**: `Evision.Mat`.

    First input image.

  - **nextImg**: `Evision.Mat`.

    Second input image of the same size and the same type as prevImg.

  - **prevPts**: `Evision.Mat`.

    Vector of 2D points for which the flow needs to be found.

  ##### Return
  - **nextPts**: `Evision.Mat.t()`.

    Output vector of 2D points containing the calculated new positions of input features in the second image.

  - **status**: `Evision.Mat.t()`.

    Output status vector. Each element of the vector is set to 1 if the
    flow for the corresponding features has been found. Otherwise, it is set to 0.

  - **err**: `Evision.Mat.t()`.

    Optional output vector that contains error response for each point (inverse confidence).

  Python prototype (for reference only):
  ```python3
  calc(prevImg, nextImg, prevPts, nextPts[, status[, err]]) -> nextPts, status, err
  ```
  """
  @spec calc(Evision.SparsePyrLKOpticalFlow.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {Evision.Mat.t(), Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def calc(self, prevImg, nextImg, prevPts, nextPts) when (is_struct(prevImg, Evision.Mat) or is_struct(prevImg, Nx.Tensor) or is_number(prevImg) or is_tuple(prevImg)) and (is_struct(nextImg, Evision.Mat) or is_struct(nextImg, Nx.Tensor) or is_number(nextImg) or is_tuple(nextImg)) and (is_struct(prevPts, Evision.Mat) or is_struct(prevPts, Nx.Tensor) or is_number(prevPts) or is_tuple(prevPts)) and (is_struct(nextPts, Evision.Mat) or is_struct(nextPts, Nx.Tensor) or is_number(nextPts) or is_tuple(nextPts))
  do
    positional = [
      prevImg: Evision.Internal.Structurise.from_struct(prevImg),
      nextImg: Evision.Internal.Structurise.from_struct(nextImg),
      prevPts: Evision.Internal.Structurise.from_struct(prevPts),
      nextPts: Evision.Internal.Structurise.from_struct(nextPts)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_calc(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Clears the algorithm state

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_clear()
    |> to_struct()
  end
  @spec clear(Evision.SparsePyrLKOpticalFlow.t()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  create
  ##### Keyword Arguments
  - **winSize**: `Size`.
  - **maxLevel**: `integer()`.
  - **crit**: `TermCriteria`.
  - **flags**: `integer()`.
  - **minEigThreshold**: `double`.

  ##### Return
  - **retval**: `Evision.SparsePyrLKOpticalFlow.t()`

  Python prototype (for reference only):
  ```python3
  create([, winSize[, maxLevel[, crit[, flags[, minEigThreshold]]]]]) -> retval
  ```
  """
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:maxLevel,:flags,:minEigThreshold,:crit,:winSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_create_static()
    |> to_struct()
  end
  @spec create([{:crit, term()} | {:flags, term()} | {:maxLevel, term()} | {:minEigThreshold, term()} | {:winSize, term()}] | nil) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def create(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:crit, :flags, :maxLevel, :minEigThreshold, :winSize])
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_create_static(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  create
  ##### Keyword Arguments
  - **winSize**: `Size`.
  - **maxLevel**: `integer()`.
  - **crit**: `TermCriteria`.
  - **flags**: `integer()`.
  - **minEigThreshold**: `double`.

  ##### Return
  - **retval**: `Evision.SparsePyrLKOpticalFlow.t()`

  Python prototype (for reference only):
  ```python3
  create([, winSize[, maxLevel[, crit[, flags[, minEigThreshold]]]]]) -> retval
  ```
  """
  @spec create() :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

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
    |> :evision_nif.sparsePyrLKOpticalFlow_empty()
    |> to_struct()
  end
  @spec empty(Evision.SparsePyrLKOpticalFlow.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

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
    |> :evision_nif.sparsePyrLKOpticalFlow_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.SparsePyrLKOpticalFlow.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getFlags

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

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
    |> :evision_nif.sparsePyrLKOpticalFlow_getFlags()
    |> to_struct()
  end
  @spec getFlags(Evision.SparsePyrLKOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getFlags(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_getFlags(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMaxLevel

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMaxLevel() -> retval
  ```
  """
  @spec getMaxLevel(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxLevel([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_getMaxLevel()
    |> to_struct()
  end
  @spec getMaxLevel(Evision.SparsePyrLKOpticalFlow.t()) :: integer() | {:error, String.t()}
  def getMaxLevel(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_getMaxLevel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMinEigThreshold

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getMinEigThreshold() -> retval
  ```
  """
  @spec getMinEigThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getMinEigThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_getMinEigThreshold()
    |> to_struct()
  end
  @spec getMinEigThreshold(Evision.SparsePyrLKOpticalFlow.t()) :: number() | {:error, String.t()}
  def getMinEigThreshold(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_getMinEigThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTermCriteria

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

  ##### Return
  - **retval**: `TermCriteria`

  Python prototype (for reference only):
  ```python3
  getTermCriteria() -> retval
  ```
  """
  @spec getTermCriteria(Keyword.t()) :: any() | {:error, String.t()}
  def getTermCriteria([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_getTermCriteria()
    |> to_struct()
  end
  @spec getTermCriteria(Evision.SparsePyrLKOpticalFlow.t()) :: {integer(), integer(), number()} | {:error, String.t()}
  def getTermCriteria(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_getTermCriteria(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getWinSize

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`

  ##### Return
  - **retval**: `Size`

  Python prototype (for reference only):
  ```python3
  getWinSize() -> retval
  ```
  """
  @spec getWinSize(Keyword.t()) :: any() | {:error, String.t()}
  def getWinSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_getWinSize()
    |> to_struct()
  end
  @spec getWinSize(Evision.SparsePyrLKOpticalFlow.t()) :: {number(), number()} | {:error, String.t()}
  def getWinSize(self) do
    positional = [
    ]
    :evision_nif.sparsePyrLKOpticalFlow_getWinSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.SparsePyrLKOpticalFlow.t(), Evision.FileNode.t()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.SparsePyrLKOpticalFlow.t(), binary()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setFlags(Keyword.t()) :: any() | {:error, String.t()}
  def setFlags([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:flags])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_setFlags()
    |> to_struct()
  end

  @doc """
  setFlags

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **flags**: `integer()`

  Python prototype (for reference only):
  ```python3
  setFlags(flags) -> None
  ```
  """
  @spec setFlags(Evision.SparsePyrLKOpticalFlow.t(), integer()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def setFlags(self, flags) when is_integer(flags)
  do
    positional = [
      flags: Evision.Internal.Structurise.from_struct(flags)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_setFlags(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxLevel(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxLevel([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:maxLevel])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_setMaxLevel()
    |> to_struct()
  end

  @doc """
  setMaxLevel

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **maxLevel**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMaxLevel(maxLevel) -> None
  ```
  """
  @spec setMaxLevel(Evision.SparsePyrLKOpticalFlow.t(), integer()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def setMaxLevel(self, maxLevel) when is_integer(maxLevel)
  do
    positional = [
      maxLevel: Evision.Internal.Structurise.from_struct(maxLevel)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_setMaxLevel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinEigThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setMinEigThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:minEigThreshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_setMinEigThreshold()
    |> to_struct()
  end

  @doc """
  setMinEigThreshold

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **minEigThreshold**: `double`

  Python prototype (for reference only):
  ```python3
  setMinEigThreshold(minEigThreshold) -> None
  ```
  """
  @spec setMinEigThreshold(Evision.SparsePyrLKOpticalFlow.t(), number()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def setMinEigThreshold(self, minEigThreshold) when is_number(minEigThreshold)
  do
    positional = [
      minEigThreshold: Evision.Internal.Structurise.from_struct(minEigThreshold)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_setMinEigThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setTermCriteria(Keyword.t()) :: any() | {:error, String.t()}
  def setTermCriteria([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:crit])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_setTermCriteria()
    |> to_struct()
  end

  @doc """
  setTermCriteria

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **crit**: `TermCriteria`

  Python prototype (for reference only):
  ```python3
  setTermCriteria(crit) -> None
  ```
  """
  @spec setTermCriteria(Evision.SparsePyrLKOpticalFlow.t(), {integer(), integer(), number()}) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def setTermCriteria(self, crit) when is_tuple(crit)
  do
    positional = [
      crit: Evision.Internal.Structurise.from_struct(crit)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_setTermCriteria(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setWinSize(Keyword.t()) :: any() | {:error, String.t()}
  def setWinSize([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:winSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_setWinSize()
    |> to_struct()
  end

  @doc """
  setWinSize

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **winSize**: `Size`

  Python prototype (for reference only):
  ```python3
  setWinSize(winSize) -> None
  ```
  """
  @spec setWinSize(Evision.SparsePyrLKOpticalFlow.t(), {number(), number()}) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def setWinSize(self, winSize) when is_tuple(winSize)
  do
    positional = [
      winSize: Evision.Internal.Structurise.from_struct(winSize)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_setWinSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.sparsePyrLKOpticalFlow_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.SparsePyrLKOpticalFlow.t(), Evision.FileStorage.t(), binary()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.SparsePyrLKOpticalFlow.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.SparsePyrLKOpticalFlow.t(), Evision.FileStorage.t()) :: Evision.SparsePyrLKOpticalFlow.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.sparsePyrLKOpticalFlow_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
