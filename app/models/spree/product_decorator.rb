Spree::Product.class_eval do

  def option_values
    @_option_values ||= Spree::OptionValue.for_product(self)
  end

  def grouped_option_values
    values = option_values.includes(:option_type).reject { |ov| ov.name.include?("—") }
    @_grouped_option_values ||= values.group_by(&:option_type)
    @_grouped_option_values.sort_by { |option_type, option_values| option_type.position }
  end

  def variants_for_option_value(value)
    @_variants_for_option_value = variants.in_stock.joins(:option_values).where(:spree_option_values => {:id => value.id})
  end

  def variants_by_option
    variants.in_stock.includes({option_values: [:option_type]}).each_with_object({}) do |v, result|
      v.option_values.each do |o|
        t = o.option_type
        result[t] ||= {}
        (result[t][o] ||= []) << v
      end
    end
  end

  def variant_options_hash
    return @_variant_options_hash if @_variant_options_hash
    hash = {}
    variants.in_stock.includes({option_values: [:option_type]}, :default_price).each do |variant|
      variant.option_values.each do |ov|
        otid = ov.option_type_id.to_s
        ovid = ov.id.to_s
        hash[otid] ||= {}
        hash[otid][ovid] ||= {}
        hash[otid][ovid][variant.id.to_s] = variant.to_hash
      end
    end
    @_variant_options_hash = hash
  end
end
