# render = fn(count) ->
#   IO.puts "Rendering..."
#
#   counter = VirtualDOM.component('div', %{
#     style: %{
#       textAlign: 'center',
#       lineHeight: '#{100 + count}px',
#       border: '1px solid red',
#       width: '#{100 + count}px',
#       height: '#{100 + count}px'
#     }
#   }, count)
#
#   wrapper = VirtualDOM.component('div', %{
#     "data-href": "//www.google.com/"
#   }, ["hey", counter])
# end
#
# component = render.(6)
#   |> Renderer.render_component
#
# File.write("test.html", component)
