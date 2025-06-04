import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/main_layout.dart';
import 'package:av_solar_services/views/layouts/sup_layout.dart';
import 'package:av_solar_services/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: bgGreen,

  ));
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: bgGreen),
        useMaterial3: true,
      ),
      initialRoute: "/",
      getPages: [
        GetPage(name: '/', page: () => const Login()),
        GetPage(name: '/main', page: () => const MainLayout()),
        GetPage(name: '/sup', page: () => const SupLayout()),
      ],
      // home: Login()
    );
  }
}
