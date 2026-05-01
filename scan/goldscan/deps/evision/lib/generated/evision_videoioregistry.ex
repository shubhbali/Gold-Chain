defmodule Evision.VideoIORegistry do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `VideoIORegistry` struct.

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
  def to_struct({:ok, %{class: Evision.VideoIORegistry, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.VideoIORegistry, ref: ref}) do
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
  Returns backend API name or "UnknownVideoAPI(xxx)"

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`.

    backend ID (#VideoCaptureAPIs)

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  getBackendName(api) -> retval
  ```
  """
  @spec getBackendName(Keyword.t()) :: any() | {:error, String.t()}
  def getBackendName([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:api])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getBackendName()
    |> to_struct()
  end
  @spec getBackendName(Evision.VideoCaptureAPIs.enum()) :: binary() | {:error, String.t()}
  def getBackendName(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_getBackendName(positional)
    |> to_struct()
  end
  @spec getBackends(Keyword.t()) :: any() | {:error, String.t()}
  def getBackends([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getBackends()
    |> to_struct()
  end

  @doc """
  Returns list of all available backends
  ##### Return
  - **retval**: `[VideoCaptureAPIs]`

  Python prototype (for reference only):
  ```python3
  getBackends() -> retval
  ```
  """
  @spec getBackends() :: list(Evision.VideoCaptureAPIs.enum()) | {:error, String.t()}
  def getBackends() do
    positional = [
    ]
    :evision_nif.videoio_registry_getBackends(positional)
    |> to_struct()
  end

  @doc """
  Returns description and ABI/API version of videoio plugin's camera interface

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`

  ##### Return
  - **retval**: `string`
  - **version_ABI**: `integer()`
  - **version_API**: `integer()`

  Python prototype (for reference only):
  ```python3
  getCameraBackendPluginVersion(api) -> retval, version_ABI, version_API
  ```
  """
  @spec getCameraBackendPluginVersion(Keyword.t()) :: any() | {:error, String.t()}
  def getCameraBackendPluginVersion([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:version_ABI,:api,:version_API])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getCameraBackendPluginVersion()
    |> to_struct()
  end
  @spec getCameraBackendPluginVersion(Evision.VideoCaptureAPIs.enum()) :: {binary(), integer(), integer()} | {:error, String.t()}
  def getCameraBackendPluginVersion(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_getCameraBackendPluginVersion(positional)
    |> to_struct()
  end
  @spec getCameraBackends(Keyword.t()) :: any() | {:error, String.t()}
  def getCameraBackends([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getCameraBackends()
    |> to_struct()
  end

  @doc """
  Returns list of available backends which works via `cv::VideoCapture(int index)`
  ##### Return
  - **retval**: `[VideoCaptureAPIs]`

  Python prototype (for reference only):
  ```python3
  getCameraBackends() -> retval
  ```
  """
  @spec getCameraBackends() :: list(Evision.VideoCaptureAPIs.enum()) | {:error, String.t()}
  def getCameraBackends() do
    positional = [
    ]
    :evision_nif.videoio_registry_getCameraBackends(positional)
    |> to_struct()
  end

  @doc """
  Returns description and ABI/API version of videoio plugin's stream capture interface

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`

  ##### Return
  - **retval**: `string`
  - **version_ABI**: `integer()`
  - **version_API**: `integer()`

  Python prototype (for reference only):
  ```python3
  getStreamBackendPluginVersion(api) -> retval, version_ABI, version_API
  ```
  """
  @spec getStreamBackendPluginVersion(Keyword.t()) :: any() | {:error, String.t()}
  def getStreamBackendPluginVersion([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:version_ABI,:api,:version_API])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getStreamBackendPluginVersion()
    |> to_struct()
  end
  @spec getStreamBackendPluginVersion(Evision.VideoCaptureAPIs.enum()) :: {binary(), integer(), integer()} | {:error, String.t()}
  def getStreamBackendPluginVersion(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_getStreamBackendPluginVersion(positional)
    |> to_struct()
  end
  @spec getStreamBackends(Keyword.t()) :: any() | {:error, String.t()}
  def getStreamBackends([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getStreamBackends()
    |> to_struct()
  end

  @doc """
  Returns list of available backends which works via `cv::VideoCapture(filename)`
  ##### Return
  - **retval**: `[VideoCaptureAPIs]`

  Python prototype (for reference only):
  ```python3
  getStreamBackends() -> retval
  ```
  """
  @spec getStreamBackends() :: list(Evision.VideoCaptureAPIs.enum()) | {:error, String.t()}
  def getStreamBackends() do
    positional = [
    ]
    :evision_nif.videoio_registry_getStreamBackends(positional)
    |> to_struct()
  end

  @doc """
  Returns description and ABI/API version of videoio plugin's buffer capture interface

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`

  ##### Return
  - **retval**: `string`
  - **version_ABI**: `integer()`
  - **version_API**: `integer()`

  Python prototype (for reference only):
  ```python3
  getStreamBufferedBackendPluginVersion(api) -> retval, version_ABI, version_API
  ```
  """
  @spec getStreamBufferedBackendPluginVersion(Keyword.t()) :: any() | {:error, String.t()}
  def getStreamBufferedBackendPluginVersion([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:version_ABI,:api,:version_API])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getStreamBufferedBackendPluginVersion()
    |> to_struct()
  end
  @spec getStreamBufferedBackendPluginVersion(Evision.VideoCaptureAPIs.enum()) :: {binary(), integer(), integer()} | {:error, String.t()}
  def getStreamBufferedBackendPluginVersion(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_getStreamBufferedBackendPluginVersion(positional)
    |> to_struct()
  end
  @spec getStreamBufferedBackends(Keyword.t()) :: any() | {:error, String.t()}
  def getStreamBufferedBackends([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getStreamBufferedBackends()
    |> to_struct()
  end

  @doc """
  Returns list of available backends which works via `cv::VideoCapture(buffer)`
  ##### Return
  - **retval**: `[VideoCaptureAPIs]`

  Python prototype (for reference only):
  ```python3
  getStreamBufferedBackends() -> retval
  ```
  """
  @spec getStreamBufferedBackends() :: list(Evision.VideoCaptureAPIs.enum()) | {:error, String.t()}
  def getStreamBufferedBackends() do
    positional = [
    ]
    :evision_nif.videoio_registry_getStreamBufferedBackends(positional)
    |> to_struct()
  end

  @doc """
  Returns description and ABI/API version of videoio plugin's writer interface

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`

  ##### Return
  - **retval**: `string`
  - **version_ABI**: `integer()`
  - **version_API**: `integer()`

  Python prototype (for reference only):
  ```python3
  getWriterBackendPluginVersion(api) -> retval, version_ABI, version_API
  ```
  """
  @spec getWriterBackendPluginVersion(Keyword.t()) :: any() | {:error, String.t()}
  def getWriterBackendPluginVersion([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:version_ABI,:api,:version_API])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getWriterBackendPluginVersion()
    |> to_struct()
  end
  @spec getWriterBackendPluginVersion(Evision.VideoCaptureAPIs.enum()) :: {binary(), integer(), integer()} | {:error, String.t()}
  def getWriterBackendPluginVersion(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_getWriterBackendPluginVersion(positional)
    |> to_struct()
  end
  @spec getWriterBackends(Keyword.t()) :: any() | {:error, String.t()}
  def getWriterBackends([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_getWriterBackends()
    |> to_struct()
  end

  @doc """
  Returns list of available backends which works via `cv::VideoWriter()`
  ##### Return
  - **retval**: `[VideoCaptureAPIs]`

  Python prototype (for reference only):
  ```python3
  getWriterBackends() -> retval
  ```
  """
  @spec getWriterBackends() :: list(Evision.VideoCaptureAPIs.enum()) | {:error, String.t()}
  def getWriterBackends() do
    positional = [
    ]
    :evision_nif.videoio_registry_getWriterBackends(positional)
    |> to_struct()
  end

  @doc """
  Returns true if backend is available

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  hasBackend(api) -> retval
  ```
  """
  @spec hasBackend(Keyword.t()) :: any() | {:error, String.t()}
  def hasBackend([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:api])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_hasBackend()
    |> to_struct()
  end
  @spec hasBackend(Evision.VideoCaptureAPIs.enum()) :: boolean() | {:error, String.t()}
  def hasBackend(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_hasBackend(positional)
    |> to_struct()
  end

  @doc """
  Returns true if backend is built in (false if backend is used as plugin)

  ##### Positional Arguments
  - **api**: `VideoCaptureAPIs`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  isBackendBuiltIn(api) -> retval
  ```
  """
  @spec isBackendBuiltIn(Keyword.t()) :: any() | {:error, String.t()}
  def isBackendBuiltIn([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:api])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.videoio_registry_isBackendBuiltIn()
    |> to_struct()
  end
  @spec isBackendBuiltIn(Evision.VideoCaptureAPIs.enum()) :: boolean() | {:error, String.t()}
  def isBackendBuiltIn(api) when is_integer(api)
  do
    positional = [
      api: Evision.Internal.Structurise.from_struct(api)
    ]
    :evision_nif.videoio_registry_isBackendBuiltIn(positional)
    |> to_struct()
  end
end
