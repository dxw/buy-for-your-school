# TODO: remove :nocov: and start testing
# :nocov:
module Support
    #class CasesController < ApplicationController
    class CasesController < ActionController::Base
      def index
        @cases = Support::Cases::Index.new.call
      end

      def show
        @case = Support::Cases::Show.new(id: sanitised_id).call
      end

      def update
      end

      private
      
      def sanitised_id
        params[:id]
      end
    end
  end
  # :nocov: