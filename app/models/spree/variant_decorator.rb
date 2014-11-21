Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    price = self.prices.find_by(currency: Spree::Config[:presentation_currency]).display_price.to_html
    old_price = self.old_price_in_won
    {
      :id    => self.id,
      :in_stock => self.in_stock?,
      :price => price,
      :old_price => old_price
    }
  end

end
