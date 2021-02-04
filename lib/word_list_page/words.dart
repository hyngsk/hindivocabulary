import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

Future<List<dynamic>> make_word_list(int start_index, int finish_index, String words_level) async {
  ByteData data_A0 = await rootBundle.load(words_level);
  var bytes =
      data_A0.buffer.asUint8List(data_A0.offsetInBytes, data_A0.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  List<dynamic> word_list = [];
      //List<dynamic>.generate(finish_index - start_index + 1, (int index) => []);

  List<dynamic> all_row = excel.tables['Sheet1'].rows;

  for(int i =start_index-1; i<=finish_index-1; i++){
    word_list.add(all_row[i]);
  }

  return word_list;
  return all_row;

}
