defmodule Evision.Rapid.Rapid do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Rapid.Rapid` struct.

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
  def to_struct({:ok, %{class: Evision.Rapid.Rapid, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Rapid.Rapid, ref: ref}) do
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
  - **self**: `Evision.Rapid.Rapid.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_Rapid_clear()
    |> to_struct()
  end
  @spec clear(Evision.Rapid.Rapid.t()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.rapid_Rapid_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  clearState

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`

  Python prototype (for reference only):
  ```python3
  clearState() -> None
  ```
  """
  @spec clearState(Keyword.t()) :: any() | {:error, String.t()}
  def clearState([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_rapid_Rapid_clearState()
    |> to_struct()
  end
  @spec clearState(Evision.Rapid.Rapid.t()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def clearState(self) do
    positional = [
    ]
    :evision_nif.rapid_rapid_Rapid_clearState(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  compute

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`
  - **img**: `Evision.Mat`
  - **num**: `integer()`
  - **len**: `integer()`
  - **k**: `Evision.Mat`

  ##### Keyword Arguments
  - **termcrit**: `TermCriteria`.

  ##### Return
  - **retval**: `float`
  - **rvec**: `Evision.Mat.t()`
  - **tvec**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  compute(img, num, len, K, rvec, tvec[, termcrit]) -> retval, rvec, tvec
  ```
  """
  @spec compute(Evision.Rapid.Rapid.t(), Evision.Mat.maybe_mat_in(), integer(), integer(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{:termcrit, term()}] | nil) :: {number(), Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def compute(self, img, num, len, k, rvec, tvec, opts) when (is_struct(img, Evision.Mat) or is_struct(img, Nx.Tensor) or is_number(img) or is_tuple(img)) and is_integer(num) and is_integer(len) and (is_struct(k, Evision.Mat) or is_struct(k, Nx.Tensor) or is_number(k) or is_tuple(k)) and (is_struct(rvec, Evision.Mat) or is_struct(rvec, Nx.Tensor) or is_number(rvec) or is_tuple(rvec)) and (is_struct(tvec, Evision.Mat) or is_struct(tvec, Nx.Tensor) or is_number(tvec) or is_tuple(tvec)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:termcrit])
    positional = [
      img: Evision.Internal.Structurise.from_struct(img),
      num: Evision.Internal.Structurise.from_struct(num),
      len: Evision.Internal.Structurise.from_struct(len),
      k: Evision.Internal.Structurise.from_struct(k),
      rvec: Evision.Internal.Structurise.from_struct(rvec),
      tvec: Evision.Internal.Structurise.from_struct(tvec)
    ]
    :evision_nif.rapid_rapid_Rapid_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Keyword.t()) :: any() | {:error, String.t()}
  def compute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:num,:img,:K,:termcrit,:len,:tvec,:rvec])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_rapid_Rapid_compute()
    |> to_struct()
  end

  @doc """
  compute

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`
  - **img**: `Evision.Mat`
  - **num**: `integer()`
  - **len**: `integer()`
  - **k**: `Evision.Mat`

  ##### Keyword Arguments
  - **termcrit**: `TermCriteria`.

  ##### Return
  - **retval**: `float`
  - **rvec**: `Evision.Mat.t()`
  - **tvec**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  compute(img, num, len, K, rvec, tvec[, termcrit]) -> retval, rvec, tvec
  ```
  """
  @spec compute(Evision.Rapid.Rapid.t(), Evision.Mat.maybe_mat_in(), integer(), integer(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {number(), Evision.Mat.t(), Evision.Mat.t()} | {:error, String.t()}
  def compute(self, img, num, len, k, rvec, tvec) when (is_struct(img, Evision.Mat) or is_struct(img, Nx.Tensor) or is_number(img) or is_tuple(img)) and is_integer(num) and is_integer(len) and (is_struct(k, Evision.Mat) or is_struct(k, Nx.Tensor) or is_number(k) or is_tuple(k)) and (is_struct(rvec, Evision.Mat) or is_struct(rvec, Nx.Tensor) or is_number(rvec) or is_tuple(rvec)) and (is_struct(tvec, Evision.Mat) or is_struct(tvec, Nx.Tensor) or is_number(tvec) or is_tuple(tvec))
  do
    positional = [
      img: Evision.Internal.Structurise.from_struct(img),
      num: Evision.Internal.Structurise.from_struct(num),
      len: Evision.Internal.Structurise.from_struct(len),
      k: Evision.Internal.Structurise.from_struct(k),
      rvec: Evision.Internal.Structurise.from_struct(rvec),
      tvec: Evision.Internal.Structurise.from_struct(tvec)
    ]
    :evision_nif.rapid_rapid_Rapid_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:pts3d,:tris])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_rapid_Rapid_create_static()
    |> to_struct()
  end

  @doc """
  create

  ##### Positional Arguments
  - **pts3d**: `Evision.Mat`
  - **tris**: `Evision.Mat`

  ##### Return
  - **retval**: `Rapid`

  Python prototype (for reference only):
  ```python3
  create(pts3d, tris) -> retval
  ```
  """
  @spec create(Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def create(pts3d, tris) when (is_struct(pts3d, Evision.Mat) or is_struct(pts3d, Nx.Tensor) or is_number(pts3d) or is_tuple(pts3d)) and (is_struct(tris, Evision.Mat) or is_struct(tris, Nx.Tensor) or is_number(tris) or is_tuple(tris))
  do
    positional = [
      pts3d: Evision.Internal.Structurise.from_struct(pts3d),
      tris: Evision.Internal.Structurise.from_struct(tris)
    ]
    :evision_nif.rapid_rapid_Rapid_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`

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
    |> :evision_nif.rapid_Rapid_empty()
    |> to_struct()
  end
  @spec empty(Evision.Rapid.Rapid.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.rapid_Rapid_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`

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
    |> :evision_nif.rapid_Rapid_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.Rapid.Rapid.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.rapid_Rapid_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_Rapid_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.Rapid.Rapid.t(), Evision.FileNode.t()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.rapid_Rapid_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_Rapid_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.Rapid.Rapid.t(), binary()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.rapid_Rapid_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.rapid_Rapid_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.Rapid.Rapid.t(), Evision.FileStorage.t(), binary()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.rapid_Rapid_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.Rapid.Rapid.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.Rapid.Rapid.t(), Evision.FileStorage.t()) :: Evision.Rapid.Rapid.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.rapid_Rapid_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
