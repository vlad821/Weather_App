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
  WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
  await weatherProvider.getDataFromLocation();
 // await weatherProvider.getAddressFromCoordinates();
  
  // Assuming cityName is a property in WeatherModel
 // String cityName = weatherProvider.data?.cityName ?? 'Unknown City';
   // String country = weatherProvider.data?.cityName ?? 'Unknown City';

  // Now you can use the cityName as needed.
 // print('City Name: $cityName');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
         extendBodyBehindAppBar: true,

      appBar: AppBar(
  backgroundColor: Colors.transparent, // Зробіть фон прозорим
  elevation: 0, // Забороніть тінь AppBar
  leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 13, 2, 51),
        ),
        onPressed: () {
          // Поверніться на попередню сторінку
          Navigator.pop(context);
        },
      );
    },
  ),
    //  backgroundColor:  Color.fromRGBO(128, 198, 255, 1),
      ),
      body: Container(
         decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 59, 161, 245),
       // Color.fromARGB(255, 23, 29, 208),
  Color.fromARGB(255, 110, 180, 237),
    Color.fromARGB(255, 207, 233, 255),
           Color.fromARGB(255, 148, 205, 251),
 Color.fromARGB(255, 59, 161, 245),
  Color.fromARGB(255, 0, 52, 130),
          Color.fromARGB(255, 48, 0, 87),
             Color.fromARGB(235, 22, 0, 38),
      ],
    ),
  ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0.6 * kToolbarHeight, 20, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
              
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 237.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
                _WeatherData(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _WeatherBackground extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var height = size.height;
//     var width = size.width;

//     final data = context.watch<WeatherProvider>().data;

//     return Align(
//       alignment: const AlignmentDirectional(1, 5),
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: data?.temp != null && data!.temp! < 18
//               ? const Color.fromARGB(255, 243, 233, 142)
//               : Colors.blue.shade200,
//         ),
//       ),
//     );
//   }
// }

class _WeatherData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<WeatherProvider>().data;


    return FutureBuilder<void>(
      // Додаємо затримку в 10 секунд
      future: Future.delayed(const Duration(seconds: 10)),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Після 15 секунд, перевіряємо чи дані все ще є нульовими
          if (data == null) {
            // Показуємо текст, оскільки дані все ще є нульовими
            return const Center(
              child: Text(
                'No data available. Try later!',
                style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 3, 7, 85),fontWeight: FontWeight.bold),
              ),
            );
          } else {
            // Відображаємо інші дані
            return _buildDataWidget(context, data);
          }
        } else {
          // Поки чекаємо 15 секунд, відображаємо індикатор завантаження
          return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 65, 155)));
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
                data.humidity! < 1010 ? 'assets/rainy.png' : 'assets/sunny.png',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
          Text(
          '${data.temp?.toInt()}°С',
          style: const TextStyle(fontSize: 60, color:Color.fromARGB(255, 15, 27, 99),fontWeight: FontWeight.w700),
        ),
        Text(
          data.cityName.toString(),
          style: const TextStyle(fontSize: 40, color:Color.fromARGB(255, 15, 27, 99),fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
     Text(
DateFormat.jm().format(DateTime.now()),
  style: const TextStyle(fontSize: 30,  color:Color.fromARGB(255, 15, 27, 99),fontWeight: FontWeight.w600),
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
