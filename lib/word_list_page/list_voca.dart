import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:hindivocabulary/main.dart';

class word_list_voca extends StatefulWidget {
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
  word_list_voca(
      {Key key,
      @required this.start_word_num,
      @required this.finish_word_num,
      @required this.page_name,
      @required this.file_name}) {
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);

    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _word_list_vocaState createState() => _word_list_vocaState(
      start_word_num, finish_word_num, page_name, file_name);
}

class _word_list_vocaState extends State<word_list_voca> {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
  int _total_itemcount;

  //힌디어 단어 가리기
  int alpha_hindi = 255;
  int red_hindi = 0;
  int green_hindi = 0;
  int blue_hindi = 0;

  //한국어 뜻 가리기
  int alpha_korean = 255;
  int red_korean = 0;
  int green_korean = 0;
  int blue_korean = 0;

  //폰트 사이즈 조절
  double font_size_hindi = 22;
  double font_size_korean = 13;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  _word_list_vocaState(int start_word_num, int finish_word_num,
      String page_name, String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_word_num, finish_word_num, file_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  //BottomNavigationBar
  int _selectedIndex = 0;
  bool _selectedcheck_hindi = false;
  bool _selectedcheck_korean = false;

  //모든 예시 보기, 보지 않기

  bool zoom_in_example = false;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);

    // TODO: implement build
    return WillPopScope(
        child: new FutureBuilder(
            future:
                make_word_list(_start_word_num, _finish_word_num, file_name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
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
                          //목차로 이동하기
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
                      backgroundColor: Colors.white,
                      selectedFontSize: 13,
                      iconSize: 18,
                      unselectedFontSize: 12,
                      unselectedItemColor: Colors.black.withOpacity(.50),
                      selectedItemColor: Colors.black,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                          if (_selectedIndex == 0)
                            _selectedcheck_hindi = !_selectedcheck_hindi;
                          if (_selectedIndex == 1)
                            _selectedcheck_korean = !_selectedcheck_korean;

                          if (_selectedcheck_hindi == true && index == 0) {
                            alpha_hindi = 255;
                            blue_hindi = 0;
                            red_hindi = 0;
                            green_hindi = 0;
                            alpha_korean = 255;
                            blue_korean = 0;
                            red_korean = 0;
                            green_korean = 0;
                          } else if (_selectedcheck_hindi == false &&
                              index == 0) {
                            alpha_hindi = 0;
                            blue_hindi = 255;
                            red_hindi = 255;
                            green_hindi = 255;
                            alpha_korean = 255;
                            blue_korean = 0;
                            red_korean = 0;
                            green_korean = 0;
                          } else if (_selectedcheck_korean == true &&
                              index == 1) {
                            alpha_hindi = 255;
                            blue_hindi = 0;
                            red_hindi = 0;
                            green_hindi = 0;
                            alpha_korean = 255;
                            blue_korean = 0;
                            red_korean = 0;
                            green_korean = 0;
                          } else if (_selectedcheck_korean == false &&
                              index == 1) {
                            alpha_hindi = 255;
                            blue_hindi = 0;
                            red_hindi = 0;
                            green_hindi = 0;
                            alpha_korean = 0;
                            blue_korean = 255;
                            red_korean = 255;
                            green_korean = 255;
                          } else if (index == 2) {
                            if (font_size_hindi <= 25) {
                              font_size_hindi += 0.5;
                            } else if (font_size_korean <= 20)
                              font_size_korean += 0.5;
                          } else if (index == 3) {
                            if (font_size_korean > 10)
                              font_size_korean -= 0.5;
                            else if (font_size_hindi > 15)
                              font_size_hindi -= 0.5;
                          }
                        });
                      },
                      items: [
                        BottomNavigationBarItem(
                            label: '단어 가림',
                            icon: Icon(
                              Icons.format_clear,
                            )),
                        BottomNavigationBarItem(
                            label: '의미 가림',
                            icon: Icon(Icons.format_strikethrough)),
                        BottomNavigationBarItem(
                            label: "단어 크게", icon: Icon(Icons.format_size)),
                        BottomNavigationBarItem(
                            label: "단어 작게", icon: Icon(Icons.text_fields))
                      ],
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
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.1, horizontal: 0.8),
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.17,
                                    actions: <Widget>[
                                      IconSlideAction(
                                        caption: '저장',
                                        color: Color.fromARGB(200, 0, 0, 139),
                                        icon: Icons.archive,
                                        onTap: () => setState(() {
                                          unMemory_words(
                                              snapshot.data[index][0]
                                                  .toString(),
                                              snapshot.data[index][1]
                                                  .toString(),
                                              snapshot.data[index][2]
                                                  .toString(),
                                              snapshot.data[index][3]
                                                  .toString(),
                                              snapshot.data[index][4]
                                                  .toString());

                                          var snackbar = SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                                "미암기 단어장에 해당 단어가 추가되었습니다."),
                                            action: SnackBarAction(
                                              label: "확인",
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackbar);
                                        }),
                                      ),
                                    ],
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      //margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
                                      child: ExpansionTile(
                                        expandedAlignment: Alignment.centerLeft,
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        initiallyExpanded: false,
                                        maintainState: false,
                                        backgroundColor: Colors.white54,
                                        title: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 0.8),
                                          child: AutoSizeText(
                                            snapshot.data[index][0],
                                            style: TextStyle(
                                              fontSize: font_size_hindi,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  alpha_hindi,
                                                  red_hindi,
                                                  green_hindi,
                                                  blue_hindi),
                                            ),
                                            minFontSize: 15,
                                            maxLines: 3,
                                          ),
                                        ),
                                        subtitle: AutoSizeText(
                                          snapshot.data[index][2],
                                          style: TextStyle(
                                            fontSize: font_size_korean,
                                            fontWeight: FontWeight.w100,
                                            color: Color.fromARGB(
                                                alpha_korean,
                                                red_korean,
                                                green_korean,
                                                blue_korean),
                                          ),
                                          maxLines: 3,
                                          minFontSize: 10,
                                        ),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 16),
                                            child: AutoSizeText(
                                              snapshot.data[index][1],
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300),
                                              maxLines: 1,
                                              minFontSize: 8,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 6),
                                            child: AutoSizeText(
                                              snapshot.data[index][3],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              minFontSize: 15,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                16, 5, 16, 10),
                                            child: AutoSizeText(
                                              snapshot.data[index][4],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w100),
                                              maxLines: 3,
                                              minFontSize: 13,
                                            ),
                                          ),
                                        ],
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
                              itemCount: snapshot.data.length),
                        ),
                      ],
                    ),
                  ),
                ));
              } else {
                return Text('Data 로딩 실패');
              }
            }),
        onWillPop: () async => false);
  }
}
