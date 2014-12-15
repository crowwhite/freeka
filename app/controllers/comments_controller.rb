class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_requirement, only: :create

  def create
    @comment = @requirement.comments.build(comment_params.merge(user_id: current_user.id))
    redirect_to @requirement, alert: 'Could not add comment' unless @comment.save
  end

  def destroy
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:requirement_id])
      unless @requirement
        flash[:alert] = 'Requirement not found'
        redirect_to(root_path)
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end