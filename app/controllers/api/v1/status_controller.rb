module Api
  module V1
    class StatusController < ApiController
      def index
        @status = Status.all
        render json: @status
      end
    end
  end
end
