class CommentsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_comment, only: [:update, :destroy]

  # GET /comments
  def index
    if comments_permitted_for_user?
      @comments = Comment.where event_id: params[:event_id]
      render json: @comments
    else
      render json: { error: "Access denied" }, status: 403
    end
  end

  # POST /comments
  def create
    if comments_permitted_for_user?
      comment = current_user.comments.create permitted_comment_params
      if comment
        comment.update event_id: params[:event_id]
        render json: comment
      else
        render json: { error: comment.errors }
      end
    else
      render json: { error: "Access denied" }, status: 403
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
      render json: { error: "Access denied"}, status: 403
    end
  end

  # DELETE /comments/1
  def destroy
    if comment_permitted_to_edit_or_delete?
      @comment.destroy
      render json: { status: "Success" }
    else
      render json: { error: "Access denied" }, status: 403
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by_id params[:id]
      unless @comment
        render json: { error: "Not found" }, status: 404
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def permitted_comment_params
      params.require(:comment).permit(:content)
    end
    # Check whether user is event's participant
    def comments_permitted_for_user?
      current_user.events.map(&:id).include? params[:event_id].to_i
    end
     #Check whether user is a creator of the comment
    def comment_permitted_to_edit_or_delete?
      current_user.id == @comment.user_id
    end
end
