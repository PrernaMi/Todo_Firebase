import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/app_const/color_const.dart';
import 'package:todo_firebase/models/todo_model.dart';

class HomePage extends StatefulWidget {
  String pageView;

  HomePage({required this.pageView});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MediaQueryData? mqData;
  String? selectedPriority;
  int? selectedPriorityNumber;
  bool isChecked = false;
  List<TodoModel> mList = [];
  List<String> priority = ["Low", "High"];
  Color? selectedColor;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  DateTime? selectedDate;
  String? formattedDate;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var collections = fireStore.collection("todos");
    mqData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: collections.snapshots(),
          builder: (_, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshots.hasData) {
              return snapshots.data!.docs.isNotEmpty
                  ? widget.pageView == 'Open'
                      ? _listView(snapshots,false)
                      : _listView(snapshots, true)
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
                                      return _bottomSheetContent(
                                          context: context);
                                    });
                              },
                              child: Text(
                                "Add Now",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    );
            }
            return Container();
          }),
      floatingActionButton: _floatingButton(),
    );
  }
  Widget _listView(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots,bool flag){
  var collections = fireStore.collection("todos");
    return ListView.builder(
        itemCount: snapshots.data!.docs.length,
        itemBuilder: (_, index) {
          return snapshots.data!.docs[index]
              .data()['isComp'] ==
              flag
              ? SizedBox(
            height: mqData!.size.height * 0.16,
            child: Card(
              child: CheckboxListTile(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15)),
                title: Text(
                  snapshots.data!.docs[index]
                      .data()['title'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                value: snapshots.data!.docs[index]
                    .data()['isComp'],
                onChanged: (bool? value) {
                  isChecked = value!;
                  collections
                      .doc(snapshots
                      .data!.docs[index].id)
                      .update(TodoModel(
                      title: snapshots.data!.docs[index]
                          .data()['title'],
                      desc: snapshots.data!.docs[index]
                          .data()['desc'],
                      assignAt: snapshots
                          .data!.docs[index]
                          .data()['assignAt'],
                      isCompleted: isChecked,
                      completeAt: snapshots
                          .data!.docs[index]
                          .data()['completeAt'],
                      priority: snapshots
                          .data!.docs[index]
                          .data()['priority'])
                      .toMap());
                  setState(() {});
                },
                secondary: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.remove_circle,
                      color: snapshots.data!.docs[index]
                          .data()['priority'] ==
                          1
                          ? Colors.green
                          : Colors.red,
                    ),
                    InkWell(
                      onTap: () {
                        collections
                            .doc(snapshots
                            .data!.docs[index].id)
                            .delete();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                tileColor: snapshots.data!.docs[index]
                    .data()['isComp'] ==
                    false
                    ? Colors.blue.shade200
                    : Colors.green.shade200,
                subtitle:
                _subTitleContent(snapshots, index),
                activeColor: Colors.blue,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity
                    .leading, // Position of the checkbox
              ),
            ),
          )
              : Container();
        });
}

  Widget _floatingButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
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
    );
  }

  Widget _bottomSheetContent({required BuildContext context}) {
    return SizedBox(
      height: mqData!.size.height * 0.56,
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
              height: mqData!.size.height * 0.46,
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
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    /*---------Add Description------------*/
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                          hintText: "Enter your Description",
                          label: Text("Description"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    /*---------DatePicker------------*/
                    TextField(
                      controller: dateController,
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
                                dateController.text = formattedDate!;
                              }
                              setState(() {});
                            },
                            child: Icon(Icons.calendar_month)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    /*---------Priority TextField------------*/
                    StatefulBuilder(builder: (_, mSetState) {
                      return DropdownMenu(
                        hintText: "Select Priority",
                        width: mqData!.size.width * 1,
                        trailingIcon: Icon(
                          Icons.remove_circle,
                          color: selectedColor,
                        ),
                        dropdownMenuEntries: priority
                            .map((item) => DropdownMenuEntry<String>(
                                  value: item,
                                  label: item,
                                ))
                            .toList(),
                        onSelected: (value) {
                          selectedPriority = value;
                          mSetState(() {
                            if (value == "Low") {
                              selectedColor = ColorConst.priorityColor[0];
                              selectedPriorityNumber = 1;
                            } else if (value == "Medium") {
                              selectedColor = ColorConst.priorityColor[1];
                              selectedPriorityNumber = 2;
                            } else {
                              selectedColor = ColorConst.priorityColor[2];
                              selectedPriorityNumber = 3;
                            }
                          });
                        },
                      );
                    }),
                    /*---------Add Task Button------------*/
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: ColorConst().mColor[0]),
                        onPressed: () {
                          var date = DateTime.now();
                          if (titleController.text.toString() != "" &&
                              descController.text.toString() != "" &&
                              selectedPriorityNumber != null &&
                              dateController.text.toString() != "") {
                            var collections = fireStore.collection("todos");
                            collections.add(TodoModel(
                                    title: titleController.text.toString(),
                                    desc: descController.text.toString(),
                                    priority: selectedPriorityNumber,
                                    completeAt: dateController.text.toString(),
                                    assignAt: DateFormat('MMM,dd yyyy')
                                        .format(date)
                                        .toString())
                                .toMap());
                            titleController.clear();
                            descController.clear();
                            dateController.clear();
                            selectedPriorityNumber = null;
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
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

  Widget _subTitleContent(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots, int index) {
    return SizedBox(
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(snapshots.data!.docs[index].data()['desc']),
            ),
          ),
          Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(
                width: 3,
              ),
              Text(
                snapshots.data!.docs[index].data()['completeAt'],
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
