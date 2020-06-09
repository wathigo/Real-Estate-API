class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show update destroy]

  # GET /properties
  def index
    @properties = Property.all

    render json: @properties
  end

  # GET /properties/1
  def show
    if @property
      render json: @property
    else
      render json: { status: 404, Message: 'Record not Found!' }
    end
  end

  # POST /properties
  def create
    @property = Property.new(property_params)

    if @property.save
      render json: @property, status: :created, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
      render json: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find_by_id(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def property_params
    params.require(:property).permit(:address, :description, :price, :category_id)
  end
end
