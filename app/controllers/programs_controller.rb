class ProgramsController < ApplicationController
  def index
    school = School.find_by!(id: params[:school_id])
    programs = school.programs
    @pagy, @record = pagy(programs)
    render json: @record, status: :ok
  end

  def create
    school = School.find_by!(id: params[:school_id])
    program = Program.new(program_params)
    program.school = school
    program.save!
    render json: program, status: :created
  end

  def show
    if params.has_key? :id
      program = Program.find_by!(id: params[:id])
      render json: program, include: 'school', status: :ok
    else
      programs = Program.all
      @pagy, @record = pagy(programs)
      render json: @record, include: 'school',status: :ok
    end
  end

  private

  def program_params
    params.require(:program).permit(:title)
  end
end
