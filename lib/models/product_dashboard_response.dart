
import '../utils/shared_import.dart';


class ProductDashboardResponse {
  List<ProductModel>? product;
  List<ProductCategoryModel>? productCategory;

  ProductDashboardResponse({this.product, this.productCategory});

  ProductDashboardResponse.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <ProductModel>[];
      json['product'].forEach((dynamic v) {
        product!.add(ProductModel.fromJson(v));
      });
    }
    if (json['product_category'] != null) {
      productCategory = <ProductCategoryModel>[];
      json['product_category'].forEach((dynamic v) {
        productCategory!.add(ProductCategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    if (productCategory != null) {
      data['product_category'] = productCategory!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
