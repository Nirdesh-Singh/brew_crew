import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';

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
  int _currentStrength = 100;

  @override
  Widget build(BuildContext context) {
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
            decoration: textInputDecoration,
            validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _currentName = val),
          ),
          const SizedBox(height: 20.0),
          // dropdown
          DropdownButtonFormField(
            decoration: textInputDecoration,
            value: _currentSugars == '' ? sugars[0] : sugars[0],
            items: sugars.map((sugar) {
              return DropdownMenuItem(
                value: sugar,
                child: Text('$sugar sugars'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _currentSugars = val.toString()),
          ),
          // slider
          Slider(
            min: 100.0,
            max: 900.0,
            divisions: 8,
            value:
                (_currentStrength != 100 ? _currentStrength : 100).toDouble(),
            activeColor:
                Colors.brown[_currentStrength != 100 ? _currentStrength : 100],
            inactiveColor:
                Colors.brown[_currentStrength != 100 ? _currentStrength : 100],
            onChanged: (val) => setState(() => _currentStrength = val.round()),
          ),
          ElevatedButton(
            onPressed: () async {
              print(_currentName);
              print(_currentSugars);
              print(_currentStrength);
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
  }
}
