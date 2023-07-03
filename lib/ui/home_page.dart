import 'package:flutter/material.dart';
import 'package:gifs_search/ui/gif_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? search;
  int offset = 0;

  Future<Map> getGifs() async {
    http.Response response;
    if (search == null || search!.isEmpty) {
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=g4M92D2yacxwAm5TMIsuHt5tD749DxFU&limit=25&offset=25&rating=g&bundle=messaging_non_clips") );
    } else
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=g4M92D2yacxwAm5TMIsuHt5tD749DxFU&q=$search&limit=25&offset=$offset&rating=g&lang=en&bundle=messaging_non_clips'));
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search!",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  search = text;
                  offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int getCount(List data){
    if(search == null){
      return data.length;

    }else{
      return data.length + 1;
    }
  }

  Widget createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if(search == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,
                    color: Colors.black,
                    size: 70,
                    ),
                    Text("Carregar mais...",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    offset += 25;
                  });
                },
              ),
            );
        }

    );
  }
}
