import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:real_aflo_park/attractions.dart';
import 'package:real_aflo_park/detail.dart';

class ListTileExample extends StatefulWidget {
  const ListTileExample({super.key});

  @override
  State<ListTileExample> createState() => _ListTileExampleState();
}

class _ListTileExampleState extends State<ListTileExample> {
  late Future<List<Attraction>> futuresAttractions;
  Future<List<Attraction>> fetchAllAttractions() async {
    final response = await http.get(Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions'));

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((data) => Attraction.fromJson(data)).toList();
    } else {
      throw Exception('Erreur de chargement des données !');
    }
  }

  @override
  void initState() {
    super.initState();
    futuresAttractions = fetchAllAttractions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListTile Sample')),
      body: FutureBuilder<List<Attraction>>(
        future: futuresAttractions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des données !'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text(snapshot.data![index].nom[0])),
                  title: Text(snapshot.data![index].nom),
                  subtitle: Text(snapshot.data![index].description),
                  trailing: Icon(Icons.airplanemode_active_rounded),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Detail(attraction: snapshot.data![index])));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
