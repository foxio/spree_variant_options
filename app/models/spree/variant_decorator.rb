Spree::Variant.class_eval do
  include Spree::CurrencyHelpers
  include ActionView::Helpers::NumberHelper

  def to_hash
    usd = self.default_price.display_price
    if self.product.old_price
      old_price_usd = display_currency(self.product.old_price, to: 'USD')
      old_price = display_currency(self.product.old_price, to: 'KRW')
    end
    {
      id: self.id,
      in_stock: self.in_stock?,
      price: display_currency(usd),
      price_usd: usd.to_html,
      old_price: old_price,
      old_price_usd: old_price_usd,
      local_shipping_price: display_currency(self.local_shipping_total, to: 'KRW'),
      local_shipping_price_usd: display_currency(self.local_shipping_total, to: 'USD'),
      international_shipping_price_usd: display_currency(self.international_shipping_total, to: 'USD')
      international_shipping_price: display_currency(self.international_shipping_total, to: 'KRW')
      total_shipping_price: display_currency(self.shipping_total, to: 'KRW'),
      total_shipping_price_usd: display_currency(self.shipping_total, to: 'USD')
    }
  end
  def self.current
    where("(SELECT MAX(updated_at) FROM spree_variants AS v WHERE v.product_id = spree_variants.product_id AND v.is_master = 'f' AND v.deleted_at is NULL) - updated_at <= interval '1 hour'")
  end

  def self.in_stock
    # !deleted & updated
    paranoia_scope.current
  end
end
