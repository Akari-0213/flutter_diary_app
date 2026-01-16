import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_diary/diary_add.dart';


List<Map<String, dynamic>> diaryDataList = [];
Future<void> saveDiaries() async {
  final prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> exportList = diaryDataList.map((item) {
    // もとのMapをコピーしてDateTime型をString型に変換
    final Map<String, dynamic> newItem = Map.from(item);
    if (newItem['diaryTime'] is DateTime) {
      newItem['diaryTime'] = (newItem['diaryTime'] as DateTime).toIso8601String();
    }
    return newItem;
  }).toList();

  await prefs.setString('diary_data', jsonEncode(exportList));
}


Future<void> loadDiaries() async {
  final prefs = await SharedPreferences.getInstance();
  final String? jsonString = prefs.getString('diary_data');
  
  if (jsonString != null) {
    final List<dynamic> decodedList = jsonDecode(jsonString);
    
    diaryDataList = decodedList.map((item) {
      final Map<String, dynamic> mapItem = Map<String, dynamic>.from(item);
      // 文字列として保存された日付をDateTime型に復元
      if (mapItem['diaryTime'] != null && mapItem['diaryTime'] is String) {
        mapItem['diaryTime'] = DateTime.parse(mapItem['diaryTime']);
      }
      return mapItem;
    }).toList();
  }
  
}


class EditDiaryWidget extends StatefulWidget {
  const EditDiaryWidget({super.key});

  @override
  State<EditDiaryWidget> createState() => _EditDiaryWidgetState();
}

class _EditDiaryWidgetState extends State<EditDiaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CustomScrollView(
            slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final data = diaryDataList[index];
                  return Card(
                    key: ValueKey(data.hashCode),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _EditedCard(
                      cardName: data["cardName"],
                      cardContent: data["cardContent"],
                      diaryTime: data["diaryTime"],
                    ),
                  );
                },
                childCount: diaryDataList.length,
              ),
            ),
          ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: "add_dialy_btn",
              onPressed: () async{
                Map<String, dynamic>? diaryData = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDiary()));
                if(diaryData != null){
                  setState(() {
                    diaryDataList.add(diaryData);
                  });
                  saveDiaries();
                }
              },
              backgroundColor: const Color.fromARGB(255, 204, 255, 146),
              child: const Icon(Icons.add, color: Color.fromARGB(255, 85, 78, 64)),
              )
          ),
        ],
      );
  }
}


class _EditedCard extends StatelessWidget {
  const _EditedCard({required this.cardName, required this.cardContent, required this.diaryTime});
  final String? cardName;
  final String? cardContent;
  final dynamic diaryTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    width: 600, 
    height: 200, 
    child: Column(
      children: [
        Center(child: Text(
        cardName != '' ? 
        '$cardName' : 'No title.', 
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
        Center(child: Text(
        diaryTime != '' ?
        '${diaryTime!.year}/${diaryTime!.month}/${diaryTime!.day}' : "No date")),
        Center(child: Text(
        cardContent != '' ?
        '$cardContent' : 'No content.',)),
      ],
      ),
    );
  }
}