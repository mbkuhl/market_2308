require './spec/spec_helper'

RSpec.describe Market do
  before(:each) do
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7) 
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")  
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3 = Vendor.new("Palisade Peach Shack") 
    @vendor3.stock(@item1, 65)
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@market).to be_a(Market)
      expect(@market.name).to eq("South Pearl Street Farmers Market")
      expect(@market.vendors).to eq([])
    end
  end

  describe '#add_vendor' do
    it 'can add vendors to the market' do   
      @market.add_vendor(@vendor1)
      expect(@market.vendors).to eq([@vendor1])
      @market.add_vendor(@vendor2)
      expect(@market.vendors).to eq([@vendor1, @vendor2])
      @market.add_vendor(@vendor3)
      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end
  end

  describe '#vendor_names' do
    it 'can show vendor names that have been added to the market' do   
      @market.add_vendor(@vendor1)
      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh"])
      @market.add_vendor(@vendor2)
      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom"])
      @market.add_vendor(@vendor3)
      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end
  end

  describe '#vendors_that_sell()' do
    it 'can show all vendors that sell a particular item' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
    end
  end

  describe '#total_inventory' do
    it 'can return a list of all items sold in the market, how much total inventory there is, and where they are sold' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.total_inventory).to eq({
        @item1 => {
          quantity: 100,
          vendors: [@vendor1, @vendor3]
        },
        @item2 => {
          quantity: 7,
          vendors: [@vendor1]
        },
        @item3 => {
          quantity: 25,
          vendors: [@vendor2]
        },
        @item4 => {
          quantity: 50,
          vendors: [@vendor2]
        }
      })
    end
  end

  describe '#overstocked_items' do
    it 'can give a list of overstocked items' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.overstocked_items).to eq([@item1])
      @vendor2.stock(@item4, 1)
      expect(@market.overstocked_items).to eq([@item1])
      @vendor3.stock(@item4, 1)
      expect(@market.overstocked_items).to eq([@item1, @item4])
      @vendor3.stock(@item3, 1)
      expect(@market.overstocked_items).to eq([@item1, @item4])
      end
  end

  describe '#sorted_item_list' do
    it 'can give a list of all items in stock, alphebetically' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", 'Peach', "Peach-Raspberry Nice Cream", 'Tomato'])
      @item5 = Item.new({name: "Chocolate Nice Cream", price: "$5.30"})
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", 'Peach', "Peach-Raspberry Nice Cream", 'Tomato'])
      @vendor2.stock(@item5, 5)
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Chocolate Nice Cream", 'Peach', "Peach-Raspberry Nice Cream", 'Tomato'])
    end
  end

  describe 'item_object list' do
    it 'can return a list of all item object sold at the market in no particular order' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.item_object_list.include?(@item1)).to be true
      expect(@market.item_object_list.include?(@item2)).to be true
      expect(@market.item_object_list.include?(@item3)).to be true
      expect(@market.item_object_list.include?(@item4)).to be true
    end
  end

  describe '#total_item_stock' do
    it 'can return the total stock of an item at the market' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.total_item_stock(@item1)).to eq(100)
      expect(@market.total_item_stock(@item2)).to eq(7)
      expect(@market.total_item_stock(@item3)).to eq(25)
      expect(@market.total_item_stock(@item4)).to eq(50)
      @vendor2.stock(@item4, 1)
      expect(@market.total_item_stock(@item4)).to eq(51)
    end
  end

  describe '#date' do
    it 'can return the date in which the object was created' do
      expect(@market.date).to be_a(String)
      allow(@market).to receive(:date).and_return('01/01/2000')
      expect(@market.date).to eq('01/01/2000')
    end

    it 'will save this date (mock)' do
      @market = double("Y2K")
      allow(@market).to receive(:date).and_return('01/01/2000')
      expect(@market.date).to eq('01/01/2000')
    end
  end

  describe '#sell' do
    it 'will not sell items if there is not enough total inventory' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.sell(@item2, 8)).to be false
      expect(@market.total_item_stock(@item2)).to eq(7)
    end

    it 'will sell items from the first vendor added to the market' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.sell(@item3, 15)).to be true
      expect(@market.total_item_stock(@item3)).to eq(10)
    end

    it 'will sell items from multiple vendors if one vendor does not have enough stock (starting with the first vendor added to the market)' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.sell(@item1, 50)).to be true
      expect(@market.total_item_stock(@item1)).to eq(50)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor3.check_stock(@item1)).to eq(50)
    end
  end
end