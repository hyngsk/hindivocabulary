import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/word_list_page/Test_voca.dart';
import 'package:hindivocabulary/word_list_page/list_voca.dart';
import 'package:hindivocabulary/word_list_page/word_one_by_one_view.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
import '../main.dart';

//단어 외우는 방식 정할 때 나오는 사진, 문자
final List<Map> select_icon_for_word = [
  {'id': 0, 'image': 'pictures/Choice_Voca/List_Voca.jpg', 'title': '단어장'},
  {
    'id': 1,
    'image': 'pictures/Choice_Voca/One_by_one_voca.jpg',
    'title': '하나씩'
  },
  {'id': 2, 'image': 'pictures/Choice_Voca/Test_voca.jpg', 'title': '테스트'},
];

class level_ extends StatefulWidget {
  List<String> wordlist;
  String chapter_list;
  List<List> start_end_num;
  String file_name;

  level_(List<String> wordlist, List<List> start_end_num, String chapter_list,
      String file_name) {
    this.wordlist = wordlist;
    this.chapter_list = chapter_list;
    this.start_end_num = start_end_num;
    this.file_name = file_name;
  }

  @override
  level_State createState() => level_State(
      this.wordlist, this.start_end_num, this.chapter_list, this.file_name);
}

class level_State extends State<level_> {
  String chapter_list;
  List<String> wordlist;
  List<List> start_end_num;
  String file_name;

  level_State(List<String> wordlist, List<List> start_end_num,
      String chapter_list, String file_name) {
    this.chapter_list = chapter_list;
    this.wordlist = wordlist;
    this.start_end_num = start_end_num;
    this.file_name = file_name;
    _loading();
  }

  _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    setState(() {
      if ((wordlist.getString('current_word_chapter')) == null) {
        (wordlist.setString('current_word_chapter', 'A0 part1 (1-30)'));
      } else
        (wordlist.setString('current_word_chapter', this.chapter_list));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loading = false;
  }

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

    //단어장 보여주는 방식 정하는 alertdialog
    void alert(BuildContext context, int start, int end, String page_title,
        String file_name) {
      AlertDialog alert = AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(10),
        )),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        title: Card(
          elevation: 1,
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.indigo,
          child: Container(
            width: horizontal_size * 0.8,
            height: vertical_size * 0.04,
            child: Text(
              '암기 방법 선택',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'hunfsfontBold',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.center,
          ),
        ),
        content: Builder(
          builder: (context) {
            loading = false;
            var horizontal_size = MediaQuery.of(context).size.width -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right;
            var vertical_size = (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom);

            return WillPopScope(
                child: Container(
                  margin: EdgeInsets.all(10),
                  color: Colors.red.withOpacity(0),
                  width: horizontal_size * 0.8,
                  height: vertical_size * 0.2,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          child: Container(
                            width: horizontal_size * 0.23,
                            height: vertical_size * 0.19,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  select_icon_for_word[0]['image'],
                                  width: horizontal_size * 0.2,
                                  height: vertical_size * 0.13,
                                ),
                                Text(
                                  select_icon_for_word[0]['title'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              loading = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new word_list_voca(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                            );
                          }),
                      InkWell(
                          child: Container(
                            width: horizontal_size * 0.23,
                            height: vertical_size * 0.19,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  select_icon_for_word[1]['image'],
                                  width: horizontal_size * 0.2,
                                  height: vertical_size * 0.13,
                                ),
                                Text(
                                  select_icon_for_word[1]['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              loading = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new word_one_by_one_view(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                            );
                          }),
                      InkWell(
                          child: Container(
                            width: horizontal_size * 0.23,
                            height: vertical_size * 0.19,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  select_icon_for_word[2]['image'],
                                  width: horizontal_size * 0.2,
                                  height: vertical_size * 0.13,
                                ),
                                Text(
                                  select_icon_for_word[2]['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              loading = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new TestVoca(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                onWillPop: () async {
                  Navigator.pop(context);
                });
          },
        ),
      );

      showDialog(context: context, builder: (BuildContext context) => alert);
    }

    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                  );
                },
              ),
              shadowColor: Colors.white,
              centerTitle: true,
              backgroundColor: Color.fromARGB(240, 10, 15, 64),
              title: const Text(
                'HUFS 힌디어 학습 도우미',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'hufsfontMedium',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  width: horizontal_size,
                  height: vertical_size * 0.08,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    chapter_list,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: 'hufsfontMedium',
                      height: 3,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                ),
                loadingAnimation(
                    loading, vertical_size * 0.01, horizontal_size),
                Expanded(
                  child: ListView.separated(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      itemBuilder: (BuildContext context, int index) {
                        int this_page_start_num = start_end_num[index][0];
                        int this_page_end_num = start_end_num[index][1];

                        return ListTile(
                          title: Text(wordlist[index]),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () => alert(context, this_page_start_num,
                              this_page_end_num, wordlist[index], file_name),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                            height: 10,
                          ),
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: wordlist.length),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}

Widget loadingAnimation(
    bool loading, double vertical_size, double horizontal_size) {
  if (loading) {
    return LinearProgressIndicator();
  } else {
    return Divider(
      color: Colors.white,
      height: vertical_size,
    );
  }
}
