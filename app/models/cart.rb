class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy

  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end

  def remove_product(product_id)
    current_item = line_items.find_by_product_id(product_id) #line_item atual
    if current_item.quantity > 1
      current_item.quantity -= 1
      current_item.save
    else
      line_items.delete(current_item)
    end
  end

  def total_price
    line_items.to_a.sum {|item| item.total_price }
  end
  
end
