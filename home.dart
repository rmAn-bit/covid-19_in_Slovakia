import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:corona_in_slovakia/myModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:splashscreen/splashscreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State {

  static List<myModel> myAllData = [];

  Map data;
  var infectedToDay = <String, Object>{};
  int dnesPribudlo = 0;
  int refresh = 0;
  static var regionInfo = <String, Object>{};

  Future<void> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://api.apify.com/v2/key-value-stores/GlTLAdXAuOz6bLAIO/records/LATEST?disableRedirect=true"),
        headers: {
          "Accept": "application/json"
        }
    );

    setState(() {
      String responseBody = response.body;
      data = json.decode(responseBody);
      int infected = data['infected'] - data['recovered'] - data['deceased'];
      infectedToDay['infectedToDay'] = infected;
      print(data['regionsData']);
      var regionInfo = data['regionsData'];
      int cisloDnes;
      for (var data in regionInfo) {
        myAllData.add(new myModel(
            data['region'], data['newInfected'], data['totalInfected']));
        cisloDnes = int.parse(data['newInfected']);
        dnesPribudlo = cisloDnes + dnesPribudlo;
        print(dnesPribudlo);
      }
    });

  }


  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      getData();
      return Loading();
    }

    return new Scaffold(
      appBar: new AppBar(
        title: Align(alignment: Alignment.center,child: new Text("Covid-19 na Slovensku",style: TextStyle(color: Colors.redAccent),)),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Container(
                      width: 150,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          border: Border.all(
                            color: Colors.grey[850],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0,top: 10.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Doposiaľ otestovaných',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              data['tested'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          border: Border.all(
                            color: Colors.grey[850],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      width: 150,
                      height: 90,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Pozitívne testy',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                                data['infected'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        border: Border.all(
                          color: Colors.grey[850],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: 310,
                    height: 90,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Dnes pribudlo',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                              (dnesPribudlo / 2).toStringAsFixed(0),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        border: Border.all(
                          color: Colors.grey[850],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: 310,
                    height: 90,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Aktívne prípady',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            infectedToDay['infectedToDay'].toString(),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        border: Border.all(
                          color: Colors.grey[850],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0,top: 10.0,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Vyliečilo sa',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 24,),
                          Text(
                            data['recovered'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        border: Border.all(
                          color: Colors.grey[850],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0,top: 10.0,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'O život prišlo',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 24,),
                          Text(
                            data['deceased'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Regions()),
          );
        },
        label: Text('Stav v krajoch'),
        icon: Icon(Icons.search),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

class Loading extends StatefulWidget{
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

//  void setupData() async {
//    await Future.delayed(Duration(seconds: 3));
//    Navigator.pushReplacementNamed(context, '/home');
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    setupData();
//  }

  Widget build(BuildContext) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomePage(),
      title: Text('Covid-19 na Slovensku'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      loaderColor: Colors.blueAccent,
      loadingText: Text('načítavam...'),
    );
  }
}

class Regions extends StatefulWidget {
  @override
  _RegionsState createState() => _RegionsState();
}

class _RegionsState extends State<Regions> {

  List myAllData = _HomePageState.myAllData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Situácia v krajoch'),
        backgroundColor: Colors.redAccent,
      ),
      body: myAllData.length == 0
          ? new Center(
        child: new CircularProgressIndicator(),
      )
          : showMyUI(),
    );
  }

  Widget showMyUI() {
    return new ListView.builder(
        itemCount: 8,
        itemBuilder: (_, index) {
          return new Container(
            margin: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: new Card(
              elevation: 10.0,
              child: new Container(
                padding: new EdgeInsets.all(12.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('${myAllData[index].region}'),
                    new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Nový nakazený : ${myAllData[index].newInfected}'),
                    new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Celkovo nakazených : ${myAllData[index].totalInfected}'),
                    new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
                  ],
                ),
              ),
            ),
          );
        });
  }

}
