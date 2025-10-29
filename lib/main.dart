// import 'package:av_solar_services/constants/colors.dart';
// import 'package:av_solar_services/views/layouts/sup_layout.dart';
// import 'package:av_solar_services/views/screens/login.dart';
// import 'package:av_solar_services/views/screens/location_screen.dart';
// import 'package:av_solar_services/views/screens/forgot_password.dart';
// import 'package:av_solar_services/views/screens/reset_password.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// void main() {
//   SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: bgGreen,

//   ));
//   runApp(const MyApp());

// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(

//         colorScheme: ColorScheme.fromSeed(seedColor: bgGreen),
//         useMaterial3: true,
//       ),
//       initialRoute: "/",
//       getPages: [
//         GetPage(name: '/', page: () => const Login()),
//       // GetPage(name: '/main', page: () => const MainLayout()),
//         GetPage(name: '/forgot-password', page: () => const ForgotPasswordPage()),
//         GetPage(name: '/sup', page: () => const SupLayout()),
//         GetPage(
//              name: '/location',
//              page: () {
//               final args = Get.arguments as Map<String, dynamic>;
//               return LocationScreen(projectId: args['projectId']);
//              },
//         ),
//           GetPage(
//     name: '/reset-password',
//     page: () {
//             final Map<String, String?> params = Get.parameters;
//             final email = params['email'] ?? "";
//             final token = params['token'] ?? "";
//             return ResetPasswordPage(email: email, token: token);
//     },
//   ),
//       ],
//        //home:Login()
//     );
//   }
// }
import 'dart:async';
import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/views/layouts/sup_layout.dart';
import 'package:av_solar_services/views/screens/login.dart';
import 'package:av_solar_services/views/screens/location_screen.dart';
import 'package:av_solar_services/views/screens/forgot_password.dart';
import 'package:av_solar_services/views/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: bgGreen,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

void _initDeepLinks() async {
  _appLinks = AppLinks();

  // Handle initial link when app is opened from a deep link
  try {
    final initialUri = await _appLinks.getInitialLink(); // ✅ Updated method
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  } catch (e) {
    print('Error handling initial link: $e');
  }

  // Listen for links when app is already running
  try {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  } catch (e) {
    print('Error listening to link stream: $e');
  }
}


  void _handleDeepLink(Uri uri) {
    print('Deep link received: $uri');
    
    if (uri.scheme == 'avsolar' && uri.host == 'reset-password') {
      final params = uri.queryParameters;
      final token = params['token'];
      final email = params['email'];
      
      print('Reset password deep link - Email: $email, Token: $token');
      
      if (token != null && email != null && token.isNotEmpty && email.isNotEmpty) {
        // Use a small delay to ensure navigation works properly
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed('/reset-password', parameters: {
            'token': token,
            'email': email,
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AV Solar Services',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: bgGreen),
        useMaterial3: true,
      ),
      initialRoute: "/",
      getPages: [
        GetPage(name: '/', page: () => const Login()),
        GetPage(name: '/forgot-password', page: () => const ForgotPasswordPage()),
        GetPage(name: '/sup', page: () => const SupLayout()),
        GetPage(
          name: '/location',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return LocationScreen(projectId: args['projectId']);
          },
        ),
        GetPage(
          name: '/reset-password',
          page: () {
            final Map<String, String?> params = Get.parameters;
            final email = params['email'] ?? "";
            final token = params['token'] ?? "";
            return ResetPasswordPage(email: email, token: token);
          },
        ),
      ],
    );
  }
}