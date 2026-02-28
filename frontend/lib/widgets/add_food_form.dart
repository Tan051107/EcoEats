import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/daily_meals_provider.dart';
import 'package:frontend/widgets/decimal_text_field.dart';
import 'package:frontend/widgets/disposal_recommendation.dart';
import 'package:frontend/widgets/meal_rating_and_comment.dart';
import 'package:frontend/widgets/shrink_button.dart';
import 'package:provider/provider.dart';

class AddFoodForm extends StatefulWidget {
  const AddFoodForm(
    {
      super.key,
      this.returnedAnalyzedResult
    }
  );

  final Map<String,dynamic>? returnedAnalyzedResult;


  @override
  State<AddFoodForm> createState() => _AddFoodFormState();
}



class _AddFoodFormState extends State<AddFoodForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController foodNameController;
  late TextEditingController foodCarbsController;
  late TextEditingController foodProteinController;
  late TextEditingController foodFatController;
  late TextEditingController foodCaloriesController;
  late Map<String,dynamic>  mealNutritions;
  bool enableSubmitButton = false;
  late List<Map<String,dynamic>> packagingMaterials;
  late String comment;
  late String rating;
  String? errorMessage;


  Future<void> addMeal()async{
    setState(() {
      errorMessage = null;
    });
    Map<String,dynamic> payLoad = {
      ...?widget.returnedAnalyzedResult,
      "name":foodNameController.text.trim(),
      "carbs":double.tryParse(foodCarbsController.text) ?? 0.0,
      "protein":double.tryParse(foodProteinController.text) ?? 0.0,
      "fat":double.tryParse(foodFatController.text) ?? 0.0,
      "calories":double.tryParse(foodCaloriesController.text) ?? 0.0,
    };


    try{ 
      final DailyMealsProvider dailyMealsProvider = Provider.of<DailyMealsProvider>(context,listen:false);
      String logMealResult = await dailyMealsProvider.addDailyMeals(payLoad);
      if(!mounted){
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(logMealResult)
        )
      );  
    }
    catch(err){
      String msg = err.toString();
      if (msg.startsWith('Exception: ')) {
        msg = msg.replaceFirst('Exception: ', '');
      }
      setState(() {
        errorMessage = msg;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mealNutritions = Map<String,dynamic>.from(widget.returnedAnalyzedResult?["nutrition"] ?? {});
    List<dynamic> packagingMaterialsList = widget.returnedAnalyzedResult?["packaging_materials"] ?? [];
    packagingMaterials = packagingMaterialsList.map((packagingMaterial)=>Map<String,dynamic>.from(packagingMaterial)).toList();
    rating = widget.returnedAnalyzedResult?["healthy_score"] ?? "";
    comment = widget.returnedAnalyzedResult?["comment"] ?? "";
    foodNameController = TextEditingController(text: widget.returnedAnalyzedResult?["name"] ?? "");
    foodCaloriesController = TextEditingController(text: mealNutritions["calories_kcal"]?.toString() ?? "");
    foodProteinController = TextEditingController(text: mealNutritions["protein_g"]?.toString() ?? "");
    foodCarbsController = TextEditingController(text:mealNutritions["carbs_g"]?.toString() ?? "");
    foodFatController = TextEditingController(text:mealNutritions["fat_g"]?.toString() ?? "");

    foodNameController.addListener(updateSubmitButtonState);
    foodCaloriesController.addListener(updateSubmitButtonState);
    foodProteinController.addListener(updateSubmitButtonState);
    foodCarbsController.addListener(updateSubmitButtonState);
    foodFatController.addListener(updateSubmitButtonState);

    updateSubmitButtonState();
  }

  void updateSubmitButtonState(){
    bool shouldEnableSubmit = foodNameController.text.isNotEmpty
                              &&foodCaloriesController.text.isNotEmpty
                              &&foodProteinController.text.isNotEmpty
                              &&foodCarbsController.text.isNotEmpty
                              &&foodFatController.text.isNotEmpty;
      
    if(shouldEnableSubmit != enableSubmitButton){
      setState(() {
        enableSubmitButton = shouldEnableSubmit;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    foodNameController.dispose();
    foodCaloriesController.dispose();
    foodProteinController.dispose();
    foodCarbsController.dispose();
    foodFatController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final DailyMealsProvider dailyMealsProvider = context.watch<DailyMealsProvider>();
    String submiButtonText;
    if (dailyMealsProvider.isEditing) {
      submiButtonText = widget.returnedAnalyzedResult != null ? "Updating..." : "Adding...";
    } else {
      submiButtonText = widget.returnedAnalyzedResult != null ? "Update Meal" : "Add Meal";
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.set_meal,
                  size: 30.0,
                ),
                SizedBox(width: 5.0),
                Text(
                  "Add Food",
                  style: headingTwoText,
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed:() => Navigator.pop(context), 
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Food Name",
                style: subtitleText,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: foodNameController,
                decoration: fieldDecoration,
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DecimalTextField(
              controller:foodCaloriesController,
              label: "Calories", unit: "kcal"
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: DecimalTextField(
                    controller:foodProteinController,
                    label: "Protein", unit: "g"
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: DecimalTextField(
                    controller:foodFatController,
                    label: "Fat", unit: "g"
                  )
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: DecimalTextField(
                    controller:foodCarbsController,
                    label: "Carbs", unit: "g"
                  )
                )
              ],
            ),
            SizedBox(height: 20.0,),
            if (errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                ),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.0),
            ],
            ShrinkButton(
            onPressed: ()async {
              if(enableSubmitButton){
                if(_formKey.currentState!.validate() && !dailyMealsProvider.isEditing){
                  await addMeal();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context,true);
                }
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: enableSubmitButton && !dailyMealsProvider.isEditing ? normalGreen : normalGreen.withValues(alpha:0.5)
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  submiButtonText,
                  textAlign: TextAlign.center,
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
        ),
        if(packagingMaterials.isNotEmpty)...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Packaging Found",
                style:TextStyle(
                  fontSize: 18
                )
              ),
              SizedBox(height:10.0),
              ...List.generate(
                packagingMaterials.length, 
                (index){
                  final packagingMaterial = packagingMaterials[index];
                    return DisposalRecommendation(
                      material: packagingMaterial["name"], 
                      disposalWay: packagingMaterial["recommendedDisposalWay"]
                    );
                }
              )
            ],
          )
        ],
        if(comment.isNotEmpty && rating.isNotEmpty)...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Rating and Comments",
                style:TextStyle(
                  fontSize: 18
                )
              ),
              MealRatingAndComment(
                rating: rating, 
                recommendation: comment
              )
            ],
          )
        ]
      ],
    );
  }
}
