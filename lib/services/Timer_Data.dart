import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
class Timer_Data extends ChangeNotifier
{
  int _time_remain_provider=11; // initial value of count down timer
  int gettime_remain_provider() => _time_remain_provider;   //method to get update value of variable
  updateRemainingTime(){
    _time_remain_provider --;  //method to update the variable value
    notifyListeners();
  }
}