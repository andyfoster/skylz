# frozen_string_literal: true

class DomainsController < ApplicationController
  before_action :set_domain, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /domains or /domains.json
  def index
    @domains = current_user.domains
  end

  # GET /domains/1 or /domains/1.json
  def show; end

  # GET /domains/new
  def new
    @domain = Domain.new
  end

  # GET /domains/1/edit
  def edit; end

  # POST /domains or /domains.json
  def create
    @domain = Domain.new(domain_params)

    c = current_user

    respond_to do |format|
      if @domain.save
        c.update_attribute(:current_domain, @domain.id)

        format.html { redirect_to root_path, notice: 'Domain was successfully created.' }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /domains/1 or /domains/1.json
  def update
    respond_to do |format|
      if @domain.update(domain_params)
        format.html { redirect_to domains_path, notice: 'Domain was successfully updated.' }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1 or /domains/1.json
  def destroy
    @domain.destroy

    respond_to do |format|
      format.html { redirect_to domains_url, notice: 'Domain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_current
    c = current_user
    c.update_attribute(:current_domain, params[:id])
    c.save!

    redirect_to root_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_domain
    @domain = Domain.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def domain_params
    params.require(:domain).permit(:name).merge({ user_id: current_user.id })
  end
end
