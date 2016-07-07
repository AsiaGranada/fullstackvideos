class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, :except => :show
  before_action :authenticate_user!, only: [:show], :unless => :free_video?
  before_action :current_subscriber?, only: [:show]


  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.order(date: :desc).page(params[:page]).per(20)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
   @video = Video.find(params[:id])
   @relateds = []
   @video.relateds.each do |item|
     unless item.wistia.blank?
       @relateds << Video.where(wistia: item.wistia).first
     end
   end
 end

  # GET /videos/new
  def new
    @video = Video.new
    @video.relateds.new
    @video.resources.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    @video.relateds.build
    @video.resources.build
    # obtain video metadata using the Wistia API
    Rails.logger.info("obtaining metadata from Wistia API for #{@video.wistia}")
    media = Wistia::Media.find(@video.wistia)
    @video.title = media.name
    @video.description = ActionController::Base.helpers.strip_tags(media.description)
    @video.duration = (media.duration.to_i / 60) % 60
    @video.thumbnail_url = media.thumbnail.url

    respond_to do |format|
      if @video.save
        format.html { redirect_to videos_path, notice: 'Created video listing.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    Rails.logger.info("updating the thumbnail URL using the Wistia API for #{@video.wistia}")
    media = Wistia::Media.find(@video.wistia)
    @video.thumbnail_url = media.thumbnail.url
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to videos_path, notice: 'Updated video listing.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Deleted video listing.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:wistia, :description, :title,
                                      :level, :date, :duration, :presenter,
                                      relateds_attributes: [ :id, :wistia, :_destroy ],
                                      resources_attributes: [ :id, :url, :text, :description, :_destroy ]
                                      )
    end

    def current_subscriber?
      if user_signed_in? && current_user.expired?
        redirect_to root_path, :alert => "Subscription has
          expired for #{current_user.email}.
          Would you like to renew?"
      end
    end

    def admin_only
      unless current_user.nil?
        unless current_user.admin?
          redirect_to :back, :alert => "Access denied."
        end
      else
        redirect_to root_path, :alert => "Please sign in."
      end
    end

    def free_video?
      @video.free?
    end
end
