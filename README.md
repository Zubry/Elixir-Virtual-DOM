# VirtualDOM

Implementation of a virtual Document Object Model in Elixir

## What is this?

Virtual DOM is a representation of the Document Object Model (the tree-like structure that represents an HTML document) popularized by React.js that is adjacent to the Document Object Model itself. A key feature of the VDOM is that it is immutable by design, which enables functional-style programming in the browser, server, or any environment where it is necessary to interact with the DOM. This is accomplished by rendering the VDOM from the top down, so that a call to `render({x, y})` always yields the same tree structure. In order to make changes to the VDOM, for example if the programmer wants to render the view with `y+1` instead of `y`, a call must be made to `render({x, y + 1})`, and then the two trees must be `diff`ed and then patched together using standard DOM operations.

Although this process is more complex at face value, it ensures that any mutable state is interacted with deliberately, which eliminates an entire class of bugs. There's also no notion of the "find an element and mutate it" pattern that is typical of non-virtual DOM use. Instead, the state is modified, and then propogated to the view by a call to some rendering function.

## What features are currently implemented?

Right now, the only features avaiable are virtual DOM generation and rendering to HTML. In the future, users will be able to load data (such as from a database) when the component is mounted.

Because Elixir is not meant to run in a browser environment, `diff` and `patch` functions will not be implemented. Instead, render components to HTML to use as front-end templates.

## Example

This example creates a component that displays a comment.

```Elixir
defmodule ComponentComment do
  import VirtualDOM

  def render(props) do
    component("comment", %{
      style: %{
        "display": "block",
        "padding": ".5em",
        "background-color": "#F5F5F5",
        "border": "1px solid #E8E8E8",
        "font-family": "sans-serif"
      }
    }, [
      ComponentCommentInfo.render(%{
        username: props.username,
        points: props.points,
        date: props.date
      }),
      ComponentCommentBody.render(%{
        body: props.body
      }),
      ComponentCommentFooter.render(%{
        id: props.id
      })
    ])
  end
end

defmodule ComponentCommentInfo do
  import VirtualDOM

  def render(props) do
    component("comment-info", %{
      style: %{
        "display": "block",
        "font-size": ".8em"
      }
    }, [
      component("a", %{
        href: "/u/#{props.username}/",
        style: %{
          "text-decoration": "none",
          "color": "#3366CC"
        }
      }, props.username),
      ComponentPoints.render(%{
        points: props.points
      }),
      ComponentDate.render(%{
        date: props.date
      })
    ])
  end
end

defmodule ComponentPoints do
  import VirtualDOM

  def render(props) do
    component("points", %{
      style: %{
        "font-weight": "bold"
      }
    }, [
      " #{props.points} points"
    ])
  end
end

defmodule ComponentDate do
  import VirtualDOM

  def render(props) do
    component("date", %{
      style: %{
        "opacity": "0.8"
      }
    }, [
      " #{props.date}"
    ])
  end
end

defmodule ComponentCommentBody do
  import VirtualDOM

  def render(props) do
    component("comment-body", %{
      style: %{
        "display": "block",
        "padding": ".5em",
        "text-indent": "1em",
        "font-size": ".9em"
      }
    }, [
      props.body
    ])
  end
end

defmodule ComponentCommentFooter do
  import VirtualDOM

  def render(props) do
    component("comment-footer", %{
      style: %{
        "display": "block"
      }
    }, [
      component("a", %{
        href: "/comments/#{props.id}/",
        style: %{
          "text-decoration": "none",
          "color": "#3366CC",
          "font-size": ".8em"
        }
      }, ["Permalink"]),
      component("a", %{
        href: "/save/#{props.id}/",
        style: %{
          "text-decoration": "none",
          "color": "#3366CC",
          "font-size": ".8em"
        }
      }, [" Save"]),
      component("a", %{
        href: "/reply/#{props.id}/",
        style: %{
          "text-decoration": "none",
          "color": "#3366CC",
          "font-size": ".8em"
        }
      }, [" Reply"])
    ])
  end
end

comment = %{
  username: "Zubry",
  points: 4,
  date: "2/29/16",
  body: "Virtual DOM is a representation of the Document Object Model (the tree-like structure that represents an HTML document) popularized by React.js that is adjacent to the Document Object Model itself. A key feature of the VDOM is that it is immutable by design, which enables functional-style programming in the browser, server, or any environment where it is necessary to interact with the DOM. This is accomplished by rendering the VDOM from the top down, so that a call to render({x, y}) always yields the same tree structure. In order to make changes to the VDOM, for example if the programmer wants to render the view with y+1 instead of y, a call must be made to render({x, y + 1}), and then the two trees must be diffed and then patched together using standard DOM operations.",
  id: "8e8fbz"
}

component = ComponentComment.render(comment)
  |> HTMLRenderer.render_component
```

Rendered output (beautified):

```html
<comment style="background-color: #F5F5F5; border: 1px solid #E8E8E8; display: block; font-family: sans-serif; padding: .5em;">
  <comment-info style="display: block; font-size: .8em;"><a href="/u/Zubry/" style="color: #3366CC; text-decoration: none;">Zubry</a>
    <points style="font-weight: bold;"> 4 points</points>
    <date style="opacity: 0.8;"> 2/29/16</date>
  </comment-info>
  <comment-body style="display: block; font-size: .9em; padding: .5em; text-indent: 1em;">Virtual DOM is a representation of the Document Object Model (the tree-like structure that represents an HTML document) popularized by React.js that is adjacent to the Document Object Model itself. A key feature of the VDOM is that it is immutable by design, which enables functional-style programming in the browser, server, or any environment where it is necessary to interact with the DOM. This is accomplished by rendering the VDOM from the top down, so that a call to render({x, y}) always yields the same tree structure. In order to make changes to the VDOM, for example if the programmer wants to render the view with y+1 instead of y, a call must be made to render({x, y + 1}), and then the two trees must be diffed and then patched together using standard DOM operations.</comment-body>
  <comment-footer style="display: block;"><a href="/comments/8e8fbz/" style="color: #3366CC; font-size: .8em; text-decoration: none;">Permalink</a><a href="/save/8e8fbz/" style="color: #3366CC; font-size: .8em; text-decoration: none;"> Save</a><a href="/reply/8e8fbz/" style="color: #3366CC; font-size: .8em; text-decoration: none;"> Reply</a>
  </comment-footer>
</comment>
```
