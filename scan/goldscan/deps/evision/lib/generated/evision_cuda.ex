defmodule Evision.CUDA do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `CUDA` struct.

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
  def to_struct({:ok, %{class: Evision.CUDA, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.CUDA, ref: ref}) do
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
  Creates a continuous matrix.

  ##### Positional Arguments
  - **rows**: `integer()`.

    Row count.

  - **cols**: `integer()`.

    Column count.

  - **type**: `integer()`.

    Type of the matrix.

  ##### Return
  - **arr**: `Evision.Mat.t()`.

    Destination matrix. This parameter changes only if it has a proper type and area (
    \\f$\\texttt{rows} \\times \\texttt{cols}\\f$ ).

  Matrix is called continuous if its elements are stored continuously, that is, without gaps at the
  end of each row.

  Python prototype (for reference only):
  ```python3
  createContinuous(rows, cols, type[, arr]) -> arr
  ```
  """
  @spec createContinuous(integer(), integer(), integer(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def createContinuous(rows, cols, type, opts) when is_integer(rows) and is_integer(cols) and is_integer(type) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_createContinuous(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec createContinuous(Keyword.t()) :: any() | {:error, String.t()}
  def createContinuous([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:type,:rows,:arr,:cols])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_createContinuous()
    |> to_struct()
  end

  @doc """
  Creates a continuous matrix.

  ##### Positional Arguments
  - **rows**: `integer()`.

    Row count.

  - **cols**: `integer()`.

    Column count.

  - **type**: `integer()`.

    Type of the matrix.

  ##### Return
  - **arr**: `Evision.Mat.t()`.

    Destination matrix. This parameter changes only if it has a proper type and area (
    \\f$\\texttt{rows} \\times \\texttt{cols}\\f$ ).

  Matrix is called continuous if its elements are stored continuously, that is, without gaps at the
  end of each row.

  Python prototype (for reference only):
  ```python3
  createContinuous(rows, cols, type[, arr]) -> arr
  ```
  """
  @spec createContinuous(integer(), integer(), integer()) :: Evision.Mat.t() | {:error, String.t()}
  def createContinuous(rows, cols, type) when is_integer(rows) and is_integer(cols) and is_integer(type)
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_createContinuous(positional)
    |> to_struct()
  end

  @doc """
  Bindings overload to create a GpuMat from existing GPU memory.

  ##### Positional Arguments
  - **rows**: `integer()`.

    Row count.

  - **cols**: `integer()`.

    Column count.

  - **type**: `integer()`.

    Type of the matrix.

  - **cudaMemoryAddress**: `size_t`.

    Address of the allocated GPU memory on the device. This does not allocate matrix data. Instead, it just initializes the matrix header that points to the specified \\a cudaMemoryAddress, which means that no data is copied. This operation is very efficient and can be used to process external data using OpenCV functions. The external data is not automatically deallocated, so you should take care of it.

  ##### Keyword Arguments
  - **step**: `size_t`.

    Number of bytes each matrix row occupies. The value should include the padding bytes at the end of each row, if any. If the parameter is missing (set to Mat::AUTO_STEP ), no padding is assumed and the actual step is calculated as cols*elemSize(). See GpuMat::elemSize.

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  **Note**: Overload for generation of bindings only, not exported or intended for use internally from C++.

  Python prototype (for reference only):
  ```python3
  createGpuMatFromCudaMemory(rows, cols, type, cudaMemoryAddress[, step]) -> retval
  ```
  """
  @spec createGpuMatFromCudaMemory(integer(), integer(), integer(), integer(), [{:step, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def createGpuMatFromCudaMemory(rows, cols, type, cudaMemoryAddress, opts) when is_integer(rows) and is_integer(cols) and is_integer(type) and is_integer(cudaMemoryAddress) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:step])
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type),
      cudaMemoryAddress: Evision.Internal.Structurise.from_struct(cudaMemoryAddress)
    ]
    :evision_nif.cuda_createGpuMatFromCudaMemory(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec createGpuMatFromCudaMemory(Keyword.t()) :: any() | {:error, String.t()}
  def createGpuMatFromCudaMemory([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:type,:rows,:cols,:step,:cudaMemoryAddress,:size])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_createGpuMatFromCudaMemory()
    |> to_struct()
  end

  @doc """
  #### Variant 1:
  Bindings overload to create a GpuMat from existing GPU memory.

  ##### Positional Arguments
  - **rows**: `integer()`.

    Row count.

  - **cols**: `integer()`.

    Column count.

  - **type**: `integer()`.

    Type of the matrix.

  - **cudaMemoryAddress**: `size_t`.

    Address of the allocated GPU memory on the device. This does not allocate matrix data. Instead, it just initializes the matrix header that points to the specified \\a cudaMemoryAddress, which means that no data is copied. This operation is very efficient and can be used to process external data using OpenCV functions. The external data is not automatically deallocated, so you should take care of it.

  ##### Keyword Arguments
  - **step**: `size_t`.

    Number of bytes each matrix row occupies. The value should include the padding bytes at the end of each row, if any. If the parameter is missing (set to Mat::AUTO_STEP ), no padding is assumed and the actual step is calculated as cols*elemSize(). See GpuMat::elemSize.

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  **Note**: Overload for generation of bindings only, not exported or intended for use internally from C++.

  Python prototype (for reference only):
  ```python3
  createGpuMatFromCudaMemory(rows, cols, type, cudaMemoryAddress[, step]) -> retval
  ```
  #### Variant 2:
  createGpuMatFromCudaMemory

  ##### Positional Arguments
  - **size**: `Size`.

    2D array size: Size(cols, rows). In the Size() constructor, the number of rows and the number of columns go in the reverse order.

  - **type**: `integer()`.

    Type of the matrix.

  - **cudaMemoryAddress**: `size_t`.

    Address of the allocated GPU memory on the device. This does not allocate matrix data. Instead, it just initializes the matrix header that points to the specified \\a cudaMemoryAddress, which means that no data is copied. This operation is very efficient and can be used to process external data using OpenCV functions. The external data is not automatically deallocated, so you should take care of it.

  ##### Keyword Arguments
  - **step**: `size_t`.

    Number of bytes each matrix row occupies. The value should include the padding bytes at the end of each row, if any. If the parameter is missing (set to Mat::AUTO_STEP ), no padding is assumed and the actual step is calculated as cols*elemSize(). See GpuMat::elemSize.

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Has overloading in C++

  **Note**: Overload for generation of bindings only, not exported or intended for use internally from C++.

  Python prototype (for reference only):
  ```python3
  createGpuMatFromCudaMemory(size, type, cudaMemoryAddress[, step]) -> retval
  ```

  """
  @spec createGpuMatFromCudaMemory({number(), number()}, integer(), integer(), [{:step, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def createGpuMatFromCudaMemory(size, type, cudaMemoryAddress, opts) when is_tuple(size) and is_integer(type) and is_integer(cudaMemoryAddress) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:step])
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type),
      cudaMemoryAddress: Evision.Internal.Structurise.from_struct(cudaMemoryAddress)
    ]
    :evision_nif.cuda_createGpuMatFromCudaMemory(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec createGpuMatFromCudaMemory(integer(), integer(), integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def createGpuMatFromCudaMemory(rows, cols, type, cudaMemoryAddress) when is_integer(rows) and is_integer(cols) and is_integer(type) and is_integer(cudaMemoryAddress)
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type),
      cudaMemoryAddress: Evision.Internal.Structurise.from_struct(cudaMemoryAddress)
    ]
    :evision_nif.cuda_createGpuMatFromCudaMemory(positional)
    |> to_struct()
  end

  @doc """
  createGpuMatFromCudaMemory

  ##### Positional Arguments
  - **size**: `Size`.

    2D array size: Size(cols, rows). In the Size() constructor, the number of rows and the number of columns go in the reverse order.

  - **type**: `integer()`.

    Type of the matrix.

  - **cudaMemoryAddress**: `size_t`.

    Address of the allocated GPU memory on the device. This does not allocate matrix data. Instead, it just initializes the matrix header that points to the specified \\a cudaMemoryAddress, which means that no data is copied. This operation is very efficient and can be used to process external data using OpenCV functions. The external data is not automatically deallocated, so you should take care of it.

  ##### Keyword Arguments
  - **step**: `size_t`.

    Number of bytes each matrix row occupies. The value should include the padding bytes at the end of each row, if any. If the parameter is missing (set to Mat::AUTO_STEP ), no padding is assumed and the actual step is calculated as cols*elemSize(). See GpuMat::elemSize.

  ##### Return
  - **retval**: `Evision.CUDA.GpuMat.t()`

  Has overloading in C++

  **Note**: Overload for generation of bindings only, not exported or intended for use internally from C++.

  Python prototype (for reference only):
  ```python3
  createGpuMatFromCudaMemory(size, type, cudaMemoryAddress[, step]) -> retval
  ```
  """
  @spec createGpuMatFromCudaMemory({number(), number()}, integer(), integer()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def createGpuMatFromCudaMemory(size, type, cudaMemoryAddress) when is_tuple(size) and is_integer(type) and is_integer(cudaMemoryAddress)
  do
    positional = [
      size: Evision.Internal.Structurise.from_struct(size),
      type: Evision.Internal.Structurise.from_struct(type),
      cudaMemoryAddress: Evision.Internal.Structurise.from_struct(cudaMemoryAddress)
    ]
    :evision_nif.cuda_createGpuMatFromCudaMemory(positional)
    |> to_struct()
  end

  @doc """
  Ensures that the size of a matrix is big enough and the matrix has a proper type.

  ##### Positional Arguments
  - **rows**: `integer()`.

    Minimum desired number of rows.

  - **cols**: `integer()`.

    Minimum desired number of columns.

  - **type**: `integer()`.

    Desired matrix type.

  ##### Return
  - **arr**: `Evision.Mat.t()`.

    Destination matrix.

  The function does not reallocate memory if the matrix has proper attributes already.

  Python prototype (for reference only):
  ```python3
  ensureSizeIsEnough(rows, cols, type[, arr]) -> arr
  ```
  """
  @spec ensureSizeIsEnough(integer(), integer(), integer(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def ensureSizeIsEnough(rows, cols, type, opts) when is_integer(rows) and is_integer(cols) and is_integer(type) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_ensureSizeIsEnough(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec ensureSizeIsEnough(Keyword.t()) :: any() | {:error, String.t()}
  def ensureSizeIsEnough([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:type,:rows,:arr,:cols])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_ensureSizeIsEnough()
    |> to_struct()
  end

  @doc """
  Ensures that the size of a matrix is big enough and the matrix has a proper type.

  ##### Positional Arguments
  - **rows**: `integer()`.

    Minimum desired number of rows.

  - **cols**: `integer()`.

    Minimum desired number of columns.

  - **type**: `integer()`.

    Desired matrix type.

  ##### Return
  - **arr**: `Evision.Mat.t()`.

    Destination matrix.

  The function does not reallocate memory if the matrix has proper attributes already.

  Python prototype (for reference only):
  ```python3
  ensureSizeIsEnough(rows, cols, type[, arr]) -> arr
  ```
  """
  @spec ensureSizeIsEnough(integer(), integer(), integer()) :: Evision.Mat.t() | {:error, String.t()}
  def ensureSizeIsEnough(rows, cols, type) when is_integer(rows) and is_integer(cols) and is_integer(type)
  do
    positional = [
      rows: Evision.Internal.Structurise.from_struct(rows),
      cols: Evision.Internal.Structurise.from_struct(cols),
      type: Evision.Internal.Structurise.from_struct(type)
    ]
    :evision_nif.cuda_ensureSizeIsEnough(positional)
    |> to_struct()
  end

  @doc """
  Perform image denoising using Non-local Means Denoising algorithm
  <http://www.ipol.im/pub/algo/bcm_non_local_means_denoising> with several computational
  optimizations. Noise expected to be a gaussian white noise

  ##### Positional Arguments
  - **src**: `Evision.CUDA.GpuMat.t()`.

    Input 8-bit 1-channel, 2-channel or 3-channel image.

  - **h**: `float`.

    Parameter regulating filter strength. Big h value perfectly removes noise but also
    removes image details, smaller h value preserves details but also preserves some noise

  ##### Keyword Arguments
  - **search_window**: `integer()`.

    Size in pixels of the window that is used to compute weighted average for
    given pixel. Should be odd. Affect performance linearly: greater search_window - greater
    denoising time. Recommended value 21 pixels

  - **block_size**: `integer()`.

    Size in pixels of the template patch that is used to compute weights. Should be
    odd. Recommended value 7 pixels

  - **stream**: `Evision.CUDA.Stream.t()`.

    Stream for the asynchronous invocations.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

    Output image with the same size and type as src .

  This function expected to be applied to grayscale images. For colored images look at
  FastNonLocalMeansDenoising::labMethod.
  @sa
  fastNlMeansDenoising

  Python prototype (for reference only):
  ```python3
  fastNlMeansDenoising(src, h[, dst[, search_window[, block_size[, stream]]]]) -> dst
  ```
  """
  @spec fastNlMeansDenoising(Evision.CUDA.GpuMat.t(), number(), [{:block_size, term()} | {:search_window, term()} | {:stream, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def fastNlMeansDenoising(src, h, opts) when is_struct(src, Evision.CUDA.GpuMat) and is_float(h) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:block_size, :search_window, :stream])
    positional = [
      src: Evision.Internal.Structurise.from_struct(src),
      h: Evision.Internal.Structurise.from_struct(h)
    ]
    :evision_nif.cuda_fastNlMeansDenoising(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec fastNlMeansDenoising(Keyword.t()) :: any() | {:error, String.t()}
  def fastNlMeansDenoising([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:src,:search_window,:dst,:stream,:block_size,:h])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_fastNlMeansDenoising()
    |> to_struct()
  end

  @doc """
  Perform image denoising using Non-local Means Denoising algorithm
  <http://www.ipol.im/pub/algo/bcm_non_local_means_denoising> with several computational
  optimizations. Noise expected to be a gaussian white noise

  ##### Positional Arguments
  - **src**: `Evision.CUDA.GpuMat.t()`.

    Input 8-bit 1-channel, 2-channel or 3-channel image.

  - **h**: `float`.

    Parameter regulating filter strength. Big h value perfectly removes noise but also
    removes image details, smaller h value preserves details but also preserves some noise

  ##### Keyword Arguments
  - **search_window**: `integer()`.

    Size in pixels of the window that is used to compute weighted average for
    given pixel. Should be odd. Affect performance linearly: greater search_window - greater
    denoising time. Recommended value 21 pixels

  - **block_size**: `integer()`.

    Size in pixels of the template patch that is used to compute weights. Should be
    odd. Recommended value 7 pixels

  - **stream**: `Evision.CUDA.Stream.t()`.

    Stream for the asynchronous invocations.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

    Output image with the same size and type as src .

  This function expected to be applied to grayscale images. For colored images look at
  FastNonLocalMeansDenoising::labMethod.
  @sa
  fastNlMeansDenoising

  Python prototype (for reference only):
  ```python3
  fastNlMeansDenoising(src, h[, dst[, search_window[, block_size[, stream]]]]) -> dst
  ```
  """
  @spec fastNlMeansDenoising(Evision.CUDA.GpuMat.t(), number()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def fastNlMeansDenoising(src, h) when is_struct(src, Evision.CUDA.GpuMat) and is_float(h)
  do
    positional = [
      src: Evision.Internal.Structurise.from_struct(src),
      h: Evision.Internal.Structurise.from_struct(h)
    ]
    :evision_nif.cuda_fastNlMeansDenoising(positional)
    |> to_struct()
  end

  @doc """
  Modification of fastNlMeansDenoising function for colored images

  ##### Positional Arguments
  - **src**: `Evision.CUDA.GpuMat.t()`.

    Input 8-bit 3-channel image.

  - **h_luminance**: `float`.

    Parameter regulating filter strength. Big h value perfectly removes noise but
    also removes image details, smaller h value preserves details but also preserves some noise

  - **photo_render**: `float`.

    float The same as h but for color components. For most images value equals 10 will be
    enough to remove colored noise and do not distort colors

  ##### Keyword Arguments
  - **search_window**: `integer()`.

    Size in pixels of the window that is used to compute weighted average for
    given pixel. Should be odd. Affect performance linearly: greater search_window - greater
    denoising time. Recommended value 21 pixels

  - **block_size**: `integer()`.

    Size in pixels of the template patch that is used to compute weights. Should be
    odd. Recommended value 7 pixels

  - **stream**: `Evision.CUDA.Stream.t()`.

    Stream for the asynchronous invocations.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

    Output image with the same size and type as src .

  The function converts image to CIELAB colorspace and then separately denoise L and AB components
  with given h parameters using FastNonLocalMeansDenoising::simpleMethod function.
  @sa
  fastNlMeansDenoisingColored

  Python prototype (for reference only):
  ```python3
  fastNlMeansDenoisingColored(src, h_luminance, photo_render[, dst[, search_window[, block_size[, stream]]]]) -> dst
  ```
  """
  @spec fastNlMeansDenoisingColored(Evision.CUDA.GpuMat.t(), number(), number(), [{:block_size, term()} | {:search_window, term()} | {:stream, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def fastNlMeansDenoisingColored(src, h_luminance, photo_render, opts) when is_struct(src, Evision.CUDA.GpuMat) and is_float(h_luminance) and is_float(photo_render) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:block_size, :search_window, :stream])
    positional = [
      src: Evision.Internal.Structurise.from_struct(src),
      h_luminance: Evision.Internal.Structurise.from_struct(h_luminance),
      photo_render: Evision.Internal.Structurise.from_struct(photo_render)
    ]
    :evision_nif.cuda_fastNlMeansDenoisingColored(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec fastNlMeansDenoisingColored(Keyword.t()) :: any() | {:error, String.t()}
  def fastNlMeansDenoisingColored([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:src,:search_window,:dst,:stream,:photo_render,:h_luminance,:block_size])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_fastNlMeansDenoisingColored()
    |> to_struct()
  end

  @doc """
  Modification of fastNlMeansDenoising function for colored images

  ##### Positional Arguments
  - **src**: `Evision.CUDA.GpuMat.t()`.

    Input 8-bit 3-channel image.

  - **h_luminance**: `float`.

    Parameter regulating filter strength. Big h value perfectly removes noise but
    also removes image details, smaller h value preserves details but also preserves some noise

  - **photo_render**: `float`.

    float The same as h but for color components. For most images value equals 10 will be
    enough to remove colored noise and do not distort colors

  ##### Keyword Arguments
  - **search_window**: `integer()`.

    Size in pixels of the window that is used to compute weighted average for
    given pixel. Should be odd. Affect performance linearly: greater search_window - greater
    denoising time. Recommended value 21 pixels

  - **block_size**: `integer()`.

    Size in pixels of the template patch that is used to compute weights. Should be
    odd. Recommended value 7 pixels

  - **stream**: `Evision.CUDA.Stream.t()`.

    Stream for the asynchronous invocations.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

    Output image with the same size and type as src .

  The function converts image to CIELAB colorspace and then separately denoise L and AB components
  with given h parameters using FastNonLocalMeansDenoising::simpleMethod function.
  @sa
  fastNlMeansDenoisingColored

  Python prototype (for reference only):
  ```python3
  fastNlMeansDenoisingColored(src, h_luminance, photo_render[, dst[, search_window[, block_size[, stream]]]]) -> dst
  ```
  """
  @spec fastNlMeansDenoisingColored(Evision.CUDA.GpuMat.t(), number(), number()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def fastNlMeansDenoisingColored(src, h_luminance, photo_render) when is_struct(src, Evision.CUDA.GpuMat) and is_float(h_luminance) and is_float(photo_render)
  do
    positional = [
      src: Evision.Internal.Structurise.from_struct(src),
      h_luminance: Evision.Internal.Structurise.from_struct(h_luminance),
      photo_render: Evision.Internal.Structurise.from_struct(photo_render)
    ]
    :evision_nif.cuda_fastNlMeansDenoisingColored(positional)
    |> to_struct()
  end
  @spec getCudaEnabledDeviceCount(Keyword.t()) :: any() | {:error, String.t()}
  def getCudaEnabledDeviceCount([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_getCudaEnabledDeviceCount()
    |> to_struct()
  end

  @doc """
  Returns the number of installed CUDA-enabled devices.
  ##### Return
  - **retval**: `integer()`

  Use this function before any other CUDA functions calls. If OpenCV is compiled without CUDA support,
  this function returns 0. If the CUDA driver is not installed, or is incompatible, this function
  returns -1.

  Python prototype (for reference only):
  ```python3
  getCudaEnabledDeviceCount() -> retval
  ```
  """
  @spec getCudaEnabledDeviceCount() :: integer() | {:error, String.t()}
  def getCudaEnabledDeviceCount() do
    positional = [
    ]
    :evision_nif.cuda_getCudaEnabledDeviceCount(positional)
    |> to_struct()
  end
  @spec getDevice(Keyword.t()) :: any() | {:error, String.t()}
  def getDevice([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_getDevice()
    |> to_struct()
  end

  @doc """
  Returns the current device index set by cuda::setDevice or initialized by default.
  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getDevice() -> retval
  ```
  """
  @spec getDevice() :: integer() | {:error, String.t()}
  def getDevice() do
    positional = [
    ]
    :evision_nif.cuda_getDevice(positional)
    |> to_struct()
  end

  @doc """
  Performs pure non local means denoising without any simplification, and thus it is not fast.

  ##### Positional Arguments
  - **src**: `Evision.CUDA.GpuMat.t()`.

    Source image. Supports only CV_8UC1, CV_8UC2 and CV_8UC3.

  - **h**: `float`.

    Filter sigma regulating filter strength for color.

  ##### Keyword Arguments
  - **search_window**: `integer()`.

    Size of search window.

  - **block_size**: `integer()`.

    Size of block used for computing weights.

  - **borderMode**: `integer()`.

    Border type. See borderInterpolate for details. BORDER_REFLECT101 ,
    BORDER_REPLICATE , BORDER_CONSTANT , BORDER_REFLECT and BORDER_WRAP are supported for now.

  - **stream**: `Evision.CUDA.Stream.t()`.

    Stream for the asynchronous version.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

    Destination image.

  @sa
  fastNlMeansDenoising

  Python prototype (for reference only):
  ```python3
  nonLocalMeans(src, h[, dst[, search_window[, block_size[, borderMode[, stream]]]]]) -> dst
  ```
  """
  @spec nonLocalMeans(Evision.CUDA.GpuMat.t(), number(), [{:block_size, term()} | {:borderMode, term()} | {:search_window, term()} | {:stream, term()}] | nil) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def nonLocalMeans(src, h, opts) when is_struct(src, Evision.CUDA.GpuMat) and is_float(h) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    Keyword.validate!(opts || [], [:block_size, :borderMode, :search_window, :stream])
    positional = [
      src: Evision.Internal.Structurise.from_struct(src),
      h: Evision.Internal.Structurise.from_struct(h)
    ]
    :evision_nif.cuda_nonLocalMeans(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec nonLocalMeans(Keyword.t()) :: any() | {:error, String.t()}
  def nonLocalMeans([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:src,:search_window,:dst,:stream,:borderMode,:block_size,:h])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_nonLocalMeans()
    |> to_struct()
  end

  @doc """
  Performs pure non local means denoising without any simplification, and thus it is not fast.

  ##### Positional Arguments
  - **src**: `Evision.CUDA.GpuMat.t()`.

    Source image. Supports only CV_8UC1, CV_8UC2 and CV_8UC3.

  - **h**: `float`.

    Filter sigma regulating filter strength for color.

  ##### Keyword Arguments
  - **search_window**: `integer()`.

    Size of search window.

  - **block_size**: `integer()`.

    Size of block used for computing weights.

  - **borderMode**: `integer()`.

    Border type. See borderInterpolate for details. BORDER_REFLECT101 ,
    BORDER_REPLICATE , BORDER_CONSTANT , BORDER_REFLECT and BORDER_WRAP are supported for now.

  - **stream**: `Evision.CUDA.Stream.t()`.

    Stream for the asynchronous version.

  ##### Return
  - **dst**: `Evision.CUDA.GpuMat.t()`.

    Destination image.

  @sa
  fastNlMeansDenoising

  Python prototype (for reference only):
  ```python3
  nonLocalMeans(src, h[, dst[, search_window[, block_size[, borderMode[, stream]]]]]) -> dst
  ```
  """
  @spec nonLocalMeans(Evision.CUDA.GpuMat.t(), number()) :: Evision.CUDA.GpuMat.t() | {:error, String.t()}
  def nonLocalMeans(src, h) when is_struct(src, Evision.CUDA.GpuMat) and is_float(h)
  do
    positional = [
      src: Evision.Internal.Structurise.from_struct(src),
      h: Evision.Internal.Structurise.from_struct(h)
    ]
    :evision_nif.cuda_nonLocalMeans(positional)
    |> to_struct()
  end

  @doc """
  printCudaDeviceInfo

  ##### Positional Arguments
  - **device**: `integer()`

  Python prototype (for reference only):
  ```python3
  printCudaDeviceInfo(device) -> None
  ```
  """
  @spec printCudaDeviceInfo(Keyword.t()) :: any() | {:error, String.t()}
  def printCudaDeviceInfo([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:device])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_printCudaDeviceInfo()
    |> to_struct()
  end
  @spec printCudaDeviceInfo(integer()) :: :ok | {:error, String.t()}
  def printCudaDeviceInfo(device) when is_integer(device)
  do
    positional = [
      device: Evision.Internal.Structurise.from_struct(device)
    ]
    :evision_nif.cuda_printCudaDeviceInfo(positional)
    |> to_struct()
  end

  @doc """
  printShortCudaDeviceInfo

  ##### Positional Arguments
  - **device**: `integer()`

  Python prototype (for reference only):
  ```python3
  printShortCudaDeviceInfo(device) -> None
  ```
  """
  @spec printShortCudaDeviceInfo(Keyword.t()) :: any() | {:error, String.t()}
  def printShortCudaDeviceInfo([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:device])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_printShortCudaDeviceInfo()
    |> to_struct()
  end
  @spec printShortCudaDeviceInfo(integer()) :: :ok | {:error, String.t()}
  def printShortCudaDeviceInfo(device) when is_integer(device)
  do
    positional = [
      device: Evision.Internal.Structurise.from_struct(device)
    ]
    :evision_nif.cuda_printShortCudaDeviceInfo(positional)
    |> to_struct()
  end

  @doc """
  Page-locks the memory of matrix and maps it for the device(s).

  ##### Positional Arguments
  - **m**: `Evision.Mat`.

    Input matrix.

  Python prototype (for reference only):
  ```python3
  registerPageLocked(m) -> None
  ```
  """
  @spec registerPageLocked(Keyword.t()) :: any() | {:error, String.t()}
  def registerPageLocked([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:m])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_registerPageLocked()
    |> to_struct()
  end
  @spec registerPageLocked(Evision.Mat.maybe_mat_in()) :: :ok | {:error, String.t()}
  def registerPageLocked(m) when (is_struct(m, Evision.Mat) or is_struct(m, Nx.Tensor) or is_number(m) or is_tuple(m))
  do
    positional = [
      m: Evision.Internal.Structurise.from_struct(m)
    ]
    :evision_nif.cuda_registerPageLocked(positional)
    |> to_struct()
  end
  @spec resetDevice(Keyword.t()) :: any() | {:error, String.t()}
  def resetDevice([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_resetDevice()
    |> to_struct()
  end

  @doc """
  Explicitly destroys and cleans up all resources associated with the current device in the current
  process.

  Any subsequent API call to this device will reinitialize the device.

  Python prototype (for reference only):
  ```python3
  resetDevice() -> None
  ```
  """
  @spec resetDevice() :: :ok | {:error, String.t()}
  def resetDevice() do
    positional = [
    ]
    :evision_nif.cuda_resetDevice(positional)
    |> to_struct()
  end
  @spec setBufferPoolConfig(Keyword.t()) :: any() | {:error, String.t()}
  def setBufferPoolConfig([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:stackCount,:deviceId,:stackSize])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_setBufferPoolConfig()
    |> to_struct()
  end

  @doc """
  setBufferPoolConfig

  ##### Positional Arguments
  - **deviceId**: `integer()`
  - **stackSize**: `size_t`
  - **stackCount**: `integer()`

  Python prototype (for reference only):
  ```python3
  setBufferPoolConfig(deviceId, stackSize, stackCount) -> None
  ```
  """
  @spec setBufferPoolConfig(integer(), integer(), integer()) :: :ok | {:error, String.t()}
  def setBufferPoolConfig(deviceId, stackSize, stackCount) when is_integer(deviceId) and is_integer(stackSize) and is_integer(stackCount)
  do
    positional = [
      deviceId: Evision.Internal.Structurise.from_struct(deviceId),
      stackSize: Evision.Internal.Structurise.from_struct(stackSize),
      stackCount: Evision.Internal.Structurise.from_struct(stackCount)
    ]
    :evision_nif.cuda_setBufferPoolConfig(positional)
    |> to_struct()
  end

  @doc """
  setBufferPoolUsage

  ##### Positional Arguments
  - **on**: `bool`

  Python prototype (for reference only):
  ```python3
  setBufferPoolUsage(on) -> None
  ```
  """
  @spec setBufferPoolUsage(Keyword.t()) :: any() | {:error, String.t()}
  def setBufferPoolUsage([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:on])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_setBufferPoolUsage()
    |> to_struct()
  end
  @spec setBufferPoolUsage(boolean()) :: :ok | {:error, String.t()}
  def setBufferPoolUsage(on) when is_boolean(on)
  do
    positional = [
      on: Evision.Internal.Structurise.from_struct(on)
    ]
    :evision_nif.cuda_setBufferPoolUsage(positional)
    |> to_struct()
  end

  @doc """
  Sets a device and initializes it for the current thread.

  ##### Positional Arguments
  - **device**: `integer()`.

    System index of a CUDA device starting with 0.

  If the call of this function is omitted, a default device is initialized at the fist CUDA usage.

  Python prototype (for reference only):
  ```python3
  setDevice(device) -> None
  ```
  """
  @spec setDevice(Keyword.t()) :: any() | {:error, String.t()}
  def setDevice([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:device])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_setDevice()
    |> to_struct()
  end
  @spec setDevice(integer()) :: :ok | {:error, String.t()}
  def setDevice(device) when is_integer(device)
  do
    positional = [
      device: Evision.Internal.Structurise.from_struct(device)
    ]
    :evision_nif.cuda_setDevice(positional)
    |> to_struct()
  end

  @doc """
  Unmaps the memory of matrix and makes it pageable again.

  ##### Positional Arguments
  - **m**: `Evision.Mat`.

    Input matrix.

  Python prototype (for reference only):
  ```python3
  unregisterPageLocked(m) -> None
  ```
  """
  @spec unregisterPageLocked(Keyword.t()) :: any() | {:error, String.t()}
  def unregisterPageLocked([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:m])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_unregisterPageLocked()
    |> to_struct()
  end
  @spec unregisterPageLocked(Evision.Mat.maybe_mat_in()) :: :ok | {:error, String.t()}
  def unregisterPageLocked(m) when (is_struct(m, Evision.Mat) or is_struct(m, Nx.Tensor) or is_number(m) or is_tuple(m))
  do
    positional = [
      m: Evision.Internal.Structurise.from_struct(m)
    ]
    :evision_nif.cuda_unregisterPageLocked(positional)
    |> to_struct()
  end

  @doc """
  Bindings overload to create a Stream object from the address stored in an existing CUDA Runtime API stream pointer (cudaStream_t).

  ##### Positional Arguments
  - **cudaStreamMemoryAddress**: `size_t`.

    Memory address stored in a CUDA Runtime API stream pointer (cudaStream_t). The created Stream object does not perform any allocation or deallocation and simply wraps existing raw CUDA Runtime API stream pointer.

  ##### Return
  - **retval**: `Evision.CUDA.Stream.t()`

  **Note**: Overload for generation of bindings only, not exported or intended for use internally from C++.

  Python prototype (for reference only):
  ```python3
  wrapStream(cudaStreamMemoryAddress) -> retval
  ```
  """
  @spec wrapStream(Keyword.t()) :: any() | {:error, String.t()}
  def wrapStream([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:cudaStreamMemoryAddress])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.cuda_wrapStream()
    |> to_struct()
  end
  @spec wrapStream(integer()) :: Evision.CUDA.Stream.t() | {:error, String.t()}
  def wrapStream(cudaStreamMemoryAddress) when is_integer(cudaStreamMemoryAddress)
  do
    positional = [
      cudaStreamMemoryAddress: Evision.Internal.Structurise.from_struct(cudaStreamMemoryAddress)
    ]
    :evision_nif.cuda_wrapStream(positional)
    |> to_struct()
  end
end
