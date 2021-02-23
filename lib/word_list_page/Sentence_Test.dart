import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:excel/excel.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/hindiCommonVoca.dart';
import 'package:hindivocabulary/main.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:hindivocabulary/word_list_page/list_voca.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:hindivocabulary/function/finish_alert_function.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
import 'package:animated_widgets/animated_widgets.dart';

class Sentence_Test extends StatelessWidget {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int start_word_num;
  int finish_word_num;
  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  //생성자 , 첫 번째 범위, 두 번째, 세 번째 단원을 나누는 범위
  Sentence_Test(@required this.start_word_num, @required this.finish_word_num,
      @required this.page_name, @required this.file_name) {
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);

    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
            SentenceTest(start_word_num, finish_word_num, page_name, file_name),
      ),
    );
  }
}

class SentenceTest extends StatefulWidget {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  SentenceTest(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _SentenceTestState createState() => _SentenceTestState(
      _start_word_num, _finish_word_num, page_name, file_name);
}

class _SentenceTestState extends State<SentenceTest>
    with TickerProviderStateMixin {

  //해당 단어 파트 이름
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
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

  //정답수, 틀린 갯수
  var result_right_num = 0;
  var result_wrong_num = 0;

  //인덱스
  int global_index = 0;

  //선택하지 않고 넘기려거나 탭하려고 할 때 진동이 울리게 하는 함수
  //아무 것도 정답 선택하지 않으면 true, 답을 선택하면 false
  bool change_decision = false;

  //정답이면 체크가 나오게하는 변수, 답이면 1 오답이면 0
  int check_right;

  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수
  int index = 0;
  int count = 1;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  //챕터별 모든 문장 학습이 끝나면 틀린 단어 모아 볼 수 있게하는 리스트 변수
  List<String> wrong_hindi_words;
  List<String> wrong_korean_words;

  _SentenceTestState(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }


  //답을 선택하지 않고 카드를 탭하면 흔들리는 경고성 메세지 함수
  void warning_Tap() {
    SizeAnimatedWidget(
      enabled: true,
      duration: Duration(milliseconds: 1500),
      values: [Size(100, 100), Size(100, 150), Size(200, 150), Size(200, 200)],
      curve: Curves.linear,

      //your widget
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: FlutterLogo(
          style: FlutterLogoStyle.stacked,
        ),
      ),
    );
  }
  
  //정답이면 정답 아이콘이 뜨고 오답이면 오답 아이콘이 뜨게하는 함수
  Widget decision_Icon(int right_or_wrong,bool decision ){
    if(decision==true && right_or_wrong==1)
      {
        Icon(
          Icons.check
        );
      }
    if(decision==true && right_or_wrong==0)
      {
        Icon(
          Icons.warning_rounded
        );
      }
  }
  //단어 답 선택 후 카드 크기가 커질 때 같이 나오는 한국어 문장 답, 힌디어 뜻, 한국어 뜻
  Widget largesize_meaning(bool decision,double horizontal_size, double vertical_size)
  {
    if(decision)
      {
        return Container(
          height: vertical_size*0.4,
          width: horizontal_size*0.8,
          child:Column(
            children: [
              Container(
                width: horizontal_size*0.8,
                height: vertical_size*0.1,
                child:AutoSizeText("정답",minFontSize: 20,maxFontSize: 25,style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 23
                ),),
              ),
              Container(
                width: horizontal_size*0.8,
                height: vertical_size*0.1,
                child:AutoSizeText(korean_example,minFontSize: 20,maxFontSize: 25,style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 23
                ),),
              ),
              Container(
                width: horizontal_size*0.8,
                height: vertical_size*0.05,
                child:AutoSizeText('단어 ',minFontSize: 20,maxFontSize: 25,style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 23
                ),),
              ),

              Container(
                width: horizontal_size*0.8,
                height: vertical_size*0.05,
                child:AutoSizeText(hindi_word,minFontSize: 20,maxFontSize: 25,style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 23
                ),),
              ),
              Container(
                width: horizontal_size*0.8,
                height: vertical_size*0.05,
                child:AutoSizeText(korean_word,minFontSize: 20,maxFontSize: 25,style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 23
                ),),
              ),

            ],
          )
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top);

    return WillPopScope(
        child: new FutureBuilder(
            future:
                make_word_list(_start_word_num, _finish_word_num, file_name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (index == 0 && count == 1) {
                  this.hindi_word = snapshot.data[index][0].toString();
                  this.word_case = snapshot.data[index][1].toString();
                  this.korean_word = snapshot.data[index][2].toString();
                  this.hindi_example = snapshot.data[index][3].toString();
                  this.korean_example = snapshot.data[index][4].toString();
                  this.korean_wrong_example =
                      snapshot.data[index][5].toString();
                  this.right_num = snapshot.data[index][6].toString();
                }

                //양 옆으로 밀었을 때 swipe 하는 기능
                void _onHorizontalDragStartHandler(DragStartDetails details) {

                  setState(() {

                      if (this.index == _total_itemcount - 1 && this.change_decision == true) {
                        alert_backto_lobi(context, this.file_name);
                      }
                      if (this.index < _total_itemcount - 1 && this.change_decision == true) {
                        this.index++;
                        count++;
                      }

                    this.hindi_word = snapshot.data[index][0].toString();
                    this.word_case = snapshot.data[index][1].toString();
                    this.korean_word = snapshot.data[index][2].toString();
                    this.hindi_example = snapshot.data[index][3].toString();
                    this.korean_example = snapshot.data[index][4].toString();
                    this.korean_wrong_example =
                        snapshot.data[index][5].toString();
                    this.right_num = snapshot.data[index][6].toString();
                    this.count = count;
                  });
                }





                return SafeArea(
                  child: Scaffold(
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
                    body: Container(
                      width: horizontal_size,
                      height: vertical_size,
                      child: Column(
                        children: [
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
                                //페이지 이름
                                Container(
                                  width: horizontal_size * 0.4,
                                  height: vertical_size * 0.05,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 0.5),
                                  child: Text(
                                    page_name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'hufsfontMedium',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                                //단어 갯수
                                Container(
                                  width: horizontal_size * 0.32,
                                  height: vertical_size * 0.05,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "단어 수: " +
                                        _total_itemcount.toString() +
                                        "개",
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
                          SizedBox(
                            height: vertical_size * 0.02,
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                if(this.change_decision==false)
                                  warning_Tap();
                                else
                                  _onHorizontalDragStartHandler;
                              });
                            },
                            child: Container(

                              width: horizontal_size*0.8,
                              height: vertical_size*0.7,
                              child: Center(
                                child:




                                    Container(

                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(240, 112, 126, 250),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          boxShadow: [
                                            new BoxShadow(
                                                color: Colors.black26,
                                                offset: new Offset(10.0, 10.0),
                                                blurRadius: 20.0,
                                                spreadRadius: 0.0)
                                          ]),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                            children: [
                                              Container(
                                                width: horizontal_size*0.2,
                                                height: vertical_size*0.1,
                                                padding: EdgeInsets.symmetric(vertical: vertical_size*0.01),
                                                child: Text(
                                                  "진행: "+count.toString()+"/"+_total_itemcount.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17
                                                  ),

                                                ),
                                              ),

                                              Container(
                                                width: horizontal_size*0.2,
                                                height: vertical_size*0.1,
                                                padding: EdgeInsets.symmetric(vertical: vertical_size*0.01),
                                                child: Text(
                                                  "점수: "+result_right_num.toString()+"/"+_total_itemcount.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: horizontal_size*0.2,
                                                height: vertical_size*0.1,
                                                padding: EdgeInsets.symmetric(vertical: vertical_size*0.01),
                                                child: AnimatedOpacity(
                                                  opacity: change_decision? 0.0 : 1.0,
                                                  duration: Duration(microseconds: 500),
                                                  child: decision_Icon(check_right,change_decision),
                                                ),
                                              )
                                            ],
                                          ),
                                          //힌디어 문장
                                          Container(
                                            width: horizontal_size*0.8,
                                            height: vertical_size*0.1,
                                            alignment: Alignment.center,
                                            child: AutoSizeText(hindi_example,minFontSize: 15,maxFontSize: 40,style: TextStyle(
                                                fontSize: 30, fontWeight: FontWeight.bold
                                            ),),
                                          ),
                                          //한국어 문장 문제
                                          Container(
                                            width: horizontal_size*0.8,
                                            height: vertical_size*0.1,
                                            alignment: Alignment.center,
                                            child: AutoSizeText(korean_wrong_example,minFontSize: 15,maxFontSize: 25,style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),
                                      Container(
                                        width: horizontal_size*0.2,
                                        height: vertical_size*0.4,
                                        padding: EdgeInsets.symmetric(vertical: vertical_size*0.01),
                                        child: AnimatedOpacity(
                                          opacity: change_decision? 0.0 : 1.0,
                                          duration: Duration(microseconds: 500),
                                          child: largesize_meaning(change_decision,horizontal_size,vertical_size),
                                        ),)

                                        ],
                                      ),

                                    ),




                                  ),
                              ),

                              ),



                          Divider(
                            height: vertical_size * 0.005,
                          ),
                          Expanded(
                            //width: horizontal_size,
                              //height: vertical_size*0.15,
                              child: Container(
                            padding:
                                EdgeInsets.only(bottom: vertical_size * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    splashColor: Colors.red,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: horizontal_size * 0.03,
                                          vertical: vertical_size * 0.03),
                                      decoration: BoxDecoration(
                                        //borderRadius: BorderRadiusGeometry.lerp(a, b, t)
                                        color: Colors.white10,
                                      ),
                                      child: Icon(
                                        Icons.radio_button_unchecked_outlined,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        this.count++;
                                        this.change_decision = true;
                                        if (right_num.compareTo('1') == 0) {

                                          this.result_right_num++;
                                          this.check_right = 1;


                                        } else {

                                          this.check_right = 0;
                                        }
                                      });
                                    }),
                                Divider(
                                  thickness: horizontal_size * 0.005,
                                ),
                                InkWell(
                                  splashColor: Colors.red,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: horizontal_size * 0.03,
                                        vertical: vertical_size * 0.03),
                                    decoration: BoxDecoration(
                                      //borderRadius: BorderRadiusGeometry.lerp(a, b, t)
                                      color: Colors.white10,
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      size: 60,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {

                                    setState(() {
                                      this.change_decision = true;
                                      this.count++;
                                      if (right_num.compareTo('0') == 0) {

                                        this.result_right_num++;
                                        this.check_right = 1;
                                      } else {


                                        this.check_right = 0;



                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              } else
                return Text("한 개당 보여주는 단어장 로딩 Failed");
            }),
        onWillPop: () async => false);
  }
}
