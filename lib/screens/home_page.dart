import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/app_const/color_const.dart';
import 'package:todo_firebase/models/todo_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MediaQueryData? mqData;

  List<TodoModel> mList = [];

  TextEditingController titleController = TextEditingController();

  TextEditingController DateController = TextEditingController();

  TextEditingController PriorityController = TextEditingController();

  DateTime? selectedDate;
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Task Tracker",
              style: TextStyle(
                  fontFamily: 'AppBar',
                  color: ColorConst().mColor[0],
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              "assets/icons/todo_ic.png",
              width: 40,
            )
          ],
        ),
        centerTitle: true,
      ),
      body: mList.isNotEmpty
          ? ListView.builder(
              itemCount: mList.length,
              itemBuilder: (_, index) {
                return SizedBox(
                  height: mqData!.size.height * 0.13,
                  child: Card(
                    child: CheckboxListTile(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                );
              })
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Todo's Yet..",
                    style: TextStyle(
                        fontFamily: 'AppBar',
                        fontWeight: FontWeight.bold,
                        color: ColorConst().mColor[0],
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConst().mColor[0],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        showModalBottomSheet(
                            context: (context),
                            builder: (_) {
                              return _bottomSheetContent(context: context);
                            });
                      },
                      child: Text(
                        "Add Now",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        splashColor: ColorConst().mColor[0],
        hoverColor: ColorConst().mColor[0],
        backgroundColor: ColorConst().mColor[0],
        elevation: 10,
        onPressed: () {
          showModalBottomSheet(
              context: (context),
              builder: (_) {
                return _bottomSheetContent(context: context);
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _bottomSheetContent({required BuildContext context}) {
    return Container(
      height: mqData!.size.height * 0.5,
      width: mqData!.size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Column(
          children: [
            Text(
              "Add Your Task",
              style: TextStyle(
                  fontFamily: 'AppBar',
                  color: ColorConst().mColor[0],
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: mqData!.size.height * 0.4,
              width: mqData!.size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: ColorConst().mColor[0]),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*---------Add Title------------*/
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "Enter your title",
                          label: Text("Title"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    /*---------DatePicker------------*/
                    TextField(
                      controller: DateController,
                      decoration: InputDecoration(
                        hintText: "Eg: Nov,23 2027",
                        label: Text("Date"),
                        suffixIcon: InkWell(
                            onTap: () async {
                              selectedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              DateTime date = selectedDate!;
                              formattedDate =
                                  DateFormat('MMM,dd yyyy').format(date);
                              if (formattedDate != null) {
                                DateController.text = formattedDate!;
                              }
                              setState(() {});
                            },
                            child: Icon(Icons.calendar_month)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    /*---------Priority TextField------------*/
                    TextField(
                      controller: PriorityController,
                      decoration: InputDecoration(
                          hintText: "Enter your Priority",
                          label: Text("Priority"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    /*---------Add Task Button------------*/
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: ColorConst().mColor[0]),
                        onPressed: () {},
                        child: Text(
                          "Add Now",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
