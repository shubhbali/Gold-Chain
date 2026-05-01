defmodule Evision.XImgProc.EdgeBoxes do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `XImgProc.EdgeBoxes` struct.

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
  def to_struct({:ok, %{class: Evision.XImgProc.EdgeBoxes, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.XImgProc.EdgeBoxes, ref: ref}) do
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
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  Python prototype (for reference only):
  ```python3
  clear() -> None
  ```
  """
  @spec clear(Keyword.t()) :: any() | {:error, String.t()}
  def clear([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_EdgeBoxes_clear()
    |> to_struct()
  end
  @spec clear(Evision.XImgProc.EdgeBoxes.t()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def clear(self) do
    positional = [
    ]
    :evision_nif.ximgproc_EdgeBoxes_clear(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns true if the Algorithm is empty (e.g. in the very beginning or after unsuccessful read

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

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
    |> :evision_nif.ximgproc_EdgeBoxes_empty()
    |> to_struct()
  end
  @spec empty(Evision.XImgProc.EdgeBoxes.t()) :: boolean() | {:error, String.t()}
  def empty(self) do
    positional = [
    ]
    :evision_nif.ximgproc_EdgeBoxes_empty(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the step size of sliding window search.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getAlpha() -> retval
  ```
  """
  @spec getAlpha(Keyword.t()) :: any() | {:error, String.t()}
  def getAlpha([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getAlpha()
    |> to_struct()
  end
  @spec getAlpha(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getAlpha(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getAlpha(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the nms threshold for object proposals.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getBeta() -> retval
  ```
  """
  @spec getBeta(Keyword.t()) :: any() | {:error, String.t()}
  def getBeta([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getBeta()
    |> to_struct()
  end
  @spec getBeta(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getBeta(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getBeta(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns array containing proposal boxes.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **edge_map**: `Evision.Mat`.

    edge image.

  - **orientation_map**: `Evision.Mat`.

    orientation map.

  ##### Return
  - **boxes**: `[Rect]`.

    proposal boxes.

  - **scores**: `Evision.Mat.t()`.

    of the proposal boxes, provided a vector of float types.

  Python prototype (for reference only):
  ```python3
  getBoundingBoxes(edge_map, orientation_map[, scores]) -> boxes, scores
  ```
  """
  @spec getBoundingBoxes(Evision.XImgProc.EdgeBoxes.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: {list({number(), number(), number(), number()}), Evision.Mat.t()} | {:error, String.t()}
  def getBoundingBoxes(self, edge_map, orientation_map, opts) when (is_struct(edge_map, Evision.Mat) or is_struct(edge_map, Nx.Tensor) or is_number(edge_map) or is_tuple(edge_map)) and (is_struct(orientation_map, Evision.Mat) or is_struct(orientation_map, Nx.Tensor) or is_number(orientation_map) or is_tuple(orientation_map)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      edge_map: Evision.Internal.Structurise.from_struct(edge_map),
      orientation_map: Evision.Internal.Structurise.from_struct(orientation_map)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getBoundingBoxes(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec getBoundingBoxes(Keyword.t()) :: any() | {:error, String.t()}
  def getBoundingBoxes([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:orientation_map,:boxes,:scores,:edge_map])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getBoundingBoxes()
    |> to_struct()
  end

  @doc """
  Returns array containing proposal boxes.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **edge_map**: `Evision.Mat`.

    edge image.

  - **orientation_map**: `Evision.Mat`.

    orientation map.

  ##### Return
  - **boxes**: `[Rect]`.

    proposal boxes.

  - **scores**: `Evision.Mat.t()`.

    of the proposal boxes, provided a vector of float types.

  Python prototype (for reference only):
  ```python3
  getBoundingBoxes(edge_map, orientation_map[, scores]) -> boxes, scores
  ```
  """
  @spec getBoundingBoxes(Evision.XImgProc.EdgeBoxes.t(), Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: {list({number(), number(), number(), number()}), Evision.Mat.t()} | {:error, String.t()}
  def getBoundingBoxes(self, edge_map, orientation_map) when (is_struct(edge_map, Evision.Mat) or is_struct(edge_map, Nx.Tensor) or is_number(edge_map) or is_tuple(edge_map)) and (is_struct(orientation_map, Evision.Mat) or is_struct(orientation_map, Nx.Tensor) or is_number(orientation_map) or is_tuple(orientation_map))
  do
    positional = [
      edge_map: Evision.Internal.Structurise.from_struct(edge_map),
      orientation_map: Evision.Internal.Structurise.from_struct(orientation_map)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getBoundingBoxes(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the cluster min magnitude.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getClusterMinMag() -> retval
  ```
  """
  @spec getClusterMinMag(Keyword.t()) :: any() | {:error, String.t()}
  def getClusterMinMag([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getClusterMinMag()
    |> to_struct()
  end
  @spec getClusterMinMag(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getClusterMinMag(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getClusterMinMag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getDefaultName

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

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
    |> :evision_nif.ximgproc_EdgeBoxes_getDefaultName()
    |> to_struct()
  end
  @spec getDefaultName(Evision.XImgProc.EdgeBoxes.t()) :: binary() | {:error, String.t()}
  def getDefaultName(self) do
    positional = [
    ]
    :evision_nif.ximgproc_EdgeBoxes_getDefaultName(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the edge merge threshold.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getEdgeMergeThr() -> retval
  ```
  """
  @spec getEdgeMergeThr(Keyword.t()) :: any() | {:error, String.t()}
  def getEdgeMergeThr([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getEdgeMergeThr()
    |> to_struct()
  end
  @spec getEdgeMergeThr(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getEdgeMergeThr(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getEdgeMergeThr(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the edge min magnitude.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getEdgeMinMag() -> retval
  ```
  """
  @spec getEdgeMinMag(Keyword.t()) :: any() | {:error, String.t()}
  def getEdgeMinMag([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getEdgeMinMag()
    |> to_struct()
  end
  @spec getEdgeMinMag(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getEdgeMinMag(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getEdgeMinMag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns adaptation rate for nms threshold.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getEta() -> retval
  ```
  """
  @spec getEta(Keyword.t()) :: any() | {:error, String.t()}
  def getEta([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getEta()
    |> to_struct()
  end
  @spec getEta(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getEta(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getEta(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the affinity sensitivity.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getGamma() -> retval
  ```
  """
  @spec getGamma(Keyword.t()) :: any() | {:error, String.t()}
  def getGamma([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getGamma()
    |> to_struct()
  end
  @spec getGamma(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getGamma(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getGamma(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the scale sensitivity.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getKappa() -> retval
  ```
  """
  @spec getKappa(Keyword.t()) :: any() | {:error, String.t()}
  def getKappa([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getKappa()
    |> to_struct()
  end
  @spec getKappa(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getKappa(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getKappa(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the max aspect ratio of boxes.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getMaxAspectRatio() -> retval
  ```
  """
  @spec getMaxAspectRatio(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxAspectRatio([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMaxAspectRatio()
    |> to_struct()
  end
  @spec getMaxAspectRatio(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getMaxAspectRatio(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMaxAspectRatio(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the max number of boxes to detect.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getMaxBoxes() -> retval
  ```
  """
  @spec getMaxBoxes(Keyword.t()) :: any() | {:error, String.t()}
  def getMaxBoxes([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMaxBoxes()
    |> to_struct()
  end
  @spec getMaxBoxes(Evision.XImgProc.EdgeBoxes.t()) :: integer() | {:error, String.t()}
  def getMaxBoxes(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMaxBoxes(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the minimum area of boxes.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getMinBoxArea() -> retval
  ```
  """
  @spec getMinBoxArea(Keyword.t()) :: any() | {:error, String.t()}
  def getMinBoxArea([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMinBoxArea()
    |> to_struct()
  end
  @spec getMinBoxArea(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getMinBoxArea(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMinBoxArea(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Returns the min score of boxes to detect.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`

  ##### Return
  - **retval**: `float`

  Python prototype (for reference only):
  ```python3
  getMinScore() -> retval
  ```
  """
  @spec getMinScore(Keyword.t()) :: any() | {:error, String.t()}
  def getMinScore([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMinScore()
    |> to_struct()
  end
  @spec getMinScore(Evision.XImgProc.EdgeBoxes.t()) :: number() | {:error, String.t()}
  def getMinScore(self) do
    positional = [
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_getMinScore(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec read(Keyword.t()) :: any() | {:error, String.t()}
  def read([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fn])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_EdgeBoxes_read()
    |> to_struct()
  end

  @doc """
  Reads algorithm parameters from a file storage

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **func**: `Evision.FileNode`

  Python prototype (for reference only):
  ```python3
  read(fn) -> None
  ```
  """
  @spec read(Evision.XImgProc.EdgeBoxes.t(), Evision.FileNode.t()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def read(self, func) when is_struct(func, Evision.FileNode)
  do
    positional = [
      func: Evision.Internal.Structurise.from_struct(func)
    ]
    :evision_nif.ximgproc_EdgeBoxes_read(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec save(Keyword.t()) :: any() | {:error, String.t()}
  def save([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:filename])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_EdgeBoxes_save()
    |> to_struct()
  end

  @doc """
  save

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **filename**: `String`

  Saves the algorithm to a file.
  In order to make this method work, the derived class must implement Algorithm::write(FileStorage& fs).

  Python prototype (for reference only):
  ```python3
  save(filename) -> None
  ```
  """
  @spec save(Evision.XImgProc.EdgeBoxes.t(), binary()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def save(self, filename) when is_binary(filename)
  do
    positional = [
      filename: Evision.Internal.Structurise.from_struct(filename)
    ]
    :evision_nif.ximgproc_EdgeBoxes_save(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setAlpha(Keyword.t()) :: any() | {:error, String.t()}
  def setAlpha([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setAlpha()
    |> to_struct()
  end

  @doc """
  Sets the step size of sliding window search.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setAlpha(value) -> None
  ```
  """
  @spec setAlpha(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setAlpha(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setAlpha(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setBeta(Keyword.t()) :: any() | {:error, String.t()}
  def setBeta([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setBeta()
    |> to_struct()
  end

  @doc """
  Sets the nms threshold for object proposals.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setBeta(value) -> None
  ```
  """
  @spec setBeta(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setBeta(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setBeta(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setClusterMinMag(Keyword.t()) :: any() | {:error, String.t()}
  def setClusterMinMag([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setClusterMinMag()
    |> to_struct()
  end

  @doc """
  Sets the cluster min magnitude.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setClusterMinMag(value) -> None
  ```
  """
  @spec setClusterMinMag(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setClusterMinMag(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setClusterMinMag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setEdgeMergeThr(Keyword.t()) :: any() | {:error, String.t()}
  def setEdgeMergeThr([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setEdgeMergeThr()
    |> to_struct()
  end

  @doc """
  Sets the edge merge threshold.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setEdgeMergeThr(value) -> None
  ```
  """
  @spec setEdgeMergeThr(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setEdgeMergeThr(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setEdgeMergeThr(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setEdgeMinMag(Keyword.t()) :: any() | {:error, String.t()}
  def setEdgeMinMag([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setEdgeMinMag()
    |> to_struct()
  end

  @doc """
  Sets the edge min magnitude.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setEdgeMinMag(value) -> None
  ```
  """
  @spec setEdgeMinMag(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setEdgeMinMag(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setEdgeMinMag(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setEta(Keyword.t()) :: any() | {:error, String.t()}
  def setEta([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setEta()
    |> to_struct()
  end

  @doc """
  Sets the adaptation rate for nms threshold.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setEta(value) -> None
  ```
  """
  @spec setEta(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setEta(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setEta(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setGamma(Keyword.t()) :: any() | {:error, String.t()}
  def setGamma([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setGamma()
    |> to_struct()
  end

  @doc """
  Sets the affinity sensitivity

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setGamma(value) -> None
  ```
  """
  @spec setGamma(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setGamma(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setGamma(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setKappa(Keyword.t()) :: any() | {:error, String.t()}
  def setKappa([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setKappa()
    |> to_struct()
  end

  @doc """
  Sets the scale sensitivity.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setKappa(value) -> None
  ```
  """
  @spec setKappa(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setKappa(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setKappa(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxAspectRatio(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxAspectRatio([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMaxAspectRatio()
    |> to_struct()
  end

  @doc """
  Sets the max aspect ratio of boxes.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setMaxAspectRatio(value) -> None
  ```
  """
  @spec setMaxAspectRatio(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setMaxAspectRatio(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMaxAspectRatio(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMaxBoxes(Keyword.t()) :: any() | {:error, String.t()}
  def setMaxBoxes([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMaxBoxes()
    |> to_struct()
  end

  @doc """
  Sets max number of boxes to detect.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `integer()`

  Python prototype (for reference only):
  ```python3
  setMaxBoxes(value) -> None
  ```
  """
  @spec setMaxBoxes(Evision.XImgProc.EdgeBoxes.t(), integer()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setMaxBoxes(self, value) when is_integer(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMaxBoxes(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinBoxArea(Keyword.t()) :: any() | {:error, String.t()}
  def setMinBoxArea([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMinBoxArea()
    |> to_struct()
  end

  @doc """
  Sets the minimum area of boxes.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setMinBoxArea(value) -> None
  ```
  """
  @spec setMinBoxArea(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setMinBoxArea(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMinBoxArea(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMinScore(Keyword.t()) :: any() | {:error, String.t()}
  def setMinScore([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:value])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMinScore()
    |> to_struct()
  end

  @doc """
  Sets the min score of boxes to detect.

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **value**: `float`

  Python prototype (for reference only):
  ```python3
  setMinScore(value) -> None
  ```
  """
  @spec setMinScore(Evision.XImgProc.EdgeBoxes.t(), number()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def setMinScore(self, value) when is_float(value)
  do
    positional = [
      value: Evision.Internal.Structurise.from_struct(value)
    ]
    :evision_nif.ximgproc_ximgproc_EdgeBoxes_setMinScore(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec write(Keyword.t()) :: any() | {:error, String.t()}
  def write([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:fs,:name])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ximgproc_EdgeBoxes_write()
    |> to_struct()
  end

  @doc """
  write

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **fs**: `Evision.FileStorage`
  - **name**: `String`

  Has overloading in C++

  Python prototype (for reference only):
  ```python3
  write(fs, name) -> None
  ```
  """
  @spec write(Evision.XImgProc.EdgeBoxes.t(), Evision.FileStorage.t(), binary()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def write(self, fs, name) when is_struct(fs, Evision.FileStorage) and is_binary(name)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs),
      name: Evision.Internal.Structurise.from_struct(name)
    ]
    :evision_nif.ximgproc_EdgeBoxes_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  Stores algorithm parameters in a file storage

  ##### Positional Arguments
  - **self**: `Evision.XImgProc.EdgeBoxes.t()`
  - **fs**: `Evision.FileStorage`

  Python prototype (for reference only):
  ```python3
  write(fs) -> None
  ```
  """
  @spec write(Evision.XImgProc.EdgeBoxes.t(), Evision.FileStorage.t()) :: Evision.XImgProc.EdgeBoxes.t() | {:error, String.t()}
  def write(self, fs) when is_struct(fs, Evision.FileStorage)
  do
    positional = [
      fs: Evision.Internal.Structurise.from_struct(fs)
    ]
    :evision_nif.ximgproc_EdgeBoxes_write(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
