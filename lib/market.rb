class Market
  attr_reader :name, :vendors
  def initialize(name)
    @name = name
    @vendors = []
  end
  
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


end