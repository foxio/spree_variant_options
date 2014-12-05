Deface::Override.new(:virtual_path   => "spree/products/show",
                     :name           => "spree_variant_options",
                     :replace        => "#product-variants",
                     :partial        => "spree/products/variant_options",
                     :disabled       => false, 
                     :original => 'be9ce3381ab1eaab22394f8deb524d0f5d82c97b' )

Deface::Override.new(:virtual_path   => "spree/admin/option_types/edit",
                     :name           => "admin_option_value_table_headers",
                     :replace        => "thead[data-hook=option_header]",
                     :partial        => "spree/admin/option_values/table_header",
                     :disabled       => false, 
                     :original => 'da907008e9e806c5e1c880a31ea7b2165a9aedbf' )

Deface::Override.new(:virtual_path   => "spree/admin/option_types/edit",
                     :name           => "admin_option_value_table_empty_colspan",
                     :set_attributes => "tr[data-hook=option_none] td",
                     :attributes     => { :colspan => 5 },
                     :disabled       => false, 
                     :original => '566bdb10ddb1e328be51407e5722a3ab91bd9a9a' )

# Image upload for many variants on admin area
Deface::Override.new(:virtual_path   => "spree/admin/images/form",
                     :name           => "admin_multiple_image_upload_for_variant_options",
                     :replace        => "[data-hook=admin_image_form_fields]",
                     :partial        => "spree/admin/images/form",
                     :disabled       => false)
