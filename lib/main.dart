import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_tienda_crud/addnote.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'editnote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyC0ZKDEp6d8wHiitFnojjV8QP63VmAIALk",
      appId: "1:619230464406:android:995c016a0f2d17321e35b7",
      messagingSenderId: "XXX",
      projectId: "app-tienda-32e0f",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mi tienda",
      theme: ThemeData(
        primaryColor: Color(0xffFf2FCAE9),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('notes').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => addnote()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text('Mi tienda'),
      ),
      body: StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("No se pudo agregar nota");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            editnote(docid: snapshot.data!.docs[index]),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            snapshot.data!.docChanges[index].doc['title'],
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data!.docChanges[index].doc['content'],
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}