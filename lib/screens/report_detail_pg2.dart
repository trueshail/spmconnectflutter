import 'package:flutter/material.dart';
import 'package:spmconnectapp/models/tasks.dart';
import 'package:spmconnectapp/utils/database_helper.dart';

class ReportDetail2 extends StatefulWidget {
  final String appBarTitle;
  final Tasks task;
  final String reportno;

  ReportDetail2(this.task, this.appBarTitle,this.reportno);
  @override
  State<StatefulWidget> createState() {
    return _ReportDetail2(this.task, this.appBarTitle,this.reportno);
  }
}

class _ReportDetail2 extends State<ReportDetail2> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  String reportno;
  Tasks task;

  FocusNode timeFocusNode;
  FocusNode wrkperfrmFocusNode;
  FocusNode hoursFocusNode;

  @override
  void initState() {
    super.initState();
    timeFocusNode = FocusNode();
    wrkperfrmFocusNode = FocusNode();
    hoursFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    timeFocusNode.dispose();
    wrkperfrmFocusNode.dispose();
    hoursFocusNode.dispose();

    super.dispose();
  }

  TextEditingController itemController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController workperfrmController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  _ReportDetail2(this.task, this.appBarTitle,this.reportno);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    itemController.text = task.item;
    timeController.text = task.time;
    workperfrmController.text = task.workperformed;
    hoursController.text = task.hours;

    return Scaffold(
       appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {                
                _save(reportno);
              },
            ),
          ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // First Element - Item Number
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                autofocus: true,
                controller: itemController,
                style: textStyle,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(timeFocusNode),
                onChanged: (value) {
                  debugPrint('Something changed in Item Text Field');
                  updateItem();
                },
                decoration: InputDecoration(
                    labelText: 'Item No.',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Second Element - Time
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: timeController,
                style: textStyle,
                focusNode: timeFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(wrkperfrmFocusNode),
                onChanged: (value) {
                  debugPrint('Something changed in Time Text Field');
                  updateTime();
                },
                decoration: InputDecoration(
                    labelText: 'Time',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Third Element - Work Performed
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: workperfrmController,
                style: textStyle,
                focusNode: wrkperfrmFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(hoursFocusNode),
                onChanged: (value) {
                  debugPrint('Something changed in Work Performed Text Field');
                  updateWorkperformed();
                },
                decoration: InputDecoration(
                    labelText: 'Work Performed',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            //Fourth Element - Hours
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: hoursController,
                style: textStyle,
                focusNode: hoursFocusNode,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  debugPrint('Something changed in Hours Text Field');
                  updateHours();
                },
                decoration: InputDecoration(
                    labelText: 'Hours',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

          ],
        ),
      ),
    );
  }

   void movetolastscreen() {
    Navigator.pop(context,true);
  }

   void _save(String reportno) async {

    movetolastscreen();
    task.projectno = reportno;
    int result;
    if (task.id != null) {
      // Case 1: Update operation
      result = await helper.updateTask(task);
    } else {
      // Case 2: Insert Operation
      result = await helper.inserTask(task);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('SPM Connect', 'Task Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('SPM Connect', 'Problem Saving Task');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

// Update the project no.
  void updateItem() {
    task.item = itemController.text;
  }

  // Update the customer namme of Note object
  void updateTime() {
    task.time = timeController.text;
  }

  // Update the plant location namme of Note object
  void updateWorkperformed() {
    task.workperformed = workperfrmController.text;
  }

  // Update the customer namme of Note object
  void updateHours() {
    task.hours = hoursController.text;
  }

}
