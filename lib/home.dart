import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';


class home extends StatefulWidget {
  @override
  _mainfunction createState() => _mainfunction();
}

class _mainfunction extends State<home> {
  //메인 화면 팜플렛, 책 주소 및 파일
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
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top);

    // var tapbar_height = (TabBar().preferredSize.height);
    print("전체 높이:"+MediaQuery.of(context).size.height.toString());
    print("앱바 높이:"+AppBar().preferredSize.height.toString());
    print("패딩 탑 높이:"+MediaQuery.of(context).padding.top.toString());
    print("앱바 높이/전체 높이:"+((AppBar().preferredSize.height)/(MediaQuery.of(context).size.height)).toString());
    //print("탭바 높이:"+ tapbar_height.toString());
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //배너 부분 컨테이너
          Container(
            height: vertical_size* 0.5,
            width: horizontal_size,
            margin: EdgeInsets.symmetric(horizontal: 0.1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.white60),
            ),
            child: PageView.builder(
              controller: pageController,
              pageSnapping: true,
              physics: BouncingScrollPhysics(),
              onPageChanged: (selectedPage) {
                setState(() {
                  currentPage = selectedPage;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, position) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'),
                      image: AssetImage(images[position]['image']),
                      fit: BoxFit.scaleDown,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: vertical_size*0.01,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: images.map((image) {
                            return GestureDetector(
                              onTap: () {
                                currentPage = image['id'];
                                pageController.jumpToPage(currentPage);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: currentPage == image['id'] ? 16 : 10,
                                height: currentPage == image['id'] ? 16 : 10,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(
                                        currentPage == image['id'] ? 8 : 5),
                                    color: Colors.white60),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          //배너, 공지사항 부분 구분자
          Divider(
            color: Colors.black54,
            height: vertical_size*0.01,
          ),

          //***공지사항 컨테이너***
          Expanded(child: Container(
            width: horizontal_size,
            //height: vertical_size * 0.39,

            //padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(width: 1, color: Colors.black12),
              color: Colors.grey[200],
            ),
            child:
            Column(
              children: [
                Container(
                  margin:EdgeInsets.only(top: vertical_size*0.007),
                  padding: EdgeInsets.fromLTRB(horizontal_size*0.01, 0,0,0),
                  width: horizontal_size,
                  height: vertical_size*0.04,
                  child:RichText(
                    softWrap: true,
                    text: TextSpan(
                      text: '공지사항',

                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontFamily: 'hufsfontMedium',
                        fontSize: 25.0,
                        color: Colors.black,

                      ),
                    ),
                  ),
                ),
                Expanded(child: Container(
                  width: horizontal_size,
                  height: vertical_size*0.34,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: horizontal_size*0.7,
                        height: vertical_size*0.33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            SizedBox(height: vertical_size*0.03),
                            SizedBox(
                              width: horizontal_size*0.7,
                              height: vertical_size*0.032,
                              child: RichText(
                                text: TextSpan(
                                  text: '▶ 특수외국어 기초교재 및 사전 이용 안내',
                                  style: announcement_text_style,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          'http://cfl.ac.kr/cop/bbs/selectBoardArticle.do?nttNo=634&pageIndex=1&menuId=MNU_0000000000000024&bbsId=BBSMSTR_000000000001';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                ),
                              ),
                            ),

                            SizedBox(height: vertical_size*0.005),
                            SizedBox(
                              width: horizontal_size*0.7,
                              height: vertical_size*0.032,
                              child: RichText(
                                text: TextSpan(
                                  text: '▶ CFLPT 모의테스트 시행 안내',
                                  style: announcement_text_style,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          'http://cfl.ac.kr/cop/bbs/selectBoardArticle.do?nttNo=581&pageIndex=1&menuId=MNU_0000000000000024&bbsId=BBSMSTR_000000000001';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                ),
                              ),),

                            SizedBox(height: vertical_size*0.005),
                            SizedBox(

                              width: horizontal_size*0.7,
                              height: vertical_size*0.032,
                              child: RichText(

                                text: TextSpan(
                                  text: '▶ 취업연계 전략시장 취업역량 캠프 안내',
                                  style: announcement_text_style,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          'http://cfl.ac.kr/cop/bbs/selectBoardArticle.do?nttNo=579&pageIndex=1&menuId=MNU_0000000000000024&bbsId=BBSMSTR_000000000001';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                ),
                              ),),

                            SizedBox(height: vertical_size*0.005),
                            SizedBox(
                              width: horizontal_size*0.7,
                              height: vertical_size*0.032,

                              child:RichText(
                                text: TextSpan(
                                  text: '▶ 특수외국어학회 CFLLS 회원모집 공고(수정)',
                                  style: announcement_text_style,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      //URL 수정 부분
                                      var url =
                                          'http://cfl.ac.kr/cop/bbs/selectBoardArticle.do?nttNo=552&pageIndex=1&menuId=MNU_0000000000000024&bbsId=BBSMSTR_000000000001';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                ),
                              ),
                            ),

                            SizedBox(height: vertical_size*0.005),
                            SizedBox(
                              width: horizontal_size*0.7,
                              height: vertical_size*0.032,
                              child: RichText(
                                text: TextSpan(
                                  text: '▶ 제1회 CFLLS 진로 세미나 대학원생편 안내',
                                  style: announcement_text_style,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          'http://cfl.ac.kr/cop/bbs/selectBoardArticle.do?nttNo=545&pageIndex=1&menuId=MNU_0000000000000024&bbsId=BBSMSTR_000000000001';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                ),
                              ),),
                            SizedBox(height: vertical_size*0.005),
                            SizedBox(
                              width: horizontal_size*0.7,
                              height: vertical_size*0.032,
                              child: RichText(
                                text: TextSpan(
                                  text: '▶ CFLLS K-POP 번안 노래부르기 공모전 결과 안내',
                                  style: announcement_text_style,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          'http://cfl.ac.kr/cop/bbs/selectBoardArticle.do?nttNo=535&pageIndex=1&menuId=MNU_0000000000000024&bbsId=BBSMSTR_000000000001';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                ),
                              ),),
                          ],
                        ),
                      ),
                      Container(
                        width: horizontal_size*0.25,
                        height: vertical_size*0.33,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(left: horizontal_size*0.1),
                        //margin: EdgeInsets.only(top: vertical_size*0.035),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //공지사항 게시 날짜 수정란
                            SizedBox(height: vertical_size*0.03),
                            //첫 번째 게시물 날짜
                            SizedBox(
                              width: horizontal_size*0.25,
                              height: vertical_size*0.032,
                              child: AutoSizeText(
                                "20.12.15",
                                maxFontSize: 10,
                                minFontSize: 6,
                                style: announcement_text_style,
                              ),),

                            SizedBox(height: vertical_size*0.005),
                            //두 번째 게시물 날짜
                            SizedBox(
                              width: horizontal_size*0.25,
                              height: vertical_size*0.032,
                              child: AutoSizeText(
                                "20.11.16",
                                maxFontSize: 10,
                                minFontSize: 6,
                                style: announcement_text_style,
                              ),),
                            SizedBox(height: vertical_size*0.005),
                            //세 번째 게시물 날짜
                            SizedBox(
                              width: horizontal_size*0.25,
                              height: vertical_size*0.032,
                              child: AutoSizeText(
                                "20.11.16",
                                maxFontSize: 10,
                                minFontSize: 6,
                                style: announcement_text_style,
                              ),),
                            SizedBox(height: vertical_size*0.005),
                            //네 번째 게시물 날짜
                            SizedBox(
                              width: horizontal_size*0.25,
                              height: vertical_size*0.032,
                              child: AutoSizeText(
                                "20.11.06",
                                maxFontSize: 10,
                                minFontSize: 6,
                                style: announcement_text_style,
                              ),),
                            SizedBox(height: vertical_size*0.005),
                            //다섯 번째 게시물 날짜
                            SizedBox(
                              width: horizontal_size*0.25,
                              height: vertical_size*0.032,
                              child:AutoSizeText(
                                "20.11.04",
                                maxFontSize: 10,
                                minFontSize: 6,
                                style: announcement_text_style,
                              ),),

                            SizedBox(height: vertical_size*0.005),
                            //여섯 번째 게시물 날짜
                            SizedBox(
                              width: horizontal_size*0.25,
                              height: vertical_size*0.032,
                              child: AutoSizeText(
                                "20.10.30",
                                maxFontSize: 10,
                                minFontSize: 6,
                                style: announcement_text_style,
                              ),),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),

          ),),
        ],
      ),
    );
  }
}
