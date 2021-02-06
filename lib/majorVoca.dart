import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindivocabulary/major_wordlist/elementary_hindi_grammar.dart';
import 'package:hindivocabulary/major_wordlist/elementary_hindi_reading.dart';
import 'package:hindivocabulary/major_wordlist/middlelevel_hindi_grammar.dart';
import 'package:hindivocabulary/major_wordlist/middlelevel_hindi_reading.dart';
import 'package:hindivocabulary/major_wordlist/flex_part_four.dart';
import 'package:hindivocabulary/major_wordlist/flex_part_three.dart';
import 'package:hindivocabulary/major_wordlist/flex_part_two.dart';
import 'package:hindivocabulary/major_wordlist/flex_part_one.dart';

class majorVoca extends StatelessWidget {
  @override
  final List<Map> major_icon_images = [
    {
      'id': 0,
      'image': 'pictures/etc/elementary_hindi_grammar.jpg',
      'title': '초급 힌디어 문법'

    },
    {
      'id': 1,
      'image': 'pictures/etc/middle_hindi_grammar.jpg',
      'title': '중급 힌디어 문법'
    },
    {
      'id': 2,
      'image': 'pictures/etc/elementary_hindi_reading.jpg',
      'title': '초급 힌디어 강독'
    },
    {
      'id': 3,
      'image': 'pictures/etc/middle_hindi_reading.jpg',
      'title': '중급 힌디어 강독'
    },
    {'id': 4, 'image': 'pictures/Flex_Logo/number_one.jpg', 'title': 'FLEX Part.1'},
    {'id': 5, 'image': 'pictures/Flex_Logo/number_two.jpg', 'title': 'FLEX Part.2'},
    {'id': 6, 'image': 'pictures/Flex_Logo/number_three.jpg', 'title': 'FLEX Part.3'},
    {'id': 7, 'image': 'pictures/Flex_Logo/number_four.jpg', 'title': 'FLEX Part.4'},
  ];

  List<dynamic>moving_link_list = [elementary_grammar(),middlelevel_grammar(),elmentary_reading(),middlelevel_reading(),flex_one(),flex_two(),flex_three(),flex_four()];

  Widget build(BuildContext context) {
    //화면별 넓이 비율 자동 조절 변수
    var horizontal_size = MediaQuery.of(context).size.width;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(

            width: horizontal_size,
            height: vertical_size * 0.144,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              border: Border.all(width: 0.1, color: Colors.black87),
            ),
            child:
                Image.asset('pictures/etc/major_banner.jpg', fit: BoxFit.fill,height: vertical_size*0.144, width: horizontal_size,
                ),
          ),
          Container(
            width: horizontal_size,
            height: vertical_size *0.75,
            alignment: Alignment.center,
            child: GridView.builder(
              itemCount: major_icon_images.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.1 ),
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                  color:  Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: new GridTile(

                      footer: new Text(major_icon_images[index]['title'],textAlign:TextAlign.center, softWrap:true,textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: true,),style:
                        TextStyle(
                          fontSize: 20,

                          fontFamily: 'hufsfontMedium',
                          letterSpacing: 1.2
                        ),),
                      child: new InkResponse(
                        enableFeedback: true,
                        onTap: () =>{
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => moving_link_list[index]),),
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),

                          child: new Image.asset(major_icon_images[index]['image'],fit: BoxFit.fill,alignment: Alignment.center,width:200,height:250,),

                        ),
                      )
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
