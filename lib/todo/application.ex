defmodule Todo.Application do
  use Application

  # minimum callback for Application
  # _type : always ignored
  # _args : passed by mix.exs
  def start(_type, _args) do
    Todo.System.start_link()
  end
end
