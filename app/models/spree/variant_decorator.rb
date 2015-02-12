Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    price = self.prices.find_by(currency: Spree::Config[:presentation_currency]).display_price.to_html
    price_usd = Spree::Money.new(self.price.to_i, { currency: "USD" }).to_html
    old_price = self.product.display_html_old_price
    old_price_usd = Spree::Money.new(self.old_price.to_i, { currency: "USD" }).to_html
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
