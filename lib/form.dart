import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:real_aflo_park/attractions.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:real_aflo_park/attractions.dart';

Future<Attraction> createAttraction(String nom, String description) async {
  final response = await http.post(
    Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'nom': nom, 'description': "okokoko", "parc_id": 1}),
  );

  if (response.statusCode == 201) {
    return Attraction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Création échouée');
  }
}

Future<Attraction> editAttraction(String nom, String description, int id) async {
  final response = await http.put(
    Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions/${id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'nom': nom, 'description': description, 'parc_id': 1}),
  );

  print(response.body);
  print(response.statusCode.toString());

  if (response.statusCode == 200) {
    return Attraction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Update echec');
  }
}

class FormDemo extends StatefulWidget {
  final Attraction? attraction2;
  const FormDemo({super.key, this.attraction2});

  @override
  State<FormDemo> createState() {
    return _FormDemoState();
  }
}

class _FormDemoState extends State<FormDemo> {
  late TextEditingController _controller;
  late TextEditingController _controller2;
  late Text _textButton;
  Future<Attraction>? attraction;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.attraction2?.nom ?? '');
    _controller2 = TextEditingController(text: widget.attraction2?.description ?? '');
    _textButton = Text(widget.attraction2 != null ? 'Modifier' : 'Créer');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (attraction == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Entrer un nom'),
        ),
        TextField(
          controller: _controller2,
          decoration: const InputDecoration(hintText: 'Entrer une description'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              attraction = _textButton == "Créer"
                  ? createAttraction(_controller.text, _controller2.text)
                  : editAttraction(_controller.text, _controller2.text, widget.attraction2!.id);
            });
          },
          child: _textButton,
        ),
      ],
    );
  }

  FutureBuilder<Attraction> buildFutureBuilder() {
    return FutureBuilder<Attraction>(
      future: attraction,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.nom);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
