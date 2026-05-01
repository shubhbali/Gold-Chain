defmodule Evision.ImgHash.ColorMomentHash do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `ImgHash.ColorMomentHash` struct.

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
  def to_struct({:ok, %{class: Evision.ImgHash.ColorMomentHash, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.ImgHash.ColorMomentHash, ref: ref}) do
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
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_ColorMomentHash_clear()
    |> to_struct()
  end
  @spec clear(Evision.ImgHash.ColorMomentHash.t()) :: Evision.ImgHash.ColorMomentHash.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.img_hash_ColorMomentHash_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec compare(Keyword.t()) :: any() | {:error, String.t()}
  def compare([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:hashTwo,:hashOne])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_img_hash_ColorMomentHash_compare()
    |> to_struct()
  end

  @doc """
  Compare the hash value between inOne and inTwo

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **hashOne**: `Evision.Mat`.

    Hash value one

  - **hashTwo**: `Evision.Mat`.

    Hash value two

  ##### Return
  - **retval**: `double`

  @return value indicate similarity between inOne and inTwo, the meaning
  of the value vary from algorithms to algorithms

  Python prototype (for reference only):
  ```python3
  compare(hashOne, hashTwo) -> retval
  ```
  """
  @spec compare(Evision.ImgHash.ColorMomentHash.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: number() | {:error, String.t()}
  def compare(self, hashOne, hashTwo) when (is_struct(hashOne, Evision.Mat) or is_struct(hashOne, Nx.Tensor) or is_number(hashOne) or is_tuple(hashOne)) and (is_struct(hashTwo, Evision.Mat) or is_struct(hashTwo, Nx.Tensor) or is_number(hashTwo) or is_tuple(hashTwo))
  do
    positional = [
      hashOne: Evision.Internal.Structurise.from_struct(hashOne),
      hashTwo: Evision.Internal.Structurise.from_struct(hashTwo)
    ]
    :evision_nif.img_hash_img_hash_ColorMomentHash_compare(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Computes hash of the input image

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **inputArr**: `Evision.Mat`.

    input image want to compute hash value

  ##### Return
  - **outputArr**: `Evision.Mat.t()`.

    hash of the image

  Python prototype (for reference only):
  ```python3
  compute(inputArr[, outputArr]) -> outputArr
  ```
  """
  @spec compute(Evision.ImgHash.ColorMomentHash.t(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def compute(self, inputArr, opts) when (is_struct(inputArr, Evision.Mat) or is_struct(inputArr, Nx.Tensor) or is_number(inputArr) or is_tuple(inputArr)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      inputArr: Evision.Internal.Structurise.from_struct(inputArr)
    ]
    :evision_nif.img_hash_img_hash_ColorMomentHash_compute(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec compute(Keyword.t()) :: any() | {:error, String.t()}
  def compute([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:outputArr,:inputArr])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_img_hash_ColorMomentHash_compute()
    |> to_struct()
  end

  @doc """
  Computes hash of the input image

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **inputArr**: `Evision.Mat`.

    input image want to compute hash value

  ##### Return
  - **outputArr**: `Evision.Mat.t()`.

    hash of the image

  Python prototype (for reference only):
  ```python3
  compute(inputArr[, outputArr]) -> outputArr
  ```
  """
  @spec compute(Evision.ImgHash.ColorMomentHash.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def compute(self, inputArr) when (is_struct(inputArr, Evision.Mat) or is_struct(inputArr, Nx.Tensor) or is_number(inputArr) or is_tuple(inputArr))
  do
    positional = [
      inputArr: Evision.Internal.Structurise.from_struct(inputArr)
    ]
    :evision_nif.img_hash_img_hash_ColorMomentHash_compute(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_img_hash_ColorMomentHash_create_static()
    |> to_struct()
  end

  @doc """
  create
  ##### Return
  - **retval**: `Evision.ImgHash.ColorMomentHash.t()`

  Python prototype (for reference only):
  ```python3
  create() -> retval
  ```
  """
  @spec create() :: Evision.ImgHash.ColorMomentHash.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.img_hash_img_hash_ColorMomentHash_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`

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
    |> :evision_nif.img_hash_ColorMomentHash_empty()
    |> to_struct()
  end
  @spec empty(Evision.ImgHash.ColorMomentHash.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.img_hash_ColorMomentHash_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`

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
    |> :evision_nif.img_hash_ColorMomentHash_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.ImgHash.ColorMomentHash.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.img_hash_ColorMomentHash_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_ColorMomentHash_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.ImgHash.ColorMomentHash.t(), Evision.FileNode.t()) :: Evision.ImgHash.ColorMomentHash.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.img_hash_ColorMomentHash_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_ColorMomentHash_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.ImgHash.ColorMomentHash.t(), binary()) :: Evision.ImgHash.ColorMomentHash.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.img_hash_ColorMomentHash_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.img_hash_ColorMomentHash_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.ImgHash.ColorMomentHash.t(), Evision.FileStorage.t(), binary()) :: Evision.ImgHash.ColorMomentHash.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.img_hash_ColorMomentHash_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.ImgHash.ColorMomentHash.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.ImgHash.ColorMomentHash.t(), Evision.FileStorage.t()) :: Evision.ImgHash.ColorMomentHash.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.img_hash_ColorMomentHash_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
