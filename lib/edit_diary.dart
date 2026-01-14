import 'package:flutter/material.dart';
import 'package:flutter_application_diary/diary_add.dart';


final List<Map<String, dynamic>> diaryDataList = [];

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