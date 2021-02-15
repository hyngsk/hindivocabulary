import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/scheduler.dart';
import 'package:hindivocabulary/function/test_result_page.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'dart:async';
import 'dart:math';
import 'package:hindivocabulary/function/finish_alert_function.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view_sentence.dart';

class sentence_Test extends StatefulWidget {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int start_word_num;
  int finish_word_num;
  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  sentence_Test(
    this.start_word_num,
    this.finish_word_num,
    this.page_name,
    this.file_name,
  ) {
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);

    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _sentence_TestState createState() => _sentence_TestState(
      start_word_num, finish_word_num, page_name, file_name);
}

class _sentence_TestState extends State<sentence_Test>
    with TickerProviderStateMixin {


  //답 맞추거나 틀릴 때 정답 보이게하는 애니메이션
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  //만약 정답이 틀리면 답이 등장하게 하는 함수
  Widget FadeInConsider(bool consider_num, String korean_sentence_right) {
    if (consider_num) {
      return Container();
    } else {
      return Container(
          child: FadeTransition(
        opacity: animation,
        child: AutoSizeText(
          "정답:   " + korean_sentence_right,
          maxFontSize: 30,
          minFontSize: 10,
          softWrap: true,
          style: TextStyle(fontSize: 18),
        ),
      ));
    }
  }

  //단어 정답이 보이는 것을 결정하는 bool
  bool consider_number =true;

  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
  int _total_itemcount;

  int count = 1;
  int correct = 0;
  int incorrect = 0;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  _sentence_TestState(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  //stful 위젯이므로 각 단어 선택시 해당되는 단어를 저장
  var hindi_word = '';
  var korean_word = '';

  //stful 위젯이므로 각 문장을 표시
  var hindi_sentence = '';
  var korean_sentence_right = '';
  var korean_sentence_wrong = '';
  var correct_num = '';

  int global_index = 0;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

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
                if (global_index == 0 && count == 1) {
                  this.hindi_word = snapshot.data[global_index][0].toString();
                  this.korean_word = snapshot.data[global_index][2].toString();
                  this.hindi_sentence =
                      snapshot.data[global_index][3].toString();
                  this.korean_sentence_right =
                      snapshot.data[global_index][4].toString();
                  this.korean_sentence_wrong =
                      snapshot.data[global_index][5].toString();
                  this.correct_num = snapshot.data[global_index][6].toString();
                } else {
                  if (global_index < _total_itemcount) {
                    this.hindi_word = snapshot.data[global_index][0].toString();
                    this.korean_word =
                        snapshot.data[global_index][2].toString();
                    this.hindi_sentence =
                        snapshot.data[global_index][3].toString();
                    this.korean_sentence_right =
                        snapshot.data[global_index][4].toString();
                    this.korean_sentence_wrong =
                        snapshot.data[global_index][5].toString();
                    this.correct_num =
                        snapshot.data[global_index][6].toString();
                  } else {
                    move_page(context, this.page_name, this._total_itemcount,
                        this.correct, wrong_hindi_words, wrong_korean_words);
                  }
                }

                List<String> hindi_wrong_word = [];
                List<String> korean_wrong_word = [];

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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(240, 10, 15, 64),
                          Color.fromARGB(240, 108, 121, 240)
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        //파트 이름, 번호, 단어 수
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          width: horizontal_size,
                          height: vertical_size * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: horizontal_size * 0.4,
                                height: vertical_size * 0.05,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 0.5),
                                child: Text(
                                  page_name,
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
                                height: vertical_size * 0.05,
                                alignment: Alignment.center,
                                child: Text(
                                  "문장 수: " + _total_itemcount.toString() + "개",
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
                        //정답, 오답 수, 제한 시간
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
                                    count.toString() +
                                        "/" +
                                        _total_itemcount.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
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
                        //단어 보이기 카드 형식
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 22, horizontal: 15),
                          width: horizontal_size * 0.95,
                          height: vertical_size * 0.75,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(240, 242, 242, 242),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black12,
                                    offset: new Offset(3.0, 3.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0)
                              ]),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: vertical_size * 0.01),
                                  alignment: Alignment.center,
                                  width: horizontal_size * 0.84,
                                  height: vertical_size * 0.23,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      boxShadow: [
                                        new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(3.0, 3.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0)
                                      ]),
                                  child: AutoSizeText(
                                    hindi_sentence,
                                    maxFontSize: 18,
                                    minFontSize: 12,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: vertical_size * 0.025,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: horizontal_size * 0.84,
                                  height: vertical_size * 0.13,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      boxShadow: [
                                        new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(3.0, 3.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0)
                                      ]),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 13),
                                    child: AutoSizeText(
                                      "문제:\t" + korean_sentence_wrong,
                                      maxFontSize: 30,
                                      minFontSize: 10,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: horizontal_size * 0.84,
                                  height: vertical_size * 0.13,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      boxShadow: [
                                        new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(3.0, 3.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0)
                                      ]),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 13),
                                      child: FadeInConsider(consider_number,
                                          korean_sentence_right)),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                            child: Icon(
                                              Icons.lens_outlined,
                                              size: 60,
                                            ),
                                            onTap: () {
                                              setState(() {

                                                if (correct_num
                                                        .compareTo('1') ==
                                                    0) {
                                                  setState(() {
                                                    consider_number =true;
                                                  });

                                                  correct++;
                                                  count++;
                                                  global_index++;
                                                } else {
                                                  setState(() {
                                                    consider_number =false;
                                                  });

                                                  unMemory_words(
                                                      snapshot
                                                          .data[global_index][0]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][1]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][2]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][3]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][4]
                                                          .toString());
                                                  wrong_hindi_words.add(snapshot
                                                      .data[global_index][0]
                                                      .toString());
                                                  wrong_korean_words.add(
                                                      snapshot
                                                          .data[global_index][2]
                                                          .toString());
                                                  incorrect++;
                                                  count++;
                                                  global_index++;
                                                }
                                              });
                                            }),
                                        InkWell(
                                            child: Icon(
                                              Icons.clear_outlined,
                                              size: 60,
                                            ),
                                            onTap: () {
                                              setState(() {

                                                if (correct_num
                                                        .compareTo('0') ==
                                                    0) {

                                                  setState(() {
                                                    consider_number =true;

                                                  });

                                                  correct++;
                                                  count++;
                                                  global_index++;
                                                } else {
                                                  setState(() {
                                                    consider_number =false;
                                                  });

                                                  unMemory_words(
                                                      snapshot
                                                          .data[global_index][0]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][1]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][2]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][3]
                                                          .toString(),
                                                      snapshot
                                                          .data[global_index][4]
                                                          .toString());
                                                  wrong_hindi_words.add(snapshot
                                                      .data[global_index][0]
                                                      .toString());
                                                  wrong_korean_words.add(
                                                      snapshot
                                                          .data[global_index][2]
                                                          .toString());
                                                  incorrect++;
                                                  count++;
                                                  global_index++;
                                                }
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              } else {
                return Text("로딩 실패");
              }
            }),
        onWillPop: () async => false);
  }
}

//페이지 이동
void move_page(
    BuildContext context,
    String page_name,
    int _total_itemcount,
    int correct,
    List<String> wrong_hindi_words,
    List<String> wrong_korean_words) {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => test_result(
                page_name,
                _total_itemcount,
                correct,
                wrong_hindi_words,
                wrong_korean_words)));
  });
}
