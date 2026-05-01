defmodule Evision.Reg.Map do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Reg.Map` struct.

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
  def to_struct({:ok, %{class: Evision.Reg.Map, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Reg.Map, ref: ref}) do
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
  @spec compose(Keyword.t()) :: any() | {:error, String.t()}
  def compose([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:map])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_Map_compose()
    |> to_struct()
  end

  @doc """
  compose

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`
  - **map**: `Map`

  Python prototype (for reference only):
  ```python3
  compose(map) -> None
  ```
  """
  @spec compose(Evision.Reg.Map.t(), Evision.Reg.Map.t()) :: Evision.Reg.Map.t() | {:error, String.t()}
  def compose(self, map) when is_struct(map, Evision.Reg.Map)
  do
    positional = [
      map: Evision.Internal.Structurise.from_struct(map)
    ]
    :evision_nif.reg_reg_Map_compose(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  inverseMap

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`

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
    |> :evision_nif.reg_reg_Map_inverseMap()
    |> to_struct()
  end
  @spec inverseMap(Evision.Reg.Map.t()) :: Evision.Reg.Map.t() | {:error, String.t()}
  def inverseMap(self) do
    positional = [
    ]
    :evision_nif.reg_reg_Map_inverseMap(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  inverseWarp

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  inverseWarp(img1[, img2]) -> img2
  ```
  """
  @spec inverseWarp(Evision.Reg.Map.t(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def inverseWarp(self, img1, opts) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_Map_inverseWarp(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec inverseWarp(Keyword.t()) :: any() | {:error, String.t()}
  def inverseWarp([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:img1,:img2])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_Map_inverseWarp()
    |> to_struct()
  end

  @doc """
  inverseWarp

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  inverseWarp(img1[, img2]) -> img2
  ```
  """
  @spec inverseWarp(Evision.Reg.Map.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def inverseWarp(self, img1) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_Map_inverseWarp(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec scale(Keyword.t()) :: any() | {:error, String.t()}
  def scale([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:factor])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_Map_scale()
    |> to_struct()
  end

  @doc """
  scale

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`
  - **factor**: `double`

  Python prototype (for reference only):
  ```python3
  scale(factor) -> None
  ```
  """
  @spec scale(Evision.Reg.Map.t(), number()) :: Evision.Reg.Map.t() | {:error, String.t()}
  def scale(self, factor) when is_number(factor)
  do
    positional = [
      factor: Evision.Internal.Structurise.from_struct(factor)
    ]
    :evision_nif.reg_reg_Map_scale(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  warp

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  warp(img1[, img2]) -> img2
  ```
  """
  @spec warp(Evision.Reg.Map.t(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def warp(self, img1, opts) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_Map_warp(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec warp(Keyword.t()) :: any() | {:error, String.t()}
  def warp([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:img1,:img2])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.reg_reg_Map_warp()
    |> to_struct()
  end

  @doc """
  warp

  ##### Positional Arguments
  - **self**: `Evision.Reg.Map.t()`
  - **img1**: `Evision.Mat`

  ##### Return
  - **img2**: `Evision.Mat.t()`.

  Python prototype (for reference only):
  ```python3
  warp(img1[, img2]) -> img2
  ```
  """
  @spec warp(Evision.Reg.Map.t(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def warp(self, img1) when (is_struct(img1, Evision.Mat) or is_struct(img1, Nx.Tensor) or is_number(img1) or is_tuple(img1))
  do
    positional = [
      img1: Evision.Internal.Structurise.from_struct(img1)
    ]
    :evision_nif.reg_reg_Map_warp(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
