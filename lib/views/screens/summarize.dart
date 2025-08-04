import 'package:av_solar_services/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Summarize extends StatefulWidget {
  const Summarize({super.key});

  @override
  State<Summarize> createState() => _SummarizeState();
}

class _SummarizeState extends State<Summarize> {
  String currentDate = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CurrentDate();
  }

  void CurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    setState(() {
      currentDate = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today Overview",
                  style: TextStyle(
                      color: textBlack,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  currentDate,
                  style: TextStyle(
                      color: textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [Text("Total Services"), Text("5")],
                    ),
                    Row(
                      children: [Text("Free Services"), Text("3")],
                    ),
                    Row(
                      children: [Text("Paid Services"), Text("2")],
                    ),
                    Row(
                      children: [Text("Total capacity"), Text("40kw")],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
