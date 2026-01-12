import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDay;
  const AddEventPage({super.key, required this.selectedDay});
  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String? _eventTitle;
  String? _eventDescription;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add Event",
          style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64), fontWeight: FontWeight.bold, fontSize: 24),
          ),
          backgroundColor: Colors.green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Selected Day: ${widget.selectedDay.year}/${widget.selectedDay.month}/${widget.selectedDay.day}"),
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {
                  _eventTitle = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              onChanged: (value){
                setState(() {
                  _eventDescription = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map<DateTime, Map<String, String>> eventData = {
                  widget.selectedDay:{
                    'title': _eventTitle ?? '',
                    'description': _eventDescription ?? '',
                  }
                };
                Navigator.pop(context, eventData);
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}