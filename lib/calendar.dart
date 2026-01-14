import 'package:flutter/material.dart';
import 'package:flutter_application_diary/calender_add_event.dart';
import 'package:table_calendar/table_calendar.dart';


final eventsData = {
  DateTime.utc(2026, 1, 11): [
    {'title': '初詣', 'description': '家族と'},
    {'title': '買い物', 'description': '牛肉, 卵, 白菜'},
  ],
  DateTime.utc(2026, 1, 23): [
    {'title': '課題提出', 'description': 'モバイルプログラミング'},
    {'title': '会議', 'description': '研究室'},
  ]
};


class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Map<String, String>> _eventsOfSelectedDay = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime.utc(now.year, now.month, now.day);

    _eventsOfSelectedDay = eventsData[_selectedDay] ?? [];
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2029, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              eventLoader: (date) {
                return eventsData[date] ?? [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected:((selectedDay, focusedDay) {
                if(!isSameDay(_selectedDay, selectedDay)){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _eventsOfSelectedDay = eventsData[selectedDay] ?? [];
                  });
                }
              }),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _eventsOfSelectedDay.length,
                itemBuilder: (context, index) {
                  final event = _eventsOfSelectedDay[index]['title']!;
                  final description = _eventsOfSelectedDay[index]['description']!;
                  return Card(
                    child: ListTile(
                      title: Text(event),
                      subtitle: Text(description),
                      trailing: IconButton(icon: const Icon(Icons.delete),
                        onPressed: (){
                          setState((){
                            _eventsOfSelectedDay.removeAt(index);
                            eventsData[_selectedDay] = _eventsOfSelectedDay;
                            debugPrint('${eventsData[_selectedDay]}');
                          });
                        },),
                    ),

                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: "add_event_btn",
            onPressed: () async{
                Map<DateTime, Map<String, String>>? eventData = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventPage(selectedDay: _selectedDay,)),
              );
              if(eventData != null){
                setState(() {
                  if(eventsData[_selectedDay] == null){
                    eventsData[_selectedDay] = [];
                  }
                  // eventsData[_selectedDay]!.add(eventData[_selectedDay]!['title']!);
                  eventData.forEach((datekey, eventdata){
                    eventsData[datekey]!.add(eventdata);
                  });
                });
                _eventsOfSelectedDay = eventsData[_selectedDay]!;
              }
              
              
            },
            backgroundColor: const Color.fromARGB(255, 204, 255, 146),
            child: const Icon(Icons.add, color: Color.fromARGB(255, 85, 78, 64)),
          ),
        ),
     ]
    );
  }
}
