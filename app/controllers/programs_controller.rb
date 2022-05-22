class ProgramsController < ApplicationController
  def index
    programs = Program.where(school_id: params[:school_id])
    if programs.empty?
      raise ActiveRecord::RecordNotFound.new 'record not found'
    else
      @pagy, @record = pagy(programs)
      render json: @record, status: :ok
    end
  end

  def create
    school = School.find_by!(id: params[:school_id])
    program = Program.new(program_params)
    program.school = school
    program.save!
    render json: program, status: :created
  end

  def show
    program = Program.find_by!(id: params[:id], school_id: params[:school_id])
    render json: program, status: :ok
  end

  private

  def program_params
    params.require(:program).permit(:title)
  end
end
