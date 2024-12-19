import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferenceExample extends StatefulWidget {
  const ThemePreferenceExample({super.key});

  @override
  _ThemePreferenceExampleState createState() => _ThemePreferenceExampleState();
}

class _ThemePreferenceExampleState extends State<ThemePreferenceExample> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load the theme preference
  void _loadThemePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = pref.getBool('isDarkTheme') ?? false;
    });
  }

  // Save the theme preference
  void _saveThemePreference(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isDarkTheme', value);
    setState(() {
      _isDarkTheme = value;
    });
  }

  // Reset the theme preference
  void reset () async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('isDarkTheme');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Preference Example'),
        ),
        body: Center(
          child: SwitchListTile(
            title: const Text('Enable Dark Theme'),
            value: _isDarkTheme,
            onChanged: (value) {
              _saveThemePreference(value);
            },
          ),
        ),
      ),
    );
  }
}
