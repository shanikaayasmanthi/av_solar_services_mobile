import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/authentication.dart';
import 'package:av_solar_services/views/screens/home.dart';
import 'package:av_solar_services/views/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/User.dart';


class SupLayout extends StatefulWidget {
  const SupLayout({super.key});

  @override
  State<SupLayout> createState() => _SupLayoutState();
}

class _SupLayoutState extends State<SupLayout> {

  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

  //variable declaration
  //user
  late User user;
  //page
    int currentPage = 0;
    final PageController _pageController = PageController();
    //toolbar height
    bool _isExpanded = true;


  // get user => null;

    @override
    Widget build(BuildContext context) {
      final box = GetStorage();
      var token = box.read('token');//user token
      final userMap = box.read('user');//user details
      if (userMap != null) {
        user = User.fromJson(userMap);
        debugPrint(user.name);
      }
      // Map<String,String>user = box.read('user');
      // debugPrint(user as String);
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: _isExpanded ? 130 : 70,
          backgroundColor: bgLightGreen,
          automaticallyImplyLeading: false,
          title: Padding(padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // title of the app
                    Text("ALTA VISION SOLAR",
                      style: TextStyle(
                        color: textGreen,
                        fontSize: _isExpanded ? 22 : 18,
                        fontWeight: FontWeight.bold,
                      ),),
                    //logout button
                    IconButton(
                      onPressed: () async{
                        final result = await _authenticationController.logout(
                            token: token.toString());
                        if(result){
                          Get.offAllNamed('/');
                        }
                      },
                      icon: const Icon(Icons.logout_rounded,
                        color: textWhite,
                        size: 22,
                      ),)
                  ],
                ),
                //show logged in user details when expanded the appbar
                if(_isExpanded)Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle, size: 60, color: textBlack,),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //username
                          children: [
                            Text(user.name,
                              style: const TextStyle(
                                  color: textBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            //phone number
                            const Text("0712567856",
                              style: TextStyle(
                                  color: textBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: bgGreen,
            ),
            child: const SizedBox(height: 50,),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: bgGreen,
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Icon(
            _isExpanded ? Icons.keyboard_arrow_up_outlined : Icons
                .keyboard_arrow_down_outlined,
            color: textWhite,
          ),
        ),
        body: Stack(
          children: [
            //page-view
            Padding(padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
              child: PageView(
                controller: _pageController,
                onPageChanged: ((value) {
                  setState(() {
                    currentPage = value;
                  });
                }),
                children: const<Widget>[
                  Home(),
                  Profile(),
                ],
              ),),


          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: bgGreen,
            currentIndex: currentPage,
            onTap: (page) {
              setState(() {
                currentPage = page;
                _pageController.animateToPage(
                  page,
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: textWhite,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: textWhite,
                ),
                label: "Profile",
              ),
            ]
        ),
      );
    }
}