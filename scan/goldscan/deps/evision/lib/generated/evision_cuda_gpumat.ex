defmodule Evision.CUDA.GpuMat do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Evision.CUDA.GpuMat` struct.

  - **channels**: `int`.

    The number of matrix channels.

  - **type**: `Evision.Mat.mat_type()`.

    Type of the matrix elements, following `:nx`'s convention.

  - **raw_type**: `int`.

    The raw value returned from `int cv::Mat::type()`.

  - **shape**: `tuple`.

    The shape of the matrix.
  
  - **elemSize**: `integer()`.

    Element size in bytes.
    
  - **step**: `integer()`.

    Number of bytes between two consecutive rows.
    
    When there are no gaps between successive rows, the value of `step` 
    is equal to the number of columns times the element size.
    
  - **device_id**: `integer() | nil`.
  
    `nil` if currently there's no GPU memory allocated for the GpuMat resource.

  - **ref**: `reference`.

    The underlying erlang resource variable.

  """
  @type t :: %__MODULE__{
    channels: integer(),
    type: Evision.Mat.mat_type(),
    raw_type: integer(),
    shape: tuple(),
    elemSize: integer(),
    step: integer(),
    device_id: integer() | nil,
    ref: reference()
  }
  @enforce_keys [:channels, :type, :raw_type, :shape, :elemSize, :step, :device_id, :ref]
  defstruct [:channels, :type, :raw_type, :shape, :elemSize, :step, :device_id, :ref]
  alias __MODULE__, as: T

  @doc false
  def to_struct(%{
        :class => Evision.CUDA.GpuMat,
        :channels => channels,
        :type => type,
        :raw_type => raw_type,
        :shape => shape,
        :step => step,
        :device_id => device_id,
        :elemSize => elemSize,
        :ref => ref
      }) do
    %T{
      channels: channels,
      type: type,
      raw_type: raw_type,
      shape: shape,
      step: step,
      device_id: device_id,
      elemSize: elemSize,
      ref: ref
    }
  end

  @doc false
  def to_struct({:ok, mat = %{:class => Evision.CUDA.GpuMat}}) do
    {:ok, to_struct(mat)}
  end

  @doc false
  def to_struct(pass_through) do
    Evision.Internal.Structurise.to_struct(pass_through)
  end

  @doc """
  Get raw pointers
  
  ##### Positional Arguments

  - **self**. `Evision.CUDA.GpuMat.t()`
  
  ##### Keyword Arguments

  - **mode**, one of `:local`, `:cuda_ipc`.
  
    - `:local`: Get a local CUDA pointer that can be used within current OS process.
    - `:cuda_ipc`: Get a CUDA IPC pointer that can be used across OS processes.
    - `:host_ipc`: Get a host IPC pointer that can be used across OS processes.
  
    Defaults to `:local`.
  """
  @spec to_pointer(Evision.CUDA.GpuMat.t()) :: {:ok, %Evision.IPCHandle.Local{}} | {:error, String.t()}
  def to_pointer(%{ref: ref}) do
    with {:ok, {handle, step, rows, cols, channels, type, device_id}} <- :evision_nif.cuda_cuda_GpuMat_to_pointer(img: ref, mode: :local) do
      {:ok, %Evision.IPCHandle.Local{
        handle: handle,
        step: step,
        rows: rows,
        cols: cols,
        channels: channels,
        type: type,
        device_id: device_id
      }}
    end
  end

  @spec to_pointer(Evision.CUDA.GpuMat.t(), [mode: :local | :cuda_ipc | :host_ipc]) :: 
    {:ok, %Evision.IPCHandle.Local{} | %Evision.IPCHandle.CUDA{} | %Evision.IPCHandle.Host{}} | {:error, String.t()}
  def to_pointer(%{ref: ref}, [mode: mode] = opts)
  when is_list(opts) and mode in [:local, :cuda_ipc, :host_ipc] do
    opts = Keyword.validate!(opts || [], [mode: :local])
    with {:ok, handle} <- :evision_nif.cuda_cuda_GpuMat_to_pointer([img: ref] ++ opts) do
      mode = opts[:mode]
      case {mode, handle} do
        {:local, {handle, step, rows, cols, channels, type, device_id}} ->
          {:ok, %Evision.IPCHandle.Local{
            handle: handle,
            step: step,
            rows: rows,
            cols: cols,
            channels: channels,
            type: type,
            device_id: device_id
          }}
        {:cuda_ipc, {handle, step, rows, cols, channels, type, device_id}} ->
          {:ok, %Evision.IPCHandle.CUDA{
            handle: handle,
            step: step,
            rows: rows,
            cols: cols,
            channels: channels,
            type: type,
            device_id: device_id
          }}
        {:host_ipc, {name, fd, size, rows, cols, channels, type}} ->
          {:ok, %Evision.IPCHandle.Host{
            name: name,
            fd: fd,
            size: size,
            rows: rows,
            cols: cols,
            channels: channels,
            type: type
          }}
      end
    end
  end

  defp compact_type(type) when is_atom(type), do: type
  defp compact_type({:s, 8}), do: :s8
  defp compact_type({:u, 8}), do: :u8
  defp compact_type({:s, 16}), do: :s16
  defp compact_type({:u, 16}), do: :u16
  defp compact_type({:s, 32}), do: :s32
  defp compact_type({:u, 32}), do: :u32
  defp compact_type({:s, 64}), do: :s64
  defp compact_type({:u, 64}), do: :u64
  defp compact_type({:f, 16}), do: :f16
  defp compact_type({:f, 32}), do: :f32
  defp compact_type({:f, 64}), do: :f64
  
  defp dtype_byte_size(:s8), do: 1
  defp dtype_byte_size(:u8), do: 1
  defp dtype_byte_size(:s16), do: 2
  defp dtype_byte_size(:u16), do: 2
  defp dtype_byte_size(:s32), do: 4
  defp dtype_byte_size(:u32), do: 4
  defp dtype_byte_size(:s64), do: 8
  defp dtype_byte_size(:u64), do: 8
  defp dtype_byte_size(:f16), do: 2
  defp dtype_byte_size(:f32), do: 4
  defp dtype_byte_size(:f64), do: 8
  defp dtype_byte_size(dtype) do
    raise ArgumentError, "Unsupported data type: #{inspect(dtype)}"
  end

  @doc """
  Create CUDA GpuMat from a shared CUDA device pointer with new shape
  
  ##### Positional Arguments

  - **handle**, either an `%Evision.IPCHandle.Local{}` or an `%Evision.IPCHandle.CUDA{}`.

  - **new_shape**, `tuple()`
  
    The shape of the shared image. It's expected to be either
    
    - `{height, width, channels}`, for any 2D image that has 1 or multiple channels
    - `{height, width}`, for any 1-channel 2D image
    - `{rows}`
  """
  @spec from_pointer(%Evision.IPCHandle.Local{} | %Evision.IPCHandle.CUDA{}, Keyword.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def from_pointer(handle, opts \\ [])
  
  def from_pointer(%Evision.IPCHandle.Local{}=handle, opts) when is_list(opts) do
    shape = opts[:shape]
    do_from_pointer(:local,
      handle.handle,
      handle.step,
      handle.rows,
      handle.cols, 
      handle.channels,
      handle.type,
      shape: shape
    )
  end
  
  def from_pointer(%Evision.IPCHandle.CUDA{}=handle, opts) when is_list(opts) do
    shape = opts[:shape]
    do_from_pointer(:cuda_ipc, 
      handle.handle, 
      handle.step, 
      handle.rows, 
      handle.cols, 
      handle.channels,
      handle.type,
      shape: shape,
      device_id: handle.device_id
    )
  end

  def from_pointer(%Evision.IPCHandle.Host{}, opts) when is_list(opts) do
    raise ArgumentError, "Host IPC handle is not supported for reading yet."
  end

  defp do_from_pointer(kind, handle, step, rows, cols, channels, dtype, opts) when is_list(opts) do
    shape = {rows, cols, channels}
    opts = Keyword.validate!(opts, [device_id: 0, shape: shape])
    expected_step_size = cols * dtype_byte_size(dtype)
    if expected_step_size > step do
      {:error, "New step size is greater than original step size: new = #{expected_step_size}, original = #{step}"}
    else
      positional = [
        kind: kind,
        dtype: compact_type(dtype),
        handle: handle
      ]
      :evision_nif.cuda_cuda_GpuMat_from_pointer(positional ++ opts)
      |> to_struct()
    end
  end

  @doc """
  Create CUDA GpuMat from a shared CUDA device pointer
  
  ##### Positional Arguments

  - **device_pointer**, `list(integer())`.
  
    This can be either a local pointer or an IPC pointer.
    
    However, please note that IPC pointers have to be generated from 
    another OS process (Erlang process doesn't count).
  
  - **dtype**, `tuple() | atom()`
  
    Data type.
    
  - **shape**, `tuple()`
  
    The shape of the shared image. It's expected to be either
    
    - `{height, width, channels}`, for any 2D image that has 1 or multiple channels
    - `{height, width}`, for any 1-channel 2D image
    - `{rows}`
    
  ##### Keyword Arguments

  - **device_id**, `non_neg_integer`. 
  
    GPU Device ID, default to `0`.
  """
  @spec from_pointer(list(integer()), atom() | {atom(), integer()}, tuple(), [device_id: non_neg_integer()]) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def from_pointer(device_pointer, dtype, shape, opts) when is_list(device_pointer) and is_tuple(shape) and is_list(opts) do
    opts = Keyword.validate!(opts || [], [device_id: 0])
    positional = [
      device_pointer: device_pointer,
      dtype: compact_type(dtype),
      shape: shape
    ]
    :evision_nif.cuda_cuda_GpuMat_from_pointer(positional ++ Evision.Internal.Structurise.from_struct(opts))
    |> to_struct()
  end


  @doc """
  GpuMat

  ##### Positional Arguments
  - **rows**: `integer()`
  - **cols**: `integer()`
  - **type**: `integer()`
  - **s**: `Evision.scalar()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(rows, cols, type, s[, allocator]) -> <cuda_GpuMat object>
  ```
  """
  @spec gpuMat(integer(), integer(), integer(), Evision.scalar(), [{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(rows, cols, type, s, opts) when is_integer(rows) and is_integer(cols) and is_integer(type) and (is_number(s) or is_tuple(s)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type),
      s: Evision.Internal.Structurise.from_struct(s)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  #### Variant 1:
  GpuMat

  ##### Positional Arguments
  - **arr**: `Evision.Mat`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(arr[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 2:
  GpuMat

  ##### Positional Arguments
  - **arr**: `Evision.CUDA.GpuMat.t()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(arr[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 3:
  GpuMat

  ##### Positional Arguments
  - **m**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(m) -> <cuda_GpuMat object>
  ```
  #### Variant 4:
  GpuMat
  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat([, allocator]) -> <cuda_GpuMat object>
  ```

  """
  @spec gpuMat(Keyword.t()) :: any() | {:error, String.t()}
  def gpuMat([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:type,:rows,:rowRange,:cols,:m,:arr,:allocator,:colRange,:roi,:size,:s])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_GpuMat()
    |> to_struct()
  end
  @spec gpuMat([{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec gpuMat(Evision.Mat.maybe_mat_in()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(arr) when (is_struct(arr, Evision.Mat) or is_struct(arr, Nx.Tensor) or is_number(arr) or is_tuple(arr))
  do
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end
  @spec gpuMat(Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(arr) when is_struct(arr, Evision.CUDA.GpuMat)
  do
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end
  @spec gpuMat(Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(m) when is_struct(m, Evision.CUDA.GpuMat)
  do
    positional = [
      m: Evision.Internal.Structurise.from_struct(m)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  GpuMat

  ##### Positional Arguments
  - **rows**: `integer()`
  - **cols**: `integer()`
  - **type**: `integer()`
  - **s**: `Evision.scalar()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(rows, cols, type, s[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 2:
  GpuMat

  ##### Positional Arguments
  - **size**: `Size`
  - **type**: `integer()`
  - **s**: `Evision.scalar()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(size, type, s[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 3:
  GpuMat

  ##### Positional Arguments
  - **rows**: `integer()`
  - **cols**: `integer()`
  - **type**: `integer()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(rows, cols, type[, allocator]) -> <cuda_GpuMat object>
  ```

  """
  @spec gpuMat({number(), number()}, integer(), Evision.scalar(), [{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(size, type, s, opts) when is_tuple(size) and is_integer(type) and (is_number(s) or is_tuple(s)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type),
      s: Evision.Internal.Structurise.from_struct(s)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec gpuMat(integer(), integer(), integer(), [{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(rows, cols, type, opts) when is_integer(rows) and is_integer(cols) and is_integer(type) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec gpuMat(integer(), integer(), integer(), Evision.scalar()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(rows, cols, type, s) when is_integer(rows) and is_integer(cols) and is_integer(type) and (is_number(s) or is_tuple(s))
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type),
      s: Evision.Internal.Structurise.from_struct(s)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  GpuMat

  ##### Positional Arguments
  - **m**: `Evision.CUDA.GpuMat.t()`
  - **rowRange**: `Range`
  - **colRange**: `Range`

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(m, rowRange, colRange) -> <cuda_GpuMat object>
  ```
  #### Variant 2:
  GpuMat

  ##### Positional Arguments
  - **size**: `Size`
  - **type**: `integer()`
  - **s**: `Evision.scalar()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(size, type, s[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 3:
  GpuMat

  ##### Positional Arguments
  - **rows**: `integer()`
  - **cols**: `integer()`
  - **type**: `integer()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(rows, cols, type[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 4:
  GpuMat

  ##### Positional Arguments
  - **size**: `Size`
  - **type**: `integer()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(size, type[, allocator]) -> <cuda_GpuMat object>
  ```

  """
  @spec gpuMat({number(), number()}, integer(), [{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(size, type, opts) when is_tuple(size) and is_integer(type) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec gpuMat(Evision.CUDA.GpuMat.t(), {integer(), integer()} | :all, {integer(), integer()} | :all) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(m, rowRange, colRange) when is_struct(m, Evision.CUDA.GpuMat) and (is_tuple(rowRange) or rowRange == :all) and (is_tuple(colRange) or colRange == :all)
  do
    positional = [
      m: Evision.Internal.Structurise.from_struct(m),
      rowRange: Evision.Internal.Structurise.from_struct(rowRange),
      colRange: Evision.Internal.Structurise.from_struct(colRange)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end
  @spec gpuMat({number(), number()}, integer(), Evision.scalar()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(size, type, s) when is_tuple(size) and is_integer(type) and (is_number(s) or is_tuple(s))
  do
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type),
      s: Evision.Internal.Structurise.from_struct(s)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end
  @spec gpuMat(integer(), integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(rows, cols, type) when is_integer(rows) and is_integer(cols) and is_integer(type)
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  GpuMat

  ##### Positional Arguments
  - **m**: `Evision.CUDA.GpuMat.t()`
  - **roi**: `Rect`

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(m, roi) -> <cuda_GpuMat object>
  ```
  #### Variant 2:
  GpuMat

  ##### Positional Arguments
  - **size**: `Size`
  - **type**: `integer()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(size, type[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 3:
  GpuMat

  ##### Positional Arguments
  - **arr**: `Evision.Mat`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(arr[, allocator]) -> <cuda_GpuMat object>
  ```
  #### Variant 4:
  GpuMat

  ##### Positional Arguments
  - **arr**: `Evision.CUDA.GpuMat.t()`

  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat(arr[, allocator]) -> <cuda_GpuMat object>
  ```

  """
  @spec gpuMat(Evision.Mat.maybe_mat_in(), [{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(arr, opts) when (is_struct(arr, Evision.Mat) or is_struct(arr, Nx.Tensor) or is_number(arr) or is_tuple(arr)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec gpuMat(Evision.CUDA.GpuMat.t(), [{:allocator, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(arr, opts) when is_struct(arr, Evision.CUDA.GpuMat) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:allocator])
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec gpuMat(Evision.CUDA.GpuMat.t(), {number(), number(), number(), number()}) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(m, roi) when is_struct(m, Evision.CUDA.GpuMat) and is_tuple(roi)
  do
    positional = [
      m: Evision.Internal.Structurise.from_struct(m),
      roi: Evision.Internal.Structurise.from_struct(roi)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end
  @spec gpuMat({number(), number()}, integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat(size, type) when is_tuple(size) and is_integer(type)
  do
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end

  @doc """
  GpuMat
  ##### Keyword Arguments
  - **allocator**: `GpuMat_Allocator*`.

  ##### Return
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  GpuMat([, allocator]) -> <cuda_GpuMat object>
  ```
  """
  @spec gpuMat() :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def gpuMat() do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_GpuMat(positional)
    |> to_struct()
  end
  @spec adjustROI(Keyword.t()) :: any() | {:error, String.t()}
  def adjustROI([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:dright,:dtop,:dleft,:dbottom])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_adjustROI()
    |> to_struct()
  end

  @doc """
  adjustROI

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **dtop**: `integer()`
  - **dbottom**: `integer()`
  - **dleft**: `integer()`
  - **dright**: `integer()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  adjustROI(dtop, dbottom, dleft, dright) -> retval
  ```
  """
  @spec adjustROI(Evision.CUDA.GpuMat.t(), integer(), integer(), integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def adjustROI(self, dtop, dbottom, dleft, dright) when is_integer(dtop) and is_integer(dbottom) and is_integer(dleft) and is_integer(dright)
  do
    positional = [
      dtop: Evision.Internal.Structurise.from_struct(dtop),
      dbottom: Evision.Internal.Structurise.from_struct(dbottom),
      dleft: Evision.Internal.Structurise.from_struct(dleft),
      dright: Evision.Internal.Structurise.from_struct(dright)
    ]
    :evision_nif.cuda_cuda_GpuMat_adjustROI(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  assignTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **m**: `Evision.CUDA.GpuMat.t()`

  ##### Keyword Arguments
  - **type**: `integer()`.

  Python prototype (for reference only):
  ```python3
  assignTo(m[, type]) -> None
  ```
  """
  @spec assignTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t(), [{:type, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def assignTo(self, m, opts) when is_struct(m, Evision.CUDA.GpuMat) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:type])
    positional = [
      m: Evision.Internal.Structurise.from_struct(m)
    ]
    :evision_nif.cuda_cuda_GpuMat_assignTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec assignTo(Keyword.t()) :: any() | {:error, String.t()}
  def assignTo([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:type,:m])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_assignTo()
    |> to_struct()
  end

  @doc """
  assignTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **m**: `Evision.CUDA.GpuMat.t()`

  ##### Keyword Arguments
  - **type**: `integer()`.

  Python prototype (for reference only):
  ```python3
  assignTo(m[, type]) -> None
  ```
  """
  @spec assignTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def assignTo(self, m) when is_struct(m, Evision.CUDA.GpuMat)
  do
    positional = [
      m: Evision.Internal.Structurise.from_struct(m)
    ]
    :evision_nif.cuda_cuda_GpuMat_assignTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  channels

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  channels() -> retval
  ```
  """
  @spec channels(Keyword.t()) :: any() | {:error, String.t()}
  def channels([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_channels()
    |> to_struct()
  end
  @spec channels(Evision.CUDA.GpuMat.t()) :: integer() | {:error, String.t()}
  def channels(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_channels(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  clone

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  clone() -> retval
  ```
  """
  @spec clone(Keyword.t()) :: any() | {:error, String.t()}
  def clone([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_clone()
    |> to_struct()
  end
  @spec clone(Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def clone(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_clone(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec col(Keyword.t()) :: any() | {:error, String.t()}
  def col([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:x])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_col()
    |> to_struct()
  end

  @doc """
  col

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **x**: `integer()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  col(x) -> retval
  ```
  """
  @spec col(Evision.CUDA.GpuMat.t(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def col(self, x) when is_integer(x)
  do
    positional = [
      x: Evision.Internal.Structurise.from_struct(x)
    ]
    :evision_nif.cuda_cuda_GpuMat_col(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec colRange(Keyword.t()) :: any() | {:error, String.t()}
  def colRange([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:endcol,:startcol,:r])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_colRange()
    |> to_struct()
  end

  @doc """
  colRange

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **startcol**: `integer()`
  - **endcol**: `integer()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  colRange(startcol, endcol) -> retval
  ```
  """
  @spec colRange(Evision.CUDA.GpuMat.t(), integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def colRange(self, startcol, endcol) when is_integer(startcol) and is_integer(endcol)
  do
    positional = [
      startcol: Evision.Internal.Structurise.from_struct(startcol),
      endcol: Evision.Internal.Structurise.from_struct(endcol)
    ]
    :evision_nif.cuda_cuda_GpuMat_colRange(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  colRange

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **r**: `Range`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  colRange(r) -> retval
  ```
  """
  @spec colRange(Evision.CUDA.GpuMat.t(), {integer(), integer()} | :all) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def colRange(self, r) when (is_tuple(r) or r == :all)
  do
    positional = [
      r: Evision.Internal.Structurise.from_struct(r)
    ]
    :evision_nif.cuda_cuda_GpuMat_colRange(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  convertTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rtype**: `integer()`
  - **alpha**: `double`
  - **beta**: `double`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  convertTo(rtype, alpha, beta, stream[, dst]) -> dst
  ```
  """
  @spec convertTo(Evision.CUDA.GpuMat.t(), integer(), number(), number(), Evision.CUDA.Stream.t(), [{atom(), term()},...] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def convertTo(self, rtype, alpha, beta, stream, opts) when is_integer(rtype) and is_number(alpha) and is_number(beta) and is_struct(stream, Evision.CUDA.Stream) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      rtype: Evision.Internal.Structurise.from_struct(rtype),
      alpha: Evision.Internal.Structurise.from_struct(alpha),
      beta: Evision.Internal.Structurise.from_struct(beta),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_convertTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec convertTo(Keyword.t()) :: any() | {:error, String.t()}
  def convertTo([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:stream,:dst,:alpha,:rtype,:beta])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_convertTo()
    |> to_struct()
  end

  @doc """
  convertTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rtype**: `integer()`
  - **alpha**: `double`
  - **beta**: `double`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  convertTo(rtype, alpha, beta, stream[, dst]) -> dst
  ```
  """
  @spec convertTo(Evision.CUDA.GpuMat.t(), integer(), number(), number(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def convertTo(self, rtype, alpha, beta, stream) when is_integer(rtype) and is_number(alpha) and is_number(beta) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      rtype: Evision.Internal.Structurise.from_struct(rtype),
      alpha: Evision.Internal.Structurise.from_struct(alpha),
      beta: Evision.Internal.Structurise.from_struct(beta),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_convertTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  convertTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rtype**: `integer()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  convertTo(rtype, stream[, dst]) -> dst
  ```
  """
  @spec convertTo(Evision.CUDA.GpuMat.t(), integer(), Evision.CUDA.Stream.t(), [{atom(), term()},...] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def convertTo(self, rtype, stream, opts) when is_integer(rtype) and is_struct(stream, Evision.CUDA.Stream) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      rtype: Evision.Internal.Structurise.from_struct(rtype),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_convertTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  #### Variant 1:
  convertTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rtype**: `integer()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  convertTo(rtype, stream[, dst]) -> dst
  ```
  #### Variant 2:
  convertTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rtype**: `integer()`

  ##### Keyword Arguments
  - **alpha**: `double`.
  - **beta**: `double`.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  convertTo(rtype[, dst[, alpha[, beta]]]) -> dst
  ```

  """
  @spec convertTo(Evision.CUDA.GpuMat.t(), integer(), [{:alpha, term()} | {:beta, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def convertTo(self, rtype, opts) when is_integer(rtype) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:alpha, :beta])
    positional = [
      rtype: Evision.Internal.Structurise.from_struct(rtype)
    ]
    :evision_nif.cuda_cuda_GpuMat_convertTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec convertTo(Evision.CUDA.GpuMat.t(), integer(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def convertTo(self, rtype, stream) when is_integer(rtype) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      rtype: Evision.Internal.Structurise.from_struct(rtype),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_convertTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  convertTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rtype**: `integer()`

  ##### Keyword Arguments
  - **alpha**: `double`.
  - **beta**: `double`.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  convertTo(rtype[, dst[, alpha[, beta]]]) -> dst
  ```
  """
  @spec convertTo(Evision.CUDA.GpuMat.t(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def convertTo(self, rtype) when is_integer(rtype)
  do
    positional = [
      rtype: Evision.Internal.Structurise.from_struct(rtype)
    ]
    :evision_nif.cuda_cuda_GpuMat_convertTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **mask**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo(mask, stream[, dst]) -> dst
  ```
  """
  @spec copyTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t(), [{atom(), term()},...] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, mask, stream, opts) when is_struct(mask, Evision.CUDA.GpuMat) and is_struct(stream, Evision.CUDA.Stream) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      mask: Evision.Internal.Structurise.from_struct(mask),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo([, dst]) -> dst
  ```
  """
  @spec copyTo(Keyword.t()) :: any() | {:error, String.t()}
  def copyTo([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:mask,:stream,:dst])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_copyTo()
    |> to_struct()
  end
  @spec copyTo(Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **mask**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo(mask, stream[, dst]) -> dst
  ```
  #### Variant 2:
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **mask**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo(mask[, dst]) -> dst
  ```
  #### Variant 3:
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo(stream[, dst]) -> dst
  ```

  """
  @spec copyTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t(), [{atom(), term()},...] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, mask, opts) when is_struct(mask, Evision.CUDA.GpuMat) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec copyTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t(), [{atom(), term()},...] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, stream, opts) when is_struct(stream, Evision.CUDA.Stream) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec copyTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, mask, stream) when is_struct(mask, Evision.CUDA.GpuMat) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      mask: Evision.Internal.Structurise.from_struct(mask),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **mask**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo(mask[, dst]) -> dst
  ```
  #### Variant 2:
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo(stream[, dst]) -> dst
  ```
  #### Variant 3:
  copyTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

  Python prototype (for reference only):
  ```python3
  copyTo([, dst]) -> dst
  ```

  """
  @spec copyTo(Evision.CUDA.GpuMat.t(), [{atom(), term()},...] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec copyTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, mask) when is_struct(mask, Evision.CUDA.GpuMat)
  do
    positional = [
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec copyTo(Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def copyTo(self, stream) when is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_copyTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec create(Keyword.t()) :: any() | {:error, String.t()}
  def create([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:type,:rows,:size,:cols])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_create()
    |> to_struct()
  end

  @doc """
  create

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **rows**: `integer()`
  - **cols**: `integer()`
  - **type**: `integer()`

  Python prototype (for reference only):
  ```python3
  create(rows, cols, type) -> None
  ```
  """
  @spec create(Evision.CUDA.GpuMat.t(), integer(), integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def create(self, rows, cols, type) when is_integer(rows) and is_integer(cols) and is_integer(type)
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_cuda_GpuMat_create(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  create

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **size**: `Size`
  - **type**: `integer()`

  Python prototype (for reference only):
  ```python3
  create(size, type) -> None
  ```
  """
  @spec create(Evision.CUDA.GpuMat.t(), {number(), number()}, integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def create(self, size, type) when is_tuple(size) and is_integer(type)
  do
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_cuda_GpuMat_create(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  cudaPtr

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `void*`

  Python prototype (for reference only):
  ```python3
  cudaPtr() -> retval
  ```
  """
  @spec cudaPtr(Keyword.t()) :: any() | {:error, String.t()}
  def cudaPtr([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_cudaPtr()
    |> to_struct()
  end
  @spec cudaPtr(Evision.CUDA.GpuMat.t()) :: :ok | {:error, String.t()}
  def cudaPtr(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_cudaPtr(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec defaultAllocator(Keyword.t()) :: any() | {:error, String.t()}
  def defaultAllocator([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_defaultAllocator_static()
    |> to_struct()
  end

  @doc """
  defaultAllocator
  ##### Return
  - **retval**: `GpuMat::Allocator*`

  Python prototype (for reference only):
  ```python3
  defaultAllocator() -> retval
  ```
  """
  @spec defaultAllocator() :: reference() | {:error, String.t()}
  def defaultAllocator() do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_defaultAllocator_static(positional)
    |> to_struct()
  end

  @doc """
  depth

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  depth() -> retval
  ```
  """
  @spec depth(Keyword.t()) :: any() | {:error, String.t()}
  def depth([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_depth()
    |> to_struct()
  end
  @spec depth(Evision.CUDA.GpuMat.t()) :: integer() | {:error, String.t()}
  def depth(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_depth(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Performs data download from GpuMat (Non-Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.Mat.t()`.

  This function copies data from device memory to host memory. As being a non-blocking call, this
  function may return even if the copy operation is not finished.
  The copy operation may be overlapped with operations in other non-default streams if \\p stream is
  not the default stream and \\p dst is HostMem allocated with HostMem::PAGE_LOCKED option.

  Python prototype (for reference only):
  ```python3
  download(stream[, dst]) -> dst
  ```
  """
  @spec download(Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def download(self, stream, opts) when is_struct(stream, Evision.CUDA.Stream) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_download(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  Performs data download from GpuMat (Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **dst**: `Evision.Mat.t()`.

  This function copies data from device memory to host memory. As being a blocking call, it is
  guaranteed that the copy operation is finished when this function returns.

  Python prototype (for reference only):
  ```python3
  download([, dst]) -> dst
  ```
  """
  @spec download(Keyword.t()) :: any() | {:error, String.t()}
  def download([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:stream,:dst])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_download()
    |> to_struct()
  end
  @spec download(Evision.CUDA.GpuMat.t()) :: Evision.Mat.t() | {:error, String.t()}
  def download(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_download(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  Performs data download from GpuMat (Non-Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **dst**: `Evision.Mat.t()`.

  This function copies data from device memory to host memory. As being a non-blocking call, this
  function may return even if the copy operation is not finished.
  The copy operation may be overlapped with operations in other non-default streams if \\p stream is
  not the default stream and \\p dst is HostMem allocated with HostMem::PAGE_LOCKED option.

  Python prototype (for reference only):
  ```python3
  download(stream[, dst]) -> dst
  ```
  #### Variant 2:
  Performs data download from GpuMat (Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **dst**: `Evision.Mat.t()`.

  This function copies data from device memory to host memory. As being a blocking call, it is
  guaranteed that the copy operation is finished when this function returns.

  Python prototype (for reference only):
  ```python3
  download([, dst]) -> dst
  ```

  """
  @spec download(Evision.CUDA.GpuMat.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def download(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_download(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec download(Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t()) :: Evision.Mat.t() | {:error, String.t()}
  def download(self, stream) when is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_download(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  elemSize

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  elemSize() -> retval
  ```
  """
  @spec elemSize(Keyword.t()) :: any() | {:error, String.t()}
  def elemSize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_elemSize()
    |> to_struct()
  end
  @spec elemSize(Evision.CUDA.GpuMat.t()) :: integer() | {:error, String.t()}
  def elemSize(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_elemSize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  elemSize1

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  elemSize1() -> retval
  ```
  """
  @spec elemSize1(Keyword.t()) :: any() | {:error, String.t()}
  def elemSize1([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_elemSize1()
    |> to_struct()
  end
  @spec elemSize1(Evision.CUDA.GpuMat.t()) :: integer() | {:error, String.t()}
  def elemSize1(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_elemSize1(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  empty

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

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
    |> :evision_nif.cuda_cuda_GpuMat_empty()
    |> to_struct()
  end
  @spec empty(Evision.CUDA.GpuMat.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec getStdAllocator(Keyword.t()) :: any() | {:error, String.t()}
  def getStdAllocator([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_getStdAllocator_static()
    |> to_struct()
  end

  @doc """
  getStdAllocator
  ##### Return
  - **retval**: `GpuMat::Allocator*`

  Python prototype (for reference only):
  ```python3
  getStdAllocator() -> retval
  ```
  """
  @spec getStdAllocator() :: reference() | {:error, String.t()}
  def getStdAllocator() do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_getStdAllocator_static(positional)
    |> to_struct()
  end

  @doc """
  isContinuous

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  isContinuous() -> retval
  ```
  """
  @spec isContinuous(Keyword.t()) :: any() | {:error, String.t()}
  def isContinuous([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_isContinuous()
    |> to_struct()
  end
  @spec isContinuous(Evision.CUDA.GpuMat.t()) :: boolean() | {:error, String.t()}
  def isContinuous(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_isContinuous(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec locateROI(Keyword.t()) :: any() | {:error, String.t()}
  def locateROI([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:ofs,:wholeSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_locateROI()
    |> to_struct()
  end

  @doc """
  locateROI

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **wholeSize**: `Size`
  - **ofs**: `Point`

  Python prototype (for reference only):
  ```python3
  locateROI(wholeSize, ofs) -> None
  ```
  """
  @spec locateROI(Evision.CUDA.GpuMat.t(), {number(), number()}, {number(), number()}) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def locateROI(self, wholeSize, ofs) when is_tuple(wholeSize) and is_tuple(ofs)
  do
    positional = [
      wholeSize: Evision.Internal.Structurise.from_struct(wholeSize),
      ofs: Evision.Internal.Structurise.from_struct(ofs)
    ]
    :evision_nif.cuda_cuda_GpuMat_locateROI(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  release

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  release() -> None
  ```
  """
  @spec release(Keyword.t()) :: any() | {:error, String.t()}
  def release([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_release()
    |> to_struct()
  end
  @spec release(Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def release(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_release(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  reshape

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **cn**: `integer()`

  ##### Keyword Arguments
  - **rows**: `integer()`.

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  reshape(cn[, rows]) -> retval
  ```
  """
  @spec reshape(Evision.CUDA.GpuMat.t(), integer(), [{:rows, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def reshape(self, cn, opts) when is_integer(cn) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:rows])
    positional = [
      cn: Evision.Internal.Structurise.from_struct(cn)
    ]
    :evision_nif.cuda_cuda_GpuMat_reshape(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec reshape(Keyword.t()) :: any() | {:error, String.t()}
  def reshape([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:rows,:cn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_reshape()
    |> to_struct()
  end

  @doc """
  reshape

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **cn**: `integer()`

  ##### Keyword Arguments
  - **rows**: `integer()`.

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  reshape(cn[, rows]) -> retval
  ```
  """
  @spec reshape(Evision.CUDA.GpuMat.t(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def reshape(self, cn) when is_integer(cn)
  do
    positional = [
      cn: Evision.Internal.Structurise.from_struct(cn)
    ]
    :evision_nif.cuda_cuda_GpuMat_reshape(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec row(Keyword.t()) :: any() | {:error, String.t()}
  def row([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:y])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_row()
    |> to_struct()
  end

  @doc """
  row

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **y**: `integer()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  row(y) -> retval
  ```
  """
  @spec row(Evision.CUDA.GpuMat.t(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def row(self, y) when is_integer(y)
  do
    positional = [
      y: Evision.Internal.Structurise.from_struct(y)
    ]
    :evision_nif.cuda_cuda_GpuMat_row(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec rowRange(Keyword.t()) :: any() | {:error, String.t()}
  def rowRange([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:endrow,:r,:startrow])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_rowRange()
    |> to_struct()
  end

  @doc """
  rowRange

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **startrow**: `integer()`
  - **endrow**: `integer()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  rowRange(startrow, endrow) -> retval
  ```
  """
  @spec rowRange(Evision.CUDA.GpuMat.t(), integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def rowRange(self, startrow, endrow) when is_integer(startrow) and is_integer(endrow)
  do
    positional = [
      startrow: Evision.Internal.Structurise.from_struct(startrow),
      endrow: Evision.Internal.Structurise.from_struct(endrow)
    ]
    :evision_nif.cuda_cuda_GpuMat_rowRange(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  rowRange

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **r**: `Range`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  rowRange(r) -> retval
  ```
  """
  @spec rowRange(Evision.CUDA.GpuMat.t(), {integer(), integer()} | :all) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def rowRange(self, r) when (is_tuple(r) or r == :all)
  do
    positional = [
      r: Evision.Internal.Structurise.from_struct(r)
    ]
    :evision_nif.cuda_cuda_GpuMat_rowRange(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  setDefaultAllocator

  ##### Positional Arguments
  - **allocator**: `GpuMat_Allocator*`

  Python prototype (for reference only):
  ```python3
  setDefaultAllocator(allocator) -> None
  ```
  """
  @spec setDefaultAllocator(Keyword.t()) :: any() | {:error, String.t()}
  def setDefaultAllocator([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:allocator])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_setDefaultAllocator_static()
    |> to_struct()
  end
  @spec setDefaultAllocator(reference()) :: :ok | {:error, String.t()}
  def setDefaultAllocator(allocator) when (is_reference(allocator) or is_struct(allocator))
  do
    positional = [
      allocator: Evision.Internal.Structurise.from_struct(allocator)
    ]
    :evision_nif.cuda_cuda_GpuMat_setDefaultAllocator_static(positional)
    |> to_struct()
  end
  @spec setTo(Keyword.t()) :: any() | {:error, String.t()}
  def setTo([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:stream,:mask,:s])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_setTo()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  setTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **s**: `Evision.scalar()`
  - **mask**: `Evision.Mat`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  setTo(s, mask, stream) -> retval
  ```
  #### Variant 2:
  setTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **s**: `Evision.scalar()`
  - **mask**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  setTo(s, mask, stream) -> retval
  ```

  """
  @spec setTo(Evision.CUDA.GpuMat.t(), Evision.scalar(), Evision.Mat.maybe_mat_in(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def setTo(self, s, mask, stream) when (is_number(s) or is_tuple(s)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask)) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      s: Evision.Internal.Structurise.from_struct(s),
      mask: Evision.Internal.Structurise.from_struct(mask),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_setTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setTo(Evision.CUDA.GpuMat.t(), Evision.scalar(), Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def setTo(self, s, mask, stream) when (is_number(s) or is_tuple(s)) and is_struct(mask, Evision.CUDA.GpuMat) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      s: Evision.Internal.Structurise.from_struct(s),
      mask: Evision.Internal.Structurise.from_struct(mask),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_setTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  setTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **s**: `Evision.scalar()`
  - **mask**: `Evision.Mat`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  setTo(s, mask) -> retval
  ```
  #### Variant 2:
  setTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **s**: `Evision.scalar()`
  - **mask**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  setTo(s, mask) -> retval
  ```
  #### Variant 3:
  setTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **s**: `Evision.scalar()`
  - **stream**: `Evision.CUDA.Stream.t()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  setTo(s, stream) -> retval
  ```

  """
  @spec setTo(Evision.CUDA.GpuMat.t(), Evision.scalar(), Evision.Mat.maybe_mat_in()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def setTo(self, s, mask) when (is_number(s) or is_tuple(s)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask))
  do
    positional = [
      s: Evision.Internal.Structurise.from_struct(s),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.cuda_cuda_GpuMat_setTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setTo(Evision.CUDA.GpuMat.t(), Evision.scalar(), Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def setTo(self, s, mask) when (is_number(s) or is_tuple(s)) and is_struct(mask, Evision.CUDA.GpuMat)
  do
    positional = [
      s: Evision.Internal.Structurise.from_struct(s),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.cuda_cuda_GpuMat_setTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setTo(Evision.CUDA.GpuMat.t(), Evision.scalar(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def setTo(self, s, stream) when (is_number(s) or is_tuple(s)) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      s: Evision.Internal.Structurise.from_struct(s),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_setTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  setTo

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **s**: `Evision.scalar()`

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  setTo(s) -> retval
  ```
  """
  @spec setTo(Evision.CUDA.GpuMat.t(), Evision.scalar()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def setTo(self, s) when (is_number(s) or is_tuple(s))
  do
    positional = [
      s: Evision.Internal.Structurise.from_struct(s)
    ]
    :evision_nif.cuda_cuda_GpuMat_setTo(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  size

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `Size`

  Python prototype (for reference only):
  ```python3
  size() -> retval
  ```
  """
  @spec size(Keyword.t()) :: any() | {:error, String.t()}
  def size([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_size()
    |> to_struct()
  end
  @spec size(Evision.CUDA.GpuMat.t()) :: {number(), number()} | {:error, String.t()}
  def size(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_size(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  step1

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  ##### Return
  - **retval**: `size_t`

  Python prototype (for reference only):
  ```python3
  step1() -> retval
  ```
  """
  @spec step1(Keyword.t()) :: any() | {:error, String.t()}
  def step1([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_step1()
    |> to_struct()
  end
  @spec step1(Evision.CUDA.GpuMat.t()) :: integer() | {:error, String.t()}
  def step1(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_step1(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec swap(Keyword.t()) :: any() | {:error, String.t()}
  def swap([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:mat])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_swap()
    |> to_struct()
  end

  @doc """
  swap

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **mat**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  swap(mat) -> None
  ```
  """
  @spec swap(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def swap(self, mat) when is_struct(mat, Evision.CUDA.GpuMat)
  do
    positional = [
      mat: Evision.Internal.Structurise.from_struct(mat)
    ]
    :evision_nif.cuda_cuda_GpuMat_swap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  type

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

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
    |> :evision_nif.cuda_cuda_GpuMat_type()
    |> to_struct()
  end
  @spec type(Evision.CUDA.GpuMat.t()) :: integer() | {:error, String.t()}
  def type(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_type(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  updateContinuityFlag

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`

  Python prototype (for reference only):
  ```python3
  updateContinuityFlag() -> None
  ```
  """
  @spec updateContinuityFlag(Keyword.t()) :: any() | {:error, String.t()}
  def updateContinuityFlag([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_updateContinuityFlag()
    |> to_struct()
  end
  @spec updateContinuityFlag(Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def updateContinuityFlag(self) do
    positional = [
    ]
    :evision_nif.cuda_cuda_GpuMat_updateContinuityFlag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec upload(Keyword.t()) :: any() | {:error, String.t()}
  def upload([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:arr,:stream])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_cuda_GpuMat_upload()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  Performs data upload to GpuMat (Non-Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **arr**: `Evision.Mat`
  - **stream**: `Evision.CUDA.Stream.t()`

  This function copies data from host memory to device memory. As being a non-blocking call, this
  function may return even if the copy operation is not finished.
  The copy operation may be overlapped with operations in other non-default streams if \\p stream is
  not the default stream and \\p dst is HostMem allocated with HostMem::PAGE_LOCKED option.

  Python prototype (for reference only):
  ```python3
  upload(arr, stream) -> None
  ```
  #### Variant 2:
  Performs data upload to GpuMat (Non-Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **arr**: `Evision.CUDA.GpuMat.t()`
  - **stream**: `Evision.CUDA.Stream.t()`

  This function copies data from host memory to device memory. As being a non-blocking call, this
  function may return even if the copy operation is not finished.
  The copy operation may be overlapped with operations in other non-default streams if \\p stream is
  not the default stream and \\p dst is HostMem allocated with HostMem::PAGE_LOCKED option.

  Python prototype (for reference only):
  ```python3
  upload(arr, stream) -> None
  ```

  """
  @spec upload(Evision.CUDA.GpuMat.t(), Evision.Mat.maybe_mat_in(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def upload(self, arr, stream) when (is_struct(arr, Evision.Mat) or is_struct(arr, Nx.Tensor) or is_number(arr) or is_tuple(arr)) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_upload(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec upload(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t(), Evision.CUDA.Stream.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def upload(self, arr, stream) when is_struct(arr, Evision.CUDA.GpuMat) and is_struct(stream, Evision.CUDA.Stream)
  do
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr),
      stream: Evision.Internal.Structurise.from_struct(stream)
    ]
    :evision_nif.cuda_cuda_GpuMat_upload(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  Performs data upload to GpuMat (Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **arr**: `Evision.Mat`

  This function copies data from host memory to device memory. As being a blocking call, it is
  guaranteed that the copy operation is finished when this function returns.

  Python prototype (for reference only):
  ```python3
  upload(arr) -> None
  ```
  #### Variant 2:
  Performs data upload to GpuMat (Blocking call)

  ##### Positional Arguments
  - **self**: `Evision.CUDA.GpuMat.t()`
  - **arr**: `Evision.CUDA.GpuMat.t()`

  This function copies data from host memory to device memory. As being a blocking call, it is
  guaranteed that the copy operation is finished when this function returns.

  Python prototype (for reference only):
  ```python3
  upload(arr) -> None
  ```

  """
  @spec upload(Evision.CUDA.GpuMat.t(), Evision.Mat.maybe_mat_in()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def upload(self, arr) when (is_struct(arr, Evision.Mat) or is_struct(arr, Nx.Tensor) or is_number(arr) or is_tuple(arr))
  do
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr)
    ]
    :evision_nif.cuda_cuda_GpuMat_upload(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec upload(Evision.CUDA.GpuMat.t(), Evision.CUDA.GpuMat.t()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def upload(self, arr) when is_struct(arr, Evision.CUDA.GpuMat)
  do
    positional = [
      arr: Evision.Internal.Structurise.from_struct(arr)
    ]
    :evision_nif.cuda_cuda_GpuMat_upload(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec get_step(Evision.CUDA.GpuMat.t()) :: integer()
  def get_step(self) do
    :evision_nif.cuda_GpuMat_get_step(Evision.Internal.Structurise.from_struct(self))
    |> to_struct()
  end
end
