class CapturesController < ApplicationController
  before_action :set_capture, only: [:show, :edit, :update, :destroy]
  #before_action :sorry_cannot_edit, only: [:edit, :update]
  around_action :set_time_zone


  # GET /captures
  # GET /captures.json
  def index
    @captures = Capture.all
  end

  # GET /captures/1
  # GET /captures/1.json
  def show
  end

  # GET /captures/new
  def new
    @capture = Capture.new
    @capture.start_time = Time.now
    @capture.end_time = Time.now + 10.minutes
  end

  # GET /captures/1/edit
  def edit
  end

  # POST /captures
  # POST /captures.json
  def create
    @capture = Capture.new(capture_params)

    respond_to do |format|
      if @capture.save
        format.html { redirect_to @capture, notice: 'Capture was successfully created.' }
        format.json { render action: 'show', status: :created, location: @capture }
      else
        format.html { render action: 'new' }
        format.json { render json: @capture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /captures/1
  # PATCH/PUT /captures/1.json
  def update
    respond_to do |format|
      if @capture.update(capture_params)
        format.html { redirect_to @capture, notice: 'Capture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @capture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /captures/1
  # DELETE /captures/1.json
  def destroy
    @capture.destroy
    respond_to do |format|
      format.html { redirect_to captures_url }
      format.json { head :no_content }
    end
  end                                                                             

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capture
      @capture = Capture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capture_params
      params.require(:capture).permit(:camera_id, :start_time, :end_time, :time_zone)
    end

    def set_time_zone
      old_time_zone = Time.zone
      Time.zone = browser_timezone if browser_timezone.present?
      yield
    ensure
      Time.zone = old_time_zone
    end
                                                                                     
    def browser_timezone
      if params[:capture].present? and params[:capture][:time_zone].present?
        params[:capture][:time_zone] 
      else
        cookies["browser.timezone"]
      end
    end
    
    def sorry_cannot_edit
      redirect_to captures_url, notice: "Capture job has been enqueued. Cannot update. Delete and create new capture job."
    end
end
