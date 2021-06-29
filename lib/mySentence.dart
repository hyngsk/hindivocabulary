import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hindivocabulary/function/test_result_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class mySentence extends StatefulWidget {
  mySentence() {
    Key:
    key;
  }

  @override
  _mySentenceState createState() => _mySentenceState();
}

class _mySentenceState extends State<mySentence> {
  _mySentenceState() {}

  @override
  Widget build(BuildContext context) {
    return sentence();
  }
}

/// This is the stateful widget that the main application instantiates.
class sentence extends StatefulWidget {
  sentence() {
    Key:
    key;
  }

  @override
  _sentenceState createState() => _sentenceState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _sentenceState extends State<sentence> {
  @override
  void initState() {
    super.initState();
    _loading();
  }

  String hindi_word = '';
  String word_class = '';
  String korean_word = '';
  String hindi_example = '';
  String korean_example = '';
  String korean_wrong_example = '';
  String right_num = '';

  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수
  int index = 0;
  int count = 0;

  //맞은 갯수, 틀린 갯수
  int correct = 0;
  int incorrect = 0;

  Color hint_color = Colors.white;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  SharedPreferences wordlist;

  _sentenceState() {
    _loading();
    _extractString();
  }

  _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();

    setState(() {
      if ((wordlist.getInt('count_num_sen')) == null) {
        (wordlist.setInt('count_num_sen', 0));

        this.count = (wordlist.getInt('count_num_sen'));
      } else {
        this.count = (wordlist.getInt('count_num_sen') ?? 0);
      }
    });
  }

  List<String> sentences = [];
  List<String> sentence_class = [];
  List<String> sentence_mean = [];
  List<String> sentence_example_hindi = [];
  List<String> sentence_example_korean = [];
  List<String> sentence_wrong_example_korean = [];
  List<String> sentence_right = [];

  _extractString() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    int temp_count;

    setState(() {
      temp_count = wordlist.getInt('count_num_sen');
    });

    if (temp_count != 0) {
      for (int i = 1; i < temp_count + 1; i++) {
        setState(() {
          this.sentences.add(wordlist.getString("s_word" + (i.toString())));

          this
              .sentence_class
              .add(wordlist.getString("s_word_class" + (i.toString())));

          this.sentence_mean.add(wordlist.getString("s_mean" + (i.toString())));

          this
              .sentence_example_hindi
              .add(wordlist.getString("s_example_hindi" + (i.toString())));

          this
              .sentence_example_korean
              .add(wordlist.getString("s_example_korean" + (i.toString())));
          this.sentence_wrong_example_korean.add(
              wordlist.getString('s_example_wrong_korean' + (i.toString())));
          this
              .sentence_right
              .add(wordlist.getString('s_right' + (i.toString())));
          print(this
              .sentence_right);
        });
      }
    } else {
      this.count = 0;
    }
  }

  _removesentence(int find_index) async{
    int count_sen;
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    count_sen = wordlist.getInt('count_num_sen');
    for (int i = 1; i < count_sen + 1; i++) {
      if (this
          .sentences[find_index]
          .compareTo(wordlist.getString('s_word' + (i.toString()))) ==
          0) {
        this.sentences.removeAt(find_index);

      }

      if (this
          .sentence_class[find_index]
          .compareTo(wordlist.getString('s_word_class' + (i.toString()))) ==
          0) {
        this.sentence_class.removeAt(find_index);

      }
      if (this
          .sentence_mean[find_index]
          .compareTo(wordlist.getString('s_mean' + (i.toString()))) ==
          0) {
        this.sentence_mean.removeAt(find_index);

      }
      if (this.sentence_example_hindi[find_index].compareTo(
          wordlist.getString('s_example_hindi' + (i.toString()))) ==
          0) {
        this.sentence_example_hindi.removeAt(find_index);

      }
      if (this.sentence_example_korean[find_index].compareTo(
          wordlist.getString('s_example_korean' + (i.toString()))) ==
          0) {
        this.sentence_example_korean.removeAt(find_index);

      }
      if (this.sentence_wrong_example_korean[find_index].compareTo(
          wordlist.getString('s_example_wrong_korean' + (i.toString()))) ==
          0) {
        this.sentence_wrong_example_korean.removeAt(find_index);

      }
      if (this
          .sentence_right[find_index]
          .compareTo(wordlist.getString('s_right' + (i.toString()))) ==
          0) {
        this.sentence_right.removeAt(find_index);

      }
    }
    count_sen--;
    wordlist.setInt('count_num_sen', count_sen);
    this.count = count_sen;
    wordlist.clear();



  }

  //해당 단어 리스트와 데이터 베이스에 저장된 인덱스 모두 삭제하기
  _removeSentence(int find_index) async {
    int count_sen;
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    count_sen = wordlist.getInt('count_num_sen');
    for (int i = 1; i < count_sen + 1; i++) {
      if (this
              .sentences[find_index]
              .compareTo(wordlist.getString('s_word' + (i.toString()))) ==
          0) {
        this.sentences.removeAt(find_index);
        wordlist.remove('s_word' + (i.toString()));
      }

      if (this
              .sentence_class[find_index]
              .compareTo(wordlist.getString('s_word_class' + (i.toString()))) ==
          0) {
        this.sentence_class.removeAt(find_index);
        wordlist.remove('s_word_class' + (i.toString()));
      }
      if (this
              .sentence_mean[find_index]
              .compareTo(wordlist.getString('s_mean' + (i.toString()))) ==
          0) {
        this.sentence_mean.removeAt(find_index);
        wordlist.remove('s_mean' + (i.toString()));
      }
      if (this.sentence_example_hindi[find_index].compareTo(
              wordlist.getString('s_example_hindi' + (i.toString()))) ==
          0) {
        this.sentence_example_hindi.removeAt(find_index);
        wordlist.remove('s_example_hindi' + (i.toString()));
      }
      if (this.sentence_example_korean[find_index].compareTo(
              wordlist.getString('s_example_korean' + (i.toString()))) ==
          0) {
        this.sentence_example_korean.removeAt(find_index);
        wordlist.remove('s_example_korean' + (i.toString()));
      }
      if (this.sentence_wrong_example_korean[find_index].compareTo(
              wordlist.getString('s_example_wrong_korean' + (i.toString()))) ==
          0) {
        this.sentence_wrong_example_korean.removeAt(find_index);
        wordlist.remove('s_example_wrong_korean' + (i.toString()));
      }
      if (this
              .sentence_right[find_index]
              .compareTo(wordlist.getString('s_right' + (i.toString()))) ==
          0) {
        this.sentence_right.removeAt(find_index);
        wordlist.remove('s_right' + (i.toString()));
      }
    }
    count_sen--;
    wordlist.setInt('count_num_sen', count_sen);
    this.count = count_sen;

    String next_sentence = '';
    String next_sentence_class = '';
    String next_sentence_mean = '';
    String next_sentence_example_hindi = '';
    String next_sentence_example_korean = '';
    String next_sentence_example_wrong_korean = '';
    String next_sentence_right = '';
    for (int i = find_index; i < count_sen + 1; i++) {
      next_sentence = wordlist.getString('s_word' + ((i + 1).toString()));

      next_sentence_class =
          wordlist.getString('s_word_class' + ((i + 1).toString()));
      next_sentence_mean = wordlist.getString('s_mean' + ((i + 1).toString()));
      next_sentence_example_hindi =
          wordlist.getString('s_example_hindi' + ((i + 1).toString()));
      next_sentence_example_korean =
          wordlist.getString('s_example_korean' + ((i + 1).toString()));
      next_sentence_example_wrong_korean =
          wordlist.getString('s_example_wrong_korean' + ((i + 1).toString()));
      next_sentence_right =
          wordlist.getString('s_right' + ((i + 1).toString()));

      wordlist.setString('s_word' + (i.toString()), next_sentence);
      this.sentences[i] = next_sentence;
      wordlist.setString('s_word_class' + (i.toString()), next_sentence_class);
      this.sentence_class[i] = next_sentence_class;
      wordlist.setString('s_mean' + (i.toString()), next_sentence_mean);
      this.sentence_mean[i] = next_sentence_mean;
      wordlist.setString(
          's_example_hindi' + (i.toString()), next_sentence_example_hindi);
      this.sentence_example_hindi[i] = next_sentence_example_hindi;
      wordlist.setString(
          's_example_korean' + (i.toString()), next_sentence_example_korean);
      this.sentence_example_korean[i] = next_sentence_example_korean;
      wordlist.setString('s_example_wrong_korean' + (i.toString()),
          next_sentence_example_wrong_korean);
      this.sentence_wrong_example_korean[i] =
          next_sentence_example_wrong_korean;
      wordlist.setString('s_right' + (i.toString()), next_sentence_right);
      this.sentence_right[i] = next_sentence_right;
    }
  }

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top);
    return WillPopScope(
        child: Builder(
          builder: (context) {
            if (this.count != 0) {
              if (index == 0 && this.count == 1) {
                this.hindi_word = this.sentences[index];
                this.word_class = this.sentence_class[index];
                this.korean_word = this.sentence_mean[index];
                this.hindi_example = this.sentence_example_hindi[index];
                this.korean_example = this.sentence_example_korean[index];
                this.korean_wrong_example =
                    this.sentence_wrong_example_korean[index];
                this.right_num = this.sentence_right[index];
              } else {
                try {
                  if (index < this.count) {
                    this.hindi_word = sentences[index];
                    this.word_class = sentence_class[index];
                    this.korean_word = sentence_mean[index];
                    this.hindi_example = sentence_example_hindi[index];
                    this.korean_example = sentence_example_korean[index];
                    this.korean_wrong_example =
                        sentence_wrong_example_korean[index];
                    this.right_num = sentence_right[index];
                  } else {
                    move_page(context, "재복습 추천 문장", this.count, this.correct,
                        wrong_hindi_words, wrong_korean_words);
                  }
                } on Exception catch (_) {
                  move_page(context, "재복습 추천 문장", this.count, this.correct,
                      wrong_hindi_words, wrong_korean_words);
                }
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
                                    "진행: " +
                                        index.toString() +
                                        "/" +
                                        this.count.toString(),
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
                        SizedBox(
                          height: vertical_size * 0.03,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: vertical_size * 0.7,
                          width: horizontal_size * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
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
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: horizontal_size * 0.02),
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    "Question" +
                                        (index + 1).toString() +
                                        ".\n아래 문장은 올바른 문장입니까?",
                                    minFontSize: 10,
                                    maxFontSize: 20,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38),
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontal_size * 0.01),
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.15,
                                child: AutoSizeText(hindi_example,
                                    minFontSize: 20,
                                    maxFontSize: 30,
                                    style: TextStyle(fontSize: 25)),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontal_size * 0.01),
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.15,
                                child: AutoSizeText(korean_wrong_example,
                                    minFontSize: 15,
                                    maxFontSize: 25,
                                    style: TextStyle(fontSize: 20)),
                              ),

                              DottedLine(
                                lineLength: horizontal_size * 0.895,
                                direction: Axis.horizontal,
                                dashColor: Colors.indigo,
                              ),
                              SizedBox(
                                height: vertical_size * 0.02,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.1,
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: horizontal_size * 0.2,
                                      height: vertical_size * 0.1,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: horizontal_size * 0.02),
                                      child: OutlineButton(
                                        onPressed: () {
                                          setState(() {
                                            hint_color = Colors.black;
                                          });
                                          //HintDialog(context,hindi_word,korean_word);
                                        },
                                        hoverColor: Colors.black12,
                                        child: AutoSizeText(
                                          "힌트",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: horizontal_size * 0.5,
                                      height: vertical_size * 0.1,
                                      alignment: Alignment.topCenter,
                                      child: AutoSizeText(
                                        this.hindi_word +
                                            "의 뜻은 " +
                                            this.korean_word +
                                            " 입니다.",
                                        minFontSize: 10,
                                        maxFontSize: 20,
                                        style: TextStyle(
                                            fontSize: 15, color: hint_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: vertical_size * 0.15,
                                        child: Icon(
                                          Icons.panorama_fish_eye,
                                          size: 50,
                                        ),
                                      ),
                                      onTap: () {
                                        if (count == index) {
                                          move_page(
                                              context,
                                              "재복습 추천 단어",
                                              this.count,
                                              this.correct,
                                              this.wrong_hindi_words,
                                              this.wrong_korean_words);
                                        }
                                        setState(() {
                                          hint_color = Colors.white;
                                          if (this.right_num.compareTo('1') ==
                                              0) {
                                            _removeSentence(index);
                                            index++;
                                            correct++;
                                          } else {
                                            wrong_hindi_words.add(hindi_word);
                                            wrong_korean_words.add(korean_word);

                                            index++;

                                            incorrect++;
                                          }
                                        });
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        height: vertical_size * 0.15,
                                        child: Icon(
                                          Icons.clear,
                                          size: 50,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (count == index) {
                                            move_page(
                                                context,
                                                "재복습 추천 문장",
                                                this.count,
                                                this.correct,
                                                this.wrong_hindi_words,
                                                this.wrong_korean_words);
                                          }

                                          hint_color = Colors.white;

                                          if (right_num.compareTo('0') == 0) {
                                            _removeSentence(index);
                                            index++;
                                            correct++;
                                          } else {
                                            wrong_hindi_words.add(hindi_word);
                                            wrong_korean_words.add(korean_word);

                                            index++;
                                            incorrect++;
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
                    ),
                  ),
                ),
              );
            } else {
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
                body: Container(
                    width: horizontal_size,
                    height: vertical_size,
                    alignment: Alignment.center,
                    color: Colors.white70,
                    child: Text(
                      "저장된 복습 문장이 없습니다.\n문장 학습 후 복습 문장을 확인하세요.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black26,
                          fontSize: 20),
                    )),
              ));
            }
          },
        ),
        onWillPop: () async => false);
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
}
