import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Product.dart';

class ProductDetails extends StatelessWidget {

  final Product? product;

  ProductDetails(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product details'),
      ),
      body: productDetailsWdget(),
    );
  }

  Widget productDetailsWdget(){
    return Container(

    );
  }

}
