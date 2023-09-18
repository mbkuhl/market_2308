class Vendor
  attr_reader :name, :inventory
  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, amount)
    @inventory[item] += amount
  end

  def potential_revenue
    sum = 0
    inventory.each do |item|
      sum += (item[0].price * check_stock(item[0]))
    end
    sum
  end
end