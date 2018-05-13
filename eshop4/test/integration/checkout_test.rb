require File.dirname(__FILE__) + '/../test_helper'

class CheckoutTest < ActionDispatch::IntegrationTest
  fixtures :producers, :suppliers, :liquors

  test "empty_cart_shows_error_message" do
    get '/checkout'
    assert_response :redirect
    assert_redirected_to :controller => 'catalog'
    assert_equal flash[:notice], 'Su carrito de la compra esta vacío! ' +
                                 'Por favor añade al menos un licor para proceder al pago.'
  end

  test "submitting_order" do
    post '/cart/add', :id => 1
    get '/checkout'
    assert_response :success
    assert_select 'legend', 'Informacion de Contacto'
    # assert_tag :tag => 'legend', :content => 'Contact Information'
    assert_select 'legend', 'Direccion de envio'
    # assert_tag :tag => 'legend', :content => 'Shipping Address'
    assert_select 'legend', 'Información de Facturación'
    # assert_tag :tag => 'legend', :content => 'Billing Information'

    post '/checkout/submit_order', :cart => { :id => Cart.last.id }, :order => {
      # Contact information
      :email => 'email@email.com',
      :phone_number => '666112233',
      # Shipping address
      :ship_to_first_name => 'Firstname',
      :ship_to_last_name => 'Lastname',
      :ship_to_address => 'Address',
      :ship_to_city => 'City',
      :ship_to_postal_code => '00000',
      :ship_to_country_code => 'Country',
      # Billing information
      :card_type => 'Visa',
      :card_number => '4007000000027',
      :card_expiration_month => '12',
      :card_expiration_year => '2018',
      :card_verification_value => '000'
    }

    assert_response :redirect
    assert_redirected_to '/checkout/thank_you'
  end
end
