import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hindivocabulary/majorVoca.dart';
import 'package:hindivocabulary/hindiCommonVoca.dart';
import 'package:hindivocabulary/setting.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
import 'package:hindivocabulary/home.dart';
import 'package:hindivocabulary/myVoca.dart';
import 'package:hindivocabulary/rememberZone.dart';
import 'package:hindivocabulary/makeTestSheet.dart';
import 'dart:ui';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        onWillPop: () async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('단어장을 종료할까요?'),
            actions: <Widget>[
              RaisedButton(
                  child: Text('아니오'),
                  onPressed: () => Navigator.of(context).pop(false)),
              RaisedButton(
                  child: Text('예'),
                  onPressed: () => exit(0)),
            ])),
    child: MaterialApp(
      title: "힌디 단어장",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 4,
        child: Main_AppBar(),
      ),
    ),);
  }
}

class Main_AppBar extends StatefulWidget {


  @override
  _Main_AppBarState createState() => _Main_AppBarState();
}

class _Main_AppBarState extends State<Main_AppBar> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    print("전체 높이0:"+MediaQuery.of(context).size.height.toString());
    return
       SafeArea(
        key:_scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {


                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            shadowColor: Colors.white,
            centerTitle: true,
            backgroundColor: Color.fromARGB(240, 10, 15, 64),
            title: const Text(
              'HUFS 힌디 단어장',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'hufsfontMedium',
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,

              labelColor: Colors.white,
              isScrollable: false,
              indicatorWeight: 1,
              tabs: [
                Tab(text: '홈'),
                Tab(text: '학과 단어'),
                Tab(text: '시험 단어'),
                Tab(text: '설정')
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: home()),
              Center(child: majorVoca()),
              Center(child: hindiCommonVoca()),
              Center(child: setting())
            ],
          ),

          //Drawer Function in left side
          drawer: Drawer(
              child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SafeArea(
                child: Container(
                  height: 100.0,
                  child: DrawerHeader(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "특수외국어 진흥원",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  fontFamily: 'hufsfontLight',
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "한국외국어대학교",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  fontFamily: 'hufsfontLight',
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage(
                                'pictures/indiaflag.jpg',
                              )),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(240, 10, 15, 64),
                    ),
                  ),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                ),
              ),
              ListTile(
                title: Text(
                  '내 단어',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'hufsfontLight',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: Icon(
                  Icons.assignment,
                  size: 20,
                ),
                selectedTileColor: Colors.white54,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (BuildContext context) => myVoca(unMemory_words.list)),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.loop,
                  size: 20,
                ),
                title: Text(
                  '나의 기억상자',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'hufsfontLight',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selectedTileColor: Colors.white70,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (BuildContext context) => rememberZone()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.print,
                  size: 20,
                ),
                title: Text(
                  '단어 내보내기',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'hufsfontLight',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selectedTileColor: Colors.white70,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (BuildContext context) => makeTestSheet()),
                  );
                },
              ),
            ],
          )),
        ),

    );
  }
}
