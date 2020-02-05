import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

//Create Model class
class News {
  final String title;
  final String description;
  final String author;
  final String urlToImage;
  final String publishedAt;

  //Alt+insert > constructor

  News(this.title, this.description, this.author, this.urlToImage,
      this.publishedAt);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initState is lifecycle
  @override
  void initState() {
    super.initState();
  }

  //To call list from api
  Future<List<News>> getNews() async {
    // future is used to handle the error when calling api > Future + async or await

    var data = await http.get(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=c4349a84570648eaa7be3cd673cc262b');

    var jsonData = json.decode(data.body);

    var newsData =
        jsonData['articles']; //to retrieve data from articles array of api

    List<News> news = []; // create array

    for (var data in newsData) {
      //assign data into News model array list from articles array of api
      News newsItem = News(data['title'], data['description'], data['author'],
          data['urlToImage'], data['publishedAt']);
      news.add(newsItem);
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: Container(
        child: FutureBuilder(
          future: getNews(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //snapshot is same with response
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                // to retrieve data as all array indexes
                itemBuilder: (BuildContext context, int index) {
                  // is same with holder

                  return InkWell(
                    // Inkwell is used to apply card view
                    onTap: () {
                      News news = new News(snapshot.data[index].title, snapshot.data[index].description, snapshot.data[index].author, snapshot.data[index].urlToImage, snapshot.data[index].publishedAt);//is used to onclick

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new Details(news: news)
                          ));
                    },

                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            height: 110.0,
                            child: ClipRRect(
                              //for corner radius
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),

                              //to retrieve image from array
                              child: snapshot.data[index].urlToImage == null
                                  ? Image.network(
                                      'https://cdn2.vectorstock.com/i/1000x1000/70/71/loading-icon-load-icon-wait-for-a-wait-please-wait-vector-24247071.jpg')
                                  : Image.network(
                                      snapshot.data[index].urlToImage,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              //include title and subtitle
                              title: Text(snapshot.data[index].title),
                              subtitle: Text(snapshot.data[index].author == null
                                  ? 'Unknown Author'
                                  : snapshot.data[index].author),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}


//next page
class Details extends StatelessWidget{
  final News news;

  Details({this.news}); // create constructor
@override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Center(
      child: Container(
        child: Column(
          children: <Widget>[

            Stack( //little same with expanded
              children: <Widget>[
                Container(
                  height: 400,
                  child: Image.network('${this.news.urlToImage}',
                  fit: BoxFit.fill,),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: InkWell(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () => Navigator.pop(context),
                  ),

                  elevation: 0,

                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[

                  SizedBox( // for title
                    height: 10,
                  ),
                  Text(
                    '${this.news.title}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 0.2,
                      wordSpacing: 0.6
                    ),
                  ),

                  SizedBox( // for description
                    height: 20,
                  ),
                  Text(
                    this.news.description,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      letterSpacing: 0.2,
                      wordSpacing: 0.3
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    ),
  );
  }
}
