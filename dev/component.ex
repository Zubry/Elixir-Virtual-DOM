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

File.write("dev/comment.html", component)
