class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_requirement, only: :create

  def create
    @comment = @requirement.comments.build(comment_params.merge(user_id: current_user.id))
    if @comment.save
      flash.now[:notice] = 'Comment added successfully'
      render nothing: true
    else
      redirect_to @requirement, alert: 'Could not add comment'
    end
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:requirement_id])
      redirect_to root_path, alert: 'Requirement not found' unless @requirement
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end