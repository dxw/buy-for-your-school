# TODO: remove :nocov: and start testing
# :nocov:
module Support
  class InteractionPresenter < SimpleDelegator
    def created_at
      super.strftime("%e %B %Y")
    end
  end
end
# :nocov: