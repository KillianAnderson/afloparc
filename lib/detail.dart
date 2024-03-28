import 'package:flutter/material.dart';
import 'package:real_aflo_park/attractions.dart';
import 'package:real_aflo_park/form.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.attraction});

  final Attraction attraction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
          child: Container(
              width: 300,
              height: 420,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              color: Color.fromARGB(255, 237, 173, 89),
              child: Column(
                children: [
                  Text('${attraction.nom}', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6), fontSize: 25)),
                  Text('${attraction.description}',
                      style: TextStyle(color: Color.fromRGBO(48, 112, 223, 0.6), fontSize: 12)),
                  GestureDetector(
                    child: Icon(Icons.create),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => FormDemo(attraction2: attraction)));
                    },
                  ),
                ],
              ))),
    );
  }
}
