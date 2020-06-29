class Product {
  String bannerImage;
  String deliveryTime;
  String catagory;
  String price;
  String weight;
  String discount;
  String quantity;
  List addtocart;
  List favourite;
  List images;
  List tags;
  String name, description, id;
  bool showasbanner;

  Product(
      {this.catagory,
      this.deliveryTime,
      this.price,
      this.weight,
      this.discount,
      this.quantity,
      this.addtocart,
      this.favourite,
      this.images,
      this.name,
      this.description,
      this.id,
      this.showasbanner,
      this.bannerImage,
      this.tags});

  static Map<String, dynamic> fromProduct(Product product) {
    return {
      "catagory": product.catagory,
      "name": product.name,
      "deliveryTime": product.deliveryTime,
      "price": product.price,
      "weight": product.weight,
      "discount": product.discount,
      "quantity": product.quantity,
      "addtocart": product.addtocart,
      "favourite": product.favourite,
      "images": product.images,
      "description": product.description,
      "id": product.id,
      "showasbanner": product.showasbanner,
      "bannerImage": product.bannerImage,
      "tags": product.tags
    };
  }

  static Product fromMap(Map<String, dynamic> data) {
    return Product(
         catagory:data['catagory'],
        deliveryTime:data['deliveryTime'],
        price:data['price'],
        weight:data['weight'],
        discount: data['discount'],
        quantity:data['quantity'],
        addtocart:data['addtocart'],
        favourite:data['favourite'],
        images:data['images'],
        name:data['name'],
        description:data['description'],
        id:data['id'],
        showasbanner:data['showasbanner'],
        bannerImage:data['bannerImage'],
        tags:data['tags']);
  }
}
