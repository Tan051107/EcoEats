import 'package:flutter/material.dart';
import 'package:frontend/services/grocery_service.dart';

class GroceryProvider extends ChangeNotifier{

  GroceryProvider(){
    fetchGroceries(category: categorySelected);
  }

  List<Map<String,dynamic>> _groceries = [];
  bool _isLoading = false;
  bool _isEditing = false;
  String _categorySelected = "packaged food";

  List<Map<String,dynamic>> get groceries => _groceries;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  String get categorySelected => _categorySelected;


  void setCategorySelected(String category){
    _categorySelected = category;
    fetchGroceries(category:category);
    notifyListeners();
  }

  Future<void> fetchGroceries({String category = "packaged food"})async{
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try{
      _groceries = await GroceryService.getShelfItems(category);
    }
    catch(err){
      _isLoading = false;
      throw Exception(err);
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<String> addGroceries(Map<String,dynamic>grocery)async{
    if (_isEditing) return "Editing";
    _isEditing = true;
    notifyListeners();
    try{
      Map<String,dynamic> result = await GroceryService.addShelfItem(grocery);
      final String? groceryToUpdate = grocery["item_id"];
      if(groceryToUpdate !=null){
        int index = _groceries.indexWhere((grocery)=>grocery["item_id"] == groceryToUpdate);
        _groceries[index] = result;
      }
      else{
        _groceries.add(grocery);
      }
      setCategorySelected(grocery["category"]);
      return "Successfully ${groceryToUpdate == null ? "added" : "updated"} meals.";
    }
    catch(err){
      _isLoading = false;
      throw Exception(err);
    }
    finally{
      _isEditing = false;
      notifyListeners();
    }
  }


  Future<void> removeGrocery(String groceryId)async{
    _isEditing = true;
    notifyListeners();
    try{
      await GroceryService.removeShelfItem(groceryId);
      int index =_groceries.indexWhere((grocery)=>grocery["item_id"] == groceryId);
      if(index != -1){
        _groceries.removeAt(index);
      }
    }
    catch(err){
      _isLoading = false;
      throw Exception(err);   
    }
    finally{
      _isEditing = false;
      notifyListeners();
    }
  }


}