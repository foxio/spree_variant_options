Spree::Variant.class_eval do
  include Spree::CurrencyHelpers
  include ActionView::Helpers::NumberHelper

  def to_hash
    usd = self.default_price.display_price
    price_usd = usd.to_html
    price = display_currency(usd)
    if self.product.old_price
      old_price_usd = display_currency(self.product.old_price, to: 'USD')
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
  def self.current
    where("(SELECT MAX(updated_at) FROM spree_variants AS v WHERE v.product_id = spree_variants.product_id) - updated_at <= interval '1 hour'")
  end

  def self.in_stock
    # !deleted & updated
    paranoia_scope.current
  end
end
