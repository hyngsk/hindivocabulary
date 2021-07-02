import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/word_list_page/sentenceTest.dart';
import 'package:hindivocabulary/function/unmemory_list.dart';
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
  _loading(String chapter_sentence) async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    setState(() {
      if ((wordlist.getString('current_sentence_chapter')) == null) {
        (wordlist.setString('current_sentence_chapter', 'A0 part1 (1-30)'));


      }
      else{
        (wordlist.setString('current_sentence_chapter',chapter_sentence));
      }

    });
  }

  //해당 챕터를 진행했는지 아니면 아직 진행하지 않았는지 구분하는 함수. 2이면 해당 챕터 공부했음, null이면 아직 안 함.
  //진행한 챕터를 2로 표시한 이유는 단어 학습에서 이미 진행한 것을 1로 표시하였기 때문. 둘다 1로 표시하면 캐쉬 정보가 공유되어
  //같이 퍼센트가 올라가는 상황이 도래됨.
  _completed_chapter_sentence_distinguish(String chapter) async{
    SharedPreferences completed_sentences_chapter = await SharedPreferences.getInstance();
    setState(() {
      completed_sentences_chapter.setInt(chapter, 2);
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
                loadingAnimation(loading, vertical_size*0.01, horizontal_size),

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
                              setState(() {
                                _completed_chapter_sentence_distinguish(wordlist[index]);
                                _loading(wordlist[index]);
                                loading = true;
                              });
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

Widget loadingAnimation(bool loading,double vertical_size, double horizontal_size)
{
  if(loading)
  {
    return LinearProgressIndicator();
  }
  else{
    return Divider(
      color: Colors.white,
      height: vertical_size,

    );
  }
}
