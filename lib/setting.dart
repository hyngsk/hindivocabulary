import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:hindivocabulary/word_list_page/words.dart';

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
            leading: Icon(Icons.share),
            title: Text('공유하기'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Share.share('한국외국어대학교 힌디어 단어장',
                subject: '학과 중간 기말, 졸업 시험, 인증 시험 모두 여기서!',
                ),
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
                '▶ 앱 기획 및 제작자\n한국외국어대학교 인도학과 15학번 구태훈\n\n▶ 단어 총괄 담당\n 한국외국어대학교 인도학과 18학번 김기훈\n\n▶ 아이콘 및 배너 디자인 총괄 담당\n 박소정\n\n▶ 앱 소유권\n 한국외국어대학교 특수외국어진흥원(CFL)  ',
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
  var alert = AlertDialog(
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
            Navigator.of(context).pop();
          },
          child: Text("확인")),
    ],
  );
  showDialog(context: context, builder: (BuildContext context) => alert);
}

//FAQ 질문들
class faqList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            title: Text('기억상자는 무엇인가요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '기억상자',
                '기억상자는 단어장에서 모름 혹은 x로 표시된 단어를 단기적으로 모아둔 단어입니다. 기억상자에서 모르는 단어를 모아서 외운 후 여기서 모르는 단어들은 내 단어 리스트로 이동하게 됩니다.',
                14),
          ),
          ListTile(
            title: Text('내 단어와 기억상자의 차이는 무엇인가요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '내 단어',
                '내 단어는 기억상자에서 못 외운 단어들을 따로 뽑아 외울 수 있도록 만든 기능입니다. 단어 외우는 과정에서 반복이 중요한 만큼 기억 상자를 거쳐 가장 안 외워지는 단어 리스트를 여기서 확인 할 수 있습니다.',
                14),
          ),
          ListTile(
            title: Text('학과 단어랑 시험 단어 차이가 무엇인가요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '시험 단어',
                '학과 단어는 한국외국어대학교 인도학과, 인도어과에서 사용한 교재에 있는 단어들을 참조하여 만들었습니다. 책에 나온 단어들을 외워 학교 시험에 도움을 주는 것에 초점을 맞추어 제작하였습니다.',
                14),
          ),
          ListTile(
            title: Text('단어 내보내기는 무엇인가요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '단어 내보내기',
                '단어 내보내기 기능은 학생들이 원하는 단원을 선택하면 랜덤으로 단어 시험지를 pdf 형식으로 만들어 저장 및 인쇄할 수 있습니다. 핸드폰에 시험지를 저장하여 실제 모의고사 시험지를 만들어 풀어보세요! ',
                14),
          ),
          ListTile(
            title: Text('앱에서 단어 퀴즈를 볼 때 제한 시간 조절 가능한가요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '제한 시간 수정',
                '각 단어당 15초를 기준으로 하고 있습니다. 이는 학교 시험에서 보는 시험의 제한시간을 근거하여 세팅한 숫자입니다. 따라서 임의로 변경은 불가능합니다. 해당 단어장 파트를 단어장이 아닌 테스트 버튼을 누르면 제한시간 안에 문제를 풀 수 있습니다.',
                14),
          ),
          ListTile(
            title: Text('한 단원당 단어의 갯수를 정한 기준이 있었나요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '단원당 단어 수',
                '한 파트당 단어 40개를 기준으로 하고 있습니다. 이 앱의 목적 중 하나가 출퇴근등 자투리 시간을 단어 암기에 이용하는 것입니다. 따라서 10~15분 동안 한 단원을 볼 수 있게 만들었습니다.',
                14),
          ),
          ListTile(
            title: Text('단어장 보는 방식을 도중에 바꾸었는데 기억상자에 저장될까요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '기억상자 저장',
                '단어장을 보는 방식은 리스트 형식, OX 형식 두 가지가 있습니다. 중간에 바꾸셔도 기억상자에는 중복 없이 저장이 됩니다.',
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
            title: Text('이 앱은 초.중 힌디어 강독, 문법 책 중 무엇을 참고했나요?'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '참고 도서',
                '▶초급, 중급 힌디어 문법\n초급 힌디어 문법, 중급 힌디어 문법\t최종찬,김용정 지음. Huine 출판\n\n▶초급 힌디어 강독\n'
                    '힌디어 첫걸음\t김우조,이동원 지음. HUINE 출판\n\n▶FLEX 힌디어\nFLEX UP 힌디어\t김우조,김용정 지음. HUINE 출판\n\n'
                    '▶힌디어 표준교제 A0,A1\t한국외국어대학교 인도어과, 인도학과 지음. 한국외국어대학교 지식출판콘테츠원 출판\n\n'
                    '▶힌디어 표준교체 A2,B0,B1,B2(출판 예정)\t한국외국어대학교 인도어과, 인도학과 지음. 한국외국어대학교 지식출판콘테츠원 출판',
                13),
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
                '업데이트는 앱에 문제가 있을 시, 새로운 단어 리스트가 추가될 시, CFL에서하는 행사 및 공지사항이 수정되리 이루어집니다. 주로 CFL 공지사항 수정을 위해 업데이트가 이루어집니다.',
                14),
          ),
          ListTile(
            title: Text('앱 배경화면을 어둡게 하고 싶어요. 어떻게하면 되나요? '),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(context, '앱 테마 설정',
                '추후 업데이트때 단어장 태마색을 변경할 수 있는 기능을 넣을 예정입니다.', 14),
          ),

        ],
      ).toList(),
    ));
  }
}
