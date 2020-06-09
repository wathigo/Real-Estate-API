class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show update destroy add_geo_location]
  skip_before_action :authenticate_request, only: %i[index]

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

  def add_geo_location
    @geo_location = @property.geo_locations.build(latt: params[:latt], long: params[:long])
    if @geo_location.save
      render json: @geo_location
    else
      render json: { status: 404, message: 'Record not found' }
    end
  end

  def get_geo_locations
    @geo_location = @property.geo_locations.find(property_id: @property.id)
    if @geo_location
      render json: @geo_location
    else
      render json: { status: 404, message: 'Record not Found' }
    end
  end

  def add_favourites
    @favourite = current_user.favourites.build(user_id: current_user.id)
    if @favourite.save
      render json: @favourite
    else
      render json: { status: 500, message: 'Something went wrong' }
    end
  end

  def get_favourites
    @properties = current_user.favourites.all.includes(:property)
    if @properties
      render json: @properties
    else
      render json: { status: 404, message: 'No favourites for you! Add some.' }
    end
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
