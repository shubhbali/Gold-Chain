defmodule Evision.Alphamat do
  import Kernel, except: [apply: 2, apply: 3]

  @typedoc """
  Type that represents an `Alphamat` struct.

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
  def to_struct({:ok, %{class: Evision.Alphamat, ref: ref}}) do
    {:ok, %T{ref: ref}}
  end

  @doc false
  def to_struct(%{class: Evision.Alphamat, ref: ref}) do
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
  Compute alpha matte of an object in an image

  ##### Positional Arguments
  - **image**: `Evision.Mat`.

    Input RGB image

  - **tmap**: `Evision.Mat`.

    Input greyscale trimap image

  ##### Return
  - **result**: `Evision.Mat.t()`.

    Output alpha matte image

   The function infoFlow performs alpha matting on a RGB image using a greyscale trimap image, and outputs a greyscale alpha matte image. The output alpha matte can be used to softly extract the foreground object from a background image. Examples can be found in the samples directory.

  Python prototype (for reference only):
  ```python3
  infoFlow(image, tmap[, result]) -> result
  ```
  """
  @spec infoFlow(Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in(), [{atom(), term()},...] | nil) :: Evision.Mat.t() | {:error, String.t()}
  def infoFlow(image, tmap, opts) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(tmap, Evision.Mat) or is_struct(tmap, Nx.Tensor) or is_number(tmap) or is_tuple(tmap)) and (opts == nil or (is_list(opts) and is_tuple(hd(opts))))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      tmap: Evision.Internal.Structurise.from_struct(tmap)
    ]
    :evision_nif.alphamat_infoFlow(positional ++ Evision.Internal.Structurise.from_struct(opts || []))
     |> to_struct()
  end
  @spec infoFlow(Keyword.t()) :: any() | {:error, String.t()}
  def infoFlow([{arg, _} | _] = named_args) when is_atom(arg) do
    named_args = Keyword.validate!(named_args, [:result,:image,:tmap])
    Enum.map(named_args, fn {named_arg, value} -> {named_arg, Evision.Internal.Structurise.from_struct(value)} end)
    |> :evision_nif.alphamat_infoFlow()
    |> to_struct()
  end

  @doc """
  Compute alpha matte of an object in an image

  ##### Positional Arguments
  - **image**: `Evision.Mat`.

    Input RGB image

  - **tmap**: `Evision.Mat`.

    Input greyscale trimap image

  ##### Return
  - **result**: `Evision.Mat.t()`.

    Output alpha matte image

   The function infoFlow performs alpha matting on a RGB image using a greyscale trimap image, and outputs a greyscale alpha matte image. The output alpha matte can be used to softly extract the foreground object from a background image. Examples can be found in the samples directory.

  Python prototype (for reference only):
  ```python3
  infoFlow(image, tmap[, result]) -> result
  ```
  """
  @spec infoFlow(Evision.Mat.maybe_mat_in(), Evision.Mat.maybe_mat_in()) :: Evision.Mat.t() | {:error, String.t()}
  def infoFlow(image, tmap) when (is_struct(image, Evision.Mat) or is_struct(image, Nx.Tensor) or is_number(image) or is_tuple(image)) and (is_struct(tmap, Evision.Mat) or is_struct(tmap, Nx.Tensor) or is_number(tmap) or is_tuple(tmap))
  do
    positional = [
      image: Evision.Internal.Structurise.from_struct(image),
      tmap: Evision.Internal.Structurise.from_struct(tmap)
    ]
    :evision_nif.alphamat_infoFlow(positional)
    |> to_struct()
  end
end
