defmodule Evision.Detail.GainCompensator do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Detail.GainCompensator` struct.

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
  def to_struct({:ok, %{class: Evision.Detail.GainCompensator, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Detail.GainCompensator, ref: ref}) do
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
  GainCompensator

  ##### Positional Arguments
  - **nr_feeds**: `integer()`

  ##### Return
  - **self**: `Evision.Detail.GainCompensator.t()`

  Python prototype (for reference only):
  ```python3
  GainCompensator(nr_feeds) -> <detail_GainCompensator object>
  ```
  """
  @spec gainCompensator(Keyword.t()) :: any() | {:error, String.t()}
  def gainCompensator([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nr_feeds])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_GainCompensator()
    |> to_struct()
  end
  @spec gainCompensator(integer()) :: Evision.Detail.GainCompensator.t() | {:error, String.t()}
  def gainCompensator(nr_feeds) when is_integer(nr_feeds)
  do
    positional = [
      nr_feeds: Evision.Internal.Structurise.from_struct(nr_feeds)
    ]
    :evision_nif.detail_detail_GainCompensator_GainCompensator(positional)
    |> to_struct()
  end

  @doc """
  GainCompensator
  ##### Return
  - **self**: `Evision.Detail.GainCompensator.t()`

  Python prototype (for reference only):
  ```python3
  GainCompensator() -> <detail_GainCompensator object>
  ```
  """
  @spec gainCompensator() :: Evision.Detail.GainCompensator.t() | {:error, String.t()}
  def gainCompensator() do
    positional = [
    ]
    :evision_nif.detail_detail_GainCompensator_GainCompensator(positional)
    |> to_struct()
  end
  @spec apply(Keyword.t()) :: any() | {:error, String.t()}
  def apply([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:mask,:corner,:image,:index])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_apply()
    |> to_struct()
  end

  @doc """
  apply

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`
  - **index**: `integer()`
  - **corner**: `Point`
  - **mask**: `Evision.Mat`

  ##### Return
  - **image**: `Evision.Mat.t()`

  Python prototype (for reference only):
  ```python3
  apply(index, corner, image, mask) -> image
  ```
  """
  @spec apply(Evision.Detail.GainCompensator.t(), integer(), {number(), number()}, Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def apply(self, index, corner, image, mask) when is_integer(index) and is_tuple(corner) and (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(mask, Evision.Mat) or is_struct(mask, Nx.Tensor) or is_number(mask) or is_tuple(mask))
  do
    positional = [
      index: Evision.Internal.Structurise.from_struct(index),
      corner: Evision.Internal.Structurise.from_struct(corner),
      image: Evision.Internal.Structurise.from_struct(image),
      mask: Evision.Internal.Structurise.from_struct(mask)
    ]
    :evision_nif.detail_detail_GainCompensator_apply(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getMatGains

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`

  ##### Return
  - **umv**: `[Evision.Mat]`.

  Python prototype (for reference only):
  ```python3
  getMatGains([, umv]) -> umv
  ```
  """
  @spec getMatGains(Evision.Detail.GainCompensator.t(), [{atom(), term()},...] | nil) :: list(Evision.Mat.t()) | {:error, String.t()}
  def getMatGains(self, opts) when opts == nil or (is_list(opts) and is_tuple(hd(opts)))
  do
    positional = [
    ]
    :evision_nif.detail_detail_GainCompensator_getMatGains(Evision.Internal.Structurise.from_struct(self), positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end

  @doc """
  getMatGains

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`

  ##### Return
  - **umv**: `[Evision.Mat]`.

  Python prototype (for reference only):
  ```python3
  getMatGains([, umv]) -> umv
  ```
  """
  @spec getMatGains(Keyword.t()) :: any() | {:error, String.t()}
  def getMatGains([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:umv])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_getMatGains()
    |> to_struct()
  end
  @spec getMatGains(Evision.Detail.GainCompensator.t()) :: list(Evision.Mat.t()) | {:error, String.t()}
  def getMatGains(self) do
    positional = [
    ]
    :evision_nif.detail_detail_GainCompensator_getMatGains(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getNrFeeds

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`

  ##### Return
  - **retval**: `integer()`

  Python prototype (for reference only):
  ```python3
  getNrFeeds() -> retval
  ```
  """
  @spec getNrFeeds(Keyword.t()) :: any() | {:error, String.t()}
  def getNrFeeds([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_getNrFeeds()
    |> to_struct()
  end
  @spec getNrFeeds(Evision.Detail.GainCompensator.t()) :: integer() | {:error, String.t()}
  def getNrFeeds(self) do
    positional = [
    ]
    :evision_nif.detail_detail_GainCompensator_getNrFeeds(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end

  @doc """
  getSimilarityThreshold

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`

  ##### Return
  - **retval**: `double`

  Python prototype (for reference only):
  ```python3
  getSimilarityThreshold() -> retval
  ```
  """
  @spec getSimilarityThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def getSimilarityThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_getSimilarityThreshold()
    |> to_struct()
  end
  @spec getSimilarityThreshold(Evision.Detail.GainCompensator.t()) :: number() | {:error, String.t()}
  def getSimilarityThreshold(self) do
    positional = [
    ]
    :evision_nif.detail_detail_GainCompensator_getSimilarityThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setMatGains(Keyword.t()) :: any() | {:error, String.t()}
  def setMatGains([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:umv])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_setMatGains()
    |> to_struct()
  end

  @doc """
  setMatGains

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`
  - **umv**: `[Evision.Mat]`

  Python prototype (for reference only):
  ```python3
  setMatGains(umv) -> None
  ```
  """
  @spec setMatGains(Evision.Detail.GainCompensator.t(), list(Evision.Mat.maybe_mat_in())) :: Evision.Detail.GainCompensator.t() | {:error, String.t()}
  def setMatGains(self, umv) when is_list(umv)
  do
    positional = [
      umv: Evision.Internal.Structurise.from_struct(umv)
    ]
    :evision_nif.detail_detail_GainCompensator_setMatGains(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setNrFeeds(Keyword.t()) :: any() | {:error, String.t()}
  def setNrFeeds([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:nr_feeds])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_setNrFeeds()
    |> to_struct()
  end

  @doc """
  setNrFeeds

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`
  - **nr_feeds**: `integer()`

  Python prototype (for reference only):
  ```python3
  setNrFeeds(nr_feeds) -> None
  ```
  """
  @spec setNrFeeds(Evision.Detail.GainCompensator.t(), integer()) :: Evision.Detail.GainCompensator.t() | {:error, String.t()}
  def setNrFeeds(self, nr_feeds) when is_integer(nr_feeds)
  do
    positional = [
      nr_feeds: Evision.Internal.Structurise.from_struct(nr_feeds)
    ]
    :evision_nif.detail_detail_GainCompensator_setNrFeeds(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
  @spec setSimilarityThreshold(Keyword.t()) :: any() | {:error, String.t()}
  def setSimilarityThreshold([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:similarity_threshold])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.detail_detail_GainCompensator_setSimilarityThreshold()
    |> to_struct()
  end

  @doc """
  setSimilarityThreshold

  ##### Positional Arguments
  - **self**: `Evision.Detail.GainCompensator.t()`
  - **similarity_threshold**: `double`

  Python prototype (for reference only):
  ```python3
  setSimilarityThreshold(similarity_threshold) -> None
  ```
  """
  @spec setSimilarityThreshold(Evision.Detail.GainCompensator.t(), number()) :: Evision.Detail.GainCompensator.t() | {:error, String.t()}
  def setSimilarityThreshold(self, similarity_threshold) when is_number(similarity_threshold)
  do
    positional = [
      similarity_threshold: Evision.Internal.Structurise.from_struct(similarity_threshold)
    ]
    :evision_nif.detail_detail_GainCompensator_setSimilarityThreshold(Evision.Internal.Structurise.from_struct(self), positional)
    |> to_struct()
  end
end
