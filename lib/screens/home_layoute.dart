import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 54, 115, 200),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 48, 0, 87),
              Color.fromARGB(255, 0, 52, 130),
              Color.fromARGB(255, 59, 161, 245),
              Color.fromARGB(255, 110, 180, 237),
              Color.fromARGB(255, 207, 233, 255),
              Color.fromARGB(255, 207, 233, 255),
              Color.fromARGB(255, 148, 205, 251),
              Color.fromARGB(255, 25, 131, 217),
              Color.fromARGB(255, 0, 52, 130),
              Color.fromARGB(255, 48, 0, 87),
              Color.fromARGB(235, 22, 0, 38),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 1.8 * kToolbarHeight, 40, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _WeatherData(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<WeatherProvider>().data;

    final startTime = DateTime.now();

    return FutureBuilder<void>(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        final elapsedTime = DateTime.now().difference(startTime);

        if (snapshot.connectionState == ConnectionState.done) {
          if (data == null) {
            return const Center(
              child: Text(
                'No data avaible. Try later!',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 3, 7, 85),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return _buildDataWidget(context, data);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // Check if 5 seconds have passed and data is still not available
          if (elapsedTime.inSeconds >= 5 && data == null) {
            return const Center(
              child: Text(
                'No data avaible. Try later!',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 3, 7, 85),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 65, 155),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 0, 65, 155),
            ),
          );
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
                data.pressure! < 1011 ? 'assets/rainy.png' : 'assets/sunny.png',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          '${data.temp?.toInt()}°С',
          style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(
          data.cityName.toString(),
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        const SizedBox(
          height: 0,
        ),

        Text(
          data.pressure! < 1011 ? 'Cloudy.Possible rain!' : 'Sunny',
          style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
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
                  builder: (context) => const DetailPage(),
                ),
              );
            },
            child: const Text(
              'Additional Information',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ],
    );
  }
}
