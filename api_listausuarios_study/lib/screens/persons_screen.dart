import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/api_services.dart';
import '../screens/profile_screen.dart';

class PersonsScreen extends StatefulWidget {
  @override
  _PersonsScreenState createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  late Future<List<Person>> futurePersons;

  @override
  void initState() {
    super.initState();
    futurePersons = ApiService().fetchPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personas'),
      ),
      body: FutureBuilder<List<Person>>(
        future: futurePersons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data![index].urlImagen),
                  ),
                  title: Text(snapshot.data![index].nombreCompleto),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data![index].profesion),
                      Text(snapshot.data![index].universidad),
                    ],
                  ),
                  trailing: ElevatedButton(
                    child: Text('Ver perfil'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(person: snapshot.data![index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}