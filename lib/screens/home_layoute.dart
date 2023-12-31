import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/logic/weather_changenotifier.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/screens/detail_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    _initializeWeatherProvider();
  }

  Future<void> _initializeWeatherProvider() async {
    WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.getDataFromLocation();
   // await weatherProvider.getAddressFromCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 65, 155),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 1.8 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                 top: -90.0,  // Adjust the top value as needed
            left:5.0, // Adjust the left value as neededF
      right:5.0, // Adjust the left value as needed
      child: _WeatherBackground()),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 300.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              _WeatherData(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    final data = context.watch<WeatherProvider>().data;

    return Align(
      alignment: AlignmentDirectional(1, -1.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: data?.temp != null && data!.temp! > 18
    ? Colors.yellow.shade400
              : Colors.blue.shade200,
        ),
      ),
    );
  }
}class _WeatherData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<WeatherProvider>().data;

    return FutureBuilder<void>(
      // Додаємо затримку в 15 секунд
      future: Future.delayed(Duration(seconds: 15)),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Після 15 секунд, перевіряємо чи дані все ще є нульовими
          if (data == null) {
            // Показуємо текст, оскільки дані все ще є нульовими
            return Center(
              child: Text(
                'No data available after 15 seconds',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            );
          } else {
            // Відображаємо інші дані
            return _buildDataWidget(context, data);
          }
        } else {
          // Поки чекаємо 15 секунд, відображаємо індикатор завантаження
          return Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 65, 155)));
        }
      },
    );
  }

  // Допоміжний метод для відображення даних, коли вони доступні
  Widget _buildDataWidget(BuildContext context, WeatherModel data) {
    return Column(
      children: [
        // UI components using data
        SizedBox(
          height: 250,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                data.humidity! > 1000 ? 'assets/rainy.png' : 'assets/sunny.png',
              ),
            ],
          ),
        ),
        Text(
          data.cityName.toString(),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 0, 0)),
        ),
        const SizedBox(
          height: 10,
        ),

        Text(
          '${data.temp}°',
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 0, 0)),
        ),
        const SizedBox(
          height: 80,
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(),
                ),
              );
            },
            child: const Text(
              'Additional Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ],
    );
  }
}
