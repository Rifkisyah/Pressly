import 'package:flutter/material.dart';
import 'package:pressly/providers/auth_provider.dart';
import 'package:pressly/providers/language_provider.dart';
import 'package:pressly/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:pressly/views/screens/auth/sign_in_screen.dart';
import 'package:pressly/views/screens/auth/sign_up_screen.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final language = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isLoggedIn = authProvider.isAuthenticated;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(language.getText('menu')),
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
          // Auth Section - Changes based on login status
          if (isLoggedIn) ...[
            // User is logged in - show profile info
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: (theme.isDarkMode) ? Colors.white24 : Colors.grey.shade300,
                    backgroundImage: user?.photoURL != null 
                        ? NetworkImage(user!.photoURL!) 
                        : null,
                    child: user?.photoURL == null 
                        ? Icon(Icons.person, size: 40, color: (theme.isDarkMode) ? Colors.white : Colors.black)
                        : null,
                  ),
                  SizedBox(height: 12),
                  Text(
                    user?.displayName ?? user?.email?.split('@').first ?? 'User',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (user?.email != null) ...[
                    SizedBox(height: 4),
                    Text(
                      user!.email!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await authProvider.signOut();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully logged out'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.logout, color: theme.isDarkMode ? Colors.white : Colors.black),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: theme.isDarkMode ? Colors.white : Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 40),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0
                        )
                      )
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // User is not logged in - show login/register options
            Column(
              children: [
                SizedBox(height: 10,),
                Text(language.getText('login_message'), style: TextStyle(fontSize: 14),),
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
                    language.getText('login'),
                    style: TextStyle(
                      color: (theme.isDarkMode) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
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
                    language.getText('register'),
                    style: TextStyle(
                      color: (theme.isDarkMode) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold
                    )
                  )
                )
              ]
            ),
          ],
          SizedBox(height: 10,),
          ListView(
            shrinkWrap: true,
            children: [
              /// home shortcut
              Card(
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text(language.getText('home')),
                ),
              ),
              /// language
              Card(
                child: ListTile(
                  leading: Icon(Icons.language),
                  title: Text(language.getText('select_language')),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration.collapsed(hintText: ''),
                      initialValue: language.currentLanguage.codd,
                      items: language.supportedLanguages.map((l) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          value: l.codd,
                          child: Text(l.codd.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          language.changeLanguage(value);
                        }
                      },
                    )
                  )
                )
              ),
              /// theme toggle
              Card(
                child: ListTile(
                  leading: Icon(Icons.dark_mode_outlined),
                  title: Text(language.getText('dark_mode')),
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
                  title: Text(language.getText('version')),
                ),

              ),
            ]
          )
        ],
      ),
    );
  }
}
