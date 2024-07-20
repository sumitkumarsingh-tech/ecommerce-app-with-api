import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../product/product_list.dart';
import 'category_modal.dart';
import 'package:cached_network_image/cached_network_image.dart';



class Category extends StatefulWidget {
  final int userId;
  const Category({super.key,required this.userId});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {


  Future<List<CatModal>> categoryData() async {

    final response = await http.get(Uri.parse("http://localhost:8080/Ecommerce_App/rest/api/category"));

    if(response.statusCode == 200) {
      final parsedValue = jsonDecode(response.body)["categories"];

            return List<CatModal>.from(
            parsedValue.map((data) => CatModal.fromJson(data)));
    } else {
      throw Exception("Failed to load data");
    }
  }


  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: categoryData(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }else if (snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          } else {
            final categoryItems = snapshot.data!;
            return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                itemCount: categoryItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 15,crossAxisSpacing: 15),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(catId:  categoryItems[index].cat_id,catName: categoryItems[index].cat_name, userId: widget.userId,),
                        ),
                      );
                    },
                    child:  Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("http://localhost:8080/Ecommerce_App/"+ categoryItems[index].imagePath.toString(),),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(categoryItems[index].cat_name,style: TextStyle(color: Colors.black87,fontFamily: "Roboto",fontSize: 25),)
                          ],
                        ),

                    )

                  );
                });
          }

        }

    );
  }
}
