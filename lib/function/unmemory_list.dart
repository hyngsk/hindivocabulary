import 'package:shared_preferences/shared_preferences.dart';

bool loading = false;

//안 외워진 단어 저장하는 리스트
class unMemory_words {
  String words;
  String word_class;
  String mean;
  String example_hindi;
  String example_korean;

  Map<String, String> _saved_word_list;

  @override
  void initState() {
    _loading();
  }

  unMemory_words(String words, String word_class, String mean,
      String example_hindi, String example_korean) {
    this.words = words;
    this.word_class = word_class;
    this.mean = mean;
    this.example_hindi = example_hindi;
    this.example_korean = example_korean;

    change_mylist_to_eternity_word(this.words, this.word_class, this.mean,
        this.example_hindi, this.example_korean);
  }

  void _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
  }

  void change_mylist_to_eternity_word(String word, String word_class,
      String mean, String example_hindi, String example_korean) async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    int count;

    if ((wordlist.getInt('count_num') ?? 0) == 0) {
      (wordlist.setInt('count_num', 1));

      count = (wordlist.getInt('count_num'));
    } else {
      count = (wordlist.getInt('count_num'));
      count = count + 1;
      wordlist.setInt('count_num', count);
    }

    wordlist.setString("w_word" + (count.toString()), word);
    wordlist.setString("w_word_class" + (count.toString()), word_class);
    wordlist.setString("w_mean" + (count.toString()), mean);
    wordlist.setString("w_example_hindi" + (count.toString()), example_hindi);
    wordlist.setString('w_example_korean' + (count.toString()), example_korean);
  }
}

//안 외워진 문 저장하는 리스트
class unMemory_sentence {
  String words;
  String word_class;
  String mean;
  String example_hindi;
  String example_korean;
  String example_wrong_korean;
  String right;

  @override
  void initState() {
    _loading();
  }

  unMemory_sentence(
      String words,
      String word_class,
      String mean,
      String example_hindi,
      String example_korean,
      String example_wrong_korean,
      String right) {
    this.words = words;
    this.word_class = word_class;
    this.mean = mean;
    this.example_hindi = example_hindi;
    this.example_korean = example_korean;
    this.example_wrong_korean = example_wrong_korean;
    this.right = right;

    change_mylist_to_eternity_word(
        this.words,
        this.word_class,
        this.mean,
        this.example_hindi,
        this.example_korean,
        this.example_wrong_korean,
        this.right);
  }

  void _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
  }

  void change_mylist_to_eternity_word(
      String word,
      String word_class,
      String mean,
      String example_hindi,
      String example_korean,
      String example_wrong_korean,
      String right) async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    int count;

    if ((wordlist.getInt('count_num_sen') ?? 0) == 0) {
      (wordlist.setInt('count_num_sen', 1));

      count = (wordlist.getInt('count_num_sen'));
    } else {
      count = (wordlist.getInt('count_num_sen'));
      count = count + 1;
      wordlist.setInt('count_num_sen', count);
    }

    wordlist.setString("s_word" + (count.toString()), word);
    wordlist.setString("s_word_class" + (count.toString()), word_class);
    wordlist.setString("s_mean" + (count.toString()), mean);
    wordlist.setString("s_example_hindi" + (count.toString()), example_hindi);
    wordlist.setString('s_example_korean' + (count.toString()), example_korean);
    wordlist.setString(
        's_example_wrong_korean' + (count.toString()), example_wrong_korean);
    wordlist.setString('s_right' + (count.toString()), right);
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
