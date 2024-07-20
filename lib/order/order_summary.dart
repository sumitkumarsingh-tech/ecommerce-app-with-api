import 'dart:convert';

import 'package:ecommerce_app/order/user_retrieve_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/home.dart';

class OrderSummary extends StatefulWidget {
  final int userId;
  final int productId;
  final double price;
  final String productName;
  final String productDescription;
  const OrderSummary({required this.userId,required this.productId,required this.price,required this.productName,required this.productDescription, super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
  double _totalAmount(){
   double totalAmount = _quantity * widget.price;
    return totalAmount;
  }

  Future<List<UserRetrieveModal>> userData() async {
    final response = await http.post(
      Uri.parse("http://localhost:8080/Ecommerce_App/rest/user/userSummary"),
      body: {
         "user_id": widget.userId.toString(),

      }

    );
    if(response.statusCode == 200) {
      final parsedValue = jsonDecode(response.body)["userSummary"];

      List<UserRetrieveModal> uData =  List<UserRetrieveModal>.from(
          parsedValue.map((data) => UserRetrieveModal.fromJson(data)));

      //List<UserRetrieveModal> filtered_uData = uData.where((element) => element.user_id == widget.userId).toList();

      return uData;
    } else {
      throw Exception("Failed to load data");
    }
  }
  Future<void> placeOrder()async {
    String userAddUrl = "http://localhost:8080/Ecommerce_App/rest/order/orderSummary";
    var response = await http.post(Uri.parse(userAddUrl),
        body: {
          "user_id": widget.userId.toString(),
          "product_id": widget.productId.toString(),
          "quantity":  _quantity.toString(),
          "total_amount": _totalAmount().toString(),
        }

    );
    if(response.statusCode == 200){
      Map<String,dynamic>  data = json.decode(response.body);
      if(data['status'] == "success"){
        SnackBar    snackBar = SnackBar(
            content: const Text("Order placed successfully"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userId: widget.userId,)));
      }else{
        SnackBar    snackBar = SnackBar(
            content: const Text("Order failed"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }else{
      print("Some error occurred");
    }

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
      ),
 body: FutureBuilder(
          future: userData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final  user_data = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Name: ${user_data[0].user_name}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mobile Number: ${user_data[0].user_phone} ',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Address:${user_data[0].user_address}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Product Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/product_img.png"))
                        ),
                      ),
                      title: Text(widget.productName),
                      subtitle: Text(widget.productDescription),
                      trailing: Text(
                        '₹ ${widget.price}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Quantity:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Opacity(
                              opacity: _quantity > 1 ? 1.0 : 0.5,
                              child: InkWell(
                                onTap: _decrementQuantity,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(Icons.remove),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '$_quantity',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: _incrementQuantity,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '₹ ${_totalAmount().toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        placeOrder();
                      },
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
