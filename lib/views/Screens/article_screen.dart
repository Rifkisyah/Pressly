import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://picsum.photos/250?image=9', width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.2, fit: BoxFit.cover),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('Judul Artikel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('Deskripsi Artikel', style: TextStyle(fontSize: 12),),
            ),
            SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 20),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)
                  )
                ),
                child: Text('Baca Selengkapnya ->', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 20,)
          ]
        );
    });
  }
}
