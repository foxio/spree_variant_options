Spree::Variant.class_eval do
  include Spree::CurrencyHelpers
  include ActionView::Helpers::NumberHelper

  def to_hash
    price = self.prices.find_by(currency: Spree::Config[:presentation_currency]).display_price.to_html
    price_usd = self.prices.find_by(currency: "USD").display_price.to_html
    if self.product.old_price
      old_price = display_currency(self.product.old_price, to: 'KRW')
      old_price_usd = display_currency(self.product.old_price, to: 'USD')
    end
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
