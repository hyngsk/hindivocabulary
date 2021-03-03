import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'package:hindivocabulary/introductionScreen.dart';

class setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          ListTile(
            leading: Text('일반'),
          ),
          ListTile(
            leading: Icon(Icons.photo_filter),
            title: Text('듀토리얼'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context).push(

                CupertinoPageRoute(
                    builder: (BuildContext context) => onboardingpage()),

              );
            }
            //Share.share(text:'한국외국어대학교 힌디어 단어장', subject:'학과 중간 기말, 졸업 시험, 인증 시험 모두 여기서!'),
          ),

          ListTile(
            leading: Icon(Icons.home),
            title: Text('홈페이지'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              var url = 'http://cfl.ac.kr/index.do';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('정보'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '앱 정보',
                '▶ 앱 기획 및 제작자\n한국외국어대학교 인도학과 15학번 구태훈\n\n▶ 아이콘 및 배너 디자인 총괄 담당\n (UI Design)\n Park SoJiung, 구태훈\n\n▶ 앱 소유권\n 한국외국어대학교 특수외국어진흥원(CFL)  ',
                15),
          ),
          ListTile(
            leading: Text('문의하기'),
          ),
          ListTile(
            leading: Icon(Icons.add_comment),
            title: Text('업데이트 관련 문의하기'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '앱 건의사항',
                '이 앱을 사용해주셔서 감사합니다. 어플 발전에 있어 좋은 아이디어가 있으시면 ku28411@daum.net으로 보내주시면 감사하겠습니다.',
                16),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('수업 관련 문의하기'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              var url =
                  'http://cfl.ac.kr/cop/bbs/selectBoardList.do?bbsId=BBSMSTR_000000000003&menuId=MNU_0000000000000030';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer_sharp),
            title: Text('FAQ'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => faqList()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 설정부분 알림창 관련 함수
void alert(BuildContext context, String info_title, String info_text,
    double font_size) {
  showDialog(context: context,builder: (context){
    Future.delayed(Duration(seconds: 10),(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyApp()));
    });
    return AlertDialog(
      title: Text(info_title),
      content: Text(
        info_text,
        overflow: TextOverflow.visible,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'hufsfontLight',
          fontSize: font_size,
          wordSpacing: 1.1,
          height: 1.5,
          fontWeight: FontWeight.normal,
          textBaseline: TextBaseline.alphabetic,
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
               Navigator.pop(context);
            },
            child: Text("확인")),
      ],
    );
  });


}

//FAQ 질문들
class faqList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
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
                body: ListView(
                  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        title: Text('나의 단어 복습은 무엇인가요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '나의 단어 복습',
                            '이 기능은 단어장에서 저장한 단어 혹은 테스트에서 틀린 단어를 모아둔 단어입니다. 암기가 완료된 단어는 삭제할 수 있습니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('나의 문장 복습은 무엇인가요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '나의 문장 복습',
                            '이 기능은 문장 학습에서 저장한 문장을 모아둔 기능입니다. 문장 학습과 같이 특정 문장을 퀴즈를 볼 수 있습니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('학과 단어는 언제 출시되나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '학과 단어',
                            '학과 단어는 한국외국어대학교 인도학과, 인도어과에서 사용한 교재에 있는 단어들을 참조하여 만들 예정입니다. 책에 나온 단어들을 외워 학교 시험에 도움을 주는 것에 초점을 맞추어 제작 예정입니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('문장 학습에서 문제는 어떤 근거로 만들었나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '문장 학습',
                            '문장 학습에서 틀린 문장은 CFLPT 단어 부분을 참고했습니다. 해당 문장은 CFLPT 단어장에 해당하는 예시 문장을 근거로 제작되었습니다',
                            14),
                      ),
                      ListTile(
                        title: Text('왜 안드로이드 사용자는 뒤로가기 버튼을 사용하지 못하나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '뒤로가기 버튼',
                            '암기 중에 학습을 중지하는 것을 최대한 방지하기 위해 이 버튼 사용을 제한하였습니다. 또한 이를 제외한 다른 페이지에서 뒤로가기 버튼을 사용할시 제작자가 의도한 부분으로 이동할 수 있게 제작했습니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('한 단원당 단어의 갯수를 정한 기준이 있었나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '단원당 단어 수',
                            '한 파트당 단어 40개를 기준으로 하고 있습니다. 이 앱의 목적 중 하나가 출퇴근 시간등 남는 시간을 이용하여 단어 암기를 하는 것을 목표로 두고 있습니다. 따라서 10~15분 동안 한 단원을 볼 수 있게 만들었습니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('단어장 보는 방식을 도중에 바꾸었는데 나만의 단어장에 저장될까요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '임시 저장',
                            '도중에 단어 암기 혹은 테스트를 정지해도 나만의 단어, 문장에 저장이 됩니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('단어장 글자 폰트는 무엇으로 작성되었나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '글자 폰트',
                            '한국어 폰트는 한국 외대 폰트를 사용하였습니다. 또한 힌디어는 가장 대중적으로 사용되는 폰트를 사용하였습니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('학과 단어는 어떤 책을 참고했나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '참고 도서',
                            '▶초급, 중급 힌디어 문법\n초급 힌디어 문법, 중급 힌디어 문법\t최종찬,김용정 지음. Huine 출판\n\n'
                                '▶FLEX 힌디어\nFLEX UP 힌디어\t김우조,김용정 지음. HUINE 출판\n\n'
                                '▶힌디어 표준교제 A0,A1\t한국외국어대학교 인도어과, 인도학과 지음. 한국외국어대학교 지식출판콘테츠원 출판\n\n'
                                '▶힌디어 표준교체 A2,B0,B1,B2(출판 예정)\t한국외국어대학교 인도어과, 인도학과 지음. 한국외국어대학교 지식출판콘테츠원 출판',
                            13),
                        //▶초급 힌디어 강독\n'
                        //                                 '힌디어 첫걸음\t김우조,이동원 지음. HUINE 출판\n\n
                      ),
                      ListTile(
                        title: Text('앱 여기서 오류가 생겨요. 어떻게하면 좋죠?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '앱 오류 보고',
                            '앱 오류 신고는 ku28411@daum.net으로 보내주시면 감사하겠습니다. 검토 후 다음 업데이트에 반영하도록 하겠습니다.',
                            14),
                      ),
                      ListTile(
                        title: Text('업데이트는 어떻게 진행되나요?'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => alert(
                            context,
                            '수정 사항',
                            '업데이트는 앱에 문제가 있을 시, 새로운 단어 리스트가 추가될 시, CFL에서 진행하는 행사 및 공지사항 변경이 있을 때 업데이트가 이루어집니다. 주로 CFL 공지사항 수정을 위해 업데이트가 이루어집니다.',
                            14),
                      ),

                    ],
                  ).toList(),
                ))),
        onWillPop: () async => false);
  }
}
