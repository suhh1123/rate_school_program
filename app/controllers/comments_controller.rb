class CommentsController < ApplicationController
  before_action :authenticate_user, scope: :create

  def index
    program = Program.find_by!(id: params[:program_id])
    comments = program.comments
    @pagy, @record = pagy(comments)
    render json: @record, status: :ok
  end

  def create
    program = Program.find_by!(id: params[:program_id])
    comment = Comment.new(comment_params)
    comment.program = program
    comment.user = @current_user
    comment.save!
    render json: comment, status: :created
  end

  def show
    if params[:id]
      comment = Comment.find_by!(id: params[:id])
      render json: comment, status: :ok
    else
      comments = Comment.all
      @pagy, @record = pagy(comments)
      render json: @record, status: :ok
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content)
  end
end
