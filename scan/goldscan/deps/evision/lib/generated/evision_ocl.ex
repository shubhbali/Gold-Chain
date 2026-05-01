defmodule Evision.OCL do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `OCL` struct.

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
  def to_struct({:ok, %{class: Evision.OCL, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.OCL, ref: ref}) do
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
  @spec finish(Keyword.t()) :: any() | {:error, String.t()}
  def finish([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_finish()
    |> to_struct()
  end

  @doc """
  finish

  Python prototype (for reference only):
  ```python3
  finish() -> None
  ```
  """
  @spec finish() :: :ok | {:error, String.t()}
  def finish() do
    positional = [
    ]
    :evision_nif.ocl_finish(positional)
    |> to_struct()
  end
  @spec haveAmdBlas(Keyword.t()) :: any() | {:error, String.t()}
  def haveAmdBlas([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_haveAmdBlas()
    |> to_struct()
  end

  @doc """
  haveAmdBlas
  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  haveAmdBlas() -> retval
  ```
  """
  @spec haveAmdBlas() :: boolean() | {:error, String.t()}
  def haveAmdBlas() do
    positional = [
    ]
    :evision_nif.ocl_haveAmdBlas(positional)
    |> to_struct()
  end
  @spec haveAmdFft(Keyword.t()) :: any() | {:error, String.t()}
  def haveAmdFft([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_haveAmdFft()
    |> to_struct()
  end

  @doc """
  haveAmdFft
  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  haveAmdFft() -> retval
  ```
  """
  @spec haveAmdFft() :: boolean() | {:error, String.t()}
  def haveAmdFft() do
    positional = [
    ]
    :evision_nif.ocl_haveAmdFft(positional)
    |> to_struct()
  end
  @spec haveOpenCL(Keyword.t()) :: any() | {:error, String.t()}
  def haveOpenCL([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_haveOpenCL()
    |> to_struct()
  end

  @doc """
  haveOpenCL
  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  haveOpenCL() -> retval
  ```
  """
  @spec haveOpenCL() :: boolean() | {:error, String.t()}
  def haveOpenCL() do
    positional = [
    ]
    :evision_nif.ocl_haveOpenCL(positional)
    |> to_struct()
  end

  @doc """
  setUseOpenCL

  ##### Positional Arguments
  - **flag**: `bool`

  Python prototype (for reference only):
  ```python3
  setUseOpenCL(flag) -> None
  ```
  """
  @spec setUseOpenCL(Keyword.t()) :: any() | {:error, String.t()}
  def setUseOpenCL([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:flag])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_setUseOpenCL()
    |> to_struct()
  end
  @spec setUseOpenCL(boolean()) :: :ok | {:error, String.t()}
  def setUseOpenCL(flag) when is_boolean(flag)
  do
    positional = [
      flag: Evision.Internal.Structurise.from_struct(flag)
    ]
    :evision_nif.ocl_setUseOpenCL(positional)
    |> to_struct()
  end
  @spec useOpenCL(Keyword.t()) :: any() | {:error, String.t()}
  def useOpenCL([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.ocl_useOpenCL()
    |> to_struct()
  end

  @doc """
  useOpenCL
  ##### Return
  - **retval**: `bool`

  Python prototype (for reference only):
  ```python3
  useOpenCL() -> retval
  ```
  """
  @spec useOpenCL() :: boolean() | {:error, String.t()}
  def useOpenCL() do
    positional = [
    ]
    :evision_nif.ocl_useOpenCL(positional)
    |> to_struct()
  end
end
