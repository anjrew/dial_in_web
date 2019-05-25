import 'package:flutter_web/material.dart';



class Item{

     @required String title; 
     @required dynamic value; 
     @required String segueId = '';
     @required String databaseId; 
     @required String placeHolderText; 
     @required List<List<dynamic>> inputViewDataSet = List<List<dynamic>>();
     @required TextInputType keyboardType = TextInputType.text; 
     @required Icon icon;
     @required TextInputAction textInputAction;
    
    Item({
        this.title,
        this.value,
        this.segueId,
        this.databaseId,
        this.placeHolderText,
        this.keyboardType,
        this.inputViewDataSet, 
        this.icon,
        this.textInputAction 
    })
    {
      if (this.inputViewDataSet == null){  this.inputViewDataSet = List<List<String>>(); }
      if (this.segueId == null){  this.segueId = ''; }
      if (this.keyboardType == null){ this.keyboardType = TextInputType.text;}
    }
}

