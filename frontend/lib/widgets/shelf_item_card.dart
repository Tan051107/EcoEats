import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

Widget shelfItemCard(
{required final estimatedShelfLife,
  required final groceryName,
  required final category,
  required final quantity,
  final image}
){
  return Card(
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0)
    ),
    child:Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.set_meal),
                ),
              ),

            ],
          )
        ],
      ),
    )
  );
}