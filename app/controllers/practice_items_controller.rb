class PracticeItemsController < ApplicationController
  before_action :set_practice_item, only: %i[ show edit update destroy ]

  # GET /practice_items or /practice_items.json
  def index
    @practice_items = PracticeItem.all
  end

  # GET /practice_items/1 or /practice_items/1.json
  def show
  end

  # GET /practice_items/new
  def new
    @practice_item = PracticeItem.new
  end

  # GET /practice_items/1/edit
  def edit
  end

  # POST /practice_items or /practice_items.json
  def create
    @practice_item = PracticeItem.new(practice_item_params)

    respond_to do |format|
      if @practice_item.save
        format.html { redirect_to practice_item_url(@practice_item), notice: "Practice item was successfully created." }
        format.json { render :show, status: :created, location: @practice_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @practice_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practice_items/1 or /practice_items/1.json
  def update
    respond_to do |format|
      if @practice_item.update(practice_item_params)
        format.html { redirect_to practice_item_url(@practice_item), notice: "Practice item was successfully updated." }
        format.json { render :show, status: :ok, location: @practice_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @practice_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practice_items/1 or /practice_items/1.json
  def destroy
    @practice_item.destroy

    respond_to do |format|
      format.html { redirect_to practice_items_url, notice: "Practice item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice_item
      @practice_item = PracticeItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def practice_item_params
      params.require(:practice_item).permit(:skill_id, :PracticeList_id)
    end
end
