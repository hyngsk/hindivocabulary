import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:hindivocabulary/function/test_result_page.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'dart:async';
import 'dart:math';

import 'package:hindivocabulary/function/unmemory_list.dart';
import 'package:hindivocabulary/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/main.dart';

class TestVoca extends StatefulWidget {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int start_word_num;
  int finish_word_num;
  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  TestVoca({
    Key key,
    @required this.start_word_num,
    @required this.finish_word_num,
    @required this.page_name,
    @required this.file_name,
  }) {
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);

    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _TestVocaState createState() =>
      _TestVocaState(start_word_num, finish_word_num, page_name, file_name);
}

class _TestVocaState extends State<TestVoca> {
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

  _TestVocaState(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  var hindi_word = '';
  var korean_word = '';

  //BottomNavigationBar
  int _selectedIndex = 0;

  int global_index = 0;

  //힌디 단어 시험인지, 한국어 의미 단어 시험인지 설정
  bool _choice_language = true;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  Map<String, dynamic> make_question(
      bool choice_num,
      String hindi_correct_word,
      String korean_correct_word,
      List<String> hindi_wrong_words,
      List<String> korean_wrong_words) {
    Map<String, dynamic> result = {
      'correct_number': 1,
      'main_word': '',
      'wrong_word': []
    };
    //일시적으로 순서 정렬하지 않은 문제 리스트
    List<String> temp_randomword = [];
    //정답,오답을 포함한 문제 리스트
    List<String> randomword = [];
    //문제를 정렬하기 위한 인덱스 리스트
    List<int> randomnumber = [0, 0, 0, 0];

    //랜덤 시드와 범위를 넣고 변경하는 랜덤 함수
    int generateRandom(int range, int seed) {
      Random random = new Random(seed);
      int randomIndex = random.nextInt(range);
      return randomIndex;
    }

    //랜덤 시드를 뽑는 함수
    int generateRandomseed() {
      Random random = new Random();
      int randomIndex = random.nextInt(1000);
      return randomIndex;
    }

    int right_num;
    int randomIndex;

    if (choice_num) {
      //처음에는 정답을 저장한 리스트 생성
      temp_randomword.add(hindi_correct_word);
      //답을 제외한 파트 별 단어 수에서 랜덤으로 3개 인덱스 뽑음

      for (int i = 0; i < 3; i++) {
        randomIndex = generateRandom(25, generateRandomseed());
        if (temp_randomword.first.compareTo(hindi_wrong_words[randomIndex]) !=
            0) {
          temp_randomword.add(hindi_wrong_words[randomIndex]);
        }
        else{
          while(true)
            {
              randomIndex = generateRandom(25, generateRandomseed());
              //3개의 랜덤 단어를 저장
              if (temp_randomword.first.compareTo(hindi_wrong_words[randomIndex]) !=
                  0) {
                temp_randomword.add(hindi_wrong_words[randomIndex]);
                break;

              }

            }
        }

      }

      //뽑는 4개중 중복된 인덱스를 걸러내는 반복문
      for (int i = 0; i < 4; i++) {
        randomIndex = generateRandom(4, generateRandomseed());
        randomnumber[i] = randomIndex;
        for (int j = 0; j < i; j++) {
          if (randomnumber[i] == randomnumber[j]) i--;
        }
      }
      //뽑은 4개의 단어를 섞는 반복문
      for (int i = 0; i < 4; i++) {
        randomword.add(temp_randomword[randomnumber[i]]);
      }

      for (int i = 0; i < randomword.length; i++) {
        if (hindi_correct_word.compareTo(randomword[i]) == 0) {
          right_num = i;
        }
      }

      result['correct_number'] = right_num;
      result['main_word'] = korean_correct_word;
      result['wrong_word'] = randomword;
      return result;
    } else {
      //처음에는 정답을 저장한 리스트 생성
      temp_randomword.add(korean_correct_word);

      //답을 제외한 파트 별 단어 수에서 랜덤으로 3개 인덱스 뽑음
      Loop1:
      for (int i = 0; i < 3; i++) {
        randomIndex = generateRandom(25, generateRandomseed());
        if (temp_randomword.first.compareTo(korean_wrong_words[randomIndex]) !=
            0) {
          temp_randomword.add(korean_wrong_words[randomIndex]);
        }
        Loop2:
        while (
            temp_randomword.first.compareTo(korean_wrong_words[randomIndex]) ==
                0) {
          randomIndex = generateRandom(25, generateRandomseed());
          //3개의 랜덤 단어를 저장
          if (temp_randomword.first
                  .compareTo(korean_wrong_words[randomIndex]) !=
              0) {
            temp_randomword.add(korean_wrong_words[randomIndex]);
            break Loop2;
          }
        }
      }
      //뽑는 4개중 중복된 인덱스를 걸러내는 반복문
      for (int i = 0; i < 4; i++) {
        randomIndex = generateRandom(4, generateRandomseed());
        randomnumber[i] = (randomIndex);
        for (int j = 0; j < i; j++) {
          if (randomnumber[i] == randomnumber[j]) i--;
        }
      }
      //뽑은 4개의 단어를 섞는 반복문
      for (int i = 0; i < 4; i++) {
        randomword.add(temp_randomword[randomnumber[i]]);
      }
      for (int i = 0; i < randomword.length; i++) {
        if (korean_correct_word.compareTo(randomword[i]) == 0) {
          right_num = i;
        }
      }
      result['correct_number'] = right_num;
      result['main_word'] = hindi_correct_word;
      result['wrong_word'] = randomword;
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);

    return WillPopScope(
        child: new FutureBuilder(
            future:
                make_word_list(_start_word_num, _finish_word_num, file_name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (global_index == 0 && count == 1) {
                  this.hindi_word = snapshot.data[global_index][0].toString();

                  this.korean_word = snapshot.data[global_index][2].toString();
                } else {
                  try {
                    if (global_index < _total_itemcount &&
                        count <= _total_itemcount) {
                      this.hindi_word =
                          snapshot.data[global_index][0].toString();

                      this.korean_word =
                          snapshot.data[global_index][2].toString();
                    } else {
                      move_page(context, this.page_name, this._total_itemcount,
                          this.correct, wrong_hindi_words, wrong_korean_words);
                    }
                  } on Exception catch (_) {
                    move_page(context, this.page_name, this._total_itemcount,
                        this.correct, wrong_hindi_words, wrong_korean_words);
                  }
                }

                List<String> hindi_wrong_word = [];
                List<String> korean_wrong_word = [];
                for (int i = 0; i < 30; i++) {
                  hindi_wrong_word.add(snapshot.data[i][0].toString());
                }
                for (int i = 0; i < 30; i++) {
                  korean_wrong_word.add(snapshot.data[i][2].toString());
                }
                Map<String, dynamic> question = make_question(
                    _choice_language,
                    this.hindi_word,
                    this.korean_word,
                    hindi_wrong_word,
                    korean_wrong_word);
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
                            if (file_name == 'assets/A0.xlsx') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => level_(
                                      A0_word_list_page,
                                      A0_word_list_scale,
                                      'A0 단어장',
                                      'assets/A0.xlsx'),
                                ),
                              );
                            } else if (file_name == 'assets/A1.xlsx') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => level_(
                                      A1_word_list_page,
                                      A1_word_list_scale,
                                      'A1 단어장',
                                      'assets/A1.xlsx'),
                                ),
                              );
                            } else if (file_name == 'assets/A2.xlsx') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => level_(
                                      A2_word_list_page,
                                      A2_word_list_scale,
                                      'A2 단어장',
                                      'assets/A2.xlsx'),
                                ),
                              );
                            } else if (file_name == 'assets/B1.xlsx') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => level_(
                                      B1_word_list_page,
                                      B1_word_list_scale,
                                      'B1 단어장',
                                      'assets/B1.xlsx'),
                                ),
                              );
                            } else if (file_name == 'assets/B2.xlsx') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => level_(
                                      B1_word_list_page,
                                      B1_word_list_scale,
                                      'B1 단어장',
                                      'assets/B1.xlsx'),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                              );
                            }
                          },
                        );
                      },
                    ),
                    shadowColor: Colors.black26,
                    centerTitle: true,
                    backgroundColor: Color.fromARGB(240, 10, 15, 64),
                    title: Text(
                      "HUFS 힌디어 학습 도우미",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'hufsfontMedium',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _selectedIndex,
                      backgroundColor: Color.fromARGB(240, 105, 118, 236),
                      selectedFontSize: 13,
                      iconSize: 18,
                      unselectedFontSize: 12,
                      unselectedItemColor: Colors.white.withOpacity(.50),
                      selectedItemColor: Colors.white,
                      onTap: (choice_num) {
                        setState(() {
                          _selectedIndex = choice_num;

                          if (_selectedIndex == 0)
                            _choice_language = true;
                          else
                            _choice_language = false;
                        });
                      },
                      items: [
                        BottomNavigationBarItem(
                            label: '힌디어 문제',
                            icon: Icon(
                              Icons.format_clear,
                            )),
                        BottomNavigationBarItem(
                            label: '한국어 문제',
                            icon: Icon(Icons.format_strikethrough)),
                      ],
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
                                      height: vertical_size * 0.002,
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
                        Expanded(
                          child: Container(
                            width: horizontal_size * 0.9,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(240, 242, 242, 242),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black12,
                                      offset: new Offset(3.0, 3.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
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
                                    question['main_word'],
                                    maxFontSize: 30,
                                    minFontSize: 12,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                SizedBox(
                                  height: vertical_size * 0.025,
                                ),
                                InkWell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: horizontal_size * 0.84,
                                      height: vertical_size * 0.065,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: AutoSizeText(
                                          "1.   " + question['wrong_word'][0],
                                          maxFontSize: 30,
                                          minFontSize: 10,
                                          softWrap: true,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (question['correct_number'] == 0) {
                                          correct++;
                                          count++;
                                          global_index++;
                                        } else {
                                          unMemory_words(
                                              snapshot.data[global_index][0]
                                                  .toString(),
                                              snapshot.data[global_index][1]
                                                  .toString(),
                                              snapshot.data[global_index][2]
                                                  .toString(),
                                              snapshot.data[global_index][3]
                                                  .toString(),
                                              snapshot.data[global_index][4]
                                                  .toString());
                                          wrong_hindi_words.add(snapshot
                                              .data[global_index][0]
                                              .toString());
                                          wrong_korean_words.add(snapshot
                                              .data[global_index][2]
                                              .toString());
                                          incorrect++;
                                          count++;
                                          global_index++;
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                InkWell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: horizontal_size * 0.84,
                                      height: vertical_size * 0.065,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: AutoSizeText(
                                          "2.   " + question['wrong_word'][1],
                                          maxFontSize: 30,
                                          minFontSize: 10,
                                          softWrap: true,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (question['correct_number'] == 1) {
                                          correct++;
                                          count++;
                                          global_index++;
                                        } else {
                                          unMemory_words(
                                              snapshot.data[global_index][0]
                                                  .toString(),
                                              snapshot.data[global_index][1]
                                                  .toString(),
                                              snapshot.data[global_index][2]
                                                  .toString(),
                                              snapshot.data[global_index][3]
                                                  .toString(),
                                              snapshot.data[global_index][4]
                                                  .toString());
                                          wrong_hindi_words.add(snapshot
                                              .data[global_index][0]
                                              .toString());
                                          wrong_korean_words.add(snapshot
                                              .data[global_index][2]
                                              .toString());
                                          incorrect++;
                                          count++;
                                          global_index++;
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                InkWell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: horizontal_size * 0.84,
                                      height: vertical_size * 0.065,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: AutoSizeText(
                                          "3.   " + question['wrong_word'][2],
                                          maxFontSize: 30,
                                          minFontSize: 10,
                                          softWrap: true,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (question['correct_number'] == 2) {
                                          correct++;
                                          count++;
                                          global_index++;
                                        } else {
                                          unMemory_words(
                                              snapshot.data[global_index][0]
                                                  .toString(),
                                              snapshot.data[global_index][1]
                                                  .toString(),
                                              snapshot.data[global_index][2]
                                                  .toString(),
                                              snapshot.data[global_index][3]
                                                  .toString(),
                                              snapshot.data[global_index][4]
                                                  .toString());
                                          wrong_hindi_words.add(snapshot
                                              .data[global_index][0]
                                              .toString());
                                          wrong_korean_words.add(snapshot
                                              .data[global_index][2]
                                              .toString());
                                          incorrect++;
                                          count++;
                                          global_index++;
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: horizontal_size * 0.84,
                                    height: vertical_size * 0.065,
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
                                        "4.   " + question['wrong_word'][3],
                                        maxFontSize: 30,
                                        minFontSize: 10,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (question['correct_number'] == 3) {
                                        correct++;
                                        count++;
                                        global_index++;
                                      } else {
                                        unMemory_words(
                                            snapshot.data[global_index][0]
                                                .toString(),
                                            snapshot.data[global_index][1]
                                                .toString(),
                                            snapshot.data[global_index][2]
                                                .toString(),
                                            snapshot.data[global_index][3]
                                                .toString(),
                                            snapshot.data[global_index][4]
                                                .toString());
                                        wrong_hindi_words.add(snapshot
                                            .data[global_index][0]
                                            .toString());
                                        wrong_korean_words.add(snapshot
                                            .data[global_index][2]
                                            .toString());
                                        incorrect++;
                                        count++;
                                        global_index++;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
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
