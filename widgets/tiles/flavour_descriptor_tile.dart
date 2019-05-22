
  import 'data/flavour_descriptors.dart';
  import 'pages/flavour_descriptors_page.dart';
  import 'package:flutter_web/material.dart';
  import 'package:material_design_icons_flutter_web/material_design_icons_flutter.dart';
  import 'package:scoped_model/scoped_model.dart';
  import 'dart:math' as math;


  class FlavourDescriptorTile extends StatefulWidget {

      final int index;

      FlavourDescriptorTile({ @required this.index});

      @override
      _FlavourDescriptorTileState createState() => _FlavourDescriptorTileState();
  }

  class _FlavourDescriptorTileState extends State<FlavourDescriptorTile>  with SingleTickerProviderStateMixin{

      AnimationController _animationController; 
      Animation _curve; 
      Animation _animation;
      bool _initialised = false;
      final _zeroAngle = 0.0001;  // There's something wrong in the perspective transform, I use a very small value instead of zero to temporarily get it around.

      @override
      void initState() {
          _animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this)
              ..addStatusListener((AnimationStatus status) {
                  if (!_initialised){
                      _initialised = status == AnimationStatus.completed;
                  }
              });
          _curve = CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut);
          _animation = Tween<double>(begin: 0, end: 1).animate(_curve); 
          super.initState();
      }

      @override
      Widget build(BuildContext context) => ScopedModelDescendant<FlavourDescriptorBloc>
      (builder: (BuildContext modelContext ,_,  _bloc)  {

        FlavourDescriptor descriptor = _bloc.descriptors[widget.index];

        // TODO;
        //   if (!descriptor.isQueried || !descriptor.isSelected){ 
        //       _animationController.forward();
        //   }
        //   else{
        //       _animationController.reverse();
        //   }

            // return
            //  AnimatedBuilder(
            //     key: widget.key,
            //     animation: _animation,
            //     builder: (BuildContext context, Widget child) => Transform.scale(scale: _animation.value, child: child,), 
            //     // Transform(
                //     transform: Matrix4.identity()..setEntry(3, 2, 0.006)..rotateX(math.pi / 4),
                //     alignment: FractionalOffset.center,
                //     child: child), 
                // /: 
                return ListTile(
                key: Key(widget.index.toString()),
                leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: descriptor.color,
                        shape: BoxShape.circle,
                        )),
                title: Text(descriptor.name),
                subtitle: Text(descriptor.description),
                trailing: descriptor.isSelected
                    ? Icon(MdiIcons.checkboxMarkedCircle)
                    : null,
                contentPadding: EdgeInsets.all(20),
                enabled: true,
                selected: descriptor.isSelected,
                onTap: () => _bloc.descriptorPressed(widget.index));
      });
            // }
    //   );
  }