require 'test_helper'

class ProductTest < ActiveSupport::TestCase
    fixtures :products

    test "product attributes must not be empty" do
        product = Product.new
        assert product.invalid?
        assert product.errors[:title].any?
        assert product.errors[:description].any?
        assert product.errors[:price].any?
        assert product.errors[:image_url].any?
    end

    test "product price must be positive" do
      product = Product.new(title: "My book title",
                            description: "yyy",
                            image_url: "zzz.png")
      product.price = -1
      assert product.invalid?
      assert_equal "must be greater than or equal to 0.01",
          product.errors[:price].join("; ")
      product.price = 0
      assert product.invalid?
      assert_equal "must be greater than or equal to 0.01",
          product.errors[:price].join("; ")
      product.price = 1
      assert product.valid?
    end

    def new_product(image_url)
        Product.new(title: "My book title",
                    description: "yyy",
                    price: 1,
                    image_url: image_url)
    end

    test "image_url" do
        ok = %w{ fref.gif fred.jpg fred.png FRED.JPG FRED.JpG
                 http://a.b.c/x/y/z/fred.gif }
        bad = %w{ fred.doc fred.gif/more fred.gif.more }

        ok.each do |name|
            assert new_product(name).valid?, "#{name} shouldn't be invalid"
        end

        bad.each do |name|
            assert new_product(name).invalid?, "#{name} shouldn't be valid"
        end
    end

    test "product is not valid without a unique title" do
        product = Product.new(title: products(:ruby).title,
            description: "yyy",
            price: 1,
            image_url: "fred.gif")
        assert !product.save
        # or I18n.translate('activerecord.errors.messages.taken')
        assert_equal "has already been taken", product.errors[:title].join("; ")
    end

    test "product title must be greater than 10 chars" do
        product = Product.new(title: "123456789",
            description: "yyy",
            price: 1,
            image_url: "fred.gif")
        assert !product.save, "title need more than 10 chars"
        assert_equal "too_short",
            product.errors[:title].join("; ")

        product = Product.new(title: "0123456789",
            description: "yyy",
            price: 1,
            image_url: "fred.gif")
        assert product.save
    end
end
