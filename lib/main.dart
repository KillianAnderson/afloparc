import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:real_aflo_park/attractions.dart';
import 'package:real_aflo_park/detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late Future<List<Attraction>> futuresAttraction;

  Future<List<Attraction>> fetchAllAttraction() async {
    final response = await http.get(Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions'));

    if (response.statusCode == 200) {
      return Attraction.parseAttractions(response.body);
    } else {
      throw Exception('Erreur de chargement des données !');
    }
  }

  @override
  void initState() {
    super.initState();
    futuresAttraction = fetchAllAttraction();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("Welcome to the Parc")),
            body: FutureBuilder<List<Attraction>>(
              future: futuresAttraction,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                        leading: Icon(Icons.settings),
                        title: Column(children: [
                          Text('${snapshot.data![index].nom}',
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6))),
                        ]),
                        tileColor: Color.fromARGB(255, 39, 48, 61),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Detail(attraction: snapshot.data![index])));
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            )));
  }
}
