Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    price = self.prices.find_by(currency: Spree::Config[:presentation_currency]).display_price.to_html
    price_usd = self.prices.find_by(currency: "USD").display_price.to_html
    old_price = self.product.old_price_in_won
    old_price_usd = self.product.old_price_in_dollar
    {
      :id => self.id,
      :in_stock => self.in_stock?,
      :price => price,
      :old_price => old_price,
      :price_usd => price_usd,
      :old_price_usd => old_price_usd
    }
  end

end
