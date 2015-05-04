class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:destroy]

  # POST /comments
  # POST /comments.json
  def create
    @link=Link.find params[:link_id]
    @comment = @link.comments.new(comment_params)
    @comment.user=current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to link_path(@link), notice: 'Comment was successfully created.' }
        format.json { render partial: @link.comments, status: :created, location: @link }
      else
        format.html { redirect_to link_path(@link), notice: 'Comment could not be created.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @link, notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @link=Link.find params[:link_id]
      @comment = @link.comments.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:link_id, :body, :user_id)
    end
end
