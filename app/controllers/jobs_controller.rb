class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  # Disable CRF
  protect_from_forgery with: :null_session

  def scrape 
    job = params[:job]
    location = params[:location]
    radius = params[:radius]
    advanced = params[:advanced]
    # Handle simple & advanced search differently
    if advanced == "1"
      remote = params[:remote]
      salaryMin = params[:salaryMin]
      salaryMax = params[:salaryMax]
      #secondJob = params[:secondJob]
      @scrape = Job.advancedScrape(job, location, radius, remote, salaryMin, salaryMax)
    else 
      @scrape = Job.scrape(job, location, radius)
    end
    # Dont generate map or go to another page if no job results were scraped
    if @scrape.length == 0 
      redirect_to root_path, alert: "No Jobs found, please try another search." 
    end
    # create gon variable of the jobs that can be accessed by js 
    gon.scrape = @scrape
  end

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all

    # Convert saved jobs into same format as scrape
    result = []
    list = @jobs.as_json
    list.each do |job|
      coords = [job["latitude"].to_f, job["longitude"].to_f]
      job.merge!({"latlong" => coords})
      result << job.except("id", "latitude", "longitude", "created_at", "updated_at")
    end
    # Set gon variable to result
    gon.scrape = result
  end

  # Small index in modal
  def miniIndex
    @jobs = Job.all
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    #@job = Job.new(title, location, salary, link, lattitude, longitude)
    ## redirect_to request.path
  end

  # GET /jobs/1/edit
  def edit
  end

  # Add job to saved list (triggered by js)
  def addJob
    # From the post request url get the index number of the job
    index = request.path.tr('^0-9', '').to_i
    # Get the job from the scraped jobs global variable
    job = $scrapedJobs[index]

    title = job[:title]
    location = job[:location]
    salary = job[:salary]
    link = job[:link]
    latlong = job[:latlong]
    latitude = latlong[0]
    longitude = latlong[1]

    create(title, location, salary, link, latitude, longitude)
  end

  # POST /jobs or /jobs.json
  def create (title, location, salary, link, latitude, longitude)
    @job = Job.new(title: title, location: location, salary: salary, link: link, latitude: latitude, longitude: longitude)

    respond_to do |format|
      if @job.save
        format.html { redirect_to job_url(@job), notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to job_url(@job), notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url, notice: "Job was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.fetch(:job, {})
      #params.require(:job).permit(:title, :location, :salary, :link)
    end
end
