class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @tweet = current_user.tweets.build
      @tweets = current_user.timeline.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
