import 'package:flutter/material.dart';

class level_A1 extends StatefulWidget {
  @override
  _level_A1State createState() => _level_A1State();
}

final List<Map> select_icon_for_word = [
  {
    'id': 0,
    'image': 'pictures/etc/elementary_hindi_grammar.png',
    'title': '단어장'
  },
  {'id': 1, 'image': 'pictures/etc/middle_hindi_grammar.png', 'title': '하나씩'},
  {
    'id': 2,
    'image': 'pictures/etc/elementary_hindi_reading.png',
    'title': '테스트'
  },
];

class _level_A1State extends State<level_A1> {
  @override
  Widget build(BuildContext context) {

    void alert(BuildContext context) {
      var alert = AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Card(
          elevation: 1,
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.amber,
          child: Container(
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
            var horizontal_size = MediaQuery.of(context).size.width;
            var vertical_size = MediaQuery.of(context).size.height * 0.12;
            return Container(
              margin: EdgeInsets.only(top: 15),
              color: Colors.red.withOpacity(0),
              width: horizontal_size,
              height: vertical_size,
              padding: EdgeInsets.zero,
              child: GridView.builder(
                itemCount: select_icon_for_word.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.1),
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: new GridTile(
                        footer: new Text(
                          select_icon_for_word[index]['title'],
                          textAlign: TextAlign.center,
                          softWrap: true,
                          textHeightBehavior: TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                          ),
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'hufsfontMedium',
                              letterSpacing: 1.1),
                        ),
                        child: new InkResponse(
                          enableFeedback: true,
                          onTap: () => {
                            Navigator.of(context).pop(),
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => select_icon_for_word[index]),
                            // ),
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: new Image.asset(
                              select_icon_for_word[index]['image'],
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        )),
                  );
                },
              ),
            );
          },
        ),
      );

      showDialog(context: context, builder: (BuildContext context) => alert);
    }

    return SafeArea(
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
                  Navigator.of(context).pop();
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
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text(
                  'CFLPT A0',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    fontFamily: 'hufsfontMedium',
                    height: 3,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
              ),
              ListTile(
                title: Text('part1 (1-30)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part2 (31-60)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part3 (61-100)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part4 (101-140)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part5 (141-180)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part6 (181-220)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part7 (221-260)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part8 (261-300)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part9 (301-340)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part10 (341-380)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part11 (381-420)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part12 (421-460)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part13 (461-500)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part14 (501-540)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part15 (541-580)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part16 (581-620)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part17 (621-660)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part18 (661-700)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
              ListTile(
                title: Text('part19 (701-742)'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => alert(
                  context,
                ),
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
