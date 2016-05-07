# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

products = Product.create([
  {
    name: 'ASOS Denim Boyfriend Shirt in Myrtle Light Wash',
    image: 'http://images.asos-media.com/inv/media/3/0/2/6/5826203/lightwashblue/image1xxl.jpg',
    category: "clothing"
  },
  {
    name: 'ASOS RAMPAGE Suede Buckle Ankle Boots',
    image: 'http://images.asos-media.com/inv/media/3/6/5/8/5728563/black/image1xxl.jpg',
    category: "footwear"
  },
  {
    name: 'ASOS Ruffle Blouse',
    image: 'http://images.asos-media.com/inv/media/6/0/3/2/5632306/cream/image1xxl.jpg',
    category: "clothing"
  },
  {
    name: 'New Look Festival Stone Ring Pack',
    image: 'http://images.asos-media.com/inv/media/7/7/6/7/6287677/silver/image1xxl.jpg',
    category: "accessories"
  }
])
