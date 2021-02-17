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
  AnimationController _flipCardController;
  Animation<double> _frontAnimation;
  Animation<double> _backAnimation;

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

  //오답이면 카드가 뒤집혀지는 것을 결정하는 변수
  bool change_desicion;

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

  @override
  void initState() {
    super.initState();

    _flipCardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // play from 0  to 0.5s
    _frontAnimation = Tween<double>(begin: 0.0, end: 0.5 * pi).animate(
        CurvedAnimation(parent: _flipCardController, curve: Interval(0, 0.5)));

    // delay in 0.5s(wait for the front flip completed) and then play
    _backAnimation = Tween<double>(begin: 1.5 * pi, end: 2 * pi).animate(
        CurvedAnimation(parent: _flipCardController, curve: Interval(0.5, 1)));
  }

  @override
  void dispose() {
    _flipCardController.dispose();
    super.dispose();
  }

  void flipCard() {
    result_wrong_num++;
    count++;
    global_index++;
    if (_flipCardController.isDismissed) {
      _flipCardController.forward();
    } else {
      _flipCardController.reverse();
    }
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

  Widget wrongAnswer_flip(bool change_decision) {
    if (change_decision) {
      print("답이 틀림");
      Stack(
        children: <Widget>[
          AnimatedBuilder(
              child: GestureDetector(
                  child: CustomCard_Behind(
                      this.hindi_word,
                      this.korean_word,
                      this.word_case,
                      this.hindi_example,
                      this.korean_example,
                      this.korean_wrong_example,
                      this.count,
                      this._total_itemcount,
                      this.result_right_num,
                      Color.fromARGB(240, 150, 131, 60)),
                  onTap: warning_Tap),
              animation: _backAnimation,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  alignment: FractionalOffset.center,
                  child: child,
                  transform: Matrix4.identity()..rotateY(_backAnimation.value),
                );
              }),
          AnimatedBuilder(
              child: GestureDetector(
                child: CustomCard_Front(
                    this.hindi_example,
                    this.korean_wrong_example,
                    this.count,
                    this._total_itemcount,
                    this.result_right_num,
                    Color.fromARGB(240, 112, 126, 250)),
                onTap: flipCard,
              ),
              animation: _frontAnimation,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  alignment: FractionalOffset.center,
                  child: child,
                  transform: Matrix4.identity()..rotateY(_frontAnimation.value),
                );
              }),
        ],
      );
    } else {
      print("답이 맞음");
      result_right_num++;
      count++;
      global_index++;
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
                    if (details.globalPosition.dx.floorToDouble() <
                        horizontal_size * 0.5) {
                      if (this.index > 0) {
                        this.index--;
                        count--;
                      }
                    } else {
                      if (this.index == _total_itemcount - 1) {
                        alert_backto_lobi(context, this.file_name);
                      }
                      if (this.index < _total_itemcount - 1) {
                        this.index++;
                        count++;
                      }
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

                void _onVerticalDragStartHandler(DragStartDetails details) {
                  setState(() {
                    if (details.globalPosition.dy.floorToDouble() >
                        vertical_size * 0.3) {
                      unMemory_words(
                        snapshot.data[index][0].toString(),
                        snapshot.data[index][1].toString(),
                        snapshot.data[index][2].toString(),
                        snapshot.data[index][3].toString(),
                        snapshot.data[index][4].toString(),
                      );

                      var snackbar = SnackBar(
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "미암기 단어장에 해당 단어가 추가되었습니다.",
                          style: TextStyle(color: Colors.black),
                        ),
                        action: SnackBarAction(
                          label: "확인",
                          onPressed: () {},
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
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
                            height: vertical_size*0.02,
                          ),

                          Container(
                            height: vertical_size * 0.77,
                            width: horizontal_size,
                            alignment: Alignment.center,
                            child: Center(
                              // ignore: missing_return
                              child: Stack(
                                children: <Widget>[
                                  AnimatedBuilder(
                                      child: GestureDetector(
                                        child: CustomCard_Behind(
                                            this.hindi_word,
                                            this.korean_word,
                                            this.word_case,
                                            this.hindi_example,
                                            this.korean_wrong_example,
                                            this.korean_example,
                                            this.count,
                                            this._total_itemcount,
                                            this.result_right_num,
                                            Color.fromARGB(240, 150, 131, 60)),
                                        onTap: flipCard,
                                        onHorizontalDragStart:
                                            _onHorizontalDragStartHandler,
                                      ),
                                      animation: _backAnimation,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Transform(
                                          alignment: FractionalOffset.center,
                                          child: child,
                                          transform: Matrix4.identity()
                                            ..rotateY(_backAnimation.value),
                                        );
                                      }),
                                  AnimatedBuilder(
                                      child: GestureDetector(
                                        child: CustomCard_Front(
                                            this.hindi_example,
                                            this.korean_wrong_example,
                                            this.count,
                                            this._total_itemcount,
                                            this.result_right_num,
                                            Color.fromARGB(240, 112, 126, 250)),
                                        onTap: flipCard,
                                        onHorizontalDragStart:
                                            _onHorizontalDragStartHandler,
                                        onVerticalDragStart:
                                            _onVerticalDragStartHandler,
                                      ),
                                      animation: _frontAnimation,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Transform(
                                          alignment: FractionalOffset.center,
                                          child: child,
                                          transform: Matrix4.identity()
                                            ..rotateY(_frontAnimation.value),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: vertical_size * 0.005,
                          ),
                          Expanded(
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
                                        if (right_num.compareTo('1') == 0) {
                                          this.change_desicion = false;
                                          wrongAnswer_flip(
                                              this.change_desicion);
                                        } else {
                                          change_desicion = true;

                                          wrongAnswer_flip(
                                              this.change_desicion);
                                          // wrong_hindi_words.add(snapshot
                                          //     .data[global_index][0]
                                          //     .toString());
                                          // wrong_korean_words.add(snapshot
                                          //     .data[global_index][2]
                                          //     .toString());

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
                                      if (right_num.compareTo('0') == 0) {
                                        this.change_desicion = false;
                                        wrongAnswer_flip(this.change_desicion);
                                      } else {
                                        change_desicion = true;

                                        wrongAnswer_flip(this.change_desicion);
                                        // wrong_hindi_words.add(snapshot
                                        //     .data[global_index][0]
                                        //     .toString());
                                        // wrong_korean_words.add(snapshot
                                        //     .data[global_index][2]
                                        //     .toString());

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

class CustomCard_Front extends StatelessWidget {
  String _hindi_sentence;
  String _korean_question;
  Color color;
  int count;
  String total_count;
  int right_count;

  CustomCard_Front(String _hindi_sentence, String _korean_question, int count,
      int total_count,int right_count, Color color) {
    this._hindi_sentence = _hindi_sentence;
    this._korean_question = _korean_question;
    this.color = color;
    this.count = count;
    this.right_count= right_count;
    this.total_count = total_count.toString();
  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
            color: this.color,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(10.0, 10.0),
                  blurRadius: 20.0,
                  spreadRadius: 0.0)
            ]),
        width: horizontal_size * 0.8,
        height: vertical_size * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: horizontal_size * 0.35,
                  height: vertical_size * 0.05,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: AutoSizeText(
                        "진행: "+this.count.toString() + "/" + total_count.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                        maxLines: 1,
                        minFontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: horizontal_size * 0.35,
                  height: vertical_size * 0.05,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: AutoSizeText(
                        "점수: " + right_count.toString()+"/"+total_count.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                        maxLines: 1,
                        minFontSize: 15,
                      ),
                    ),
                  ),

                ),


              ],
            ),
            SizedBox(
              width: horizontal_size * 0.6,
              height: vertical_size * 0.2,
              child: Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                  this._hindi_sentence,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                  maxLines: 2,
                  minFontSize: 20,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: horizontal_size * 0.2,
                  height: vertical_size * 0.05,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Container(
                      alignment: Alignment.center,
                      width: horizontal_size * 0.64,
                      height: vertical_size * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: AutoSizeText(
                        "문제",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3),
                        maxLines: 1,
                        minFontSize: 12,
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white24,
                )
              ],
            ),
            SizedBox(
              width: horizontal_size * 0.6,
              height: vertical_size * 0.25,
              child: Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                  this._korean_question,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                  maxLines: 2,
                  minFontSize: 18,
                ),
              ),
            ),
          ],
        ));
  }
}

class CustomCard_Behind extends StatelessWidget {
  String _korean_word;
  String _hindi_word;
  String _word_class;
  String _hindi_example;
  String _korean_question;
  String _korean_right_answer;
  //인덱스
  int count;
  //총 단어 갯수
  int total_count;
  Color color;
  //정답 갯수
  int right_count;

  CustomCard_Behind(
      String _hindi_word,
      String _korean_word,
      String _word_class,
      String _hindi_example,
      String _korean_question,
      String _korean_right_answer,
      int count,
      int total_count,
      int right_count,
      Color color) {
    this._hindi_word = _hindi_word;
    this._korean_word = _korean_word;
    this._word_class = _word_class;
    this._hindi_example = _hindi_example;
    this._korean_question = _korean_question;
    this._korean_right_answer = _korean_right_answer;
    this.count = count;
    this.total_count = total_count;
    this.right_count= right_count;
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top);
    return Container(
        decoration: BoxDecoration(
            color: this.color,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(10.0, 10.0),
                  blurRadius: 20.0,
                  spreadRadius: 0.0)
            ]),
        width: horizontal_size * 0.8,
        height: vertical_size * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: horizontal_size * 0.35,
                  height: vertical_size * 0.05,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: AutoSizeText(
                        "진행: "+this.count.toString() + "/" + total_count.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                        maxLines: 1,
                        minFontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: horizontal_size * 0.35,
                  height: vertical_size * 0.05,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: AutoSizeText(
                        "점수: " + right_count.toString()+"/"+total_count.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                        maxLines: 1,
                        minFontSize: 15,
                      ),
                    ),
                  ),

                ),


              ],
            ),

            SizedBox(height: vertical_size * 0.03),
            Container(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.07,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: AutoSizeText(
                  this._hindi_word,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'hufsfontMedium'),
                  maxLines: 3,
                  presetFontSizes: [35, 25, 21],
                ),
              ),
            ),
            Container(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.07,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: AutoSizeText(
                  this._korean_word,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  minFontSize: 10,
                ),
              ),
            ),
            SizedBox(height: vertical_size * 0.02),
            Container(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black26,
                        offset: new Offset(5.0, 5.0),
                        blurRadius: 5.0,
                        spreadRadius: 0.0)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: horizontal_size * 0.7,
                    height: vertical_size * 0.035,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Container(
                        alignment: Alignment.center,
                        width: horizontal_size * 0.64,
                        height: vertical_size * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: AutoSizeText(
                          "예제",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: horizontal_size * 0.7,
                    height: vertical_size * 0.08,
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                      child: AutoSizeText(
                        this._hindi_example,
                        style: TextStyle(fontWeight: FontWeight.w300),
                        maxLines: 3,
                        presetFontSizes: [25, 18, 15],
                        minFontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: horizontal_size * 0.7,
                    height: vertical_size * 0.035,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Container(
                        alignment: Alignment.center,
                        width: horizontal_size * 0.64,
                        height: vertical_size * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: AutoSizeText(
                          "문제",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: vertical_size * 0.07,
                    width: horizontal_size * 0.7,
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: AutoSizeText(
                        this._korean_question,
                        style: TextStyle(fontWeight: FontWeight.w300),
                        maxLines: 3,
                        minFontSize: 8,
                        presetFontSizes: [16, 12, 8],
                      ),
                    ),
                  ),
                  Container(
                    width: horizontal_size * 0.7,
                    height: vertical_size * 0.035,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Container(
                        alignment: Alignment.center,
                        width: horizontal_size * 0.64,
                        height: vertical_size * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: AutoSizeText(
                          "정답",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: vertical_size * 0.07,
                    width: horizontal_size * 0.7,
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: AutoSizeText(
                        this._korean_right_answer,
                        style: TextStyle(fontWeight: FontWeight.w300),
                        maxLines: 3,
                        minFontSize: 8,
                        presetFontSizes: [16, 12, 8],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
