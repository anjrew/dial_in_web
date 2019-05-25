import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {

  final title;
  final Widget _body;

  CustomScaffold(this._body, {this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 209, 140, 92),
        title: Text(title,  style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black),),
        brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
        leading: FlatButton(child: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black),
                    onPressed: () => Navigator.pop(context),
                  color: const Color.fromARGB(250, 209, 140, 92))),
        body: _body);
  }
}
