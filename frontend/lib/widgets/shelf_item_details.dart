import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/grocery_provider.dart';
import 'package:frontend/widgets/add_grocery_form.dart';
import 'package:frontend/widgets/average_nutrition_card.dart';
import 'package:frontend/widgets/form_dialog.dart';
import 'package:frontend/widgets/shrink_button.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShelfItemDetails extends StatefulWidget {
  ShelfItemDetails(
    {
      super.key,
      required this.groceryDetails
    }
  );

  final Map<String,dynamic> groceryDetails;

  @override
  State<ShelfItemDetails> createState() => _ShelfItemDetailsState();
}

class _ShelfItemDetailsState extends State<ShelfItemDetails> {
  late String name;
  late String category;
  late int estimatedShelfLife;
  late Map<String,dynamic> nutritions;
  late double calories;
  late double protein;
  late double carbs;
  late double fats;
  late List<String> images;
  late String imageUrl;
  late int quantity;
  late List<Map<String,dynamic>> nutritionValues =[];
  late Color bgColor;
  late Color iconColor;
  late String icon;

  @override
  void initState() {
    super.initState();
    print(widget.groceryDetails);
    name = widget.groceryDetails["name"] ?? "";
    category = widget.groceryDetails["category"] ?? "";
    estimatedShelfLife = widget.groceryDetails["estimated_shelf_life"] ?? 0;
    nutritions = Map<String,dynamic>.from(widget.groceryDetails["nutrition"] ?? {});
    calories = (nutritions["calories_kcal"]as num?)?.toDouble() ?? 0.0;
    protein = (nutritions["protein_g"] as num?)?.toDouble() ?? 0.0;
    carbs = (nutritions["carbs_g"] as num?)?.toDouble() ?? 0.0;
    fats = (nutritions["fat_g"] as num?)?.toDouble() ?? 0.0;
    images = (widget.groceryDetails["image_urls"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    imageUrl = "";
    quantity = widget.groceryDetails["quantity"] ?? 0;

    nutritionValues =[
      {
        "nutritionName": "Calories",
        "circleColor":normalBlue,
        "value": calories,
        "unit":"kcal"
      },
      {
        "nutritionName": "Carbs",
        "circleColor":orange,
        "value": carbs,
        "unit":"g"
      },
      {
        "nutritionName": "Protein",
        "circleColor":normalYellow,
        "value": protein,
        "unit":"g"
      },
      {
        "nutritionName": "Fats",
        "circleColor":normalBlue,
        "value": fats,
        "unit":"g"
      },
    ];
  
    switch(estimatedShelfLife){
      case < 3:
        iconColor = normalRed;
        bgColor = lightRed;
        break;
      case < 5:
        iconColor = normalYellow;
        bgColor = lightYellow;
        break;
      default:
        iconColor = gray;
        bgColor = Colors.transparent;
    }

    switch(category.toLowerCase()){
      case "fresh produce":
        icon = "assets/icons/salad.svg";
        break;
      case "packaged food":
        icon = "assets/icons/canned-food.svg";
        break;
      case "packaged beverage":
        icon = "assets/icons/milk.svg";    
    }

    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    if (images.isNotEmpty && images[0].isNotEmpty) {
      try {
        final storageRef = FirebaseStorage.instance.refFromURL(images[0]);
        final downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print("Error loading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = (screenWidth * 0.1).clamp(30,40);
    double nameFontSize = screenWidth * 0.06;
    double detailsFontSize = screenWidth * 0.045;
    double smallDetailsFontSize = screenWidth * 0.04;
    final GroceryProvider groceryProvider = context.watch<GroceryProvider>(); 

    Future<void> removeGrocery(groceryId)async{
      try{
        await groceryProvider.removeGrocery(groceryId);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully removed a meal.")
          )
        );
      }
      catch(err){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to remove meal:$err")
          )
        );
        print(err);      
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          child: Align(
            alignment: AlignmentGeometry.centerRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: Icon(Icons.close)
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor
          ),
          child:Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(        
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child:Padding(
                    padding: EdgeInsets.all(15.0),
                    child: (imageUrl.isNotEmpty)
                          ? Image.network(
                            imageUrl,
                            height: iconSize,
                            width: iconSize,
                            fit: BoxFit.contain,
                          )
                          : SvgPicture.asset(
                            icon,
                            height: iconSize,
                            width: iconSize,
                          ),
                  ),
                ),
                SizedBox(width:10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      category,
                      style: TextStyle(
                        color: gray,
                        fontSize: detailsFontSize
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          color: iconColor,
                          size: 18,
                        ),
                        Text(
                          "${estimatedShelfLife}d left",
                          style: TextStyle(
                            fontSize:smallDetailsFontSize,
                            color: iconColor
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),   
          )
        ),
        SizedBox(height:20.0),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nutrition Info",
                  style:TextStyle(
                    fontSize: detailsFontSize,
                    fontWeight: FontWeight.bold
                  ),
                ),
                GestureDetector(
                  onTap: ()async {
                    Navigator.of(context).pop();
                    await showFormDialog(
                      context: context, 
                      child: AddGroceryForm(returnedAnalyzedResult:widget.groceryDetails)
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: normalGreen,
                      shape: BoxShape.circle
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                )
              ],
            ),
            GridView.builder(
              itemCount: nutritionValues.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 170,
                childAspectRatio: 170/100
              ),
              itemBuilder:(context,index){
                final Map<String,dynamic> nutritionLabel = nutritionValues[index];
                return AverageNutritionCard(
                  name: nutritionLabel["nutritionName"], 
                  value: nutritionLabel["value"], 
                  circleColor: nutritionLabel["circleColor"],
                  unit:nutritionLabel["unit"] ,
                );
              }
            ),
            SizedBox(height: 20.0),
            ShrinkButton(
              onPressed: ()async =>groceryProvider.isEditing ? {} : {await removeGrocery(widget.groceryDetails["item_id"])},
              child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color:groceryProvider.isLoading ? normalRed.withValues(alpha: 0.5):  normalRed
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  textAlign: TextAlign.center,
                  groceryProvider.isEditing ? "Removing Grocery" : "Remove Grocery",
                  style: TextStyle(
                    fontSize: subtitleText.fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
            )
          ],
        )
      ],      
    );
  }
}