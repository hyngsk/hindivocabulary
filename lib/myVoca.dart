import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';

class myVoca extends StatefulWidget {

  //미암기 단어들 모음
  List<Map<String, String>> my_Voca_list;

  //생성자 , 첫 번째 범위, 두 번째, 세 번째 단원을 나누는 범위
  myVoca(List<Map<String, String>> my_Voca_list) {
    this.my_Voca_list = my_Voca_list;


  }

  @override
  _myVocaState createState() => _myVocaState(my_Voca_list);
}

class _myVocaState extends State<myVoca> {
  //미암기 단어 리스트
  List<Map<String, String>> my_Voca_list;


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

  _myVocaState(List<Map<String, String>> my_Voca_list) {
    this.my_Voca_list = my_Voca_list;
  }
  //
  // List<Map<String, String>> make_unoverlapped_list(List<Map<String, String>>overlapped_list)
  // {
  //   List<Map<String, String>>unoverlapped_list;
  //
  //   for(Map<String,String>v in overlapped_list)
  //   {
  //     if(!overlapped_list.contains(v))
  //       unoverlapped_list.add(v);
  //   }
  //   return unoverlapped_list;
  // }


  //BottomNavigationBar
  int _selectedIndex = 0;
  bool _selectedcheck_hindi = false;
  bool _selectedcheck_korean = false;

  //모든 예시 보기, 보지 않기

  bool zoom_in_example = false;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);




    // TODO: implement build
    return new Builder(builder: (BuildContext context) {
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
        bottomNavigationBar: Container(
          // height: vertical_size * 0.07,
          // width: horizontal_size,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            backgroundColor: Colors.white,
            selectedFontSize: 15,
            iconSize: 20,
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
                } else if (_selectedcheck_hindi == false && index == 0) {
                  alpha_hindi = 0;
                  blue_hindi = 255;
                  red_hindi = 255;
                  green_hindi = 255;
                  alpha_korean = 255;
                  blue_korean = 0;
                  red_korean = 0;
                  green_korean = 0;
                } else if (_selectedcheck_korean == true && index == 1) {
                  alpha_hindi = 255;
                  blue_hindi = 0;
                  red_hindi = 0;
                  green_hindi = 0;
                  alpha_korean = 255;
                  blue_korean = 0;
                  red_korean = 0;
                  green_korean = 0;
                } else if (_selectedcheck_korean == false && index == 1) {
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
                  } else if (font_size_korean <= 20) font_size_korean += 0.5;
                } else if (index == 3) {
                  if (font_size_korean > 10)
                    font_size_korean -= 0.5;
                  else if (font_size_hindi > 15) font_size_hindi -= 0.5;
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
                  label: '의미 가림', icon: Icon(Icons.format_strikethrough)),
              BottomNavigationBarItem(
                  label: "단어 크게", icon: Icon(Icons.format_size)),
              BottomNavigationBarItem(
                  label: "단어 작게", icon: Icon(Icons.text_fields))
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: horizontal_size,
                height: vertical_size * 0.06,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                      child: Text(
                        '미암기 단어',
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

                        "단어 수: " + unMemory_words.list.length.toString() + "개",
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
                              caption: '삭제',
                              color: Colors.red,
                              icon: Icons.archive,
                              onTap: () => setState(() {
                                var snackbar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("해당 단어는 삭제되었습니다."),
                                  action: SnackBarAction(
                                    label: "확인",
                                    onPressed: () {},
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
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
                                  my_Voca_list[index]['힌디어'],
                                  style: TextStyle(
                                    fontSize: font_size_hindi,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(alpha_hindi,
                                        red_hindi, green_hindi, blue_hindi),
                                  ),
                                  minFontSize: 15,
                                  maxLines: 3,
                                ),
                              ),
                              subtitle: AutoSizeText(
                                my_Voca_list[index]['품사'],
                                style: TextStyle(
                                  fontSize: font_size_korean,
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromARGB(alpha_korean,
                                      red_korean, green_korean, blue_korean),
                                ),
                                maxLines: 3,
                                minFontSize: 10,
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  child: AutoSizeText(
                                    my_Voca_list[index]['의미'],
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
                                    my_Voca_list[index]['힌디어 예시'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 3,
                                    minFontSize: 15,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(16, 5, 16, 10),
                                  child: AutoSizeText(
                                    my_Voca_list[index]['한국어 예시'],
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
                    itemCount: unMemory_words.list.length),
              ),
            ],
          ),
        ),
      ));
    });
  }
}
