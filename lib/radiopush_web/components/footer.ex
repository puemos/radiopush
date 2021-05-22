defmodule RadiopushWeb.Components.Footer do
  use Surface.Component

  alias Surface.Components.{
    Link
  }

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="relative mt-8 mb-12 pt-4">
      <div class="border-t-2 border-gray-700 border-opacity-30">
        <div class="flex flex-col items-center">
          <div class="flex flex-row items-center space-x-2">
            <span class="">
              <Link to={{"/legal"}} class="text-white hover:text-gray-100 py-2 rounded-md text-sm font-medium">
                Legal
              </Link>
            </span>
            <span class="text-gray-500"> </span>
            <span class="my-2">
              <Link to={{"mailto:radiopush.app@gmail.com"}} class="text-white hover:text-gray-100 py-2 rounded-md text-sm font-medium">
                Contact
              </Link>
            </span>
          </div>
          <div class="text-center py-2">
            <p class="text-sm text-gray-300 mb-2">
              © 2021 Made with 🎶 by <a class="sp-underline primary hover:text-white" href="https://github.com/puemos">Shy Alter</a>
            </p>
          </div>
        </div>
      </div>
    </footer>

    """
  end
end
