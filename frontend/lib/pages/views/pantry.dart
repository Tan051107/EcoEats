import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/widgets/header.dart';

class Pantry extends StatefulWidget {
  const Pantry({super.key});

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderSection(),
                    SizedBox(width: 20.0),
                    CategorySelectionSection()
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}


Widget HeaderSection(){
  return Padding(
    padding: EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Header(title: "Shelf" , subtitle: "6 items in stock", isShowBackButton: false),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: normalGreen
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        )
      ],
    )
  );
}

Widget CategorySelectionSection(){
  List<String> groceryCategory = ["Packaged Food" , "Packaged Beverage" , "Fresh Produce"];
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
              ...List.generate(
          groceryCategory.length,
          (index){
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 3 , horizontal: 10),
                    child: Text(
                      groceryCategory[index],
                      style: TextStyle(
                        color: darkGreen,
                        fontSize:15
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0)
              ],
            );
          }      
        )
      ],
    ),
  );
}