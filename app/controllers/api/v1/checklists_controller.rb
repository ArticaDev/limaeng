module Api
  module V1
    class ChecklistsController < ApiController
      def index
        @checklists = Checklist.all
        render json: @checklists
      end
    end
  end
end
