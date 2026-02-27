import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/daily_meals_provider.dart';
import 'package:frontend/widgets/add_food_form.dart';
import 'package:frontend/widgets/average_nutrition_card.dart';
import 'package:frontend/widgets/form_dialog.dart';
import 'package:frontend/widgets/shrink_button.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MealDetails extends StatefulWidget {
  MealDetails(
    {
      super.key,
      required this.mealDetails
    }
  );

  final Map<String,dynamic> mealDetails;

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  late String name;
  late Map<String,dynamic> nutritions;
  late double calories;
  late double protein;
  late double carbs;
  late double fats;
  late List<String> images;
  late String imageUrl;
  late List<Map<String,dynamic>> nutritionValues =[];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.mealDetails);
    name = widget.mealDetails["name"] ?? "";
    nutritions = Map<String,dynamic>.from(widget.mealDetails["nutrition"] ?? {});
    calories = (nutritions["calories_kcal"]as num?)?.toDouble() ?? 0.0;
    protein = (nutritions["protein_g"] as num?)?.toDouble() ?? 0.0;
    carbs = (nutritions["carbs_g"] as num?)?.toDouble() ?? 0.0;
    fats = (nutritions["fat_g"] as num?)?.toDouble() ?? 0.0;
    images = (widget.mealDetails["image_urls"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    imageUrl = "";

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
        print(downloadUrl);
      } catch (e) {
        print("Error loading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double nameFontSize = screenWidth * 0.06;
    double detailsFontSize = screenWidth * 0.045;
    final DailyMealsProvider dailyMealsProvider = context.watch<DailyMealsProvider>(); 

    Future<void> removeMeal(String mealId)async{
      try{
        await dailyMealsProvider.removeDailyMeals(mealId);
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
            borderRadius: BorderRadius.circular(12.0),
            color: normalGreen
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
                    child:imageUrl.isNotEmpty
                          ?Image.network(
                            imageUrl,
                            height: 40,
                            width: 40,
                          )
                          :Icon(
                                  Icons.fastfood,
                                  size: 40,
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
                      child: AddFoodForm(returnedAnalyzedResult:widget.mealDetails)
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
              onPressed: ()async =>dailyMealsProvider.isEditing ? {} : {await removeMeal(widget.mealDetails["meal_id"])},
              child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color:dailyMealsProvider.isEditing ? normalRed.withValues(alpha: 0.5):  normalRed
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  textAlign: TextAlign.center,
                  dailyMealsProvider.isEditing ? "Removing Meal" : "Remove Meal",
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