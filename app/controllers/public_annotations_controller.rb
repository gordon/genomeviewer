class PublicAnnotationsController < ApplicationController

  append_before_filter :title

  #
  # active scaffold declaration and configuration
  #
  active_scaffold :annotations do |config|

    config.label = @title

    config.columns = [:name, :description, :user, :sequence_regions]

    # make it readonly, in addition exclude also show, which is uninteresting for the purpose
    [:create, :update, :new, :delete, :show].each do |act|
      config.actions.exclude act
    end

    config.action_links.add :open, :type => :record, :page => true

  end

  #
  # open the current annotation in the viewer
  #
  def open
    annotation = Annotation.find(params["id"])
    redirect_to :controller => :viewer,
                :annotation => annotation.name,
                :username   => annotation.user.username
  end

  #
  # an user's page
  #
  def user
    @public_user = User.find_by_username(params[:username])
    if !@public_user
      flash[:errors] = "#{params[:username]}: user not found"
      redirect_to :action => :index
    elsif @public_user.public_annotations_count == 0
      flash[:errors] = "#{params[:username]} has no public annotations"
      redirect_to :action => :index
    end
    @title = @public_user.name
  end

private

  def self.active_scaffold_controller_for (klass)
    return PublicUsersController if klass==User
    super
  end

  def conditions_for_collection
    "public != 'f' and public != 0"
  end

  def title
    @title = "Public Annotations"
  end

  #
  # only public annotations may be accessed
  #
  def public_annotation?
    if params["id"] # == only for actions working on a single record
      annotation = Annotation.find(params["id"])
      redirect_to root_url unless annotation.public
    end
  end
  alias_method :list_authorized?, :public_annotation?
  before_filter :public_annotation?, :only => [:open]

end