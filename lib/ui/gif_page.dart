import 'package:flutter/material.dart';
import 'package:gifs_search/ui/home_page.dart';
import 'package:share/share.dart';


class GifPage extends StatelessWidget {
  final Map gifData;
  GifPage(this.gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          gifData["title"]
        ),
        actions: [
          IconButton(
              onPressed: (){
                Share.share(gifData["images"]["fixed_height"]["url"]);
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: Center(
        child: Center(
          child: Image.network(gifData["images"]["fixed_height"]["url"]),
        ),
      ),
    );
  }
}
