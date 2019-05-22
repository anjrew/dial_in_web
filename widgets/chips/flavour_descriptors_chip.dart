import 'classes/error_reporting.dart';
import 'data/flavour_descriptors.dart';
import 'package:flutter_web/material.dart';

class FlavourDescriptorsChip extends StatefulWidget {

    final FlavourDescriptor descriptor;
    final Function(String) delete;
    final Key key;

    const FlavourDescriptorsChip({@required this.key, @required this.descriptor, this.delete}) : super(key: key);

    @override
    _FlavourDescriptorsChipState createState() => _FlavourDescriptorsChipState();
}

class _FlavourDescriptorsChipState extends State<FlavourDescriptorsChip>  with SingleTickerProviderStateMixin {
  
    AnimationController _animationController; 
    Animation _curve; 
    Animation _animation;
    bool _initialised = false;

    @override
    void initState() {
        _animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this)
            ..addStatusListener((AnimationStatus status) {
                print(_animation.value);
                if (!_initialised){
                     _initialised = status == AnimationStatus.completed;
                }
            });
        _curve = CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut);
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_curve);
        super.initState();
    }

    @override
    Widget build(BuildContext context) { 

        if (!_initialised){ _animationController.forward();}
        return AnimatedBuilder(
            key: widget.key,
            animation: _animation,
            builder: (BuildContext context, Widget child) =>  Transform.scale(scale: _animation.value, child: child), 
            child: Chip(
                deleteIcon: Icon(Icons.delete),
                deleteIconColor: widget.delete != null ? Colors.white : null ,
                onDeleted: widget.delete != null ? _delete : null,
                deleteButtonTooltipMessage: widget.delete != null ? "Remove Descriptor" : null,
                key: widget.key ?? UniqueKey(),
                label: Text(widget.descriptor.name),
                labelStyle: Theme.of(context).textTheme.display1.apply(color: Colors.white, fontWeightDelta: 1),
                backgroundColor: widget.descriptor.color,
                labelPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) 
                ), 
            );
    }

    void _delete(){
        _animationController.reverse()
            .then((_){
                setState(() {
                    widget.delete(widget.descriptor.name);
                });
            })
            .catchError(Sentry.report);
    }
}



class FlavourDescriptorChip extends StatelessWidget {

  final FlavourDescriptor descriptor;
  final Function onDeleted;

  FlavourDescriptorChip(this.descriptor, {this.onDeleted});

  @override
  Widget build(BuildContext context) =>
    Chip(
      avatar: CircleAvatar(
        backgroundColor: descriptor.color,
        child: Text(descriptor.name[0].toUpperCase()),
      ),
      label: Text(descriptor.name),
      onDeleted: onDeleted,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
}
