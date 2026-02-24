import 'package:flutter/material.dart';
import 'package:frontend/services/meal_service.dart';
import 'package:frontend/services/summary_service.dart';

class DailyMealsProvider extends ChangeNotifier{
  List<Map<String,dynamic>> _dailyMeals = [];
  Map<String,dynamic> _dailySummary = {};
  bool _isLoading = false;

  List<Map<String,dynamic>> get dailyMeals => _dailyMeals;
  Map<String,dynamic> get dailySummary => _dailySummary;
  bool get isLoading => _isLoading;

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
    try{
      String result = await MealService.addDailyMeals(mealData);
      notifyListeners();
      return result;
    }
    catch(err){
      throw Exception(err);
    }
  }
}