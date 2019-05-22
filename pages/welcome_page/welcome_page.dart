import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/data/images.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dial_in_v1/routes/routes.dart';

class WelcomeScreen extends StatefulWidget {
  _WelcomeScreenState createState() => _WelcomeScreenState();}
  class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _contoller =  new PageController();

  @override
  Widget build(BuildContext context) => 
    Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: MainBloc.of(context).images.kalitaMain, fit: BoxFit.cover)),
        alignment: Alignment(0, 0),
        child: new Stack(children: <Widget>[

          Container(
            color: Colors.white.withOpacity(0.8),
          ),
          
          PageView(
          controller: _contoller,
          pageSnapping: true,
          children: <Widget>[
            
            PageOne(controller: _contoller,),

            WelcomeScreenInfo(text: 'DIAL IN is a tool for people who take coffee brewing way too seriously.'
            ),

            WelcomeScreenInfo(text: 'With DIAL IN you can record every parameter that you could possibly think of when it comes to brewing coffee.',
            ),

            WelcomeScreenInfo(text: 'You can score a brew, and learn what variable changed the specific attribute in the flavour profile.',
            ),

            WelcomeScreenInfo(text: 'With your records you can learn to look back on previous data and aim to make the perfect cup of coffee with specific parameters.',
            ),

            WelcomeScreenInfo(text: 'Check the news feed, where you can see other peoples profiles, follow them and learn from their data as well.',
             ),

            WelcomeScreenInfo(text: 'You can choose to hide or share your data with other users, as and when you like.'
            ),

            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Images.add_profile_button,
                      ),
                      fit: BoxFit.cover)),
              alignment: Alignment(0, 0),
            ),
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.drawer), fit: BoxFit.cover)),
                alignment: Alignment(0, 0)),
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.follow_button),
                        fit: BoxFit.cover)),
                alignment: Alignment(0, 0)),
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage(Images.profile_page_copy_delete_buttons),
                        fit: BoxFit.cover)),
                alignment: Alignment(0, 0)),
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.profile_page_edit_button),
                        fit: BoxFit.cover)),
                alignment: Alignment(0, 0)),
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.sliders), fit: BoxFit.cover)),
                alignment: Alignment(0, 0)),

            YouCanRetakeThisTour(),

            LastPage()
          ],
        ),
      ])
    );

  @override
  void dispose() { 
    _contoller.dispose();
    super.dispose();
  }
}

class PageOne extends StatelessWidget {

  final PageController controller;
 
  PageOne({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) => 
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

    // Welcome text
    Container(
        width: 230.0,
        margin: const EdgeInsets.all(10.0),
        alignment: Alignment(0.0, 0.0),
        child: Text(
          'Hey! it looks like your first time.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .display4
              .apply(color: Colors.black54, fontSizeFactor: 1.2),
        )),

    Container(
        padding: EdgeInsets.all(10),
        child: Shimmer.fromColors(
            period: Duration(seconds: 1),
            baseColor: Colors.black38,
            highlightColor: Colors.black,
            child: GestureDetector(
                onTap: () => controller.animateToPage(1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut),
                child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.center,
                        children: [
                      Text(
                        'Lets take a little tour...',
                        style: Theme.of(context)
                            .textTheme
                            .display4
                            .apply(
                                color: Colors.black,
                                fontSizeFactor: 1.3),
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black54,
                      )
                    ])))))
  ]);
}

class WelcomeScreenInfo extends StatelessWidget {

  final String text;

  WelcomeScreenInfo({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => 
    Center(child: 
      Padding(padding: EdgeInsets.all(30), child: 
        Text(text ,
        style: Theme.of(context).textTheme.display4.apply(color: Colors.black87),
        textAlign: TextAlign.center,),),);

}

class LastPage extends StatelessWidget {

  LastPage({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) =>  Center(child:
            
            Padding(
              padding: EdgeInsets.all(20),
              child:  Shimmer.fromColors(
                baseColor: Colors.black38,
                highlightColor: Colors.black,
                child: GestureDetector(
                    onTap: () => _goBackToOverview(context),
                    child: Text(
                        'Lets make some coffee!',
                        style: Theme.of(context).textTheme.display4.apply(color: Colors.black, fontSizeFactor: 2),
                        textAlign: TextAlign.center,
                      ),
                    )
              ),
            )
      );

        void _goBackToOverview(BuildContext context){
            if ( Navigator.of(context).canPop() ){
                Navigator.pop(context);
            }
            else{
                Navigator.pushNamed(context, RouteIds.overview);
            }
        }
}

class YouCanRetakeThisTour extends StatelessWidget {
 
  YouCanRetakeThisTour({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
            Center(child:Padding(
              padding: EdgeInsets.all(10),
              child: 
              Container(
                width: 230.0,
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  'You can retake this tour anytime by selecting it in the menu.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .display4
                      .apply(color: Colors.black87, fontSizeFactor: 1.2),
                )),   
            )
      );
}
