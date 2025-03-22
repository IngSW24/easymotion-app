import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseFilter extends StatelessWidget {
  const CourseFilter(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.onStartDateChange,
        required this.onEndDateChange});

  final DateTime startDate, endDate;
  final void Function(DateTime) onStartDateChange;
  final void Function(DateTime) onEndDateChange;

  Future<void> _askStartDate(BuildContext context) async {
    var date = await showDatePicker(context: context, firstDate: DateTime.timestamp(), lastDate: DateTime.timestamp());
    if (date != null) onStartDateChange(date);
  }

  Future<void> _askEndDate(BuildContext context) async {
    var date = await showDatePicker(context: context, firstDate: DateTime.timestamp(), lastDate: DateTime.timestamp());
    if (date != null) onEndDateChange(date);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Select filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          OutlinedButton(onPressed: () => _askStartDate(context), child: Text("Select start date")),
          OutlinedButton(onPressed: () => _askEndDate(context), child: Text("Select end date")),
          Spacer(),
          Expanded(
            flex: 0,
            child: FilledButton.icon(
              onPressed: () => context.pop(),
              label: Text('Apply Filters'),
              icon: Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
