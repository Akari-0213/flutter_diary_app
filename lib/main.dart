import 'package:flutter/material.dart';


void main() {
 runApp(const MyApp());
}


class MyApp extends StatefulWidget {
 const MyApp({super.key});


 @override
 State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: Scaffold(
       appBar: AppBar(
         title: Text("dialy"),
         backgroundColor: Colors.green
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       floatingActionButton:SizedBox(
         width: 75,
         height: 75,
         child: FloatingActionButton(
           shape: CircleBorder(),
           backgroundColor: const Color.fromARGB(255, 204, 255, 146),
          
           onPressed: () {},
           child: Icon(
             Icons.home,
             size: 50,
             color: Color.fromARGB(255, 85, 78, 64),
           ),
         ),
       ),
       bottomNavigationBar: MenuBottomApp(),
    


     ),
   );
 }
}




class MenuBottomApp extends StatelessWidget {
 const MenuBottomApp({super.key});


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
           onPressed: () {
             debugPrint("clicked");
           },
         ),
         const SizedBox(width: 20),
         IconButton(
           icon: Icon(
               Icons.mode_edit,
               color:  Color.fromARGB(255, 219, 201, 162),
               size: 40
             ),
           onPressed: () {},
         ),
         const SizedBox(width: 100),
         IconButton(
           icon: Icon(
               Icons.sunny,
               color:  Color.fromARGB(255, 219, 201, 162),
               size: 40
             ),
           onPressed: () {},
         ),
         const SizedBox(width: 20),
         IconButton(
           icon: Icon(
               Icons.person,
               color:  Color.fromARGB(255, 219, 201, 162),
               size: 40
             ),
           onPressed: () {},
         ),
       ],
     ),
   );
 }
}





