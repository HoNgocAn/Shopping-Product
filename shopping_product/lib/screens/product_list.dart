import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_product/service/db_helper.dart';

import '../model/cart_model.dart';
import '../provider/cart_provider.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper? dbHelper = DBHelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Watermelon',
    "Apple"
  ];

  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
    "KG"
  ];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70, 80];

  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    "https://media.post.rvohealth.io/wp-content/uploads/2022/01/grapes-732x549-thumbnail.jpg",
    'https://nutritionsource.hsph.harvard.edu/wp-content/uploads/2018/08/bananas-1354785_1920.jpg',
    "https://img.freepik.com/free-psd/black-pepper-isolated-transparent-background_191095-12643.jpg",
    "https://cdn.britannica.com/68/124168-050-33A2B851/Fruit-peach-tree.jpg",
    "https://cdn.britannica.com/99/143599-050-C3289491/Watermelon.jpg",
    "https://waapple.org/wp-content/uploads/2021/06/Variety_Cosmic-Crisp-transparent-658x677.png"
  ];

  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:
            const Text("Product List", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20.0)
        ],
      ),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.network(productImage[index],
                                height: 100, width: 100),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName[index],
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  Text(productUnit[index].toString() + " " + r"$" + productPrice[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: (){
                                        dbHelper!.insert(
                                            Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index].toString(),
                                                initialPrice: productPrice[index],
                                                productPrice: productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index].toString(),
                                                image: productImage[index].toString())
                                        ).then((value){

                                          cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                          cart.addCounter();

                                          final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        }).onError((error, stackTrace){
                                          print("error"+error.toString());
                                          final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: const Center(
                                          child: Text("Add to cart", style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )

                          ],
                        )
                      ],
                    ),
                  );
                }))
      ]),
    );
  }
}
