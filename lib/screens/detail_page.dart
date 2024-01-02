// home_layout.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/logic/weather_changenotifier.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: _DetailPageContent(),
    );
  }
}

class _DetailPageContent extends StatefulWidget {
  @override
  State<_DetailPageContent> createState() => _DetailPageContentState();
}

class _DetailPageContentState extends State<_DetailPageContent> {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Повернутися на попередню сторінку
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
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
          padding: const EdgeInsets.fromLTRB(20, 1.3 * kToolbarHeight, 20, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _WeatherData(),
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

  Widget _buildDataWidget(BuildContext context, WeatherModel data) {
    return Column(
      children: [
        // UI components using data
        SizedBox(
          height: 200,
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
        const SizedBox(height: 10),
        Text(
          '${data.temp?.toInt()}°С',
          style: const TextStyle(
              fontSize: 60,
              color: Color.fromARGB(255, 15, 27, 99),
              fontWeight: FontWeight.w700),
        ),
        Text(
          data.cityName.toString(),
          style: const TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 15, 27, 99),
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          DateFormat.jm().format(DateTime.now()),
          style: const TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 15, 27, 99),
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/wind.png'),
                ),
                const Text(
                  'Wind',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const Spacer(),
                Text(
                  '${data.wind} m/s',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/humidity.png'),
                ),
                const Text(
                  'Humidity',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const Spacer(),
                Text(
                  '${data.humidity} %',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/thermometer.png'),
                ),
                const Text(
                  'Pressure',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const Spacer(),
                Text(
                  '${data.pressure} hPa',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/winter.png'),
                ),
                const Text(
                  'Feels Like',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const Spacer(),
                Text(
                  '${data.feelsLike?.toInt()}°C',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
