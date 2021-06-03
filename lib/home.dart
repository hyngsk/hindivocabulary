import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {
  @override
  _mainfunction createState() => _mainfunction();
}

class _mainfunction extends State<home> {
  //메인 화면 팜플렛, 책 주소 및 파일

  //총 단어 수
  int total_word;
  //총 문장 수
  int total_sentence;

  //미암기 단어 수
  int rememorize_word;
  //미암기 문장 수
  int rememorize_sentence;
  //현재 학습 중인 문장 파트
  String this_part_word = '';
  String this_part_sentence = '';

  final List<Map> images = [
    {
      'id': 0,
      'image': 'pictures/informed_pictures/hindi_songfestival_first.jpg',
    },
    {
      'id': 1,
      'image': 'pictures/informed_pictures/hindi_songfestival_second.jpg',
    },
    {
      'id': 2,
      'image': 'pictures/informed_pictures/hindi_songfestival_third.jpg',
    },
    {
      'id': 3,
      'image': 'pictures/informed_pictures/hindi_verb_book_picture.png',
    },
  ];

  PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _loading();
  }

  _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    setState(() {
      if ((wordlist.getInt('count_num')) == null) {
        (wordlist.setInt('count_num', 0));

        this.rememorize_word = (wordlist.getInt('count_num'));
      } else {
        this.rememorize_word = (wordlist.getInt('count_num') ?? 0);
      }
      if ((wordlist.getInt('count_num_sen')) == null) {
        (wordlist.setInt('count_num_sen', 0));

        this.rememorize_sentence = (wordlist.getInt('count_num_sen'));
      } else {
        this.rememorize_sentence = (wordlist.getInt('count_num_sen') ?? 0);
      }
      if ((wordlist.getString('current_word_chapter')) == null) {
        (wordlist.setString('current_word_chapter', 'A0 part1 (1-30)'));

        this.this_part_word = (wordlist.getString('current_word_chapter'));
      } else {
        this.this_part_word = (wordlist.getString('current_word_chapter'));
      }
      if ((wordlist.getString('current_sentence_chapter')) == null) {
        (wordlist.setString('current_sentence_chapter', 'A0 part1 (1-30)'));

        this.this_part_sentence =
            (wordlist.getString('current_sentence_chapter'));
      } else {
        this.this_part_sentence =
            (wordlist.getString('current_sentence_chapter'));
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //공지사항 문장 글자 스타일
  var announcement_text_style = TextStyle(
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    fontFamily: 'hufsfontLight',
    fontSize: 12.0,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    //화면별 넓이 비율 자동 조절 변수
    var horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);

    return Scaffold(
        body: Container(
      width: horizontal_size,
      height: vertical_size,
      child: ListView(
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  width: horizontal_size,
                  height: vertical_size * 0.4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black87),
                  ),
                  child: Image.asset(
                    'pictures/home_background.jpg',
                    fit: BoxFit.fill,
                    height: vertical_size * 0.4,
                    width: horizontal_size,
                  ),
                ),
                Container(
                  width: horizontal_size,
                  height: vertical_size * 0.4,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        width: horizontal_size,
                        height: vertical_size * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: horizontal_size * 0.6,
                                    height: vertical_size * 0.07,
                                    child: AutoSizeText("최근 진행한 어 챕터"),
                                  ),
                                  Container(
                                    width: horizontal_size * 0.6,
                                    height: vertical_size * 0.13,
                                    child: AutoSizeText(this.this_part_word),
                                  )
                                ],
                              ),
                              width: horizontal_size * 0.6,
                              height: vertical_size * 0.2,
                            ),
                            // Container(
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         width: horizontal_size*0.4,
                            //         height: vertical_size*0.07,
                            //         child: AutoSizeText("평균 점수"),
                            //       ),
                            //       Container(
                            //         width: horizontal_size*0.4,
                            //         height: vertical_size*0.13,
                            //         child: AutoSizeText("평균 점수는 입니다."),
                            //       )
                            //     ],
                            //   ),
                            //   width: horizontal_size*0.4,
                            //   height: vertical_size*0.2,
                            // )
                          ],
                        ),
                      ),
                      Container(
                        width: horizontal_size,
                        height: vertical_size * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: horizontal_size * 0.6,
                                    height: vertical_size * 0.07,
                                    child: AutoSizeText("최근 진행한 문장 챕터"),
                                  ),
                                  Container(
                                    width: horizontal_size * 0.6,
                                    height: vertical_size * 0.13,
                                    child:
                                        AutoSizeText(this.this_part_sentence),
                                  )
                                ],
                              ),
                              width: horizontal_size * 0.6,
                              height: vertical_size * 0.2,
                            ),
                            // Container(
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         width: horizontal_size*0.4,
                            //         height: vertical_size*0.07,
                            //         child: AutoSizeText("평균 점수"),
                            //       ),
                            //       Container(
                            //         width: horizontal_size*0.4,
                            //         height: vertical_size*0.13,
                            //         child: AutoSizeText("평균 점수는 입니다."),
                            //       )
                            //     ],
                            //   ),
                            //   width: horizontal_size*0.4,
                            //   height: vertical_size*0.2,
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: AutoSizeText("복습이 필요한 단어"),
                  subtitle: AutoSizeText(
                      "나의 단어 복습 파트에서 내가 틀린 단어를 볼 수 있습니다.\n완전 암기된 단어들은 옆으로 슬라이드해 삭제 해보세요."),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText("복습 단어 수"),
                            AutoSizeText(
                                (this.rememorize_word.toString() + "개")),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText("복습 문장 수"),
                            AutoSizeText(
                                (this.rememorize_sentence.toString() + "개")),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: AutoSizeText("학습 진도율"),
                  subtitle: AutoSizeText(
                      "총 단어 중에서 한 번이상 본 챕터를 기록합니다.\n학습량을 늘려 100%의 진도율을 완성해 보세요."),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText("복습 단어 수"),
                            AutoSizeText(
                                (this.rememorize_word.toString() + "개")),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText("복습 문장 수"),
                            AutoSizeText(
                                (this.rememorize_sentence.toString() + "개")),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(240, 10, 15, 64),
            Color.fromARGB(240, 108, 121, 240)
          ])),
    ));
  }
}
