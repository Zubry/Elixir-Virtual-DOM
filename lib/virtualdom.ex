defmodule VirtualDOM do
  def component(name, properties) do
    component(name, properties, [])
  end

  def component(name, properties, children) do
    {:ok, child_nodes} = addChild(children, name, properties)

    vnode(name, properties, [] ++ child_nodes)
  end

  defp vnode(name, properties, children) do
    %{
      :tag_type => :node,
      :tag_name => name,
      :properties => properties,
      :children => children
    }
  end

  defp vtext(text) do
    %{
      :tag_type => :text,
      :tag_name => :text_element,
      :properties => %{},
      :children => [],
      :text_content => text
    }
  end

  defp unknownnode(name, properties, children) do
    %{
      :message => "Unknown element, make sure the children passed to VirtualDOM.component are a valid type",
      :children => children,
      :parent => vnode(name, properties, nil)
    }
  end

  defp addChild(children, _, _) when is_bitstring(children) do
    {:ok, vtext(children)}
  end

  defp addChild(children, n, p) when is_number(children) do
    to_string(children)
      |> addChild(n, p)
  end

  defp addChild(children, n, p) when is_list(children) do
    {
      :ok,
      children
        |> Enum.map(fn(c) ->
          {:ok, child} = addChild(c, n, p)
          child
        end)
    }
  end

  defp addChild(children, _, _) when is_nil(children) do
    {:ok, nil}
  end

  defp addChild(children, n, p) when is_map(children) do
    unless(Map.has_key?(children, :tag_type)) do
      {:error, unknownnode(n, p, children)}
    else
      {:ok, children}
    end
  end

  defp addChild(children, name, properties) do
    {:error, unknownnode(name, properties, children)}
  end
end
