import 'package:flutter/material.dart';
import 'package:frontend/services/meal_service.dart';
import 'package:frontend/services/summary_service.dart';

class DailyMealsProvider extends ChangeNotifier{
  List<Map<String,dynamic>> _dailyMeals = [];
  Map<String,dynamic> _dailySummary = {};
  bool _isLoading = false;
  bool _isEditing = false;

  List<Map<String,dynamic>> get dailyMeals => _dailyMeals;
  Map<String,dynamic> get dailySummary => _dailySummary;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;

  Future<void> fetchDailyMeals()async{
    if(_isLoading){
      return;
    }
    _isLoading = true;
    notifyListeners();
    try{
      _dailyMeals =  await MealService.fetchDailyMeals();
      _dailySummary = await SummaryService.getDailySummary();
      print("Provider Daily Summary: $_dailySummary");
      notifyListeners();
    }
    catch(err){
      throw Exception(err);
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<String> addDailyMeals(Map<String,dynamic>mealData)async{
    _isEditing = true;
    notifyListeners();
    try{
      Map<String,dynamic> result = await MealService.addDailyMeals(mealData);
      final String? mealIdToUpdate = mealData["meal_id"];
      if(mealIdToUpdate !=null){
        int index = _dailyMeals.indexWhere((dailyMeal)=>dailyMeal["meal_id"] == mealIdToUpdate);
        _dailyMeals[index] = result;
      }
      else{
        _dailyMeals.add(result);
      }
      return "Successfully ${mealIdToUpdate == null ? "added" : "updated"} meals.";
    }
    catch(err){
      throw Exception(err);
    }
    finally{
      _isEditing = false;
      notifyListeners();
    }
  }

  Future<void> removeDailyMeals(String mealId)async{
    _isEditing = true;
    try{
      await MealService.removeMeal(mealId);
      int index =_dailyMeals.indexWhere((dailyMeal)=>dailyMeal["meal_id"] == mealId);
      if(index != -1){
        _dailyMeals.removeAt(index);
      }
    }
    catch(err){
      throw Exception(err);   
    }
    finally{
      _isEditing = false;
      notifyListeners();
    }
  }
}