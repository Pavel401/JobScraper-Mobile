import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/darkTheme/dark_theme_bloc.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});
  bool isDarkThemeEnabled = false;
  Color selectedColor = Colors.blue;
  String selectedOption = 'Option 1'; // Replace with your default option
  List<String> dropdownOptions = ['Option 1', 'Option 2', 'Option 3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        children: [
          ListTile(
            title: Text('Enable Dark Mode'),
            trailing: BlocBuilder<DarkThemeBloc, ThemeState>(
              builder: (context, state) {
                bool isDarkMode = state is SetDarkThemeState;
                return Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    if (value) {
                      // Toggle dark mode
                      context.read<DarkThemeBloc>().setDarkMode();
                    } else {
                      // Toggle light mode
                      context.read<DarkThemeBloc>().setLightMode();
                    }
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text('Theme Color'),
          ),
        ],
      ),
    );
  }
}
