
import 'package:shared_preferences/shared_preferences.dart';

// 프로그램이 종료되어도 남아있는 데이터 모음

class mainMemory{
  //instancememory는 초기 시작 때 튜토리얼을 확인했는지 확인하기 위한 변수이다.
  SharedPreferences _instancememory;
  //show one time은 만약 튜토리얼 확인을 했으면 안 보이게 결정할 수 있는 변수이다.
  bool show_one_time;

  mainMemory()
  {
    _makeInstance();


  }
  //_makeInstance는 튜토리얼 관련 인스턴스 생성 및 default면 show one time을 true로 놓아 처음 이 앱을 쓴다는 것을 확인
  _makeInstance() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    this._instancememory = await SharedPreferences.getInstance();
    this.show_one_time = (_instancememory.getBool('first_experience') ?? true);


  }
  //튜토리얼을 봤는지 확인하는 함수
  void setBool() async{
    this._instancememory.setBool('first_experience', false);
  }



}

class mainMemoryWord{
  SharedPreferences _wordmemory;
  String key_name;
  String value_name;


  mainMemoryWord(String key_name,String value_name){
    this._wordmemory=_savedWord();
    this.key_name = key_name;
    this.value_name = value_name;
  }
  _savedWord() async{
    await SharedPreferences.getInstance();
  }

  savedWord (String key_name,String value_name)async{
    _wordmemory.setString(key_name, value_name);
  }
}


class mainMemorySentence{
  SharedPreferences _sentencememory;

  mainMemorySentence(){
    _savedWord();
  }
  _savedWord() async{
    this._sentencememory = await SharedPreferences.getInstance();
  }
}
