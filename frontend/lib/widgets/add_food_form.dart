import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/daily_meals_provider.dart';
import 'package:frontend/widgets/decimal_text_field.dart';
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
  late TextEditingController foodProteinController ;
  late TextEditingController foodFatController;
  late TextEditingController foodCaloriesController;
  bool enableSubmitButton = false;

  Future<void> addMeal()async{
    Map<String,dynamic> payLoad = {
      "name":foodNameController.text,
      "carbs":double.tryParse(foodCarbsController.text) ?? 0.0,
      "protein":double.tryParse(foodProteinController.text) ?? 0.0,
      "fat":double.tryParse(foodFatController.text) ?? 0.0,
      "calories":double.tryParse(foodCaloriesController.text) ?? 0.0,
    };

    try{ 
      final DailyMealsProvider dailyMealsProvider = Provider.of<DailyMealsProvider>(context,listen:false);
      String logMealResult = await dailyMealsProvider.addDailyMeals(payLoad);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(logMealResult)
        )
      );  
    }
    catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString())
        )
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodNameController = TextEditingController(text: widget.returnedAnalyzedResult?["name"] ?? "");
    foodCaloriesController = TextEditingController(text: widget.returnedAnalyzedResult?["calories_kcal"] ?? "");
    foodProteinController = TextEditingController(text: widget.returnedAnalyzedResult?["protein_g"] ?? "");
    foodCarbsController = TextEditingController(text: widget.returnedAnalyzedResult?["carbs_g"] ?? "");
    foodFatController = TextEditingController(text: widget.returnedAnalyzedResult?["fat_g"] ?? "");

    foodNameController.addListener(updateSubmitButtonState);
    foodCaloriesController.addListener(updateSubmitButtonState);
    foodProteinController.addListener(updateSubmitButtonState);
    foodCarbsController.addListener(updateSubmitButtonState);
    foodFatController.addListener(updateSubmitButtonState);
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
    // TODO: implement dispose
    super.dispose();
    foodNameController.dispose();
    foodCaloriesController.dispose();
    foodProteinController.dispose();
    foodCarbsController.dispose();
    foodFatController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
            ShrinkButton(
            onPressed: ()async {
              if(enableSubmitButton){
                if(_formKey.currentState!.validate()){
                  await addMeal();
                  Navigator.pop(context);
                }
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: enableSubmitButton ? normalGreen : normalGreen.withValues(alpha:0.5)
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Add Food",
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
        )
      ],
    );
  }
}
