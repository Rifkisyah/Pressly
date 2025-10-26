import 'package:flutter/material.dart';
import 'package:pressly/views/auth/signin_screen.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)
            ),
          ),
          Column(

            children: [
              SizedBox(height: 10,),
              Text('Masuk Untuk Mendapat Lebih Banyak Pengalaman', style: TextStyle(fontSize: 14),),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 20),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)
                  )
                ),
                child: Text(
                  'Masuk',
                  style: TextStyle(
                    color: Colors.white,
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
              Card(
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Beranda'),
                ),
              ),
              // Card(
              //   child: ListTile(
              //     leading: Icon(Icons.account_circle),
              //     title: Text('Informasi Akun'),
              //   ),
              // ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Versi Aplikasi'),
                ),

              ),
            ]
          )
        ],
      ),
    );
  }
}
