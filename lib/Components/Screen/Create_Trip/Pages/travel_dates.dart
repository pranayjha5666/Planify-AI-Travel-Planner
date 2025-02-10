import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/Create_Trip/Pages/select_budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../Provider/CreateTripProvider.dart';

class TravelDates extends StatefulWidget {
  static const String routeName = "/create-trip/travel-dates-screen";
  const TravelDates({super.key});

  @override
  State<TravelDates> createState() => _TravelDatesState();
}

class _TravelDatesState extends State<TravelDates> {
  DateTime? _startDate;
  DateTime? _endDate;
  int? _totalNoOfDays;
  DateTime? _focusedDay = DateTime.now();


  void calculateTotalDays() {
    if (_startDate != null && _endDate != null) {
      _totalNoOfDays = _endDate!.difference(_startDate!).inDays + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Travel Dates",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          padding: const EdgeInsets.only(left: 16),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            firstDay: DateTime.now(),
            lastDay: DateTime(3000),
            focusedDay: _focusedDay ?? DateTime.now(),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return (_startDate != null &&
                      _endDate != null &&
                      day.isAfter(_startDate!) &&
                      day.isBefore(_endDate!)) ||
                  (_startDate != null && isSameDay(day, _startDate!)) ||
                  (_endDate != null && isSameDay(day, _endDate!));
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              isTodayHighlighted: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_startDate == null ||
                    (_startDate != null && _endDate != null)) {
                  _startDate = selectedDay;
                  _endDate = null;
                } else {
                  if (selectedDay.isAfter(_startDate!)) {
                    _endDate = selectedDay;
                  } else if (selectedDay.isBefore(_startDate!)) {
                    _startDate = selectedDay;
                    _endDate = null;
                  } else {
                    _endDate = selectedDay;
                  }
                }
                _focusedDay = selectedDay;
                calculateTotalDays();
              });
            },
          ),
          const Spacer(),
          if (_startDate != null && _endDate != null)
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                    onTap: () {
                      if (_startDate != null && _endDate != null) {
                        Provider.of<TripProvider>(context, listen: false)
                            .setTripData(
                                startDate: _startDate.toString(),
                                endDate: _endDate.toString(),
                                totalNoOfDays: _totalNoOfDays);
                      }
                      Navigator.pushNamed(context, SelectBudget.routeName);
                    },
                    text: "Continue")),
        ],
      ),
    );
  }
}
