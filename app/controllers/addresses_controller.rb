class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :update, :destroy, :edit]
  # GET /addresses
  # GET /addresses.json
  def index
    if user_signed_in?
      @addresses = current_user.addresses
    else
      @addresses = Address.all
    end
  end
  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end
  # GET /addresses/new
  def new
    @address = Address.new
    1.times {@address.address_categories.build}
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)
    @address.user = current_user
    respond_to do |format|
      if @address.save
        @address.set_crypto_currencies_accepted = address_params[:crypto_currencies_accepted]
        format.html { redirect_to @address, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:description,:business_name,:web_site,:facebook_page,:country_id, :state, :city,
                                      :zip_code,:district,
                                      :street, :number, :complement,
                                      :reference_point,
                                      :email, :phone, address_categories_attributes: [:id, :_destroy, :category_id, category_attributes: [:id, :_destroy, :name]], crypto_currencies_accepted: [] )

    end
end
