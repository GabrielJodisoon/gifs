import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gifs_search/ui/gif_page.dart';
import 'package:gifs_search/ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(hintColor: Colors.black),
  ));

}


