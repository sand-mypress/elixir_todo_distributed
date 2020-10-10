# Todo.System supervisor
#   |- Todo.ProcessRegistry worker

defmodule Todo.ProcessRegistry do
  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def child_spec(_) do
    Supervisor.child_spec(  # child_spec(module_or_map, overrides)
      Registry,             # Registry.child_spec & overrides
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
      # keyword list
      # [{:id, __MODULE__}, {:start, {__MODULE__, :start_link, []}}]
    )
  end

  def via_tuple(key) do
    # {:via, Registry, {registry_name, process_key}}
    {:via, Registry, {__MODULE__, key}}
  end
end
