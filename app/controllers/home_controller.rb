# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render inertia: 'projects/index', props: {
      projects:
      [
        {
          name: 'Lima Engenharia'
        }
      ]
    }
  end
end
