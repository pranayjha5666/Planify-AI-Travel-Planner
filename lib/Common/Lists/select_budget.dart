import 'package:ai_travel_planner/Model/budget_model.dart';
import 'package:flutter/material.dart';

List<BudgetModel> budgetList=[
  BudgetModel(
    id: 1,
    title: "Cheap",
    icon: Icon(Icons.money,size: 40,color: Colors.pink,),
    desc: "Stay consious of cost",
  ),
  BudgetModel(
      id: 2,
      title: "Moderate",
      icon: Icon(Icons.attach_money,size: 40,color: Colors.orange,),
      desc: 'Keep Cost on the average size'
  ),
  BudgetModel(
      id: 3,
      title: "Luxery",
      icon: Icon(Icons.stay_current_portrait_sharp,size: 40,color: Colors.green,),
      desc: 'Dont Worry About Cost'
  ),

];