import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatelessWidget{
  late TextEditingController dateinput;

  DateInput({required this.dateinput});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          TextField(
            controller: dateinput,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Wprowadź datę"
            ),
            //readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101)
              );

              if(pickedDate != null ){
                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

              }else{
                print("Date is not selected");
              }
            }
          ),
        ],
      ),
    );
  }

}