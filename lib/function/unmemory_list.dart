import 'dart:collection';
import 'package:hindivocabulary/main_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';


bool loading =false;
//안 외워진 단어 저장하는 리스트
class unMemory_words {
  String words;
  String word_class;
  String mean;
  String example_hindi;
  String example_korean;
  int count =0;
  Map<String, String> _saved_word_list;
  SharedPreferences wordlist;

  unMemory_words(String words, String word_class, String mean,
      String example_hindi, String example_korean) {
    this.words = words;
    this.word_class = word_class;
    this.mean = mean;
    this.example_hindi = example_hindi;
    this.example_korean = example_korean;
    this.count++;

    change_mylist_to_eternity_word(this.count, this.words, this.word_class, this.mean, this.example_hindi, this.example_korean);

  }
  void change_mylist_to_eternity_word(int count,String word,String word_class,String mean,String example_hindi,String example_korean) async

  {
    wordlist.setString("w_word"+count.toString(), word);
    wordlist.setString("w_word_class"+count.toString(), word_class);
    wordlist.setString("w_mean"+count.toString(), mean);
    wordlist.setString("w_example_hindi"+count.toString(), example_hindi);
    wordlist.setString('w_example_korean'+count.toString(), example_korean);
    wordlist.setInt('count_word', count);
  }


}



//안 외워진 단어 저장하는 리스트
class unMemory_sentence {
  String words;
  String word_class;
  String mean;
  String example_hindi;
  String example_korean;
  String example_wrong_korean;
  String right;
  int count;
  Map<String, String> _saved_word_list;
  SharedPreferences sentencelist;

  unMemory_sentence(String words, String word_class, String mean,
      String example_hindi, String example_korean,String example_wrong_korean,String right) {
    this.words = words;
    this.word_class = word_class;
    this.mean = mean;
    this.example_hindi = example_hindi;
    this.example_korean = example_korean;
    this.example_wrong_korean = example_wrong_korean;
    this.right = right;
    this.count++;

    change_mylist_to_eternity_sentence(this.count, this.words, this.word_class, this.mean, this.example_hindi, this.example_korean,
        this.example_wrong_korean, this.right);
  }
  void change_mylist_to_eternity_sentence(int count,String word,String word_class,String mean,
      String example_hindi,String example_korean,String example_wrong_korean,String right) async

  {
    sentencelist.setInt("count_sentence", count);
    sentencelist.setString("s_word"+count.toString(), word);
    sentencelist.setString("s_word_class"+count.toString(), word_class);
    sentencelist.setString("s_mean"+count.toString(), mean);
    sentencelist.setString("s_example_hindi"+count.toString(), example_hindi);
    sentencelist.setString('s_example_korean'+count.toString(), example_korean);
    sentencelist.setString("s_example_wrong_korean"+count.toString(),example_wrong_korean);
    sentencelist.setString("s_right"+count.toString(), right);

  }
}
//안 외워진 단어 저장하는 리스트
class temp_unMemory_words {
  String words;

  String mean;

  Map<String, String> _saved_word_list;

  List<Map<String, String>> temp_list = new List<Map<String, String>>();

  temp_unMemory_words(
    String words,
    String mean,
  ) {
    this.words = words;

    this.mean = mean;

    _saved_word_list = {
      '힌디어': this.words,
      '의미': this.mean,
    };
    temp_list.add(_saved_word_list);

  }
}

// //리스트형 안 외워지는 단어를 set형으로 변환시키는 함수
// Set convertList(List<Map<String, String>> list)
// {
//   HashSet<Map<String,String>> setList =new HashSet();
//
//   for(int i =0; i<list.length; i++)
//     {
//       setList.add(list[i]);
//     }
//   for(HashSet i in setList['힌디'])
//     {
//       print(i);
//     }
//   return setList;어
// }
