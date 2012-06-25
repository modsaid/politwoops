class Admin::TweetsController < Admin::AdminController

  # list either unreviewed
  def index
    # boilerplate I don't fully understand
    @group_name = params[:group_name] || @default_group.name
    @politicians = Politician.active.joins(:groups).where({:groups => {:name => @group_name}}).all

    @tweets = DeletedTweet.where(:politician_id => @politicians)

    # filter to relevant subset of deleted tweets
    @tweets = @tweets.where :reviewed => params[:reviewed], :approved => params[:approved]

    per_page = params[:per_page] ? params[:per_page].to_i : nil
    per_page ||= Tweet.per_page
    per_page = 200 if per_page > 200

    @tweets = @tweets.includes(:politician => [:party]).paginate(:page => params[:page], :per_page => per_page)
  end

  # approve or unapprove a tweet, mark it as reviewed either way
  def review
  end

end