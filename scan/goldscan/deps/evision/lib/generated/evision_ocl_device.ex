defmodule Evision.OCL.Device do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `OCL.Device` struct.

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
  def to_struct({:ok, %{class: Evision.OCL.Device, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.OCL.Device, ref: ref}) do
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
  import Bitwise

  @type enum :: integer()
  @doc enum: true
  def cv_TYPE_DEFAULT, do: bsl(1, 0)
  @doc enum: true
  def cv_TYPE_CPU, do: bsl(1, 1)
  @doc enum: true
  def cv_TYPE_GPU, do: bsl(1, 2)
  @doc enum: true
  def cv_TYPE_ACCELERATOR, do: bsl(1, 3)
  @doc enum: true
  def cv_TYPE_DGPU, do: (cv_TYPE_GPU() + bsl(1, 16))
  @doc enum: true
  def cv_TYPE_IGPU, do: (cv_TYPE_GPU() + bsl(1, 17))
  @doc enum: true
  def cv_TYPE_ALL, do: 4294967295
  @doc enum: true
  def cv_FP_DENORM, do: bsl(1, 0)
  @doc enum: true
  def cv_FP_INF_NAN, do: bsl(1, 1)
  @doc enum: true
  def cv_FP_ROUND_TO_NEAREST, do: bsl(1, 2)
  @doc enum: true
  def cv_FP_ROUND_TO_ZERO, do: bsl(1, 3)
  @doc enum: true
  def cv_FP_ROUND_TO_INF, do: bsl(1, 4)
  @doc enum: true
  def cv_FP_FMA, do: bsl(1, 5)
  @doc enum: true
  def cv_FP_SOFT_FLOAT, do: bsl(1, 6)
  @doc enum: true
  def cv_FP_CORRECTLY_ROUNDED_DIVIDE_SQRT, do: bsl(1, 7)
  @doc enum: true
  def cv_EXEC_KERNEL, do: bsl(1, 0)
  @doc enum: true
  def cv_EXEC_NATIVE_KERNEL, do: bsl(1, 1)
  @doc enum: true
  def cv_NO_CACHE, do: 0
  @doc enum: true
  def cv_READ_ONLY_CACHE, do: 1
  @doc enum: true
  def cv_READ_WRITE_CACHE, do: 2
  @doc enum: true
  def cv_NO_LOCAL_MEM, do: 0
  @doc enum: true
  def cv_LOCAL_IS_LOCAL, do: 1
  @doc enum: true
  def cv_LOCAL_IS_GLOBAL, do: 2
  @doc enum: true
  def cv_UNKNOWN_VENDOR, do: 0
  @doc enum: true
  def cv_VENDOR_AMD, do: 1
  @doc enum: true
  def cv_VENDOR_INTEL, do: 2
  @doc enum: true
  def cv_VENDOR_NVIDIA, do: 3

  @spec device(Keyword.t()) :: any() | {:error, String.t()}
  def device([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_Device()
    |> to_struct()
  end

  @doc """
  Device
  ##### Return
  - **self**: `Evision.OCL.Device.t()`

  Python prototype (for reference only):
  ```python3
  Device() -> <ocl_Device object>
  ```
  """
  @spec device() :: Evision.OCL.Device.t() | {:error, String.t()}
  def device() do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_Device(positional)
    |> to_struct()
  end

  @doc """
  OpenCLVersion

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  OpenCLVersion() -> retval
  ```
  """
  @spec openCLVersion(Keyword.t()) :: any() | {:error, String.t()}
  def openCLVersion([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_OpenCLVersion()
    |> to_struct()
  end
  @spec openCLVersion(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def openCLVersion(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_OpenCLVersion(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  OpenCL_C_Version

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  OpenCL_C_Version() -> retval
  ```
  """
  @spec openCL_C_Version(Keyword.t()) :: any() | {:error, String.t()}
  def openCL_C_Version([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_OpenCL_C_Version()
    |> to_struct()
  end
  @spec openCL_C_Version(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def openCL_C_Version(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_OpenCL_C_Version(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  addressBits

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  addressBits() -> retval
  ```
  """
  @spec addressBits(Keyword.t()) :: any() | {:error, String.t()}
  def addressBits([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_addressBits()
    |> to_struct()
  end
  @spec addressBits(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def addressBits(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_addressBits(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  available

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  available() -> retval
  ```
  """
  @spec available(Keyword.t()) :: any() | {:error, String.t()}
  def available([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_available()
    |> to_struct()
  end
  @spec available(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def available(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_available(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  compilerAvailable

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  compilerAvailable() -> retval
  ```
  """
  @spec compilerAvailable(Keyword.t()) :: any() | {:error, String.t()}
  def compilerAvailable([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_compilerAvailable()
    |> to_struct()
  end
  @spec compilerAvailable(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def compilerAvailable(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_compilerAvailable(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  deviceVersionMajor

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  deviceVersionMajor() -> retval
  ```
  """
  @spec deviceVersionMajor(Keyword.t()) :: any() | {:error, String.t()}
  def deviceVersionMajor([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_deviceVersionMajor()
    |> to_struct()
  end
  @spec deviceVersionMajor(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def deviceVersionMajor(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_deviceVersionMajor(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  deviceVersionMinor

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  deviceVersionMinor() -> retval
  ```
  """
  @spec deviceVersionMinor(Keyword.t()) :: any() | {:error, String.t()}
  def deviceVersionMinor([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_deviceVersionMinor()
    |> to_struct()
  end
  @spec deviceVersionMinor(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def deviceVersionMinor(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_deviceVersionMinor(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  doubleFPConfig

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  doubleFPConfig() -> retval
  ```
  """
  @spec doubleFPConfig(Keyword.t()) :: any() | {:error, String.t()}
  def doubleFPConfig([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_doubleFPConfig()
    |> to_struct()
  end
  @spec doubleFPConfig(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def doubleFPConfig(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_doubleFPConfig(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  driverVersion

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  driverVersion() -> retval
  ```
  """
  @spec driverVersion(Keyword.t()) :: any() | {:error, String.t()}
  def driverVersion([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_driverVersion()
    |> to_struct()
  end
  @spec driverVersion(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def driverVersion(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_driverVersion(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  endianLittle

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  endianLittle() -> retval
  ```
  """
  @spec endianLittle(Keyword.t()) :: any() | {:error, String.t()}
  def endianLittle([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_endianLittle()
    |> to_struct()
  end
  @spec endianLittle(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def endianLittle(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_endianLittle(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  errorCorrectionSupport

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  errorCorrectionSupport() -> retval
  ```
  """
  @spec errorCorrectionSupport(Keyword.t()) :: any() | {:error, String.t()}
  def errorCorrectionSupport([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_errorCorrectionSupport()
    |> to_struct()
  end
  @spec errorCorrectionSupport(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def errorCorrectionSupport(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_errorCorrectionSupport(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  executionCapabilities

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  executionCapabilities() -> retval
  ```
  """
  @spec executionCapabilities(Keyword.t()) :: any() | {:error, String.t()}
  def executionCapabilities([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_executionCapabilities()
    |> to_struct()
  end
  @spec executionCapabilities(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def executionCapabilities(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_executionCapabilities(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  extensions

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  extensions() -> retval
  ```
  """
  @spec extensions(Keyword.t()) :: any() | {:error, String.t()}
  def extensions([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_extensions()
    |> to_struct()
  end
  @spec extensions(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def extensions(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_extensions(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec getDefault(Keyword.t()) :: any() | {:error, String.t()}
  def getDefault([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_getDefault_static()
    |> to_struct()
  end

  @doc """
  getDefault
  ##### Return
  - **retval**: `Evision.OCL.Device.t()`

  Python prototype (for reference only):
  ```python3
  getDefault() -> retval
  ```
  """
  @spec getDefault() :: Evision.OCL.Device.t() | {:error, String.t()}
  def getDefault() do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_getDefault_static(positional)
    |> to_struct()
  end

  @doc """
  globalMemCacheLineSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  globalMemCacheLineSize() -> retval
  ```
  """
  @spec globalMemCacheLineSize(Keyword.t()) :: any() | {:error, String.t()}
  def globalMemCacheLineSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_globalMemCacheLineSize()
    |> to_struct()
  end
  @spec globalMemCacheLineSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def globalMemCacheLineSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_globalMemCacheLineSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  globalMemCacheSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  globalMemCacheSize() -> retval
  ```
  """
  @spec globalMemCacheSize(Keyword.t()) :: any() | {:error, String.t()}
  def globalMemCacheSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_globalMemCacheSize()
    |> to_struct()
  end
  @spec globalMemCacheSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def globalMemCacheSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_globalMemCacheSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  globalMemCacheType

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  globalMemCacheType() -> retval
  ```
  """
  @spec globalMemCacheType(Keyword.t()) :: any() | {:error, String.t()}
  def globalMemCacheType([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_globalMemCacheType()
    |> to_struct()
  end
  @spec globalMemCacheType(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def globalMemCacheType(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_globalMemCacheType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  globalMemSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  globalMemSize() -> retval
  ```
  """
  @spec globalMemSize(Keyword.t()) :: any() | {:error, String.t()}
  def globalMemSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_globalMemSize()
    |> to_struct()
  end
  @spec globalMemSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def globalMemSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_globalMemSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  halfFPConfig

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  halfFPConfig() -> retval
  ```
  """
  @spec halfFPConfig(Keyword.t()) :: any() | {:error, String.t()}
  def halfFPConfig([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_halfFPConfig()
    |> to_struct()
  end
  @spec halfFPConfig(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def halfFPConfig(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_halfFPConfig(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  hasFP16

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  hasFP16() -> retval
  ```
  """
  @spec hasFP16(Keyword.t()) :: any() | {:error, String.t()}
  def hasFP16([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_hasFP16()
    |> to_struct()
  end
  @spec hasFP16(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def hasFP16(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_hasFP16(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  hasFP64

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  hasFP64() -> retval
  ```
  """
  @spec hasFP64(Keyword.t()) :: any() | {:error, String.t()}
  def hasFP64([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_hasFP64()
    |> to_struct()
  end
  @spec hasFP64(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def hasFP64(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_hasFP64(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  hostUnifiedMemory

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  hostUnifiedMemory() -> retval
  ```
  """
  @spec hostUnifiedMemory(Keyword.t()) :: any() | {:error, String.t()}
  def hostUnifiedMemory([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_hostUnifiedMemory()
    |> to_struct()
  end
  @spec hostUnifiedMemory(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def hostUnifiedMemory(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_hostUnifiedMemory(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  image2DMaxHeight

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  image2DMaxHeight() -> retval
  ```
  """
  @spec image2DMaxHeight(Keyword.t()) :: any() | {:error, String.t()}
  def image2DMaxHeight([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_image2DMaxHeight()
    |> to_struct()
  end
  @spec image2DMaxHeight(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def image2DMaxHeight(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_image2DMaxHeight(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  image2DMaxWidth

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  image2DMaxWidth() -> retval
  ```
  """
  @spec image2DMaxWidth(Keyword.t()) :: any() | {:error, String.t()}
  def image2DMaxWidth([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_image2DMaxWidth()
    |> to_struct()
  end
  @spec image2DMaxWidth(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def image2DMaxWidth(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_image2DMaxWidth(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  image3DMaxDepth

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  image3DMaxDepth() -> retval
  ```
  """
  @spec image3DMaxDepth(Keyword.t()) :: any() | {:error, String.t()}
  def image3DMaxDepth([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_image3DMaxDepth()
    |> to_struct()
  end
  @spec image3DMaxDepth(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def image3DMaxDepth(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_image3DMaxDepth(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  image3DMaxHeight

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  image3DMaxHeight() -> retval
  ```
  """
  @spec image3DMaxHeight(Keyword.t()) :: any() | {:error, String.t()}
  def image3DMaxHeight([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_image3DMaxHeight()
    |> to_struct()
  end
  @spec image3DMaxHeight(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def image3DMaxHeight(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_image3DMaxHeight(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  image3DMaxWidth

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  image3DMaxWidth() -> retval
  ```
  """
  @spec image3DMaxWidth(Keyword.t()) :: any() | {:error, String.t()}
  def image3DMaxWidth([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_image3DMaxWidth()
    |> to_struct()
  end
  @spec image3DMaxWidth(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def image3DMaxWidth(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_image3DMaxWidth(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  imageFromBufferSupport

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  imageFromBufferSupport() -> retval
  ```
  """
  @spec imageFromBufferSupport(Keyword.t()) :: any() | {:error, String.t()}
  def imageFromBufferSupport([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_imageFromBufferSupport()
    |> to_struct()
  end
  @spec imageFromBufferSupport(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def imageFromBufferSupport(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_imageFromBufferSupport(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  imageMaxArraySize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  imageMaxArraySize() -> retval
  ```
  """
  @spec imageMaxArraySize(Keyword.t()) :: any() | {:error, String.t()}
  def imageMaxArraySize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_imageMaxArraySize()
    |> to_struct()
  end
  @spec imageMaxArraySize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def imageMaxArraySize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_imageMaxArraySize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  imageMaxBufferSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  imageMaxBufferSize() -> retval
  ```
  """
  @spec imageMaxBufferSize(Keyword.t()) :: any() | {:error, String.t()}
  def imageMaxBufferSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_imageMaxBufferSize()
    |> to_struct()
  end
  @spec imageMaxBufferSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def imageMaxBufferSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_imageMaxBufferSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  imageSupport

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  imageSupport() -> retval
  ```
  """
  @spec imageSupport(Keyword.t()) :: any() | {:error, String.t()}
  def imageSupport([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_imageSupport()
    |> to_struct()
  end
  @spec imageSupport(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def imageSupport(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_imageSupport(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  intelSubgroupsSupport

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  intelSubgroupsSupport() -> retval
  ```
  """
  @spec intelSubgroupsSupport(Keyword.t()) :: any() | {:error, String.t()}
  def intelSubgroupsSupport([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_intelSubgroupsSupport()
    |> to_struct()
  end
  @spec intelSubgroupsSupport(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def intelSubgroupsSupport(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_intelSubgroupsSupport(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  isAMD

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  isAMD() -> retval
  ```
  """
  @spec isAMD(Keyword.t()) :: any() | {:error, String.t()}
  def isAMD([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_isAMD()
    |> to_struct()
  end
  @spec isAMD(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def isAMD(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_isAMD(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec isExtensionSupported(Keyword.t()) :: any() | {:error, String.t()}
  def isExtensionSupported([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:extensionName])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_isExtensionSupported()
    |> to_struct()
  end

  @doc """
  isExtensionSupported

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`
  - **extensionName**: `String`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  isExtensionSupported(extensionName) -> retval
  ```
  """
  @spec isExtensionSupported(Evision.OCL.Device.t(), binary()) :: boolean() | {:error, String.t()}
  def isExtensionSupported(self, extensionName) when is_binary(extensionName)
  do
    positional = [
      extensionName: Evision.Internal.Structurise.from_struct(extensionName)
    ]
    :evision_nif.ocl_ocl_Device_isExtensionSupported(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  isIntel

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  isIntel() -> retval
  ```
  """
  @spec isIntel(Keyword.t()) :: any() | {:error, String.t()}
  def isIntel([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_isIntel()
    |> to_struct()
  end
  @spec isIntel(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def isIntel(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_isIntel(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  isNVidia

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  isNVidia() -> retval
  ```
  """
  @spec isNVidia(Keyword.t()) :: any() | {:error, String.t()}
  def isNVidia([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_isNVidia()
    |> to_struct()
  end
  @spec isNVidia(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def isNVidia(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_isNVidia(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  linkerAvailable

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  linkerAvailable() -> retval
  ```
  """
  @spec linkerAvailable(Keyword.t()) :: any() | {:error, String.t()}
  def linkerAvailable([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_linkerAvailable()
    |> to_struct()
  end
  @spec linkerAvailable(Evision.OCL.Device.t()) :: boolean() | {:error, String.t()}
  def linkerAvailable(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_linkerAvailable(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  localMemSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  localMemSize() -> retval
  ```
  """
  @spec localMemSize(Keyword.t()) :: any() | {:error, String.t()}
  def localMemSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_localMemSize()
    |> to_struct()
  end
  @spec localMemSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def localMemSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_localMemSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  localMemType

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  localMemType() -> retval
  ```
  """
  @spec localMemType(Keyword.t()) :: any() | {:error, String.t()}
  def localMemType([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_localMemType()
    |> to_struct()
  end
  @spec localMemType(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def localMemType(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_localMemType(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxClockFrequency

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxClockFrequency() -> retval
  ```
  """
  @spec maxClockFrequency(Keyword.t()) :: any() | {:error, String.t()}
  def maxClockFrequency([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxClockFrequency()
    |> to_struct()
  end
  @spec maxClockFrequency(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxClockFrequency(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxClockFrequency(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxComputeUnits

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxComputeUnits() -> retval
  ```
  """
  @spec maxComputeUnits(Keyword.t()) :: any() | {:error, String.t()}
  def maxComputeUnits([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxComputeUnits()
    |> to_struct()
  end
  @spec maxComputeUnits(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxComputeUnits(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxComputeUnits(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxConstantArgs

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxConstantArgs() -> retval
  ```
  """
  @spec maxConstantArgs(Keyword.t()) :: any() | {:error, String.t()}
  def maxConstantArgs([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxConstantArgs()
    |> to_struct()
  end
  @spec maxConstantArgs(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxConstantArgs(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxConstantArgs(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxConstantBufferSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  maxConstantBufferSize() -> retval
  ```
  """
  @spec maxConstantBufferSize(Keyword.t()) :: any() | {:error, String.t()}
  def maxConstantBufferSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxConstantBufferSize()
    |> to_struct()
  end
  @spec maxConstantBufferSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxConstantBufferSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxConstantBufferSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxMemAllocSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  maxMemAllocSize() -> retval
  ```
  """
  @spec maxMemAllocSize(Keyword.t()) :: any() | {:error, String.t()}
  def maxMemAllocSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxMemAllocSize()
    |> to_struct()
  end
  @spec maxMemAllocSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxMemAllocSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxMemAllocSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxParameterSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  maxParameterSize() -> retval
  ```
  """
  @spec maxParameterSize(Keyword.t()) :: any() | {:error, String.t()}
  def maxParameterSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxParameterSize()
    |> to_struct()
  end
  @spec maxParameterSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxParameterSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxParameterSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxReadImageArgs

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxReadImageArgs() -> retval
  ```
  """
  @spec maxReadImageArgs(Keyword.t()) :: any() | {:error, String.t()}
  def maxReadImageArgs([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxReadImageArgs()
    |> to_struct()
  end
  @spec maxReadImageArgs(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxReadImageArgs(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxReadImageArgs(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxSamplers

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxSamplers() -> retval
  ```
  """
  @spec maxSamplers(Keyword.t()) :: any() | {:error, String.t()}
  def maxSamplers([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxSamplers()
    |> to_struct()
  end
  @spec maxSamplers(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxSamplers(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxSamplers(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxWorkGroupSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  maxWorkGroupSize() -> retval
  ```
  """
  @spec maxWorkGroupSize(Keyword.t()) :: any() | {:error, String.t()}
  def maxWorkGroupSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxWorkGroupSize()
    |> to_struct()
  end
  @spec maxWorkGroupSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxWorkGroupSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxWorkGroupSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxWorkItemDims

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxWorkItemDims() -> retval
  ```
  """
  @spec maxWorkItemDims(Keyword.t()) :: any() | {:error, String.t()}
  def maxWorkItemDims([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxWorkItemDims()
    |> to_struct()
  end
  @spec maxWorkItemDims(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxWorkItemDims(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxWorkItemDims(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  maxWriteImageArgs

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  maxWriteImageArgs() -> retval
  ```
  """
  @spec maxWriteImageArgs(Keyword.t()) :: any() | {:error, String.t()}
  def maxWriteImageArgs([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_maxWriteImageArgs()
    |> to_struct()
  end
  @spec maxWriteImageArgs(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def maxWriteImageArgs(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_maxWriteImageArgs(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  memBaseAddrAlign

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  memBaseAddrAlign() -> retval
  ```
  """
  @spec memBaseAddrAlign(Keyword.t()) :: any() | {:error, String.t()}
  def memBaseAddrAlign([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_memBaseAddrAlign()
    |> to_struct()
  end
  @spec memBaseAddrAlign(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def memBaseAddrAlign(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_memBaseAddrAlign(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  name

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  name() -> retval
  ```
  """
  @spec name(Keyword.t()) :: any() | {:error, String.t()}
  def name([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_name()
    |> to_struct()
  end
  @spec name(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def name(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_name(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthChar

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthChar() -> retval
  ```
  """
  @spec nativeVectorWidthChar(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthChar([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthChar()
    |> to_struct()
  end
  @spec nativeVectorWidthChar(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthChar(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthChar(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthDouble

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthDouble() -> retval
  ```
  """
  @spec nativeVectorWidthDouble(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthDouble([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthDouble()
    |> to_struct()
  end
  @spec nativeVectorWidthDouble(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthDouble(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthDouble(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthFloat

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthFloat() -> retval
  ```
  """
  @spec nativeVectorWidthFloat(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthFloat([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthFloat()
    |> to_struct()
  end
  @spec nativeVectorWidthFloat(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthFloat(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthFloat(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthHalf

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthHalf() -> retval
  ```
  """
  @spec nativeVectorWidthHalf(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthHalf([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthHalf()
    |> to_struct()
  end
  @spec nativeVectorWidthHalf(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthHalf(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthHalf(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthInt

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthInt() -> retval
  ```
  """
  @spec nativeVectorWidthInt(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthInt([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthInt()
    |> to_struct()
  end
  @spec nativeVectorWidthInt(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthInt(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthInt(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthLong

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthLong() -> retval
  ```
  """
  @spec nativeVectorWidthLong(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthLong([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthLong()
    |> to_struct()
  end
  @spec nativeVectorWidthLong(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthLong(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthLong(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  nativeVectorWidthShort

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  nativeVectorWidthShort() -> retval
  ```
  """
  @spec nativeVectorWidthShort(Keyword.t()) :: any() | {:error, String.t()}
  def nativeVectorWidthShort([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_nativeVectorWidthShort()
    |> to_struct()
  end
  @spec nativeVectorWidthShort(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def nativeVectorWidthShort(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_nativeVectorWidthShort(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthChar

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthChar() -> retval
  ```
  """
  @spec preferredVectorWidthChar(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthChar([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthChar()
    |> to_struct()
  end
  @spec preferredVectorWidthChar(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthChar(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthChar(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthDouble

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthDouble() -> retval
  ```
  """
  @spec preferredVectorWidthDouble(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthDouble([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthDouble()
    |> to_struct()
  end
  @spec preferredVectorWidthDouble(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthDouble(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthDouble(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthFloat

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthFloat() -> retval
  ```
  """
  @spec preferredVectorWidthFloat(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthFloat([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthFloat()
    |> to_struct()
  end
  @spec preferredVectorWidthFloat(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthFloat(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthFloat(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthHalf

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthHalf() -> retval
  ```
  """
  @spec preferredVectorWidthHalf(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthHalf([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthHalf()
    |> to_struct()
  end
  @spec preferredVectorWidthHalf(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthHalf(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthHalf(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthInt

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthInt() -> retval
  ```
  """
  @spec preferredVectorWidthInt(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthInt([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthInt()
    |> to_struct()
  end
  @spec preferredVectorWidthInt(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthInt(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthInt(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthLong

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthLong() -> retval
  ```
  """
  @spec preferredVectorWidthLong(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthLong([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthLong()
    |> to_struct()
  end
  @spec preferredVectorWidthLong(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthLong(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthLong(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  preferredVectorWidthShort

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  preferredVectorWidthShort() -> retval
  ```
  """
  @spec preferredVectorWidthShort(Keyword.t()) :: any() | {:error, String.t()}
  def preferredVectorWidthShort([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_preferredVectorWidthShort()
    |> to_struct()
  end
  @spec preferredVectorWidthShort(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def preferredVectorWidthShort(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_preferredVectorWidthShort(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  printfBufferSize

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  printfBufferSize() -> retval
  ```
  """
  @spec printfBufferSize(Keyword.t()) :: any() | {:error, String.t()}
  def printfBufferSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_printfBufferSize()
    |> to_struct()
  end
  @spec printfBufferSize(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def printfBufferSize(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_printfBufferSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  profilingTimerResolution

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  profilingTimerResolution() -> retval
  ```
  """
  @spec profilingTimerResolution(Keyword.t()) :: any() | {:error, String.t()}
  def profilingTimerResolution([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_profilingTimerResolution()
    |> to_struct()
  end
  @spec profilingTimerResolution(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def profilingTimerResolution(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_profilingTimerResolution(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  singleFPConfig

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  singleFPConfig() -> retval
  ```
  """
  @spec singleFPConfig(Keyword.t()) :: any() | {:error, String.t()}
  def singleFPConfig([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_singleFPConfig()
    |> to_struct()
  end
  @spec singleFPConfig(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def singleFPConfig(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_singleFPConfig(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  type

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  type() -> retval
  ```
  """
  @spec type(Keyword.t()) :: any() | {:error, String.t()}
  def type([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_type()
    |> to_struct()
  end
  @spec type(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def type(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_type(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  vendorID

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  vendorID() -> retval
  ```
  """
  @spec vendorID(Keyword.t()) :: any() | {:error, String.t()}
  def vendorID([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_vendorID()
    |> to_struct()
  end
  @spec vendorID(Evision.OCL.Device.t()) :: integer() | {:error, String.t()}
  def vendorID(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_vendorID(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  vendorName

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  vendorName() -> retval
  ```
  """
  @spec vendorName(Keyword.t()) :: any() | {:error, String.t()}
  def vendorName([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_vendorName()
    |> to_struct()
  end
  @spec vendorName(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def vendorName(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_vendorName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  version

  ##### Positional Arguments
  - **self**: `Evision.OCL.Device.t()`

  ##### Return
  - **retval**: `String`

  Python prototype (for reference only):
  ```python3
  version() -> retval
  ```
  """
  @spec version(Keyword.t()) :: any() | {:error, String.t()}
  def version([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_ocl_Device_version()
    |> to_struct()
  end
  @spec version(Evision.OCL.Device.t()) :: binary() | {:error, String.t()}
  def version(self) do
    positional = [
    ]
    :evision_nif.ocl_ocl_Device_version(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
