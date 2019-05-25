import 'dart:async';

import 'data/flavour_descriptors.dart';
import 'database_functions.dart';
import 'widgets/popups.dart';
import 'package:flutter_web/material.dart';

class AddFlavourDescriptorDiolog extends StatefulWidget {
    _AddFlavourDescriptorDiologState createState() =>
      _AddFlavourDescriptorDiologState();
}

class _AddFlavourDescriptorDiologState extends State<AddFlavourDescriptorDiolog> {
    final EdgeInsetsGeometry _padding = EdgeInsets.all(20);
    TextEditingController _nameController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();

    List<TasteTypeData> _flavourTypes = new List<TasteTypeData>();
    TasteTypeData _typeValue;

    void initState() {
        setupFlavoutTypes();
        super.initState();
    }

    @override
    Widget build(BuildContext context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text('Add flavour descriptor', textAlign: TextAlign.center,),
            titlePadding: _padding,
            contentPadding: _padding,
            children: <Widget>[
            TextFormField(
                key: Key('Name'),
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
            ),
            TextFormField(
                key: Key('Description'),
                decoration: InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(
                        'Type: ',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .apply(fontSizeFactor: 1.4),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Padding(padding: _padding, child: setupDropdownButton())
                ],
            ),
            RaisedButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: Text('Add Descriptor' , style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black87)),
                onPressed: saveFlavourDescriptor
                ),
            ],
        );

        void setupFlavoutTypes() {
                FlavourType.values.forEach((type) {
                TasteTypeData newElement = new TasteTypeData(type);
                _flavourTypes.add(newElement);
            });
        } 

    DropdownButton setupDropdownButton() {
        return new DropdownButton<TasteTypeData>(
        value: _typeValue,
        onChanged: (TasteTypeData newValue) {
            setState(() {
            _typeValue = newValue;
            });
        },
        items: _flavourTypes
            .map<DropdownMenuItem<TasteTypeData>>((TasteTypeData value) {
            return DropdownMenuItem<TasteTypeData>(
            value: value,
            child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Container(width: 30, height: 30, decoration: BoxDecoration(color: FlavourDescriptor.getFlavoutTypeColor(value.type) , shape: BoxShape.circle,)),  
                Padding(padding: EdgeInsets.all(10),),
                Text(value.name,),
            ],)
            );
        }).toList(),
        );
  }

    void saveFlavourDescriptor() async {

        bool passedCheck = checkDeatilsAreAllFilledOut();

        if (passedCheck){

            FlavourDescriptor decriptor = new FlavourDescriptor(
                nameIn: _nameController.text[0].toUpperCase() + _nameController.text.substring(1).trim(),
                descriptionIn: _descriptionController.text[0].toUpperCase() + _descriptionController.text.substring(1).trim(),
                typeIn: _typeValue.type);

            bool didSave = await Dbf.saveFlavourDescriptor(decriptor)
                .timeout(databaseTimeoutDuration);
                // .catchError(showTimeoutAlert);
            
            if ( !didSave ){
                 PopUps.showAlert('Error', 'This descriptor already exists.', 'OK', () => Navigator.pop(context), context);
            }else{
                Navigator.pop(context);
            }
        }
        else{
            PopUps.showAlert('Error', 'Please fill out all fields.', 'OK', () => Navigator.pop(context), context);
        }
    }
            
    bool checkDeatilsAreAllFilledOut() {
        bool namecheck = _nameController.text != null || _nameController.text != '';
        bool descriptionCheck = _descriptionController.text != null || _descriptionController.text != '';
        bool typeCheck = _typeValue != null && _typeValue.type != null ;

            return namecheck && descriptionCheck && typeCheck;
        }
                
        FutureOr<void> showTimeoutAlert(Error error)async{
            PopUps.showAlert('Error', 'It took too lonf to update the database. Please check you connection.', 'OK', () => Navigator.pop(context), context);
    }
}

class TasteTypeData {
    FlavourType type;
    String name;

    TasteTypeData(this.type) {
        name = type.toString().substring(12);
        name = name[0].toUpperCase() + name.substring(1);
    }
}
