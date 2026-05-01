defmodule Evision.TickMeter do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `TickMeter` struct.

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
  def to_struct({:ok, %{class: Evision.TickMeter, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.TickMeter, ref: ref}) do
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
  @spec tickMeter(Keyword.t()) :: any() | {:error, String.t()}
  def tickMeter([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_TickMeter()
    |> to_struct()
  end

  @doc """
  TickMeter
  ##### Return
  - **self**: `Evision.TickMeter.t()`

  Python prototype (for reference only):
  ```python3
  TickMeter() -> <TickMeter object>
  ```
  """
  @spec tickMeter() :: Evision.TickMeter.t() | {:error, String.t()}
  def tickMeter() do
    positional = [
    ]
    :evision_nif.tickMeter_TickMeter(positional)
    |> to_struct()
  end

  @doc """
  getAvgTimeMilli

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getAvgTimeMilli() -> retval
  ```
  """
  @spec getAvgTimeMilli(Keyword.t()) :: any() | {:error, String.t()}
  def getAvgTimeMilli([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getAvgTimeMilli()
    |> to_struct()
  end
  @spec getAvgTimeMilli(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getAvgTimeMilli(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getAvgTimeMilli(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getAvgTimeSec

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getAvgTimeSec() -> retval
  ```
  """
  @spec getAvgTimeSec(Keyword.t()) :: any() | {:error, String.t()}
  def getAvgTimeSec([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getAvgTimeSec()
    |> to_struct()
  end
  @spec getAvgTimeSec(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getAvgTimeSec(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getAvgTimeSec(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getCounter

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `int64`

  Python prototype (for reference only):
  ```python3
  getCounter() -> retval
  ```
  """
  @spec getCounter(Keyword.t()) :: any() | {:error, String.t()}
  def getCounter([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getCounter()
    |> to_struct()
  end
  @spec getCounter(Evision.TickMeter.t()) :: integer() | {:error, String.t()}
  def getCounter(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getCounter(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getFPS

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getFPS() -> retval
  ```
  """
  @spec getFPS(Keyword.t()) :: any() | {:error, String.t()}
  def getFPS([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getFPS()
    |> to_struct()
  end
  @spec getFPS(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getFPS(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getFPS(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getLastTimeMicro

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getLastTimeMicro() -> retval
  ```
  """
  @spec getLastTimeMicro(Keyword.t()) :: any() | {:error, String.t()}
  def getLastTimeMicro([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getLastTimeMicro()
    |> to_struct()
  end
  @spec getLastTimeMicro(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getLastTimeMicro(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getLastTimeMicro(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getLastTimeMilli

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getLastTimeMilli() -> retval
  ```
  """
  @spec getLastTimeMilli(Keyword.t()) :: any() | {:error, String.t()}
  def getLastTimeMilli([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getLastTimeMilli()
    |> to_struct()
  end
  @spec getLastTimeMilli(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getLastTimeMilli(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getLastTimeMilli(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getLastTimeSec

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getLastTimeSec() -> retval
  ```
  """
  @spec getLastTimeSec(Keyword.t()) :: any() | {:error, String.t()}
  def getLastTimeSec([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getLastTimeSec()
    |> to_struct()
  end
  @spec getLastTimeSec(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getLastTimeSec(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getLastTimeSec(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getLastTimeTicks

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `int64`

  Python prototype (for reference only):
  ```python3
  getLastTimeTicks() -> retval
  ```
  """
  @spec getLastTimeTicks(Keyword.t()) :: any() | {:error, String.t()}
  def getLastTimeTicks([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getLastTimeTicks()
    |> to_struct()
  end
  @spec getLastTimeTicks(Evision.TickMeter.t()) :: integer() | {:error, String.t()}
  def getLastTimeTicks(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getLastTimeTicks(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTimeMicro

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getTimeMicro() -> retval
  ```
  """
  @spec getTimeMicro(Keyword.t()) :: any() | {:error, String.t()}
  def getTimeMicro([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getTimeMicro()
    |> to_struct()
  end
  @spec getTimeMicro(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getTimeMicro(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getTimeMicro(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTimeMilli

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getTimeMilli() -> retval
  ```
  """
  @spec getTimeMilli(Keyword.t()) :: any() | {:error, String.t()}
  def getTimeMilli([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getTimeMilli()
    |> to_struct()
  end
  @spec getTimeMilli(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getTimeMilli(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getTimeMilli(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTimeSec

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getTimeSec() -> retval
  ```
  """
  @spec getTimeSec(Keyword.t()) :: any() | {:error, String.t()}
  def getTimeSec([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getTimeSec()
    |> to_struct()
  end
  @spec getTimeSec(Evision.TickMeter.t()) :: number() | {:error, String.t()}
  def getTimeSec(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getTimeSec(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getTimeTicks

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  ##### Return
  - **retval**: `int64`

  Python prototype (for reference only):
  ```python3
  getTimeTicks() -> retval
  ```
  """
  @spec getTimeTicks(Keyword.t()) :: any() | {:error, String.t()}
  def getTimeTicks([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_getTimeTicks()
    |> to_struct()
  end
  @spec getTimeTicks(Evision.TickMeter.t()) :: integer() | {:error, String.t()}
  def getTimeTicks(self) do
    positional = [
    ]
    :evision_nif.tickMeter_getTimeTicks(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  reset

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  Python prototype (for reference only):
  ```python3
  reset() -> None
  ```
  """
  @spec reset(Keyword.t()) :: any() | {:error, String.t()}
  def reset([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_reset()
    |> to_struct()
  end
  @spec reset(Evision.TickMeter.t()) :: Evision.TickMeter.t() | {:error, String.t()}
  def reset(self) do
    positional = [
    ]
    :evision_nif.tickMeter_reset(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  start

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  Python prototype (for reference only):
  ```python3
  start() -> None
  ```
  """
  @spec start(Keyword.t()) :: any() | {:error, String.t()}
  def start([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_start()
    |> to_struct()
  end
  @spec start(Evision.TickMeter.t()) :: Evision.TickMeter.t() | {:error, String.t()}
  def start(self) do
    positional = [
    ]
    :evision_nif.tickMeter_start(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  stop

  ##### Positional Arguments
  - **self**: `Evision.TickMeter.t()`

  Python prototype (for reference only):
  ```python3
  stop() -> None
  ```
  """
  @spec stop(Keyword.t()) :: any() | {:error, String.t()}
  def stop([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.tickMeter_stop()
    |> to_struct()
  end
  @spec stop(Evision.TickMeter.t()) :: Evision.TickMeter.t() | {:error, String.t()}
  def stop(self) do
    positional = [
    ]
    :evision_nif.tickMeter_stop(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
