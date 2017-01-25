class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  def index
    if comments_permitted_to_show?
      comments = Comment.where event_id: params[:event_id]
      render json: comments
    else
      render json: { error: "Access denied"}
    end
  end

  # GET /comments/1
  def show
    if comment_permitted_to_edit_or_delete?
      render json: @comment
    else
      render json: { error: "Access denied"}
    end
  end
  # POST /comments
  def create
    comment = current_user.comments.create permitted_comment_params
    if comment
      comment.update event_id: params[:event_id]
      render json: comment
    else
      render json: { error: comment.errors }
    end
  end

  # PATCH/PUT /comments/1
  def update
    if comment_permitted_to_edit_or_delete?
      if @comment.update(permitted_comment_params)
        render json: @comment
      else
        render json: { error: @comment.errors }
      end
    else
      render json: { error: "Access denied"}
    end
  end

  # DELETE /comments/1
  def destroy
    if comment_permitted_to_edit_or_delete?
      @comment.destroy
      render json: { data: {message: "Successfuly deleted"} }
    else
      render json: { error: "Access denied"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by_id params[:id]
      unless @comment
        render json: { error: "Not found" }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_comment_params
      params.require(:comment).permit(:content)
    end
    # Check whether user is event's participant
    def comments_permitted_to_show?
      current_user.events.map(&:id).include? params[:event_id].to_i
    end
    # Check whether user is a creator of the comment
    def comment_permitted_to_edit_or_delete?
      current_user.id == @comment.user_id
    end
end
