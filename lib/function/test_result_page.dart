import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:hindivocabulary/main.dart';

//시험 후 틀린 단어 한 번 보고 시험 점수도 알 수 있는 페이지

class test_result extends StatefulWidget {
  //해당 단원 이름
  String _page_name;

  //해당 단원 단어 총 갯수
  int _total_itemcount;

  //맞은 단어
  int _correct_count;


  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();


  test_result(String _page_name, int _total_itemcount, int _correct_count,
      List<String> wrong_hindi_words,List<String> wrong_korean_words) {
    this._page_name = _page_name;
    this._total_itemcount = _total_itemcount;
    this._correct_count = _correct_count;
    this.wrong_hindi_words= wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;
  }

  @override
  _test_resultState createState() => _test_resultState(this._page_name,
      this._total_itemcount, this._correct_count, this.wrong_hindi_words,this.wrong_korean_words);
}

class _test_resultState extends State<test_result> {
  //해당 단원 이름
  String _page_name;

  //해당 단원 단어 총 갯수
  int _total_itemcount;

  //맞은 단어
  int _correct_count;

  // 틀린 단어 리스트 형식
  var _incorrect_word_list;


  //총 점수(100점 만점)
  int _total_score;


  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  _test_resultState(String _page_name, int _total_itemcount, int _correct_count,
      List<String> wrong_hindi_words,List<String> wrong_korean_words) {
    this._page_name = _page_name;
    this._total_itemcount = _total_itemcount;
    this._correct_count = _correct_count;
    this._incorrect_word_list = _incorrect_word_list;
    this.wrong_hindi_words= wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;

    _total_score =
        ((this._correct_count / this._total_itemcount) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width-MediaQuery.of(context).padding.left
        -MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom);

    return WillPopScope(child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: AppBar().preferredSize.width*0.2,
                height: AppBar().preferredSize.height*0.95,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyApp(),),
                    );
                  },
                ),
              );
            },
          ),
          shadowColor: Colors.black26,
          centerTitle: true,
          backgroundColor: Color.fromARGB(240, 10, 15, 64),
          title: Text(
            "HUFS 힌디 단어장",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'hufsfontMedium',
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
        ),
        body: Container(
          width: horizontal_size,
          height: vertical_size,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(240, 10, 15, 64),
                    Color.fromARGB(240, 108, 121, 240)
                  ])),
          child: Column(
            children: [
              //파트 이름, 번호, 단어 수
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: horizontal_size,
                height: vertical_size * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: horizontal_size * 0.4,
                      height: vertical_size * 0.08,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 0.5),
                      child: Text(
                        _page_name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'hufsfontMedium',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    Container(
                      width: horizontal_size * 0.32,
                      height: vertical_size * 0.08,
                      alignment: Alignment.center,
                      child: Text(
                        "단어 수: " + _total_itemcount.toString() + "개",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'hufsfontMedium',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                width: horizontal_size * 0.95,
                height: vertical_size * 0.8,
                decoration: BoxDecoration(
                    color: Color.fromARGB(240, 242, 242, 242),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0)
                    ]),
                child: Column(
                  children: [
                    //점수판
                    Container(
                      width: horizontal_size * 0.9,
                      height: vertical_size * 0.25,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Column(
                        children: [
                          Container(
                            width: horizontal_size * 0.3,
                            height: vertical_size * 0.1,
                            alignment: Alignment.center,
                            child: Text(
                              (_total_score.toString() + " 점"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          Container(
                            width: horizontal_size * 0.3,
                            height: vertical_size * 0.1,
                            alignment: Alignment.center,
                            child: Text(
                              (_correct_count.toString() +
                                  "/" +
                                  _total_itemcount.toString()),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: horizontal_size * 0.85,
                      height: vertical_size * 0.08,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        "틀린 단어",style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),

                    Expanded(

                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              //margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
                              child: ListTile(

                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 0.8),
                                  child: AutoSizeText(
                                    wrong_hindi_words[index],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    minFontSize: 15,
                                    maxLines: 3,
                                  ),
                                ),
                                subtitle: AutoSizeText(
                                  wrong_korean_words[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                  ),
                                  maxLines: 3,
                                  minFontSize: 10,
                                ),
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black26,
                        ),
                        itemCount: wrong_hindi_words.length,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ), onWillPop: (){});
  }
}


class mySentence_result extends StatefulWidget {
  //해당 단원 이름
  String _page_name;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  mySentence_result(String _page_name,
      List<String> wrong_hindi_words,List<String> wrong_korean_words) {
    this._page_name = _page_name;

    this.wrong_hindi_words= wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;
  }

  @override
  _mySentence_resultState createState() => _mySentence_resultState(this._page_name,
      this.wrong_hindi_words,this.wrong_korean_words);
}

class _mySentence_resultState extends State<mySentence_result> {
  //해당 단원 이름
  String _page_name;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  _mySentence_resultState(String _page_name,
      List<String> wrong_hindi_words,List<String> wrong_korean_words) {
    this._page_name = _page_name;

    this.wrong_hindi_words= wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;

  }
  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width-MediaQuery.of(context).padding.left
        -MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom);

    return WillPopScope(child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: AppBar().preferredSize.width*0.2,
                height: AppBar().preferredSize.height*0.95,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyApp(),),
                    );
                  },
                ),
              );
            },
          ),
          shadowColor: Colors.black26,
          centerTitle: true,
          backgroundColor: Color.fromARGB(240, 10, 15, 64),
          title: Text(
            "HUFS 힌디 단어장",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'hufsfontMedium',
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
        ),
        body: Container(
          width: horizontal_size,
          height: vertical_size,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(240, 10, 15, 64),
                    Color.fromARGB(240, 108, 121, 240)
                  ])),
          child: Column(
            children: [
              //파트 이름, 번호, 단어 수
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: horizontal_size,
                height: vertical_size * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: horizontal_size * 0.4,
                      height: vertical_size * 0.08,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 0.5),
                      child: Text(
                        _page_name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'hufsfontMedium',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                width: horizontal_size * 0.95,
                height: vertical_size * 0.8,
                decoration: BoxDecoration(
                    color: Color.fromARGB(240, 242, 242, 242),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0)
                    ]),
                child: Column(
                  children: [
                    //점수판

                    Container(
                      width: horizontal_size * 0.85,
                      height: vertical_size * 0.08,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        "틀린 단어",style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),

                    Expanded(

                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              //margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
                              child: ListTile(

                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 0.8),
                                  child: AutoSizeText(
                                    wrong_hindi_words[index],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    minFontSize: 15,
                                    maxLines: 3,
                                  ),
                                ),
                                subtitle: AutoSizeText(
                                  wrong_korean_words[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                  ),
                                  maxLines: 3,
                                  minFontSize: 10,
                                ),
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black26,
                        ),
                        itemCount: wrong_hindi_words.length,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ), onWillPop: (){});
  }
  }


