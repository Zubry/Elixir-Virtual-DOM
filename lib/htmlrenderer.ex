defmodule HTMLRenderer do
  def render_component(node) do
    render(node)
      |> Enum.join("")
  end

  defp render(node) when is_map(node) do
    unless(Map.has_key?(node, :tag_type)) do
      {:error, "No node to render"}
    else
      case node.tag_type do
        :text -> render_text(node)
        _     -> render_node(node)
      end
    end
  end

  defp render(node) when is_list(node) do
    node
      |> Enum.map(fn(e) -> render(e) end)
      |> List.flatten
  end

  defp render_node(node) do
    children = render(node.children)
    {properties, styles} = render_properties(node.properties)

    ["<#{node.tag_name} #{properties} style=\"#{styles}\">"]
    ++ children
    ++ ["</#{node.tag_name}>"]
  end

  defp render_text(node) do
    [node.text_content]
  end

  defp render_properties(properties) do
    styles = if(Map.has_key?(properties, :style)) do
        properties.style
          |> Map.to_list
          |> Enum.map(fn(prop) ->
              {key, val} = prop
              "#{key}: #{val};"
            end)
          |> Enum.join(" ")
      else
        ""
      end

    props = properties
      |> Map.delete(:style)
      |> Map.to_list
      |> Enum.map(fn(prop) ->
          {key, val} = prop
          "#{key}=\"#{val}\""
         end)
      |> Enum.join(" ")

    {props, styles}
  end
end
