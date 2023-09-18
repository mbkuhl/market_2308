require './spec/spec_helper'

RSpec.describe Market do
  before(:each) do
    @arket = Market.new("South Pearl Street Farmers Market")
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

  describe '#add_vendors' do
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

  describe '#potential_revenue' do
    it 'can show how much money a vendor would make if they sold al their stock' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@vendor1.potential_revenue).to eq(29.75)
      expect(@vendor2.potential_revenue).to eq(345.00)
      expect(@vendor3.potential_revenue).to eq(48.75)
    end
  end
end