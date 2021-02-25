import 'package:page_turn/page_turn.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/hindiCommonVoca.dart';
import 'package:hindivocabulary/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hindivocabulary/word_list_page/list_voca.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/word_list_page/words.dart';

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
    Key :key;
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

class _SentenceTestState extends State<SentenceTest> {

  final _controller = GlobalKey<PageTurnState>();
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

  //인덱스
  int global_index = 0;


  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수
  int index = 0;
  int count = 1;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  //엑셀파일에서 단어에 관한 자료를 받아서 컨테이너 위젯 형식으로 저장하는 리스
  List<Widget> list_sentence = new List();


  //BottomNavigationBar
  int _selectedIndex = 0;


  //폰트 사이즈 조절
  double font_size_hindi = 22;
  double font_size_korean = 13;



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
  Widget build(BuildContext context) {
    // TODO: implement build
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top);
    return WillPopScope(child: new FutureBuilder(
        future:
        make_word_list(_start_word_num, _finish_word_num, file_name),
        builder: (BuildContext context, AsyncSnapshot snapshot){
    if (snapshot.hasData){
      for(index =0; index<_total_itemcount; index++){
        this.hindi_word = snapshot.data[index][0].toString();
        this.word_case = snapshot.data[index][1].toString();
        this.korean_word = snapshot.data[index][2].toString();
        this.hindi_example = snapshot.data[index][3].toString();
        this.korean_example = snapshot.data[index][4].toString();
        this.korean_wrong_example =
            snapshot.data[index][5].toString();
        this.right_num = snapshot.data[index][6].toString();

        makeSentenceList(list_sentence, vertical_size, horizontal_size,hindi_example,
            korean_example, korean_wrong_example, hindi_word, korean_word, right_num);
      }

    }
    return SafeArea(child: Scaffold(
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
      bottomNavigationBar: SizedBox(
        height: vertical_size * 0.07,
        width: horizontal_size,
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
                if (index == 0) {
                if (font_size_hindi <= 25) {
                  font_size_hindi += 0.5;
                } else if (font_size_korean <= 20)
                  font_size_korean += 0.5;
              } else if (index == 1) {
                if (font_size_korean > 10)
                  font_size_korean -= 0.5;
                else if (font_size_hindi > 15) font_size_hindi -= 0.5;
              }
            });
          },
          items: [

            BottomNavigationBarItem(
                label: "단어 크게", icon: Icon(Icons.format_size)),
            BottomNavigationBarItem(
                label: "단어 작게", icon: Icon(Icons.text_fields))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          _controller.currentState.goToPage(2);
        },
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
        child: PageTurn(
          key: _controller,
          backgroundColor: Colors.white,
          showDragCutoff: false,
          lastPage: Container(child: Center(child: Text('Last Page!'))),
          children: <Widget>[
            for (var i = 0; i < _total_itemcount; i++) list_sentence[i],
          ],
        ),

      ),
    )
    );


    }
    ),
        onWillPop: () async => false);
  }
  List<Widget> makeSentenceList(List<Widget>sentence_list,double vertical_size,
      double horizontal_size,String hindiSentence, String korean_Right_Sentence
      ,String korean_Wrong_Sentence, String hindi_word, String korean_word, String right_num)
  {
    String right='';
    if(right_num.compareTo('1')==0)
      {
        right = 'O';
      }
    else if(right_num.compareTo('0')==0)
      {
        right = 'X';
      }
    else
      {
        right = '문제 오류';
      }
    sentence_list.add(
      Container(
        width: horizontal_size,
        height: vertical_size,
        child: Column(

          children: [
            //단원 이름, 문제
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
            SizedBox(height: vertical_size*0.02),
            Container(
              alignment: Alignment.center,
              height: vertical_size*0.7,
        width: horizontal_size*0.8,
        decoration: BoxDecoration(
        color: Colors.indigo,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(10.0, 10.0),
                  blurRadius: 20.0,
                  spreadRadius: 10.0)
            ]),
              child: Column(
                children: [
                  SizedBox(height: vertical_size*0.002),
                  //예문 부분
                  Container(

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                  width: horizontal_size*0.78,
                    height: vertical_size*0.05,
                    child: AutoSizeText("Q: 한국어로 해석된 문장이 맞는 문장인가요?",minFontSize: 15,maxLines: 2,
                    maxFontSize: 20,style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),),

                  ),
                  //힌디어 지문
                  Container(
                    alignment: Alignment.center,
                    width: horizontal_size*0.8,
                    height: vertical_size*0.1,
                    child: AutoSizeText(hindiSentence, minFontSize: 20, maxFontSize: 35,maxLines: 3,
                    style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                  ),

                  //문제 부분
                  Container(
                    alignment: Alignment.center,
                    width: horizontal_size*0.8,
                    height: vertical_size*0.1,
                    child: AutoSizeText(korean_Wrong_Sentence,minFontSize: 20, maxFontSize: 30,maxLines: 3,
                      style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(height: vertical_size*0.003,color: Colors.white,),
                      Container(decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        width: horizontal_size*0.12,
                        height: horizontal_size*0.06,
                        child: Container(alignment: Alignment.center,
                            child: AutoSizeText("문장",style: TextStyle(color:Colors.black),),)
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: horizontal_size*0.8,
                      height: vertical_size*0.4,

                      child: AutoSizeText("Tap Here", style: TextStyle(fontSize:40,fontWeight:FontWeight.bold,
                          color: Colors.black12),
                      maxFontSize: 50,minFontSize: 35,),
                    ),
                    onTap: (){


                        rightAnswer(horizontal_size, vertical_size,right, korean_Right_Sentence, hindi_word, korean_word);

                    },
                  ),
                  //정답

                ],
              ),
            ),

          ],
        ),
      )
    );
  }
Widget rightAnswer(double horizontal_size, double vertical_size,String right,String korean_Right_Sentence,
    String hindi_word,String korean_word)
{
  return Container(
    child: Column(
      children: [
        SizedBox(height: vertical_size*0.05,),
        Container(
          alignment: Alignment.center,
          width: horizontal_size*0.8,
          height: vertical_size*0.05,
          child: AutoSizeText("정답:"+ right,minFontSize: 15, maxFontSize: 30,maxLines: 3,
            style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
        ),
        //한국어 정답
        Container(
          padding: EdgeInsets.symmetric(horizontal: horizontal_size*0.01),
          alignment: Alignment.center,
          width: horizontal_size*0.8,
          height: vertical_size*0.1,
          child: AutoSizeText(korean_Right_Sentence,minFontSize: 15, maxFontSize: 30,maxLines: 3,
            style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),

        ),
        //힌디어 단어
        Container(
          alignment: Alignment.center,
          width: horizontal_size*0.8,
          height: vertical_size*0.07,
          child: AutoSizeText(hindi_word,minFontSize: 15, maxFontSize: 20,maxLines: 3,
            style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
        ),
        //한국어 뜻
        Container(
          padding: EdgeInsets.symmetric(horizontal: horizontal_size*0.01),
          alignment: Alignment.center,
          width: horizontal_size*0.8,
          height: vertical_size*0.07,
          child: AutoSizeText(korean_word,minFontSize: 15, maxFontSize: 20,maxLines: 3,
            style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
        )
      ],
    ),
  );
}
}