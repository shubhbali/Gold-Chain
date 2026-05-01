defmodule Evision.Animation do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Animation` struct.

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
  def to_struct({:ok, %{class: Evision.Animation, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Animation, ref: ref}) do
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
  @spec get_bgcolor(Evision.Animation.t()) :: Evision.scalar()
  def get_bgcolor(self) do
    :evision_nif.animation_get_bgcolor(Evision.Internal.Structurise.from_struct(self))
    |> to_struct()
  end
  @spec set_bgcolor(Evision.Animation.t(), Evision.scalar()) :: Evision.Animation.t()
  def set_bgcolor(self, prop) do
    :evision_nif.animation_set_bgcolor(
        Evision.Internal.Structurise.from_struct(self),
        [bgcolor: Evision.Internal.Structurise.from_struct(prop)]
    )
    |> to_struct()
  end
  @spec get_durations(Evision.Animation.t()) :: list(integer())
  def get_durations(self) do
    :evision_nif.animation_get_durations(Evision.Internal.Structurise.from_struct(self))
    |> to_struct()
  end
  @spec set_durations(Evision.Animation.t(), list(integer())) :: Evision.Animation.t()
  def set_durations(self, prop) do
    :evision_nif.animation_set_durations(
        Evision.Internal.Structurise.from_struct(self),
        [durations: Evision.Internal.Structurise.from_struct(prop)]
    )
    |> to_struct()
  end
  @spec get_frames(Evision.Animation.t()) :: list(Evision.Mat.t())
  def get_frames(self) do
    :evision_nif.animation_get_frames(Evision.Internal.Structurise.from_struct(self))
    |> to_struct()
  end
  @spec set_frames(Evision.Animation.t(), list(Evision.Mat.maybe_mat_in())) :: Evision.Animation.t()
  def set_frames(self, prop) do
    :evision_nif.animation_set_frames(
        Evision.Internal.Structurise.from_struct(self),
        [frames: Evision.Internal.Structurise.from_struct(prop)]
    )
    |> to_struct()
  end
  @spec get_loop_count(Evision.Animation.t()) :: integer()
  def get_loop_count(self) do
    :evision_nif.animation_get_loop_count(Evision.Internal.Structurise.from_struct(self))
    |> to_struct()
  end
  @spec set_loop_count(Evision.Animation.t(), integer()) :: Evision.Animation.t()
  def set_loop_count(self, prop) do
    :evision_nif.animation_set_loop_count(
        Evision.Internal.Structurise.from_struct(self),
        [loop_count: Evision.Internal.Structurise.from_struct(prop)]
    )
    |> to_struct()
  end
end
