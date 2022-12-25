# frozen_string_literal: true

module Api
  module V1
    # Api controller to interact with the projects context
    class ProjectsController < ApiController
      before_action :set_project, only: %i[show edit update destroy get_project_financial_values]

      # GET /projects or /projects.json
      def index
        @projects = Project.all
        render json: @projects
      end

      # GET /projects/1 or /projects/1.json
      def show; end

      # GET /projects/new
      def new
        @project = Project.new
      end

      # GET /projects/1/edit
      def edit; end

      # POST /projects or /projects.json
      def create
        @project = Project.create(project_params)

        render json: @project, status: :created
      end

      # PATCH/PUT /projects/1 or /projects/1.json
      def update
        respond_to do |format|
          if @project.update(project_params)
            format.html { redirect_to project_url(@project), notice: 'Project was successfully updated.' }
            format.json { render :show, status: :ok, location: @project }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @project.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /projects/1 or /projects/1.json
      def destroy
        @project.destroy

        respond_to do |format|
          format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      def get_project_financial_values
        coeficients = {
          'Barracão, lig. Provisórias, projetos': 3.5,
          'Infraestrututra (estacas, brocas, baldrames, sapatas)': 5,
          'Supraestrutura (vigas, pilares, cintas, escadas)': 15,
          'Paredes e Painéis': 8,
          Esquadrias: 9,
          'Vidros e Plásticos': 1,
          'Coberturas (estrutura e telhas)': 7,
          Impermeabilizações: 4,
          'Revestimentos Internos': 8,
          Forros: 1,
          'Revestimentos Externos': 4.5,
          Pisos: 9,
          Pinturas: 6,
          'Acabamentos (soleiras, rodapes, peitoril, etc.)': 1.2,
          'Instalações Elétricas e Telefônicas': 4,
          'Instalações Hidráulicas': 4,
          'Instalações: Esgoto e Águas Pluviais': 4,
          'Louças e Metais': 4.5,
          'Complementos - limpeza geral e calafete': 1.3,
          'Custo total': 100
        }

        padrao = {
          Baixo: 2257.09,
          Normal: 2274.49,
          Alto: 2612.98
        }

        total_cost = @project.area.sum * padrao[@project.type.to_sym]

        @project_financial_values = {}

        coeficients.each do |key, value|
          value = number_to_currency_br((total_cost * (value.to_f / 100)).round(2))
          @project_financial_values[key] = value
        end

        render json: @project_financial_values
      end

      private

      def number_to_currency_br(number)
        ActionController::Base.helpers.number_to_currency(number, unit: 'R$ ', separator: ',',
                                                                  delimiter: '.')
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def project_params
        params.require(:project).permit(:owner_name, :address, :floors, :type, :platibanda,
                                        :start_date, :duration, :financial_institution, :contract_date, area: [])
      end
    end
  end
end
