
import '../../data/database_functions.dart';
import '../../routes/routes.dart';
import '../../widgets/popups.dart';
import 'package:flutter_web/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();}

  class _HomePageState extends State<HomePage> {

  final Image _logo = Image.asset('assets/images/dial_in_logo_nobg.png',
											height: 200.0, width: 250.0);

  @override
  Widget build(BuildContext context) {

    if (ModalRoute.of(context).isCurrent) {
          tryToLogIn();
    }

    return Scaffold(body: Center(child: 
       Hero(
        tag: 'logo',
        child: _logo,)
    ) ,);
  }

  void tryToLogIn() async {
    
    var user = await Dbf.getCurrentUser().timeout(databaseTimeoutDuration); 
		if (user != null) {
        if ( MainBloc.of(context).isInitalised ){
          user.reload();
          Navigator.pushNamed(context, RouteIds.overview);	
        }
        else{
           await MainBloc.of(context).init()
		      .catchError((error){ PopUps.showAlert("Failed to log in", error.toString(), 'OK', ()=> Navigator.popUntil(context,  ModalRoute.withName(RouteIds.login)), context);});
          Future.delayed(Duration(seconds:1));
          tryToLogIn();
        }
		}
		else{
			Navigator.pushNamed(context, RouteIds.login);
		}
	}
}