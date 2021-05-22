defmodule RadiopushWeb.Pages.Legal do
  use RadiopushWeb, :surface_view_helpers

  alias RadiopushWeb.Components.{
    PrivacyPolicy,
    TermsAndConditions,
    Page
  }

  data active_tab, :string,
    default: "terms_and_conditions",
    values: ["terms_and_conditions", "privacy_policy"]

  @impl true
  def render(assigns) do
    ~H"""
      <Page current_user={{nil}} path={{@path}}>
        <div>
          <nav class="flex flex-row mb-4 border-b border-gray-700 pb-2">
            <button :on-click="set_active_tab" phx-value-tab="terms_and_conditions" class={{"outline-none focus:outline-none text-white font-semibold", "text-primary-400": @active_tab == "terms_and_conditions"}}>
              Terms and conditions
            </button>
            <div class="mx-2"><span>•</span></div>
            <button :on-click="set_active_tab" phx-value-tab="privacy_policy" class={{"outline-none focus:outline-none text-white font-semibold", "text-primary-400": @active_tab == "privacy_policy"}}>
              Privacy Policy
            </button>
          </nav>
          <PrivacyPolicy :if={{@active_tab == "privacy_policy"}} />
          <TermsAndConditions :if={{@active_tab == "terms_and_conditions"}} />
        </div>
      </Page>
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
