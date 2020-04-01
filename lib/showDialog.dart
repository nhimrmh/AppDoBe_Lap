import 'package:appdobe/translations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'main.dart';
import 'resultModel.dart';
import 'AudioWidget.dart';
import 'translations.dart';

Color scoreColor_good = Colors.green;
Color scoreColor_bad = Colors.redAccent;
List<AudioPlayer> list_playing = new List<AudioPlayer>();

popDialog(BuildContext context) {
  Navigator.pop(context);
}

class ExpansionContent extends StatelessWidget{
  final List<resultModel> listResult;
  final BuildContext context;
  final List<String> listName;

  ExpansionContent(this.listResult, this.context, this.listName);

  _buildExpansionContents(List<resultModel> listResult) {
    List<Widget> columnContents = [];
    for(int i = 0; i < listResult.length; i++){
      columnContents.add(
          new MediaQuery(
            data: MediaQueryData(padding: EdgeInsets.zero),
            //width: MediaQuery.of(context).size.width,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Question " + (i + 1).toString()),
                  AudioWidget(listResult.elementAt(i).filePath, list_playing)
                ],
              ),
              subtitle: Container(
                transform: Matrix4.translationValues(0, -10, 0),
                child: RichText(
                  text: TextSpan(
                      children: [
                        WidgetSpan(
                            child: Container(
                              transform: Matrix4.translationValues(0, 2, 0),
                              margin: EdgeInsets.only(right: 5),
                              child: listResult.elementAt(i).answer == "true" ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.close, color: Colors.redAccent,),
                            )
                        ),
                        TextSpan(
                            text: listResult.elementAt(i).filePath.substring(0,1) == "t" ? "Tiếng rò rỉ" : listName[i],
                            style: TextStyle(
                              color: Colors.grey,
                            )
                        )
                      ]
                  ),
                )
              )
            ),
          )
      );
    }
    return columnContents;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height - 359,
      child: ListView(
        children: _buildExpansionContents(listResult),
      ),
    );
  }

}

Future getResult(BuildContext context, List<resultModel> listResult, List<String> listName) async {
  for(int i = 0; i < listResult.length; i++){
    listName.add(Translations.of(context).text(listResult.elementAt(i).filePath) == null ? "Null" : Translations.of(context).text(listResult.elementAt(i).filePath));
  }
  return;
}

showResultDialog(BuildContext context, int score, int total, List<resultModel> listResult) async {
  List<String> listName = [];
  await getResult(context, listResult, listName);

  Widget home = Container(
    margin: EdgeInsets.only(left: 0, right: 0),
    child: RaisedButton.icon(
      label: Text(Translations.of(context).text("dialog_home"), style: TextStyle(fontSize: 14),),
      icon: Icon(Icons.home),
      onPressed:  () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      color: Colors.white,
      elevation: 0.0,
    )
  );

  Widget detail = Container(
    //height: MediaQuery.of(context).size.height/2.2,
    //margin: EdgeInsets.only(left: 5, right: 5, top: 10),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text("Xem lại kết quả"),
      children: <Widget>[
        ListTile(
          title: Container(
            height: MediaQuery.of(context).size.height - 359,
            child: ListView(
              children: <Widget>[
                new ExpansionContent(listResult, context, listName),
              ],
            ),
          )
        )
      ],
    ),
  );

  // set up the button
  Widget okIcon = Container(
      margin: EdgeInsets.all(0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget> [
                Text(Translations.of(context).text("dialog_score"), style: TextStyle(fontSize: 16),),
                Text(score.toString() + "/" + total.toString(), style: TextStyle(fontSize: 55, color: (score >= 5 ? scoreColor_good : scoreColor_bad)),),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: detail,
            )
          ],
        )
      )
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: okIcon,
    backgroundColor: Colors.white,
    elevation: 10,
    actions: <Widget>[
      home,
    ],
    //shape: CircleBorder(),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: (){},
        child: alert,
      );
    },
  );
}

showTrueDialog(BuildContext context){
  Widget okIcon = Container(
      margin: EdgeInsets.all(20),
      child: SizedBox(
          width: 200,
          height: 184,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 40),
                child: Text(Translations.of(context).text("dialog_true"), style: TextStyle(fontSize: 20),),
              ),
              Container(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(200)),
                ),
              ),
            ],
          )
      )
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: okIcon,
    backgroundColor: Colors.white,
    elevation: 10,
    //shape: CircleBorder(),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showFalseDialog(BuildContext context) {
  // set up the button
  Widget okIcon = Container(
    margin: EdgeInsets.all(20),
      child: SizedBox(
          width: 200,
          height: 184,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 40),
                child: Text(Translations.of(context).text("dialog_false"), style: TextStyle(fontSize: 20),),
              ),
              Container(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(200)),
                ),
              ),
            ],
          )
      )
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: okIcon,
    backgroundColor: Colors.white,
    elevation: 10,
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}