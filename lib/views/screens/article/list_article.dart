import 'package:flutter/material.dart';
import '../../../services/article_service.dart';
import 'detailed_news_article.dart';

class ListArticle extends StatefulWidget {
  final String category;

  const ListArticle({super.key, required this.category});

  @override
  State<ListArticle> createState() => _ListArticleState();
}

class _ListArticleState extends State<ListArticle> {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ArticleService.fetchArticlesByCategory(widget.category),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("ERROR: ${snapshot.error}"));
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text("No Articles Found"));
        }
        final allArticles = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: allArticles.length,
                itemBuilder: (context, index) {
                  final article = allArticles[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailArticleScreen(article: article),
                            )
                        ),
                        child: Column(
                          children: [
                            article['image'] != null && article['image'] != ""
                                ? Image.network(
                              article['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                heightFactor: 3,
                                child: Icon(Icons.broken_image, size: 50,),
                              ),
                            )
                                : const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(article['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(article['description'], style: TextStyle(fontSize: 12),),
                            ),
                            SizedBox(height: 10,),
                            // Center(
                            //   child: ElevatedButton(
                            //     onPressed: () {},
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.white,
                            //       fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 20),
                            //       elevation: 0,
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(0)
                            //       )
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           'Read More',
                            //           style: TextStyle(
                            //             color: Colors.black,
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //         SizedBox(width: 6),
                            //         Icon(
                            //           Icons.arrow_forward,
                            //           color: Colors.black,
                            //           size: 20,
                            //         ),
                            //       ],
                            //     ),
                            //   )
                            // ),
                            SizedBox(height: 20,)
                          ]
                        ),
                      )
                    ],
                  );
                }
              ),
            )
          ]
        );
      }
    );
  }
}
