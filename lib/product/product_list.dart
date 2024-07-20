// product_screen.dart
import 'package:ecommerce_app/product/product_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../order/order_summary.dart';

class ProductScreen extends StatefulWidget {
  final int userId;
  final int catId;
  final String catName;
  ProductScreen({super.key,required this.userId,  required this.catId,required this.catName});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  Future<List<ProductModal>> productData() async {

    final response = await http.get(Uri.parse("http://localhost:8080/Ecommerce_App/rest/api/product"));

    if(response.statusCode == 200) {
      final parsedValue = jsonDecode(response.body)["pList"];
      List<ProductModal> product_list =  List<ProductModal>.from(
          parsedValue.map((data) => ProductModal.fromJson(data)));

      List<ProductModal> filtered_product_list = product_list.where((element) => element.categoryId == widget.catId).toList();

      return filtered_product_list;
    } else {
      throw Exception("Failed to load data");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('"${widget.catName}"'),
      ),
      body:  FutureBuilder(
          future: productData(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }else if (snapshot.hasError){
              return Text("Error: ${snapshot.error}");
            } else {
              final productItems = snapshot.data!;
              return GridView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: productItems.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 200 ,
                      width: 200,
                      child: Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 100,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade50,
                                    image: DecorationImage(
                                      image: NetworkImage("http://localhost:8080/Ecommerce_App/" + productItems[index].imagePath!.toString()),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                productItems[index].productName!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                productItems[index].productDescription!,
                                overflow: TextOverflow.ellipsis,
                                 maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                ' ₹ ${productItems[index].productPrice!.toString()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 36,
                                width: 180,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderSummary(price: productItems[index].productPrice!, userId: widget.userId,
                                          productName: productItems[index].productName!, productDescription: productItems[index].productDescription!, productId: productItems[index].productId!,),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Buy',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],


                      ),
                    );

                  });
            }

          }

      )
    );
  }
}
