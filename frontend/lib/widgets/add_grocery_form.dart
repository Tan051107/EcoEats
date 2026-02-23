import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/widgets/decimal_text_field.dart';
import 'package:frontend/widgets/int_text_field.dart';
import 'package:frontend/widgets/shrink_button.dart';

class AddGroceryForm extends StatefulWidget {
  const AddGroceryForm(
    {
      super.key,
      this.returnedAnalyzedResult
    }
  );

  final Map<String,dynamic>? returnedAnalyzedResult;


  @override
  State<AddGroceryForm> createState() => _AddGroceryFormState();
}



class _AddGroceryFormState extends State<AddGroceryForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController groceryNameController;
  late TextEditingController groceryQuantityController ;
  late TextEditingController groceryExpiryDateController;
  late TextEditingController groceryCarbsController;
  late TextEditingController groceryProteinController ;
  late TextEditingController groceryFatController;
  late TextEditingController groceryCaloriesController;
  late String groceryCategory;
  bool enableSubmitButton = false;

  Future <void> addGrocery()async{
    Map<String,dynamic> payLoad = {
      "name":groceryNameController.text,
      "quantity":int.tryParse(groceryQuantityController.text) ?? 0,
      "carbs_g":double.tryParse(groceryCarbsController.text) ?? 0.0,
      "protein_g":double.tryParse(groceryProteinController.text) ?? 0.0,
      "fat_g":double.tryParse(groceryFatController.text) ?? 0.0,
      "calories_kcal":double.tryParse(groceryCaloriesController.text) ?? 0.0,
      "category":groceryCategory.toLowerCase(),
      "expiry_date":groceryExpiryDateController.text
    };

    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final addShelfItem = functions.httpsCallable("addShelfItem");
    try{
      final response = await addShelfItem.call(payLoad);
      final Map<String,dynamic> responseResult = response.data;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseResult["message"])
        )
      ); 
    }
    on FirebaseFunctionsException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString())
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
    groceryNameController = TextEditingController(text: widget.returnedAnalyzedResult?["name"] ?? "");
    groceryQuantityController = TextEditingController(text: "");
    groceryCaloriesController = TextEditingController(text: widget.returnedAnalyzedResult?["calories_kcal"]?.toString() ?? "");
    groceryProteinController = TextEditingController(text: widget.returnedAnalyzedResult?["protein_g"]?.toString() ?? "");
    groceryCarbsController = TextEditingController(text: widget.returnedAnalyzedResult?["carbs_g"]?.toString() ?? "");
    groceryFatController = TextEditingController(text: widget.returnedAnalyzedResult?["fat_g"]?.toString() ?? "");
    groceryExpiryDateController = TextEditingController(text: widget.returnedAnalyzedResult?["expiry_date"]?.toString() ?? "" );
    groceryCategory = widget.returnedAnalyzedResult?["category"]?.toString().toLowerCase() ?? "";

    groceryNameController.addListener(updateSubmitButtonState);
    groceryQuantityController.addListener(updateSubmitButtonState);
    groceryCaloriesController.addListener(updateSubmitButtonState);
    groceryProteinController.addListener(updateSubmitButtonState);
    groceryCarbsController.addListener(updateSubmitButtonState);
    groceryFatController.addListener(updateSubmitButtonState);
   groceryExpiryDateController.addListener(updateSubmitButtonState);
  }

  void updateSubmitButtonState(){
    bool shouldEnableSubmit = groceryNameController.text.isNotEmpty
                              && groceryQuantityController.text.isNotEmpty
                              &&groceryCaloriesController.text.isNotEmpty
                              &&groceryProteinController.text.isNotEmpty
                              &&groceryCarbsController.text.isNotEmpty
                              &&groceryFatController.text.isNotEmpty
                              &&groceryExpiryDateController.text.isNotEmpty
                              &&groceryCategory.isNotEmpty;
      
    if(shouldEnableSubmit != enableSubmitButton){
      setState(() {
        enableSubmitButton = shouldEnableSubmit;
      });
    }
  }

  Future<void> selectExpiryDate(BuildContext context)async{
    DateTime now = DateTime.now();
    DateTime? selectedExpiryDate = await showDatePicker(
      context: context, 
      firstDate: DateTime(now.year,now.month,now.day), 
      lastDate: DateTime(2100)
    );

    if(selectedExpiryDate != null){
      String day = selectedExpiryDate.day.toString().padLeft(2,'0');
      String month = selectedExpiryDate.month.toString().padLeft(2,'0');
      String year = selectedExpiryDate.year.toString();
      groceryExpiryDateController.text = "$year-$month-$day";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    groceryNameController.dispose();
    groceryQuantityController.dispose();
    groceryCaloriesController.dispose();
    groceryProteinController.dispose();
    groceryCarbsController.dispose();
    groceryFatController.dispose();
    groceryExpiryDateController.dispose();
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
                  Icons.trolley,
                  size: 30.0,
                ),
                SizedBox(width: 5.0),
                Text(
                  "Add Grocery",
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
                controller: groceryNameController,
                decoration: fieldDecoration,
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
            Text(
              "Food Category",
              style: subtitleText,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>
            (
              decoration: fieldDecoration,
              items:['Fresh Produce' , 'Packaged Food' , 'Packaged Beverage']
                .map((e)=>DropdownMenuItem(
                  value: e,
                  child: Text(e)
                )
              ).toList(),
              onChanged:(value){
                setState(() {
                  groceryCategory = value!;
                });
                updateSubmitButtonState();
              },
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "Required.";
                }

                return null;
              },
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: IntTextField(
                    controller:groceryQuantityController,
                    label: "Quantity", unit: ""
                  )
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expiry Date",
                        style: subtitleText,
                      ),
                      SizedBox(height:10.0),
                      TextField(
                        controller: groceryExpiryDateController,
                        readOnly: true,
                        onTap: () => selectExpiryDate(context),
                        decoration: fieldDecoration,
                      )
                    ],
                  )
                )
              ],
            ),
            SizedBox(height: 10.0),
            DecimalTextField(
              controller:groceryCaloriesController,
              label: "Calories", unit: "kcal"
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: DecimalTextField(
                    controller:groceryProteinController,
                    label: "Protein", unit: "g"
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: DecimalTextField(
                    controller:groceryFatController,
                    label: "Fat", unit: "g"
                  )
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: DecimalTextField(
                    controller:groceryCarbsController,
                    label: "Carbs", unit: "g"
                  )
                )
              ],
            ),
            SizedBox(height: 20.0,),
            ShrinkButton(
            onPressed: () async{
              if(enableSubmitButton){
                if(_formKey.currentState!.validate()){
                  await addGrocery();
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
                  "Add Grocery",
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
