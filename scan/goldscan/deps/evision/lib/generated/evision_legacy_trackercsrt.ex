defmodule Evision.Legacy.TrackerCSRT do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Legacy.TrackerCSRT` struct.

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
  def to_struct({:ok, %{class: Evision.Legacy.TrackerCSRT, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Legacy.TrackerCSRT, ref: ref}) do
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
  - **self**: `Evision.Legacy.TrackerCSRT.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_TrackerCSRT_clear()
    |> to_struct()
  end
  @spec clear(Evision.Legacy.TrackerCSRT.t()) :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.legacy_TrackerCSRT_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_legacy_TrackerCSRT_create_static()
    |> to_struct()
  end

  @doc """
  Constructor
  ##### Return
  - **retval**: `legacy::TrackerCSRT`

  Python prototype (for reference only):
  ```python3
  create() -> retval
  ```
  """
  @spec create() :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def create() do
    positional = [
    ]
    :evision_nif.legacy_legacy_TrackerCSRT_create_static(positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`

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
    |> :evision_nif.legacy_TrackerCSRT_empty()
    |> to_struct()
  end
  @spec empty(Evision.Legacy.TrackerCSRT.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.legacy_TrackerCSRT_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`

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
    |> :evision_nif.legacy_TrackerCSRT_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.Legacy.TrackerCSRT.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.legacy_TrackerCSRT_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec init(Keyword.t()) :: any() | {:error, String.t()}
  def init([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:boundingBox,:image])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_legacy_TrackerCSRT_init()
    |> to_struct()
  end

  @doc """
  Initialize the tracker with a known bounding box that surrounded the target

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **image**: `Evision.Mat`.

    The initial frame

  - **boundingBox**: `Rect2d`.

    The initial bounding box

  ##### Return
  - **retval**: `bool`

  @return True if initialization went succesfully, false otherwise

  Python prototype (for reference only):
  ```python3
  init(image, boundingBox) -> retval
  ```
  """
  @spec init(Evision.Legacy.TrackerCSRT.t(), Evision.Mat.maybe_mat_in(), {number(), number(), number(), number()}) :: boolean() | {:error, String.t()}
  def init(self, image, boundingBox) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and is_tuple(boundingBox)
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      boundingBox: Evision.Internal.Structurise.from_struct(boundingBox)
    ]
    :evision_nif.legacy_legacy_TrackerCSRT_init(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_TrackerCSRT_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.Legacy.TrackerCSRT.t(), Evision.FileNode.t()) :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.legacy_TrackerCSRT_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_TrackerCSRT_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.Legacy.TrackerCSRT.t(), binary()) :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.legacy_TrackerCSRT_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setInitialMask(Keyword.t()) :: any() | {:error, String.t()}
  def setInitialMask([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:mask])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_legacy_TrackerCSRT_setInitialMask()
    |> to_struct()
  end

  @doc """
  setInitialMask

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **mask**: `Evision.Mat`

  Python prototype (for reference only):
  ```python3
  setInitialMask(mask) -> None
  ```
  """
  @spec setInitialMask(Evision.Legacy.TrackerCSRT.t(), Evision.Mat.maybe_mat_in()) :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def setInitialMask(self, mask) when (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask))
  do
    positional = [
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.legacy_legacy_TrackerCSRT_setInitialMask(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec update(Keyword.t()) :: any() | {:error, String.t()}
  def update([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:boundingBox,:image])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_legacy_TrackerCSRT_update()
    |> to_struct()
  end

  @doc """
  Update the tracker, find the new most likely bounding box for the target

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **image**: `Evision.Mat`.

    The current frame

  ##### Return
  - **retval**: `bool`
  - **boundingBox**: `Rect2d`.

    The bounding box that represent the new target location, if true was returned, not
    modified otherwise

  @return True means that target was located and false means that tracker cannot locate target in
  current frame. Note, that latter *does not* imply that tracker has failed, maybe target is indeed
  missing from the frame (say, out of sight)

  Python prototype (for reference only):
  ```python3
  update(image) -> retval, boundingBox
  ```
  """
  @spec update(Evision.Legacy.TrackerCSRT.t(), Evision.Mat.maybe_mat_in()) :: {number(), number(), number(), number()} | false | {:error, String.t()}
  def update(self, image) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image)
    ]
    :evision_nif.legacy_legacy_TrackerCSRT_update(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.legacy_TrackerCSRT_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.Legacy.TrackerCSRT.t(), Evision.FileStorage.t(), binary()) :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.legacy_TrackerCSRT_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.Legacy.TrackerCSRT.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.Legacy.TrackerCSRT.t(), Evision.FileStorage.t()) :: Evision.Legacy.TrackerCSRT.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.legacy_TrackerCSRT_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
