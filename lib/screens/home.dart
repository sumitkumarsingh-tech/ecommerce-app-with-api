import 'package:ecommerce_app/category/category_list.dart';
import 'package:ecommerce_app/settings.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
   int userId;
  Home({super.key,required this.userId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  void onTapChange(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [
      Category(userId: widget.userId),
      Settings(),
    ];




    return Scaffold(
        appBar: AppBar(
          title: const Text("Ecommerce"),
          backgroundColor: Colors.yellow,
        ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
           label: "Category"
        ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting"
          ),
        ],
      currentIndex: selectedIndex,
      onTap: onTapChange,
      ),
    );
  }
}


