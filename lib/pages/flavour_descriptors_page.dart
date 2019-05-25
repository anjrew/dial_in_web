import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/data/flavour_descriptors.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/widgets/chips/flavour_descriptors_chip.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:dial_in_v1/widgets/popups.dart';
import 'package:dial_in_v1/widgets/searchbar.dart';
import 'package:dial_in_v1/widgets/tiles/flavour_descriptor_tile.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/classes/error_reporting.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class FlavourDescriptorPicker extends StatefulWidget {
    final dynamic descriptors;
    FlavourDescriptorPicker({@required this.descriptors}) {
      assert(descriptors != null, 'descriptors is null');
    }

    _FlavourDescriptorPickerState createState() =>_FlavourDescriptorPickerState();
}

class _FlavourDescriptorPickerState extends State<FlavourDescriptorPicker> {

  FlavourDescriptorBloc _bloc;

  void initState() {
    super.initState();
    _bloc = new FlavourDescriptorBloc(widget.descriptors, avaiableDescriptors: MainBloc.of(context).flavoursStream);
  }

  @override
  Widget build(BuildContext context) => Material(child: ScopedModel<FlavourDescriptorBloc>( 
                model: _bloc, child:  CustomScrollView(slivers: <Widget>[

                    SliverAppBar(
                        floating: true,
                        backgroundColor: const Color.fromARGB(250, 209, 140, 92),
                        brightness: Theme.of(context).brightness == Brightness.light
                            ? Brightness.dark
                            : Brightness.light,
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color:
                                    Theme.of(context).brightness == Brightness.light
                                        ? Colors.white
                                        : Colors.black87),
                            onPressed: _goback),
                        centerTitle: true,
                        title:  SearchBar(
                            title: 'Search Descriptors',
                            onQueryString: _bloc.sendQuery,
                            onSort: _bloc.sort ,
                            currentSort: _bloc.sortingType, sortingOptions: [ListSortingOptions.alphabeticallyAcending, ListSortingOptions.alphabeticallyDecending].toSet(),
                        ),

                        actions: <Widget>[
                            IconButton(
                            key: UniqueKey(),
                            onPressed: () =>
                                PopUps.showAddFlavourDescriptorDiolog(context),
                            icon: Icon(
                                Icons.add,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                            ),
                            ),
                        ],
                    ),

                    SliverStickyHeader(
                        header: SelectedDescriptors(),
                        sliver: ScopedModelDescendant<FlavourDescriptorBloc>(
                        rebuildOnChange: true,
                        builder: (BuildContext modelContext ,_, FlavourDescriptorBloc bloc) =>  SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context , int index) => _makeFlavourDescriptorTile(context, index),
                            childCount : _bloc.descriptors.length,
                                )
                            )
                        ),
                    ),          
                ]
                )
            )
        );


  Widget _makeFlavourDescriptorTile(BuildContext context, int index) => FlavourDescriptorTile(index: index,);
    

    void _goback() {
        Navigator.pop(context, _bloc.savedDescriptorList);
    }
}

class SelectedDescriptors extends StatelessWidget {

    @override
    Widget build(BuildContext context) {

        return ScopedModelDescendant<FlavourDescriptorBloc>(
            rebuildOnChange: true,
            builder: (BuildContext modelContext ,_, FlavourDescriptorBloc bloc) {  

                bool hasDescriptor = bloc.savedDescriptorList.length > 0;

                return Card(child: 
                    AnimatedContainer( 
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                        width: !hasDescriptor ? 0 : double.infinity,
                        constraints: BoxConstraints(maxHeight: 2000, maxWidth: 2000),
                        height: !hasDescriptor ? 0 : null,
                        padding: !hasDescriptor ? null :  EdgeInsets.all(10), 
                        child: hasDescriptor ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 2.0, // gap between lineschildren:
                        children: bloc.savedDescriptorList
                            .map((FlavourDescriptor value) =>
                                FlavourDescriptorsChip(key: Key(value.hashCode.toString()),descriptor: value, delete: bloc.chipDeletePressed,))
                                .toList()):  BlankWidget() 
                    )
                );
            }
        );
    } 
}



class FlavourDescriptorBloc extends Model {

    bool _initialised = false;
    List<String> _incomingValues = List<String>();
    String _query = '';

    BehaviorSubject<List<FlavourDescriptor>> _databaseFlavoursObservable = new BehaviorSubject<List<FlavourDescriptor>>();
    Stream<List<FlavourDescriptor>> get _databaseStream => _databaseFlavoursObservable.stream;

    List<FlavourDescriptor> descriptors = new List<FlavourDescriptor>();

    List<FlavourDescriptor> savedDescriptorList = new List<FlavourDescriptor>();

    ListSortingOptions sortingType = ListSortingOptions.alphabeticallyDecending;

  ///Constructor
    FlavourDescriptorBloc(dynamic descriptorsIn, { @required Stream<List<FlavourDescriptor>> avaiableDescriptors}) {
        _incomingValues = _formatIncomingValue(descriptorsIn);
        _databaseFlavoursObservable.addStream(avaiableDescriptors);
        _databaseFlavoursObservable.listen(_refreshScreen);
        _databaseStream.listen(_refreshScreen);
       
        assert(descriptorsIn is String || descriptorsIn is List<String>);
        _formatIncomingValue(descriptorsIn);
        setPickedItems(savedDescriptorList); 
    }

    void _refreshScreen(List<FlavourDescriptor> data){

        if (!_initialised){
            _initialised = true;
            for (var x = 0; x < _incomingValues.length; x++) {
                bool wasFound = false;
                for (var i = 0; i < data.length; i++) {
                    if (data[i].name == _incomingValues[x]){
                        data[i].isSelected = true;
                        savedDescriptorList.add(data[i]);
                        wasFound = true;
                    }
                }
                if (!wasFound) {
                    savedDescriptorList.add(new FlavourDescriptor(
                        nameIn: _incomingValues[x],
                        descriptionIn: '',
                        typeIn: FlavourType.balance));
                }
            }
        }
        else{

        }
        descriptors = data;

        if (sortingType == ListSortingOptions.alphabeticallyDecending) {
                descriptors.sort((a,b) => a.name.compareTo(b.name));
        } else {
            descriptors.sort((a,b) => b.name.compareTo(a.name));
        }

        descriptors = new List<FlavourDescriptor>.from(_databaseFlavoursObservable.value);

        if (_query != '' && _query != null) {
            descriptors.retainWhere((FlavourDescriptor des) =>  des.name.toLowerCase().contains(_query.toLowerCase()));
        }
        this.notifyListeners(); 
    }

    List<String> _formatIncomingValue(dynamic incoming) {
        /// Check the format of the descriptor value.
        List<String> values;
        if (incoming is String) {
        String descriptorsString = incoming;
        if (descriptorsString == null || descriptorsString == '') {
            values = List<String>();
        } else {
            values = descriptorsString.split(',');
        }
        values.removeWhere((value) => value == '' || value == ' ');

        } else if (incoming is List<String>) {

            values = List<String>.from(incoming);
        }
        else{
            TypeError error = TypeError();
            Sentry.report(error);
        }
        values.forEach((value) => value.trim());

        return values ?? List<String>();
    }

    FlavourDescriptor returnMatchingFlavourDescriptors(List<FlavourDescriptor> descriptorsIn) {

        FlavourDescriptor returnValue;
            
            for (var i = 0; i < descriptorsIn.length; i++) {
                for (var x = 0; x < savedDescriptorList.length; x++) {
                  
                    if (descriptorsIn[i].name == savedDescriptorList[x].name) {
                        returnValue = descriptorsIn[i];
                        break;
                    } 
                }
            }

        assert(returnValue != null);
        return returnValue;

    }

    FlavourDescriptor getFlavourDescriptorByName(String name) {

        FlavourDescriptor returnValue;
            
            for (var i = 0; i < descriptors.length; i++) {
                if (descriptors[i].name == name) {
                    returnValue = descriptors[i];
                    break;
                } 
            }
 
        assert(returnValue != null);
        return returnValue;

    }

    void descriptorPressed(int index) {
        FlavourDescriptor descriptor = descriptors[index];
        bool itemIsSelected = descriptor.isSelected;

        ///Deal with the value accordingly by removing it or inserting it.
        if (itemIsSelected) {

            List<FlavourDescriptor> list = savedDescriptorList;
            list.removeWhere((listItem) => listItem.name == descriptor.name);
            descriptor.isSelected = false;
            savedDescriptorList = list;

        } else {

            List<FlavourDescriptor> list = List<FlavourDescriptor>.from(savedDescriptorList);
            descriptor.isSelected = true;
            list.add(descriptor);
            savedDescriptorList = list;

        }

        List<FlavourDescriptor> list = List<FlavourDescriptor>.from(descriptors);
        list[index] = descriptor;
        descriptors = list;
        this.notifyListeners();
    }

    void chipDeletePressed(String id) {

        FlavourDescriptor descriptor = descriptors.firstWhere((FlavourDescriptor element) => element.name == id);

        ///Deal with the value accordingly by removing it or inserting it.
        if (descriptor.isSelected) {

            List<FlavourDescriptor> list = savedDescriptorList;
            list.removeWhere((listItem) => listItem.name == descriptor.name);
            descriptor.isSelected = false;
            savedDescriptorList = list;

        } else {

            List<FlavourDescriptor> list = List<FlavourDescriptor>.from(savedDescriptorList);
            descriptor.isSelected = true;
            list.add(descriptor);
            savedDescriptorList = list;

        }

        List<FlavourDescriptor> list = List<FlavourDescriptor>.from(descriptors);
        int i = list.indexWhere((FlavourDescriptor element) => element.name == id);
        list[i] = descriptor;
        descriptors = list;
        _refreshScreen(_databaseFlavoursObservable.value);
        this.notifyListeners();
    }

    static FlavourDescriptorBloc of(BuildContext context) {
        return (context.inheritFromWidgetOfExactType(FlavourDescriptorBloc)
            as FlavourDescriptorBloc);
    }


    List<FlavourDescriptor> setPickedItems(List<FlavourDescriptor> items) {
        List<FlavourDescriptor> newList = List<FlavourDescriptor>.from(items);

        for (FlavourDescriptor flavour in savedDescriptorList) {
        for (var i = 0; i < newList.length; i++) {
            String itemName = newList[i].name;
            if (flavour.name == itemName) {
            newList[i].isSelected = true;
            }
        }
        }

        return newList;
    }

    void sendQuery(String query){
        _query = query;
       _refreshScreen(_databaseFlavoursObservable.value);
    }

    void sort(ListSortingOptions option){
        sortingType = option;
        _refreshScreen(_databaseFlavoursObservable.value);
    }
}
