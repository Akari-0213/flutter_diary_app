import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class HomeWidget extends StatefulWidget {
  final DateTime now;
  const HomeWidget({super.key, required this.now});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  DateTime lastLoginDay = DateTime.utc(2026, 1, 15);
  int loginStreak = 0;
  String weatherName = "取得中...";
  String tempertureName = "取得中...";
  IconData? iconName; 
  Map<String,List<dynamic>> weatherTaranslation = {
    "Clear":["晴れ", Icons.sunny],
    "Clouds": ["曇り", Icons.cloud],
    "Rain": ["雨", Icons.umbrella],
    "Snow": ["雪", Icons.snowing],
    "Thunderstorm": ["雷雨", Icons.thunderstorm],
    "Drizzle": ["霧雨", Icons.umbrella],
    "Mist": ["霧", Icons.foggy],
    "Fog": ["濃霧", Icons.foggy]
  };

  @override
  void initState(){
    super.initState();
    _setupLoginStreak();
    getWeather();
  }

  Future<void> _setupLoginStreak() async {
    final prefs = await SharedPreferences.getInstance();

    String? lastSaved = prefs.getString('last_login_day');
    int savedStreak =  prefs.getInt('login_streak') ?? 0;
    if (lastSaved != null) {
      debugPrint(lastSaved);
      lastLoginDay = DateTime.parse(lastSaved);
      loginStreak = savedStreak;
    }
    final today = DateTime.utc(widget.now.year, widget.now.month, widget.now.day);
    final lastLoginUtc = DateTime.utc(lastLoginDay.year, lastLoginDay.month, lastLoginDay.day);
    final difference = today.difference(lastLoginUtc).inDays;
    setState(() {
      if(difference == 1){
        loginStreak++;
      }else if(difference == 0){
        
      }else{
        loginStreak = 0;
      }
    });

    await prefs.setString('last_login_day', today.toIso8601String());
    await prefs.setInt('login_streak', loginStreak);
  }

  Future<void> getWeather() async{
    final dio = Dio();
    String key = "";//openweathermapのapiキーを入れる
    double lat = 35.4912; //緯度
    double lon = 139.2917; //経度
    try {
        final response = await dio.get(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$key"
        );
      final Map<String, dynamic> data = response.data;

        if (data["weather"] != null && (data["weather"] as List).isNotEmpty) {
          final String resDataWeather = data["weather"][0]["main"];
          final num resDataTemperture = data["main"]["temp"];
          double tempDouble = resDataTemperture.toDouble();

          if (!mounted) return;

          setState(() {
            if (weatherTaranslation.containsKey(resDataWeather)) {
              weatherName = weatherTaranslation[resDataWeather]![0];
              iconName = weatherTaranslation[resDataWeather]![1];
            } else {
              weatherName = resDataWeather;
              iconName = Icons.help_outline;
            }
            double tempCelsius = tempDouble - 273.15;
            tempertureName = tempCelsius.toStringAsFixed(1);
          });
        } else {
          // weatherデータが想定外の形式だった場合
          throw Exception("天気データが見つかりません");
        }
      } catch (e) {
        // 通信エラーやAPIキーミスなどで失敗した場合の処理
        debugPrint("天気取得エラー: $e");
        if (!mounted) return;
        setState(() {
          weatherName = "取得失敗";
          iconName = Icons.error_outline;
          tempertureName = "取得失敗";
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: SizedBox(
            width: 600, 
            height: 150,
            child: Column(
              children:[
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("連続ログイン日数",
                    style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64),fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    Icon(Icons.person, color: const Color.fromARGB(255, 85, 78, 64),)
                  ]
                ),
                SizedBox(height: 20),
                Text("$loginStreak",
                    style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64),fontSize: 30, fontWeight: FontWeight.bold)
                  ),
              ],
            ),
          ),
        ),
        Card(
          child: SizedBox(
            width: 600, 
            height: 300,
            child: Column(
              children: [
                SizedBox(height: 25),
                Text("現在の所沢お天気",
                    style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64),fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                SizedBox(height: 35),
                Text(weatherName,
                    style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64),fontSize: 30, fontWeight: FontWeight.bold)
                  ),
                Icon(iconName ?? Icons.refresh, color: Color.fromARGB(255, 85, 78, 64), size: 50),
                SizedBox(height: 20),
                Text("温度：$tempertureName℃",
                    style: TextStyle(color: const Color.fromARGB(255, 85, 78, 64),fontSize: 30, fontWeight: FontWeight.bold)
                  ),
              ],
            ),
          ),
        ),
      ]
    );
    
  }
}