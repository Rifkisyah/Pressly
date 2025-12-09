import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pressly/providers/language_provider.dart';
import 'package:pressly/providers/theme_provider.dart';
import 'package:pressly/views/screens/auth/sign_up_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final language = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset((theme.isDarkMode) ? '../../assets/images/logo_app_dark_theme.png' : '../../assets/images/logo_app_light_theme.png', width: MediaQuery.of(context).size.width * 0.3, height: MediaQuery.of(context).size.height * 0.1, fit: BoxFit.contain),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: (theme.isDarkMode) ? Colors.white : Colors.black,
            width: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // login via Google
            Text(language.getText('login'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            Text(language.getText('login_subtitle'), style: TextStyle(fontSize: 13),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: (){

                  },
                  icon: Image.network('https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-1024.png'),
                  label: Text(language.getText('login_google'), style: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black, fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: (theme.isDarkMode) ? Colors.white : Colors.black,
                      style: BorderStyle.solid,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              )
            ),

            // separator
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    thickness: 2.0,
                  )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                Text(
                  language.getText('or'),
                  style: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                Expanded(
                  child: Divider(
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    thickness: 2.0,
                  )
                )
              ],
            ),
            SizedBox(height: 30),
            // login manual
            Text(language.getText('login_email_title'), style: TextStyle(fontSize: 13),),
            SizedBox(height: 20),
            TextField(
              // controller: emailController,
              decoration: InputDecoration(
                labelText: language.getText('email'),
                labelStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                hintText: language.getText('email_hint'),
                hintStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black, fontSize: 13),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    style: BorderStyle.solid,
                  )
                )
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              // controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: language.getText('password'),
                labelStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                hintText: language.getText('password_hint'),
                hintStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black, fontSize: 13),
                suffixIcon: Icon(Icons.remove_red_eye),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: (theme.isDarkMode) ? Colors.white : Colors.black,
                    style: BorderStyle.solid,
                  )
                )
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: (theme.isDarkMode) ? Colors.white : Colors.black),
                children: [
                  TextSpan(text: language.getText('no_account')),
                  TextSpan(
                    text: language.getText('register_here'),
                    style: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                side: BorderSide(
                  color: (theme.isDarkMode) ? Colors.white : Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              onPressed: () {
                
              },
              child: Text(language.getText('login'), style: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.bold),)
            )
          ],
        )
      ),
    );
  }
}
