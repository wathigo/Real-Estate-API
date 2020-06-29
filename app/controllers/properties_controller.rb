class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show update destroy add_geo_location geo_location_item add_favourites favourites] # rubocop:disable Layout/LineLength
  before_action :set_favourite_properties, only: %i[add_favourites favourites]
  skip_before_action :authenticate_request, only: %i[index]

  # GET /properties
  def index
    @properties = Property.all

    render json: @properties
  end

  # GET /properties/1
  def show
    if @property
      render json: { property: @property, user: current_user }
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
    if @property
      @geo_location = GeoLocation.new(latt: params[:latt], long: params[:long], property_id: @property.id)
      if @geo_location.save
        render json: @geo_location
      else
        render json: { error: @geo_location.errors }, status: :not_found
      end
    else
      render json: { error: 'Property not found' }, status: :not_found
    end
  end

  def geo_location_item
    if @property
      @geo_location = GeoLocation.where(property_id: @property.id).take
      if @geo_location
        render json: @geo_location
      else
        render json: { error: 'Location not Found' }, status: :not_found
      end
    else
      render json: { error: 'Property not Found' }, status: :not_found
    end
  end

  def add_favourites
    if @property
      @favourite = current_user.favourites.new(property_id: @property.id)
      if @favourite.save
        render json: { favourite: @favourite, user: current_user, favourites: @properties }
      else
        render json: { error: @favourite.errors }, status: :not_found
      end
    else
      render json: { error: 'Property not Found' }, status: :not_found
    end
  end

  def favourites
    if @properties
      render json: { properties: @properties, user: current_user }
    else
      render json: { error: 'No favourites for you! Add some.' }, status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find_by_id(params[:id])
  end

  def set_favourite_properties 
    @favourites ||= current_user.favourites.all.includes(:property)
    @properties ||= @favourites.map { |favourite| favourite.property }
  end

  # Only allow a trusted parameter "white list" through.
  def property_params
    params.require(:property).permit(:address, :description, :price, :category_id)
  end
end
