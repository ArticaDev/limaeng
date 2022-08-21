class ProjectsController < ApplicationController
  def index
    render inertia: 'projects/index', props:{
      projects:
      [
        { 
          name: 'Lima Engenharia'
        }
      ]
    }
  end
end
