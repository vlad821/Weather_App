// home_layout.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/logic/weather_changenotifier.dart';
import 'package:intl/intl.dart';

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
  WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
  await weatherProvider.getDataFromLocation();
 // await weatherProvider.getAddressFromCoordinates();
  
  // Assuming cityName is a property in WeatherModel
  String cityName = weatherProvider.data?.cityName ?? 'Unknown City';
   // String country = weatherProvider.data?.cityName ?? 'Unknown City';

  // Now you can use the cityName as needed.
  print('City Name: $cityName');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 0, 65, 155),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 0, 65, 155),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          color: Colors.white, // Set the icon color to white
          ),
          onPressed: () {
            // Pop the current route
            Navigator.pop(context);
          },
        ),
        // Other AppBar properties
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.5 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
                 Positioned(
                   top: -85.0,  // Adjust the top value as needed
            left:5.0, // Adjust the left value as neededF
      right:5.0, // Adjust the left value as needed
      child: _WeatherBackground(),
    ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 300.0),
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
      alignment: const AlignmentDirectional(1, -5.5),
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
}

class _WeatherData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<WeatherProvider>().data;

    if (data == null) {
      // Handle the case where data is null, you might want to show a loading indicator
      return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 65, 155)));
    }

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
                data.humidity! > 1000 ? 'assets/rainy.png' : 'assets/sunny.png',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data.cityName.toString(),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
     Text(
DateFormat.jm().format(DateTime.now()),
  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
),

        Text(
          '${data.temp}°',
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
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
                                '${data.feelsLike}° ',
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
