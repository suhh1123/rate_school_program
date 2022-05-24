class CommentsController < ApplicationController
  before_action :authenticate_user, only: [:create]

  def index
    program = Program.find_by!(id: params[:program_id])
    comments = program.comments
    @pagy, @record = pagy(comments)
    render json: @record, include: 'user', status: :ok
  end

  def create
    program = Program.find_by!(id: params[:program_id])
    comment = Comment.new(comment_params)
    comment.program = program
    comment.user = @current_user
    comment.save!
    render json: comment, include: ['user', 'program'], status: :created
  end

  def show
    if params[:id]
      comment = Comment.find_by!(id: params[:id])
      render json: comment, include: 'user', status: :ok
    else
      comments = Comment.all
      @pagy, @record = pagy(comments)
      render json: @record, include: ['user', 'program'], status: :ok
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content)
  end
end
