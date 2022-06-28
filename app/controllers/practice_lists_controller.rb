class PracticeListsController < ApplicationController
  before_action :set_practice_list, only: %i[ show edit update destroy ]

  # GET /practice_lists or /practice_lists.json
  def index
    @practice_lists = PracticeList.all
  end

  # GET /practice_lists/1 or /practice_lists/1.json
  def show
  end

  # GET /practice_lists/new
  def new
    @practice_list = PracticeList.new
  end

  # GET /practice_lists/1/edit
  def edit
  end

  # POST /practice_lists or /practice_lists.json
  def create
    @practice_list = PracticeList.new(practice_list_params)

    respond_to do |format|
      if @practice_list.save
        format.html { redirect_to practice_list_url(@practice_list), notice: "Practice list was successfully created." }
        format.json { render :show, status: :created, location: @practice_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @practice_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practice_lists/1 or /practice_lists/1.json
  def update
    respond_to do |format|
      if @practice_list.update(practice_list_params)
        format.html { redirect_to practice_list_url(@practice_list), notice: "Practice list was successfully updated." }
        format.json { render :show, status: :ok, location: @practice_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @practice_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practice_lists/1 or /practice_lists/1.json
  def destroy
    @practice_list.destroy

    respond_to do |format|
      format.html { redirect_to practice_lists_url, notice: "Practice list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice_list
      @practice_list = PracticeList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def practice_list_params
      params.fetch(:practice_list, {})
    end
end
