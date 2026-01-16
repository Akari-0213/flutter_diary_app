import 'package:flutter/material.dart';
import 'package:flutter_application_diary/edit_diary.dart';
import 'package:flutter_application_diary/home.dart';
import 'calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
 runApp(const MyApp());
}


class MyApp extends StatefulWidget {
 const MyApp({super.key});


 @override
 State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final now = DateTime.now();
  late final List<Widget> _pages= <Widget>[
    CalendarWidget(now: now),
    EditDiaryWidget(),
    HomeWidget(now: now),
  ];

  void _onItemclicked(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dialy App",
          style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64), fontWeight: FontWeight.bold, fontSize: 24),
          ),
          backgroundColor: Colors.green
        ),
        body: _pages[_selectedIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:SizedBox(
          width: 75,
          height: 75,
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: const Color.fromARGB(255, 204, 255, 146),
            
            onPressed: _clickedHomeButton,
            child: Icon(
              Icons.home,
              size: 50,
              color: Color.fromARGB(255, 85, 78, 64),
            ),
          ),
        ),
        bottomNavigationBar: MenuBottomApp(onclick: _onItemclicked),
      


      ),
    );
  }
  void _clickedHomeButton(){
    debugPrint("Home button clicked");
    setState(() { 
      _selectedIndex = 2;
    });
  }
}



class MenuBottomApp extends StatelessWidget {
  

  final Function(int) onclick;
  const MenuBottomApp({super.key, required this.onclick});


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
      ),
      color: const Color.fromARGB(255, 85, 78, 64),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
                Icons.calendar_month,
                color:  Color.fromARGB(255, 219, 201, 162),
                size: 40
              ),
            onPressed: () => onclick(0),
          ),
          const SizedBox(width: 150),
          IconButton(
            icon: Icon(
                Icons.mode_edit,
                color:  Color.fromARGB(255, 219, 201, 162),
                size: 40
              ),
            onPressed: () => onclick(1),
          ),
        ],
      ),
    );
  }
}





