import 'data/flavour_descriptors.dart';
import 'pages/profile_pages/profile_page_model.dart';
import 'package:flutter_web/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'database_functions.dart';
import 'classes/error_reporting.dart';

class FlavourDescriptorPiker extends StatefulWidget {
  _FlavourDescriptorPikerState createState() => _FlavourDescriptorPikerState();}
  class _FlavourDescriptorPikerState extends State<FlavourDescriptorPiker> {

  FlavourDescriptorBloc bloc = new FlavourDescriptorBloc();

  ProfilePageModel profilePageModel;

  void initState() { 
    super.initState();
    profilePageModel = ProfilePageModel.of(context);
  }

  @override
  Widget build(BuildContext context) =>
  
  Scaffold(
    appBar: AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context),),
      centerTitle: true,
      ),
    body: ListView.builder(
      itemExtent: 100.0,
      itemCount: bloc.descriptors.length,
      itemBuilder: (BuildContext context, int index) =>  makeFlavourDescriptorTile( context, index ),
    ),
  );

  Widget makeFlavourDescriptorTile(BuildContext context, int index){

    return ListTile(
      key: Key(index.toString()),
      leading: null,  // TODO bloc.descriptors[index].asset,
      title: Text(bloc.descriptors[index].name),
      subtitle: Text(bloc.descriptors[index].description),
      trailing: bloc.descriptors[index].isSelected ? Icon(Icons.arrow_back): null,
      contentPadding: EdgeInsets.all(10),
      enabled: true,
      selected: bloc.descriptors[index].isSelected,
      onTap: () => descriptorPressed(index)
      );
  }

  void descriptorPressed(int index){

    FlavourDescriptor descriptor = bloc.descriptors[index];
    bool itemIsSelected = descriptor.isSelected;

    var descriptors = profilePageModel.getItemValue(DatabaseIds.descriptors);
    List<String> descriptorList = new List<String>();

    /// Check the format of the descriptor value.
    if (descriptors is String){
      String descriptorsString = descriptors;
      descriptorsString.split(',');
    }
    else if (descriptors is List<String>){
      descriptorList = descriptors;
    }
    else{ 
      TypeError error = TypeError();
      Sentry.report(error); 
    }

    ///Deal with the value accordingly by removing it or inserting it.
    if (itemIsSelected){
      descriptorList.removeWhere((listItem)=> listItem == descriptor.name);
    }
    else{
      descriptorList.add(descriptor.name);
    }

    /// Pass the value back to the profile page model
    if (descriptors is String){
      String descriptorsString = descriptorList.join(',');
      profilePageModel.setProfileItemValue(DatabaseIds.descriptors, descriptorsString);
    }
    else if (descriptors is List<String>){
      profilePageModel.setProfileItemValue(DatabaseIds.descriptors, descriptorList);
    }
    else{ 
      TypeError error = TypeError();
      Sentry.report(error); 
    }
  }
}


class FlavourDescriptorBloc extends Model {

  FlavourDescriptorBloc({Key key, this.child});

  List<FlavourDescriptor>  descriptors = new List<FlavourDescriptor>();

  final Widget child;

  static FlavourDescriptorBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FlavourDescriptorBloc)as FlavourDescriptorBloc);
  }
}