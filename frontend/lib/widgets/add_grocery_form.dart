import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/grocery_provider.dart';
import 'package:frontend/widgets/decimal_text_field.dart';
import 'package:frontend/widgets/disposal_recommendation.dart';
import 'package:frontend/widgets/int_text_field.dart';
import 'package:frontend/widgets/shrink_button.dart';
import 'package:provider/provider.dart';

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
  late String groceryUnit;
  bool enableSubmitButton = false;
  late Map<String,dynamic>  groceryNutritions;
  late List<Map<String,dynamic>> packagingMaterials;
  late String per;
  String? errorMessage;

  Future <void> addGrocery()async{
    setState(() {
      errorMessage = null;
    });
    Map<String,dynamic> payLoad = {
      ...?widget.returnedAnalyzedResult,
      "name":groceryNameController.text,
      "category":groceryCategory.toLowerCase(),
      "quantity":int.tryParse(groceryQuantityController.text) ?? 0,
      "expiry_date":groceryExpiryDateController.text,
      "calories_kcal":double.tryParse(groceryCaloriesController.text) ?? 0.0,
      "protein_g":double.tryParse(groceryProteinController.text) ?? 0.0,
      "fat_g":double.tryParse(groceryFatController.text) ?? 0.0,
      "carbs_g":double.tryParse(groceryCarbsController.text) ?? 0.0,
      "per": per,
      "unit":groceryUnit.toLowerCase(),
    };

    try{
      final GroceryProvider groceryProvider = Provider.of(context , listen: false);
      await groceryProvider.addGroceries(payLoad);
      if (!mounted) return;
      Navigator.pop(context,true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully ${widget.returnedAnalyzedResult == null ? "added" : "updated"} groceries")
        )
      ); 
    }
    catch(err){
      print(err);
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
    // TODO: implement initState
    super.initState(); 
    groceryNameController = TextEditingController(text: widget.returnedAnalyzedResult?["name"] ?? "");
    groceryQuantityController = TextEditingController(text: widget.returnedAnalyzedResult?["quantity"]?.toString() ?? "");
    Map<String,dynamic> groceryNutritions = Map<String,dynamic>.from(widget.returnedAnalyzedResult?["nutrition"] ?? {});
    groceryCaloriesController = TextEditingController(text: groceryNutritions["calories_kcal"]?.toString() ?? "");
    groceryProteinController = TextEditingController(text: groceryNutritions["protein_g"]?.toString() ?? "");
    groceryCarbsController = TextEditingController(text: groceryNutritions["carbs_g"]?.toString() ?? "");
    groceryFatController = TextEditingController(text: groceryNutritions["fat_g"]?.toString() ?? "");
    groceryExpiryDateController = TextEditingController(text: widget.returnedAnalyzedResult?["expiry_date"] ?? "");
    groceryCategory = widget.returnedAnalyzedResult?["category"]?.toString().toLowerCase() ?? "";
    groceryUnit = widget.returnedAnalyzedResult?["unit"]?.toString().toLowerCase() ?? "";
    List<dynamic> packagingMaterialsList = widget.returnedAnalyzedResult?["packaging_materials"] ?? [];
    packagingMaterials = packagingMaterialsList.map((packagingMaterial)=>Map<String,dynamic>.from(packagingMaterial)).toList();
    per = widget.returnedAnalyzedResult?["per"]?.toString() ?? "100 g";
    

    print("Analyzed Result:${widget.returnedAnalyzedResult}");
    print("Category:$groceryCategory");
    updateSubmitButtonState();

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
    final GroceryProvider groceryProvider = context.watch<GroceryProvider>();
    String buttonText;
    if(groceryProvider.isEditing){
      buttonText = widget.returnedAnalyzedResult != null ? "Updating..." : "Adding...";
    }
    else{
      buttonText = widget.returnedAnalyzedResult != null ? "Update Grocery" : "Add Grocery";
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
                "Grocery Name",
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
              initialValue:groceryCategory.isNotEmpty ? groceryCategory : null,
              hint: Text("Select a grocery category"),
              decoration: fieldDecoration,
              items:['Fresh Produce' , 'Packaged Food' , 'Packaged Beverage']
                .map((e)=>DropdownMenuItem(               
                  value: e.toLowerCase(),
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
            Column(
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
            ),
            SizedBox(height: 10.0),
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
                        "Unit",
                        style: subtitleText,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>
                      (
                        decoration: fieldDecoration,
                        initialValue: groceryUnit.isNotEmpty ? groceryUnit : null,
                        hint: Text('Select a unit'),
                        items:["g","unit" , "m3"]
                          .map((e)=>DropdownMenuItem(
                            value: e ,
                            child: Text(e)
                          )
                        ).toList(),
                        onChanged:(value){
                          setState(() {
                            groceryUnit = value!;
                          });
                          updateSubmitButtonState();
                        },
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Required.";
                          }
                          return null;
                        },
                      )
                    ],
                  )
                )
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              "Nutritional Value (Per $per)",
              style: subtitleText,
            ),
            SizedBox(height: 10),
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
            onPressed: () async{
              if(enableSubmitButton && !groceryProvider.isEditing){
                if(_formKey.currentState!.validate()){
                  await addGrocery();
                }
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: enableSubmitButton && !groceryProvider.isEditing ? normalGreen : normalGreen.withValues(alpha:0.5)
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  buttonText ,
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
        ]
      ],
    );
  }
}
