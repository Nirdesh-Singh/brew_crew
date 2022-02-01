import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName = "";
  String _currentSugars = "";
  int _currentStrength = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData!.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  const SizedBox(height: 20.0),
                  // dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _currentSugars = val.toString()),
                  ),
                  // slider
                  Slider(
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    value: (_currentStrength != 0
                            ? _currentStrength
                            : userData.strength)
                        .toDouble(),
                    activeColor: Colors.brown[_currentStrength != 0
                        ? _currentStrength
                        : userData.strength],
                    inactiveColor: Colors.brown[_currentStrength != 0
                        ? _currentStrength
                        : userData.strength],
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars.isEmpty
                              ? userData.sugars
                              : _currentSugars,
                          _currentName.isEmpty ? userData.name : _currentName,
                          _currentStrength == 0
                              ? userData.strength
                              : _currentStrength,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Update'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink[400],
                      shadowColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
