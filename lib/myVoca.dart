import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:shared_preferences/shared_preferences.dart';

class myVoca extends StatefulWidget {
  @override
  _myVocaState createState() => _myVocaState();
}

class _myVocaState extends State<myVoca> {
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

  int count_num = 0;
  SharedPreferences wordlist;

  _myVocaState() {
    _loading();
    _extractString();
  }

  _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    setState(() {
      if ((wordlist.getInt('count_num')) == null) {
        (wordlist.setInt('count_num', 0));

        this.count_num = (wordlist.getInt('count_num'));
      }
      this.count_num = (wordlist.getInt('count_num') ?? 0);
    });
  }

  List<String> word = [];
  List<String> word_class = [];
  List<String> word_mean = [];
  List<String> word_example_hindi = [];
  List<String> word_example_korean = [];

  _extractString() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    int index;

    setState(() {
      index = wordlist.getInt('count_num');
    });

    if (index != 0) {
      for (int i = 1; i < index + (1); i++) {
        setState(() {
          String temp;
          temp = wordlist.getString("w_word" + (i.toString()));

          this.word.add(temp);

          this
              .word_class
              .add(wordlist.getString("w_word_class" + (i.toString())));

          this.word_mean.add(wordlist.getString("w_mean" + (i.toString())));

          this
              .word_example_hindi
              .add(wordlist.getString("w_example_hindi" + (i.toString())));

          this
              .word_example_korean
              .add(wordlist.getString("w_example_korean" + (i.toString())));
        });
      }
    }
  }

  //해당 단어 리스트와 데이터 베이스에 저장된 인덱스 모두 삭제하기
  _removeString(int find_index) async {
    int count;
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    count = wordlist.getInt('count_num');
    for (int i = 1; i < count + 1; i++) {
      if (this
              .word[find_index]
              .compareTo(wordlist.getString('w_word' + (i.toString()))) ==
          0) {
        wordlist.remove('w_word' + (i.toString()));
        this.word.removeAt(find_index);
      }

      if (this
              .word_class[find_index]
              .compareTo(wordlist.getString('w_word_class' + (i.toString()))) ==
          0) {
        wordlist.remove('w_word_class' + (i.toString()));
        this.word_class.removeAt(find_index);
      }
      if (this
              .word_mean[find_index]
              .compareTo(wordlist.getString('w_mean' + (i.toString()))) ==
          0) {
        wordlist.remove('w_mean' + (i.toString()));
        this.word_mean.removeAt(find_index);
      }
      if (this.word_example_hindi[find_index].compareTo(
              wordlist.getString('w_example_hindi' + (i.toString()))) ==
          0) {
        wordlist.remove('w_example_hindi' + (i.toString()));
        this.word_example_hindi.removeAt(find_index);
      }
      if (this.word_example_korean[find_index].compareTo(
              wordlist.getString('w_example_korean' + (i.toString()))) ==
          0) {
        wordlist.remove('w_example_korean' + (i.toString()));
        this.word_example_korean.removeAt(find_index);
      }
    }
    count--;
    wordlist.setInt('count_num', count);
    this.count_num = count;

    String next_word = '';
    String next_word_class = '';
    String next_word_mean = '';
    String next_word_example_hindi = '';
    String next_word_example_korean = '';
    for (int i = find_index + 1; i < count + 1; i++) {
      next_word = wordlist.getString('w_word' + ((i + 1).toString()));
      next_word_class =
          wordlist.getString('w_word_class' + ((i + 1).toString()));
      next_word_mean = wordlist.getString('w_mean' + ((i + 1).toString()));
      next_word_example_hindi =
          wordlist.getString('w_example_hindi' + ((i + 1).toString()));
      next_word_example_korean =
          wordlist.getString('w_example_korean' + ((i + 1).toString()));

      wordlist.setString('w_word' + (i.toString()), next_word);
      this.word[i] = next_word;
      wordlist.setString('w_word_class' + (i.toString()), next_word_class);
      this.word_class[i] = next_word_class;
      wordlist.setString('w_mean' + (i.toString()), next_word_mean);
      this.word_mean[i] = next_word_mean;
      wordlist.setString(
          'w_example_hindi' + (i.toString()), next_word_example_hindi);
      this.word_example_hindi[i] = next_word_example_hindi;
      wordlist.setString(
          'w_example_korean' + (i.toString()), next_word_example_korean);
      this.word_example_korean[i] = next_word_example_korean;
    }
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
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);

    if (this.count_num == 0) {
      {
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
                "저장된 복습 단어가 없습니다.\n단어 학습 후 나의 단어장을 확인하세요.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black26,
                    fontSize: 20),
              )),
        ));
      }
    } else {
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
                          "단어 수: " + count_num.toString() + "개",
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
                                  _removeString(index);

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
                                    word[index],
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
                                  word_class[index],
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
                                      word_mean[index],
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
                                      word_example_hindi[index],
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
                                      word_example_korean[index],
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
                      itemCount: count_num),
                ),
              ],
            ),
          ),
        ));
      });
    }
  }
}
