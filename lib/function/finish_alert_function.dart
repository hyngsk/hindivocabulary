import 'package:flutter/material.dart';
import 'package:hindivocabulary/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:hindivocabulary/word_list_page/words.dart';
import 'package:hindivocabulary/clfpt_wordlist/word_list_view.dart';
import 'package:hindivocabulary/main.dart';

void alert_backto_lobi(BuildContext context, String file_name) async {
  var alert = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "알림",
            style: TextStyle(
                fontSize: 20, letterSpacing: 2, fontFamily: 'hufsfontMedium'),
          ),
          content: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(45)),
            ),
            child: Text(
              "이번 챕터의 모든 단어를 열람했습니다.\n목차로 이동할까요?",
              softWrap: true,
              style: TextStyle(
                  height: 1.5, fontSize: 15, fontFamily: 'hufsfontLight'),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                alert_backto_list(context);
              },
              child: Text("아니오"),
            ),
            FlatButton(
                onPressed: () {
                  if (file_name == 'assets/A0.xlsx') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => level_(A0_word_list_page,
                            A0_word_list_scale, 'A0 단어장', 'assets/A0.xlsx'),
                      ),
                    );
                  } else if (file_name == 'assets/A1.xlsx') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => level_(A1_word_list_page,
                            A1_word_list_scale, 'A1 단어장', 'assets/A1.xlsx'),
                      ),
                    );
                  } else if (file_name == 'assets/A2.xlsx') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => level_(A2_word_list_page,
                            A2_word_list_scale, 'A2 단어장', 'assets/A2.xlsx'),
                      ),
                    );
                  } else if (file_name == 'assets/B1.xlsx') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => level_(B1_word_list_page,
                            B1_word_list_scale, 'B1 단어장', 'assets/B1.xlsx'),
                      ),
                    );
                  } else if (file_name == 'assets/B2.xlsx') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => level_(B1_word_list_page,
                            B1_word_list_scale, 'B1 단어장', 'assets/B1.xlsx'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  }
                },
                child: Text("예")),
          ],
        );
      });
}

void alert_backto_list(BuildContext context) async {
  var alert = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "이동",
            style: TextStyle(
                fontSize: 20, letterSpacing: 2, fontFamily: 'hufsfontMedium'),
          ),
          content: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(45)),
            ),
            child: Text(
              "그럼 메인 메뉴로 이동할까요?",
              softWrap: true,
              style: TextStyle(
                  height: 1.5, fontSize: 15, fontFamily: 'hufsfontLight'),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("아니오"),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (route) => false);
                },
                child: Text("예")),
          ],
        );
      });
}
