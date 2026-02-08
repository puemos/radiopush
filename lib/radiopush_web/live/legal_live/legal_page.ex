defmodule RadiopushWeb.Pages.Legal do
  use RadiopushWeb, :live_view

  alias RadiopushWeb.Components.{
    PrivacyPolicy,
    TermsAndConditions,
    Page
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :active_tab, "terms_and_conditions")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Page.render current_user={nil} path={@path}>
      <div>
        <nav class="flex flex-row mb-4 border-b border-gray-700 pb-2">
          <button
            phx-click="set_active_tab"
            phx-value-tab="terms_and_conditions"
            class={[
              "outline-none focus:outline-none text-white font-semibold",
              @active_tab == "terms_and_conditions" && "text-primary-400"
            ]}
          >
            Terms and conditions
          </button>
          <div class="mx-2"><span>•</span></div>
          <button
            phx-click="set_active_tab"
            phx-value-tab="privacy_policy"
            class={[
              "outline-none focus:outline-none text-white font-semibold",
              @active_tab == "privacy_policy" && "text-primary-400"
            ]}
          >
            Privacy Policy
          </button>
        </nav>
        <PrivacyPolicy.render :if={@active_tab == "privacy_policy"} />
        <TermsAndConditions.render :if={@active_tab == "terms_and_conditions"} />
      </div>
    </Page.render>
    """
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{
      path: path
    } = URI.parse(uri)

    socket =
      socket
      |> assign(path: path)

    {:noreply, socket}
  end

  @impl true
  def handle_event("set_active_tab", %{"tab" => tab}, socket) do
    socket =
      socket
      |> assign(:active_tab, tab)

    {:noreply, socket}
  end
end
