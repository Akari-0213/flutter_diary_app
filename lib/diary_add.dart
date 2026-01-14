import 'package:flutter/material.dart';

class AddDiary extends StatefulWidget {
  const AddDiary({super.key});

  @override
  State<AddDiary> createState() => _AddDiaryState();
}

class _AddDiaryState extends State<AddDiary> {
  String? _diaryTitle;
  String? _diaryContent;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Diary",
          style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64), fontWeight: FontWeight.bold, fontSize: 24),
          ),
          backgroundColor: Colors.green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DatePicker(onDateChanged:(date){
              setState(() {
                _selectedDate = date;
              });
            }),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
              ),
              onChanged:(value) {
                setState(() {
                  _diaryTitle = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _diaryContent = value;
                });
              },
              maxLines: 10,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> diaryData =
                {
                  "cardName": _diaryTitle ?? '',
                  "cardContent": _diaryContent ?? '',
                  "diaryTime": _selectedDate ?? '',
                };
                Navigator.pop(context, diaryData);
              },
              child: Text('Save'),
            ),
          ],
        ),
      )
      );
  }
}


class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  const DatePicker({super.key, required this.onDateChanged});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2030),
    );
    setState(() {
      if (pickedDate != null){
        selectedDate = pickedDate;
        widget.onDateChanged(selectedDate!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: <Widget>[
          Text(
            selectedDate != null
                ? '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}'
                : 'No date selected',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 40,
            width: 120,
            child:
            ElevatedButton(
            onPressed: _selectDate, 
            child: const Text('Select Date', style: TextStyle(fontSize: 12),),
            ),
          ),
        ],
    );
  }
}