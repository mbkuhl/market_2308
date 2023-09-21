require 'date'

class Market
  attr_reader :name, :vendors, :date
  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today.strftime("%d/%m/%Y")
  end
  
  # def format_date
  #   date = 
  #   date.
  # end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.find_all { |vendor| vendor.inventory.keys.include?(item) }
  end

  def sorted_item_list
    @vendors.flat_map do |vendor| 
      vendor.inventory.keys.map do |item_object|
        item_object.name
      end
    end.uniq.sort
  end

  def total_inventory
    items = item_object_list
    total_inventory_hash = Hash.new
    items.each do |item|
      total_inventory_hash[item] = {
        quantity: total_item_stock(item),
        vendors: vendors_that_sell(item)
      }
    end
    total_inventory_hash
  end

  def overstocked_items
    item_object_list.find_all do |item|
      total_item_stock(item) > 50 && vendors_that_sell(item).count > 1
    end
  end

  def item_object_list
    items = @vendors.flat_map do |vendor| 
      vendor.inventory.keys
    end.uniq
  end

  def total_item_stock(item)
    vendors_that_sell(item).sum do |vendor|
      vendor.check_stock(item)
    end
  end

  def sell(item, quantity)
    return false if quantity > total_item_stock(item)
    sellers = vendors_that_sell(item)
    current_seller = 0
    amount_needed = quantity
    until sellers[current_seller].check_stock(item) > amount_needed
      seller = sellers[current_seller]
      amount_needed -= seller.check_stock(item)
      seller.stock(item, -seller.check_stock(item))
      current_seller= current_seller.next
    end
    sellers[current_seller].stock(item, -amount_needed)
    true
  end

end