
import 'package:flutter/material.dart';

class PatientInfo extends StatelessWidget {
  final String PatientName;
  final String Age;
  final String DiseaseName;
  final String type;
  PatientInfo({this.PatientName,this.Age,this.DiseaseName,this.type});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  PatientName
                ),
                Text(
                    Age
                ),
                Text(
                    DiseaseName
                ),
                Text(
                    type
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.edit,color: Colors.green,),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.delete,color: Colors.red,),
            ),
          ],
        ),
      ),
    );
  }
}
