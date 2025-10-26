import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pressly/views/auth/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('../assets/images/logo_app.png', width: MediaQuery.of(context).size.width * 0.3, height: MediaQuery.of(context).size.height * 0.1, fit: BoxFit.contain),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 3.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // login via Google
            Text('Masuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            Text("Gunakan layanan di bawah ini untuk masuk Ke Pressly.", style: TextStyle(fontSize: 13),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),

              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: (){

                  },
                  icon: Image.network('https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-1024.png'),
                  label: Text('Masuk Dengan Google', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      width: 2.0,
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

                    thickness: 2.0,
                  )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                Text(
                  'Atau',
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                Expanded(
                  child: Divider(

                    thickness: 2.0,
                  )
                )
              ],
            ),
            SizedBox(height: 30),
            // login manual
            Text('Masuk Menggunakan Email Anda :', style: TextStyle(fontSize: 13),),
            SizedBox(height: 20),
            TextField(
              // controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Masukkan Email Akun Anda...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Colors.black,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Colors.black,
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
                labelText: 'Kata Sandi',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Masukkan Kata Sandi Akun Anda...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                suffixIcon: Icon(Icons.remove_red_eye),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Colors.black,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.0,
                      color: Colors.black,
                      style: BorderStyle.solid,
                    )
                )
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(text: 'Belum Mempunyai Akun? '),
                  TextSpan(
                    text: 'Daftar disini',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signUpScreen()),
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
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                
              },
              child: Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)
            )
          ],
        )
      ),
    );
  }
}
