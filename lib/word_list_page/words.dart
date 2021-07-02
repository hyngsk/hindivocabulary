import 'package:excel/excel.dart';

import 'package:flutter/services.dart' show ByteData, rootBundle;

Future<List<dynamic>> make_word_list(
    int start_index, int finish_index, String words_level) async {

  ByteData data;

  if(words_level.compareTo('assets/A0.xlsx')==0)
    {
          data = await rootBundle.load('assets/A0.xlsx');

    }
  else if(words_level.compareTo('assets/A1.xlsx')==0)
    {
      if(start_index>=1 && finish_index<=90)
        {
          data = await rootBundle.load('assets/A1_1.xlsx');
        }
      else if(start_index>=91 && finish_index<=180)
        {
          data = await rootBundle.load('assets/A1_2.xlsx');
        }
      else if(start_index>=181 && finish_index<=270)
      {
        data = await rootBundle.load('assets/A1_3.xlsx');
      }
      else if(start_index>=271 && finish_index<=360)
      {
        data = await rootBundle.load('assets/A1_4.xlsx');
      }
      else if(start_index>=361 && finish_index<=450)
      {
        data = await rootBundle.load('assets/A1_5.xlsx');
      }
      else if(start_index>=451 && finish_index<=540)
      {
        data = await rootBundle.load('assets/A1_6.xlsx');
      }
      else if(start_index>=541 && finish_index<=630)
      {
        data = await rootBundle.load('assets/A1_7.xlsx');
      }
      else
      {
        data = await rootBundle.load('assets/A1_8.xlsx');
      }
    }
  else if(words_level.compareTo('assets/A2.xlsx')==0){
    if(start_index>=1 && finish_index<=90)
    {
      data = await rootBundle.load('assets/A2_1.xlsx');
    }
    else if(start_index>=91 && finish_index<=180)
    {
      data = await rootBundle.load('assets/A2_2.xlsx');
    }
    else if(start_index>=181 && finish_index<=270)
    {
      data = await rootBundle.load('assets/A2_3.xlsx');
    }
    else if(start_index>=271 && finish_index<=360)
    {
      data = await rootBundle.load('assets/A2_4.xlsx');
    }
    else if(start_index>=361 && finish_index<=450)
    {
      data = await rootBundle.load('assets/A2_5.xlsx');
    }
    else if(start_index>=451 && finish_index<=540)
    {
      data = await rootBundle.load('assets/A2_6.xlsx');
    }
    else if(start_index>=541 && finish_index<=630)
    {
      data = await rootBundle.load('assets/A2_7.xlsx');
    }
    else if(start_index>=631 && finish_index<=720)
    {
      data = await rootBundle.load('assets/A2_8.xlsx');
    }
    else if(start_index>=721 && finish_index<=810)
    {
      data = await rootBundle.load('assets/A2_9.xlsx');
    }
    else
    {
      data = await rootBundle.load('assets/A2_10.xlsx');
    }

  }
  else if(words_level.compareTo('assets/B1.xlsx')==0){
    if(start_index>=1 && finish_index<=90)
    {
      data = await rootBundle.load('assets/B1_1.xlsx');
    }
    else if(start_index>=91 && finish_index<=180)
    {
      data = await rootBundle.load('assets/B1_2.xlsx');
    }
    else if(start_index>=181 && finish_index<=270)
    {
      data = await rootBundle.load('assets/B1_3.xlsx');
    }
    else if(start_index>=271 && finish_index<=360)
    {
      data = await rootBundle.load('assets/B1_4.xlsx');
    }
    else if(start_index>=361 && finish_index<=450)
    {
      data = await rootBundle.load('assets/B1_5.xlsx');
    }
    else if(start_index>=451 && finish_index<=540)
    {
      data = await rootBundle.load('assets/B1_6.xlsx');
    }
    else if(start_index>=541 && finish_index<=630)
    {
      data = await rootBundle.load('assets/B1_7.xlsx');
    }
    else if(start_index>=631 && finish_index<=720)
    {
      data = await rootBundle.load('assets/B1_8.xlsx');
    }
    else if(start_index>=721 && finish_index<=810)
    {
      data = await rootBundle.load('assets/B1_9.xlsx');
    }
    else if(start_index>=811 && finish_index<=900)
    {
      data = await rootBundle.load('assets/B1_10.xlsx');
    }
    else if(start_index>=901 && finish_index<=990)
    {
      data = await rootBundle.load('assets/B1_11.xlsx');
    }
    else if(start_index>=991 && finish_index<=1080)
    {
      data = await rootBundle.load('assets/B1_12.xlsx');
    }
    else{
      data = await rootBundle.load('assets/B1_13.xlsx');
    }

  }


  var bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  List<dynamic> word_list = [];
  //List<dynamic>.generate(finish_index - start_index + 1, (int index) => []);

  List<dynamic> all_row = excel.tables['Sheet1'].rows;

  for(int i =0; i<finish_index-start_index+1; i++){
    word_list.add(all_row[i]);
  }

  return word_list;

}

