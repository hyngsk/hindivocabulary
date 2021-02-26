import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/word_list_page/sentenceTest.dart';

import '../main.dart';

class level_Sentence extends StatefulWidget {
  List<String> wordlist;
  String chapter_list;
  List<List> start_end_num;
  String file_name;

  level_Sentence(List<String> wordlist, List<List> start_end_num,
      String chapter_list, String file_name) {
    this.wordlist = wordlist;
    this.chapter_list = chapter_list;
    this.start_end_num = start_end_num;
    this.file_name = file_name;
  }

  @override
  level_SentenceState createState() => level_SentenceState(
      this.wordlist, this.start_end_num, this.chapter_list, this.file_name);
}

class level_SentenceState extends State<level_Sentence> {
  String chapter_list;
  List<String> wordlist;
  List<List> start_end_num;
  String file_name;

  level_SentenceState(List<String> wordlist, List<List> start_end_num,
      String chapter_list, String file_name) {
    this.chapter_list = chapter_list;
    this.wordlist = wordlist;
    this.start_end_num = start_end_num;
    this.file_name = file_name;
  }

  @override
  Widget build(BuildContext context) {
    //화면별 넓이 비율 자동 조절 변수
    var horizontal_size = MediaQuery.of(context).size.width-MediaQuery.of(context).padding.left
        -MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom);

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
                'HUFS 힌디 단어장',
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new sentenceTest(
                                      this_page_start_num,
                                      this_page_end_num,
                                      wordlist[index],
                                      file_name),
                                ),
                              );
                            });
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
