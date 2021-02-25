import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/scheduler.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hindivocabulary/function/test_result_page.dart';
/// This is the main application widget.
class mySentence extends StatelessWidget {

  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  mySentence() {
    Key :key;
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
        body: Center(
          child: mysentence(),
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class mysentence extends StatefulWidget {

  int _total_itemcount;

  mysentence(){

  }
  @override
  _mysentenceState createState() => _mysentenceState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _mysentenceState extends State<mysentence> {

  int _total_itemcount;

  //카드별 단어 내용
  var hindi_word = '';
  var korean_word = '';
  var word_case = '';
  var korean_example = '';
  var hindi_example = '';
  var korean_wrong_example = '';

  //정답 번호
  var right_num = '';


  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수
  int index = 0;
  int count = 1;

  //맞은 갯수, 틀린 갯수
  int correct = 0;
  int incorrect = 0;


  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();


  _sentenceState() {
    this._total_itemcount = unMemory_sentence.list_sentence.length;

  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery
        .of(context)
        .size
        .width;
    var vertical_size = (MediaQuery
        .of(context)
        .size
        .height -
        AppBar().preferredSize.height -
        MediaQuery
            .of(context)
            .padding
            .top);
    return WillPopScope(child: new Builder(
      builder: (context) {


        if (unMemory_sentence.list_sentence.length!=0) {
          if (index == 0 && count == 1)
          {
            this.hindi_word = unMemory_sentence.list_sentence[index]['힌디어'];
          this.word_case = unMemory_sentence.list_sentence[index]['품사'];
          this.korean_word = unMemory_sentence.list_sentence[index]['의미'];
          this.hindi_example = unMemory_sentence.list_sentence[index]['힌디어 예시'];
          this.korean_example = unMemory_sentence.list_sentence[index]['한국어 예시'];
          this.korean_wrong_example =unMemory_sentence.list_sentence[index]['한국어 문제'];
          this.right_num = unMemory_sentence.list_sentence[index]['정답'];
          }

          else {
            try{
              if (index < _total_itemcount&&count<=_total_itemcount) {
                this.hindi_word = unMemory_sentence.list_sentence[index]['힌디어'];
                this.word_case = unMemory_sentence.list_sentence[index]['품사'];
                this.korean_word = unMemory_sentence.list_sentence[index]['의미'];
                this.hindi_example = unMemory_sentence.list_sentence[index]['힌디어 예시'];
                this.korean_example = unMemory_sentence.list_sentence[index]['한국어 예시'];
                this.korean_wrong_example =unMemory_sentence.list_sentence[index]['한국어 문제'];
                this.right_num = unMemory_sentence.list_sentence[index]['정답'];
              } else {
                move_page(
                    context,
                    "재복습 추천 문장",
                    this._total_itemcount,
                    this.correct,
                    wrong_hindi_words,wrong_korean_words);
              }
            } on Exception catch(_){
              move_page(
                  context,
                  "재복습 추천 문장",
                  this._total_itemcount,
                  this.correct,
                  wrong_hindi_words,wrong_korean_words);
            }

          }




          return SafeArea(child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(240, 10, 15, 64),
                        Color.fromARGB(240, 108, 121, 240)
                      ])),
              width: horizontal_size,
              height: vertical_size,
              child: Column(
                children: [
                  //단원 이름, 문제
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    width: horizontal_size,
                    height: vertical_size * 0.06,
                    decoration:
                    BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(1.5, 0),
                      )
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: horizontal_size * 0.4,
                          height: vertical_size * 0.05,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 0.5),
                          child: Text(
                            "복습 문장 갯수:",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'hufsfontMedium',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        Container(
                          width: horizontal_size * 0.32,
                          height: vertical_size * 0.05,
                          alignment: Alignment.center,
                          child: Text(
                            "단어 수: " + _total_itemcount.toString() + "개",
                            style: TextStyle(
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
                  SizedBox(height: vertical_size * 0.02),
                  //틀린 문제, 맞은 문제
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    padding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    width: horizontal_size,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: vertical_size * 0.15,
                          width: horizontal_size * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: horizontal_size * 0.4,
                                margin: EdgeInsets.only(left: 0.5),
                                child: Text(
                                  "O: " + correct.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 3,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: horizontal_size * 0.4,
                                margin: EdgeInsets.only(left: 0.5),
                                child: Text(
                                  "X: " + incorrect.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 3,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: vertical_size * 0.15,
                          width: horizontal_size * 0.32,
                          child: Container(
                            child: Text(
                              "진행: " + count.toString() +
                                  "/" +
                                  _total_itemcount.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 2,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //문제 카드
                  Container(
                    alignment: Alignment.center,
                    height: vertical_size * 0.7,
                    width: horizontal_size * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black26,
                              offset: new Offset(10.0, 10.0),
                              blurRadius: 20.0,
                              spreadRadius: 10.0)
                        ]),
                    child: Column(
                      children: [
                        //질문 번호
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontal_size * 0.02),
                          alignment: Alignment.centerLeft,
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.1,
                          child: AutoSizeText("Question" + count.toString() +
                              ".\n아래 문장은 올바른 문장입니까?", minFontSize: 10,
                            maxFontSize: 20,
                            style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38),),

                        ),
                        Container(
                          alignment: Alignment.center,
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.15,
                          child: AutoSizeText(
                              hindi_example, minFontSize: 20, maxFontSize: 30,
                              style: TextStyle(fontSize: 25)),


                        ),
                        Container(
                          alignment: Alignment.center,
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.15,
                          child: AutoSizeText(
                              korean_wrong_example, minFontSize: 15,
                              maxFontSize: 25,
                              style: TextStyle(fontSize: 20)),


                        ),

                        DottedLine(lineLength: horizontal_size * 0.895,
                          direction: Axis.horizontal,
                          dashColor: Colors.indigo,),
                        SizedBox(height: vertical_size * 0.02,),
                        Container(
                            alignment: Alignment.center,
                            width: horizontal_size * 0.9,
                            height: vertical_size * 0.05,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              // width: horizontal_size*0.3,
                              // height: vertical_size*0.05,
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontal_size * 0.02),
                              child: OutlineButton(onPressed: () {
                                showAlertDialog(BuildContext context)
                                {
                                  AlertDialog alert = AlertDialog(
                                    title: AutoSizeText(
                                      "단어 의미", minFontSize: 10, maxFontSize: 20,
                                      style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold),),
                                    content: AutoSizeText(
                                        "단어 " + hindi_word + " 의 의미는 " +
                                            korean_word + "입니다."),
                                    actions: [
                                      FlatButton(onPressed: () =>
                                          Navigator.of(context).pop(),
                                          child: Text("확인"))
                                    ],);
                                }

                              }, hoverColor: Colors.black12,

                                child: AutoSizeText(
                                  "힌트", style: TextStyle(fontSize: 10,
                                    color: Colors.black),),),
                            )

                        ),
                        Expanded(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                child: Container(

                                  height: vertical_size * 0.15,
                                  child: Icon(
                                    Icons.panorama_fish_eye, size: 50,),
                                ),
                                onTap: () {
                                  setState(() {
                                    count++;
                                    index++;
                                    if (right_num.compareTo('1') == 0) {
                                      correct++;
                                      unMemory_sentence.list_sentence[index]
                                          .remove('힌디어');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('품사');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('의미');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('힌디어 예시');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('한국어 예시');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('한국어 문제');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('정답');

                                    }
                                    else
                                    {

                                      incorrect++;
                                      wrong_hindi_words.add(unMemory_sentence.list_sentence[index]['힌디어']);
                                      wrong_korean_words.add(unMemory_sentence.list_sentence[index]['의미']);
                                    }

                                  });
                                },
                              ),
                              InkWell(
                                child: Container(

                                  height: vertical_size * 0.15,
                                  child: Icon(Icons.clear, size: 50,),

                                ),
                                onTap: () {
                                  setState(() {
                                    count++;
                                    index++;
                                    if (right_num.compareTo('0') == 0)
                                      {correct++;
                                      unMemory_sentence.list_sentence[index]
                                          .remove('힌디어');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('품사');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('의미');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('힌디어 예시');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('한국어 예시');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('한국어 문제');
                                      unMemory_sentence.list_sentence[index]
                                          .remove('정답');

                                      }
                                    else
                                    {
                                      incorrect++;
                                      wrong_hindi_words.add(unMemory_sentence.list_sentence[index]['힌디어']);
                                      wrong_korean_words.add(unMemory_sentence.list_sentence[index]['의미']);

                                    }

                                  });
                                },
                              ),

                            ],
                          ),
                        )

                      ],
                    ),
                  ),

                ],
              ),),
          ),
          );
        }
        else{
          return Text("저장된 복습 문장이 없습니다.",style: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.black26, fontSize: 40),);
        }
      },
      ),
        onWillPop: () async => false);
  }

  //페이지 이동
  void move_page(BuildContext context, String page_name, int _total_itemcount,
      int correct, List<String> wrong_hindi_words,
      List<String> wrong_korean_words) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  test_result(
                      page_name, _total_itemcount, correct, wrong_hindi_words,
                      wrong_korean_words)));
    });
  }


}