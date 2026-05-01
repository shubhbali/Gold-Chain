defmodule Evision.Reg.MapProjec do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Reg.MapProjec` struct.

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
  def to_struct({:ok, %{class: Evision.Reg.MapProjec, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Reg.MapProjec, ref: ref}) do
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
  MapProjec

  ##### Positional Arguments
  - **projTr**: `Evision.Mat`

  ##### Return
  - **self**: `MapProjec`

  Python prototype (for reference only):
  ```python3
  MapProjec(projTr) -> <reg_MapProjec object>
  ```
  """
  @spec mapProjec(Keyword.t()) :: any() | {:error, String.t()}
  def mapProjec([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:projTr])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_MapProjec()
    |> to_struct()
  end
  @spec mapProjec(Evision.Mat.maybe_mat_in()) :: Evision.Reg.MapProjec.t() | {:error, String.t()}
  def mapProjec(projTr) when (is_struct(projTr, Evision.Mat) or is_struct(projTr, Nx.Tensor) or is_number(projTr) or is_tuple(projTr))
  do
    positional = [
      projTr: Evision.Internal.Structurise.from_struct(projTr)
    ]
    :evision_nif.reg_reg_MapProjec_MapProjec(positional)
    |> to_struct()
  end

  @doc """
  MapProjec
  ##### Return
  - **self**: `MapProjec`

  Python prototype (for reference only):
  ```python3
  MapProjec() -> <reg_MapProjec object>
  ```
  """
  @spec mapProjec() :: Evision.Reg.MapProjec.t() | {:error, String.t()}
  def mapProjec() do
    positional = [
    ]
    :evision_nif.reg_reg_MapProjec_MapProjec(positional)
    |> to_struct()
  end
  @spec compose(Keyword.t()) :: any() | {:error, String.t()}
  def compose([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:map])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_compose()
    |> to_struct()
  end

  @doc """
  compose

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`
  - **map**: `Map`

  Python prototype (for reference only):
  ```python3
  compose(map) -> None
  ```
  """
  @spec compose(Evision.Reg.MapProjec.t(), Evision.Reg.Map.t()) :: Evision.Reg.MapProjec.t() | {:error, String.t()}
  def compose(self, map) when is_struct(map, Evision.Reg.Map)
  do
    positional = [
      map: Evision.Internal.Structurise.from_struct(map)
    ]
    :evision_nif.reg_reg_MapProjec_compose(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getProjTr

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`

  ##### Return
  - **projTr**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  getProjTr([, projTr]) -> projTr
  ```
  """
  @spec getProjTr(Evision.Reg.MapProjec.t(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def getProjTr(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.reg_reg_MapProjec_getProjTr(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  getProjTr

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`

  ##### Return
  - **projTr**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  getProjTr([, projTr]) -> projTr
  ```
  """
  @spec getProjTr(Keyword.t()) :: any() | {:error, String.t()}
  def getProjTr([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:projTr])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_getProjTr()
    |> to_struct()
  end
  @spec getProjTr(Evision.Reg.MapProjec.t()) :: Evision.Mat.t() | {:error, String.t()}
  def getProjTr(self) do
    positional = [
    ]
    :evision_nif.reg_reg_MapProjec_getProjTr(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  inverseMap

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`

  ##### Return
  - **retval**: `cv::Ptr<Map>`

  Python prototype (for reference only):
  ```python3
  inverseMap() -> retval
  ```
  """
  @spec inverseMap(Keyword.t()) :: any() | {:error, String.t()}
  def inverseMap([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_inverseMap()
    |> to_struct()
  end
  @spec inverseMap(Evision.Reg.MapProjec.t()) :: Evision.Reg.Map.t() | {:error, String.t()}
  def inverseMap(self) do
    positional = [
    ]
    :evision_nif.reg_reg_MapProjec_inverseMap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  inverseWarp

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  inverseWarp(img1[, img2]) -> img2
  ```
  """
  @spec inverseWarp(Evision.Reg.MapProjec.t(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def inverseWarp(self, img1, opts) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_MapProjec_inverseWarp(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec inverseWarp(Keyword.t()) :: any() | {:error, String.t()}
  def inverseWarp([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:img1,:img2])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_inverseWarp()
    |> to_struct()
  end

  @doc """
  inverseWarp

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  inverseWarp(img1[, img2]) -> img2
  ```
  """
  @spec inverseWarp(Evision.Reg.MapProjec.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def inverseWarp(self, img1) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_MapProjec_inverseWarp(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  normalize

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`

  Python prototype (for reference only):
  ```python3
  normalize() -> None
  ```
  """
  @spec normalize(Keyword.t()) :: any() | {:error, String.t()}
  def normalize([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_normalize()
    |> to_struct()
  end
  @spec normalize(Evision.Reg.MapProjec.t()) :: Evision.Reg.MapProjec.t() | {:error, String.t()}
  def normalize(self) do
    positional = [
    ]
    :evision_nif.reg_reg_MapProjec_normalize(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec scale(Keyword.t()) :: any() | {:error, String.t()}
  def scale([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:factor])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_scale()
    |> to_struct()
  end

  @doc """
  scale

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`
  - **factor**: `double`

  Python prototype (for reference only):
  ```python3
  scale(factor) -> None
  ```
  """
  @spec scale(Evision.Reg.MapProjec.t(), number()) :: Evision.Reg.MapProjec.t() | {:error, String.t()}
  def scale(self, factor) when is_number(factor)
  do
    positional = [
      factor: Evision.Internal.Structurise.from_struct(factor)
    ]
    :evision_nif.reg_reg_MapProjec_scale(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  warp

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  warp(img1[, img2]) -> img2
  ```
  """
  @spec warp(Evision.Reg.MapProjec.t(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def warp(self, img1, opts) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_MapProjec_warp(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec warp(Keyword.t()) :: any() | {:error, String.t()}
  def warp([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:img1,:img2])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_MapProjec_warp()
    |> to_struct()
  end

  @doc """
  warp

  ##### Positional Arguments
  - **self**: `Evision.Reg.MapProjec.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  warp(img1[, img2]) -> img2
  ```
  """
  @spec warp(Evision.Reg.MapProjec.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def warp(self, img1) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_MapProjec_warp(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
