import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  //creating to load List user from RESTful

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Advanced',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Advance Json'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: fetchListUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data;
                return new ListView(
                  children: users
                      .map((user) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('UserName: ${user.username}'),
                              Text('Name: ${user.name}'),
                              Text(
                                  'Lat/lng: ${user.address.geo.lat}/${user.address.geo.lng}'),
                              new Divider()
                            ],
                          ))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              //Default show progress loading,  not return null
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Future<List<User>> fetchListUser() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  if (response.statusCode == 200) {
    List users = json.decode(response.body);
    return users.map((user) => new User.fromJson(user)).toList();
  } else
    throw Exception('Failed to load');
}

class User {
  final int id;
  final String name, username, email, phone, website;
  final Address address;
  final Company company;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.website,
      this.address,
      this.company});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        phone: json['phone'],
        website: json['website'],
        address: Address.fromJson(json['address']),
        company: Company.fromJson(json['company']));
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({this.name, this.bs, this.catchPhrase});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        name: json['name'], catchPhrase: json['catchPhrase'], bs: json['bs']);
  }
}

class Geo {
  final String lat, lng;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(lat: json['lat'], lng: json['lng']);
  }
}

class Address {
  final String street;
  final String suite;
  final String zipcode;
  final Geo geo;

  Address({this.street, this.suite, this.zipcode, this.geo});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}
