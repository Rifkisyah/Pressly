import 'package:flutter/material.dart';
import 'package:pressly/providers/language_provider.dart';
import 'package:pressly/providers/theme_provider.dart';
import 'package:pressly/services/article_service.dart';
import 'package:provider/provider.dart';
import 'package:pressly/views/screens/auth/sign_in_screen.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menu'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)
            ),
            shape: Border(
              bottom: BorderSide(
                color: (theme.isDarkMode) ? Colors.white : Colors.black,
                width: 1.0,
              )
            ),
          ),
          Column(
            children: [
              SizedBox(height: 10,),
              Text('Login To Get More Experience', style: TextStyle(fontSize: 14),),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 20),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                      color: (theme.isDarkMode) ? Colors.white : Colors.black,
                      style: BorderStyle.solid,
                      width: 2.0
                    )
                  )
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ]
          ),
          SizedBox(height: 10,),
          ListView(
            shrinkWrap: true,
            children: [
              /// home shortcut
              Card(
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
              ),
              /// language
              Card(
                child: ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Select Language'),
                  trailing: Consumer<LanguageProvider>(
                    builder: (context, languageProvider, _) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(hintText: ''),
                          value: languageProvider.currentLanguage.codd,
                          items: languageProvider.supportedLanguages.map((l) {
                            return DropdownMenuItem(
                              alignment: Alignment.center,
                              value: l.codd,
                              child: Text(l.codd.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              languageProvider.changelanguage();
                            }
                          },
                        )
                      );
                    }
                  ),
                )
              ),
              // Card(
              //   child: ListTile(
              //     leading: Icon(Icons.account_circle),
              //     title: Text('Informasi Akun'),
              //   ),
              // ),
              /// theme toggle
              Card(
                child: ListTile(
                  leading: Icon(Icons.dark_mode_outlined),
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: theme.isDarkMode,
                    onChanged: (value) {
                      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                      themeProvider.toggleTheme(value);
                    }
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Version'),
                ),

              ),
            ]
          )
        ],
      ),
    );
  }
}
