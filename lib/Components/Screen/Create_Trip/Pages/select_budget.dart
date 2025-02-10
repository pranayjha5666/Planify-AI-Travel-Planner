import 'package:ai_travel_planner/Common/Lists/select_budget.dart';
import 'package:ai_travel_planner/Components/Screen/Create_Trip/Pages/reveiew_trip.dart';
import 'package:ai_travel_planner/Model/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Common/widget/custom_button.dart';
import '../../../../Provider/CreateTripProvider.dart';

class SelectBudget extends StatefulWidget {
  static const String routeName = "/create-trip/budget-screen";

  const SelectBudget({super.key});

  @override
  State<SelectBudget> createState() => _SelectBudgetState();
}

class _SelectBudgetState extends State<SelectBudget> {
  int? _selectedIndex;
  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _selectedIndex != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          padding: const EdgeInsets.only(left: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Budget",
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose spending habit for your trip',
              style: TextStyle(
                fontSize: 23,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: budgetList.length,
                itemBuilder: (context, index) {
                  final option = budgetList[index];
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : Border.all(color: Colors.transparent),
                        color: Color(0xffe7e7e7),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(14.0),
                      child: ListTile(
                        title: Text(
                          option.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          option.desc,
                          style: const TextStyle(fontSize: 17),
                        ),
                        trailing: option.icon,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isButtonEnabled)
              CustomButton(
                onTap: () {
                  if (_selectedIndex != null) {
                    final selectedOption = budgetList[_selectedIndex!];
                    Provider.of<TripProvider>(context, listen: false).setTripData(
                        budget: BudgetModel(id: selectedOption.id, title: selectedOption.title, desc: selectedOption.desc, icon: selectedOption.icon).toMap()
                    );
                    Navigator.pushNamed(context, ReviewTrip.routeName);
                  } else {
                    print("No option selected.");
                  }
                },
                text: "Continue",
              )

          ],
        ),
      ),

    );
  }
}
