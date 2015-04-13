Spree::Variant.class_eval do
  include Spree::CurrencyHelpers
  include ActionView::Helpers::NumberHelper

  def to_hash
    usd = self.prices.find_by(currency: "USD")
    price = display_currency(usd)
    price_usd = usd.display_price.to_html
    if self.product.old_price
      old_price_usd = display_currency(self.product.old_price)
      old_price = display_currency(self.product.old_price, to: 'KRW')
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
