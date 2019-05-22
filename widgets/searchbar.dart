import 'data/functions.dart';
import 'data/mini_classes.dart';
import 'theme/appColors.dart';
import 'widgets/popups.dart';
import 'package:flutter_web/material.dart';

class SearchBar extends StatelessWidget {
      final String title;
      final Function(String) onQueryString;
      final Function(ListSortingOptions) onSort;
      final ListSortingOptions currentSort;
      final Set<ListSortingOptions> sortingOptions;


    const SearchBar({@required this.title, @required this.onQueryString, @required this.onSort, @required this.currentSort,  @required this.sortingOptions});

    @override
    Widget build(BuildContext context) {

        return Container(
            key: UniqueKey(),
            width: double.infinity,
            height: 60,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
            constraints: BoxConstraints(maxWidth: 500, maxHeight: 100),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Padding(padding: EdgeInsets.all(3)),
                        Icon(Icons.search,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.white54
                                : Colors.black54),
                        Padding(padding: EdgeInsets.all(4)),
                        SearchBarText(title: title, onQueryString: onQueryString),
                        Padding(padding: EdgeInsets.all(3)),
                        SortingOptionsButton(onSort: onSort, currentSort: currentSort, sortingOptions:sortingOptions),
                        Padding(padding: EdgeInsets.all(3)),
                    ],
                ),
        );
    }
}

class SearchBarText extends StatefulWidget {

    final Function(String) onQueryString;
    final String title;
    const SearchBarText({Key key, @required this.title, @required this.onQueryString}) : super(key: key);

    @override
    _SearchBarTextState createState() => _SearchBarTextState();
}

class _SearchBarTextState extends State<SearchBarText> {

    static final _orderFormKey = GlobalKey<FormFieldState<String>>();
    @override
    Widget build(BuildContext context) => Expanded(
  
          child: TextField(
              key: _orderFormKey,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white70
                      : Colors.black87),
              onChanged: widget.onQueryString,
              decoration: InputDecoration.collapsed(
                  hintText: widget.title,
                  hintStyle: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white54
                              : Colors.black54)),
          )
    );
}


class SortingOptionsButton extends StatelessWidget {

    final Function(ListSortingOptions) onSort;
    final ListSortingOptions currentSort;
    final Set<ListSortingOptions> sortingOptions;

    const SortingOptionsButton({@required this.onSort, @required this.currentSort,  @required this.sortingOptions});
    
    @override
    Widget build(BuildContext context) =>  Container(
            key: UniqueKey(),
            margin: EdgeInsets.all(2),
            child: AspectRatio(
                aspectRatio: 1,
                child: RawMaterialButton(
                    constraints: BoxConstraints(maxHeight: 10, maxWidth: 10),
                    shape: CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.white70
                        : Colors.black87,
                    key: UniqueKey(),
                    child: Text(Functions.getIconValueOfSortingMethod(currentSort),
                    style: TextStyle(
                        color: AppColors.getColor(ColorType.primarySwatch),
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                    ),
                    ),
                    onPressed: () => PopUps.selectSortTypeDiolog(context, onSort, options: sortingOptions),
                )
            )
        );
}

