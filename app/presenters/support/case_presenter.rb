# TODO: remove :nocov: and start testing
# :nocov:
module Support
  class CasePresenter < SimpleDelegator
    def state
      super.upcase
    end

    def category
      super.upcase
    end

    def last_updated
      super.strftime("%e %B %Y")
    end

    def organisation
      super.capitalize
    end
  end
end
# :nocov: