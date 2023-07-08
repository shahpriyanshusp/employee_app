// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../bloc/employee_bloc.dart';
// import '../model/employee.dart';
//
// class EmployeeFormScreen extends StatefulWidget {
//   @override
//   _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
// }
//
// class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _roleController = TextEditingController();
//   DateTime? _fromDate;
//   DateTime? _toDate;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _roleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Employee'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _roleController,
//                 decoration: InputDecoration(labelText: 'Role'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter a role';
//                   }
//                   return null;
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(Duration(days: 365)),
//                   ).then((date) {
//                     setState(() {
//                       _fromDate = date;
//                     });
//                   });
//                 },
//                 child: Text('Select From Date'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(Duration(days: 365)),
//                   ).then((date) {
//                     setState(() {
//                       _toDate = date;
//                     });
//                   });
//                 },
//                 child: Text('Select To Date'),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final employee = Employee(
//                       name: _nameController.text,
//                       role: _roleController.text,
//                       fromDate: _fromDate,
//                       toDate: _toDate,
//                     );
//                     BlocProvider.of<EmployeeBloc>(context).add(AddEmployee(employee));
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/employee_bloc.dart';
import '../data/employee_repository.dart';
import '../model/employee.dart';


class EmployeeFormScreen extends StatefulWidget {
  final String purpose;
  final String name;
  final String role;
  final String fromdate;
  final String todate;
  final String id;
  EmployeeFormScreen(this.purpose, {Key? key,this.name="",this.role="",this.fromdate="",this.todate="",this.id=""}) : super(key: key);
  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _todateController = TextEditingController();
  final _fromdateController = TextEditingController();
  DateTime today=DateTime.now();
  final EmployeeRepository repository = EmployeeRepository();
  final List<String> Roles=['Product Designer','Flutter Developer', 'QA Tester', 'Product Owner'];
  String SelectedButton='today';
  String Employeeid='';


  @override
  void initState() {
    // TODO: implement initState
    if(widget.purpose.toString()=="edit"){
      _nameController.text=widget.name;
      _roleController.text=widget.role;
      Employeeid=widget.id;
      DateTime dateTime = DateTime.parse(widget.fromdate);
      DateTime dateTime2 = DateTime.parse(widget.todate);
      _fromdateController.text=DateFormat('dd MMM yyyy').format(dateTime);
      _todateController.text=DateFormat('dd MMM yyyy').format(dateTime2);
    }
    super.initState();
  }
  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeBloc>(
      create: (context) => EmployeeBloc(repository),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.purpose!="edit"?'Add Employee Details':'Edit Employee Details'),
          actions: [
          if(widget.purpose=="edit")  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                  onTap: (){
                    print("hello");
                    BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(int.parse(Employeeid ?? "0")));
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.delete_outline,color: Colors.white,)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                        hintText: 'Employee name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: SizedBox(
                        height: 25,
                        width: 25,
                        child: Icon(Icons.person_2_outlined,color: Colors.blueAccent,))

                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  readOnly: true,
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return _buildBottomSheetContent(context);
                      },
                    );
                  },
                  controller: _roleController,
                  decoration: InputDecoration(
                      hintText: 'Select role',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: SizedBox(
                          height: 25,
                          width: 25,
                          child: Icon(Icons.shopping_bag_outlined,color: Colors.blueAccent,)),
                      suffixIcon: SizedBox(
                          height: 25,
                          width: 25,
                          child: Icon(Icons.arrow_drop_down_rounded,color: Colors.blueAccent,)),

                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a role';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fromdateController,
                        readOnly: true,
                        onTap: (){
                          today=DateFormat("dd MMM yyyy").parse(_fromdateController.text!=null && _fromdateController.text !="" ?_fromdateController.text : DateFormat("dd MMM yyyy").format(DateTime.now()));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                            return    StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                return
                                 Column(
                                   mainAxisSize: MainAxisSize.min,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                        setState((){
                                                          SelectedButton="today";
                                                          today=DateTime.now();
                                                        });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:SelectedButton=="today"? Colors.blue:Color(0xffEDF8FF),

                                                        ),
                                                        child: Text('Today',style: TextStyle(color:SelectedButton=="today"? Colors.white:Colors.blueAccent ),),
                                                      ),
                                                    ),
                                                    SizedBox(width: 50,),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            SelectedButton="Monday";
                                                            DateTime nextMonday =
                                                            _calculateNextWeekday(DateTime.monday);
                                                            today = nextMonday;
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:SelectedButton=="Monday"? Colors.blue:Color(0xffEDF8FF),

                                                        ),
                                                        child: Text('Next Monday',style:  TextStyle(color:SelectedButton=="Monday"? Colors.white:Colors.blueAccent ),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            SelectedButton="Tuesday";
                                                            DateTime nextTuesday =
                                                            _calculateNextWeekday(DateTime.tuesday);
                                                            today = nextTuesday;
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:SelectedButton=="Tuesday"? Colors.blue:Color(0xffEDF8FF),

                                                        ),
                                                        child: Text('Next Tuesday',style:  TextStyle(color:SelectedButton=="Tuesday"? Colors.white:Colors.blueAccent )),
                                                      ),
                                                    ),
                                                    SizedBox(width: 50,),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            SelectedButton="Week";
                                                            DateTime nextWeek = DateTime.now().add(Duration(days: 7));
                                                            // _setSelectedDate(nextWeek);
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                        backgroundColor:SelectedButton=="Week"? Colors.blue:Color(0xffEDF8FF),

                                                      ),

                                                        child: Text('After 1 Week',style:  TextStyle(color:SelectedButton=="Week"? Colors.white:Colors.blueAccent )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 400,
                                          child:  Material(
                                            child: Container(
                                              height: 400,
                                              color: Colors.white,
                                              child: TableCalendar(
                                                calendarStyle: CalendarStyle(
                                                  defaultDecoration: BoxDecoration(
                                                    color: Colors.white,
                                                  )
                                                ),
                                                calendarFormat: CalendarFormat.month,
                                                availableGestures: AvailableGestures.all,
                                                onDaySelected: (day,focusday)=> {
                                                  setState(() {
                                                  today=day;
                                                  print(today.day.toString());
                                                })
                                                },
                                                selectedDayPredicate: (day)=>isSameDay(day, today),
                                                firstDay: DateTime.utc(2010, 10, 16),
                                                lastDay: DateTime.utc(2030, 3, 14),
                                                focusedDay: today,
                                                locale: 'en_US',
                                                headerStyle: HeaderStyle(formatButtonVisible: false,titleCentered: true),
                                                currentDay: today,

                                              ),
                                            ),
                                          ),
                              ),
                                          Container(

                                              color: Colors.white,

                                            child: Column(
                                              children: [
                                                Divider(height: 1,color: Colors.grey,),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.calendar_month_outlined,color: Colors.blueAccent,),
                                                         SizedBox(width: 10,),
                                                         Material(child: Text(DateFormat('dd MMM yyyy').format(today).toString(),style: TextStyle(fontSize: 16),))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Color(0xffEDF8FF),

                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text('Cancel',style: TextStyle(color: Colors.blueAccent),),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                           _fromdateController.text= DateFormat('dd MMM yyyy').format(today).toString();
                                                           Navigator.pop(context);
                                                            },
                                                            child: Text('Save'),
                                                          ),
                                                        ],
                                                      )


                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                                   ],
                                 );});
                            },
                          );



                          // showDatePicker(
                          //   context: context,
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime.now(),
                          //   lastDate: DateTime.now().add(Duration(days: 365)),
                          // ).then((date) {
                          //   setState(() {
                          //     _fromDate = date;
                          //     _fromdateController.text=date.toString();
                          //   });
                          // });
                        },
                        decoration: InputDecoration(
                          hintText: 'No date',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          contentPadding: EdgeInsets.all(0),
                          prefixIcon: SizedBox(
                              height: 25,
                              width: 25,
                              child: Icon(Icons.calendar_month_outlined,color: Colors.blueAccent,)),


                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a role';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.06,
                      width: MediaQuery.of(context).size.width*0.13,child: Icon(Icons.arrow_right_alt_rounded,color: Colors.blueAccent,size: 30),),
                    Expanded(
                      child: TextFormField(
                        controller: _todateController,
                        readOnly: true,
                        onTap: (){
                          today=DateFormat("dd MMM yyyy").parse(_todateController.text!=null && _todateController.text !="" ?_todateController.text : DateFormat("dd MMM yyyy").format(DateTime.now()));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return    StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(

                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(horizontal: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                setState((){
                                                                  SelectedButton="today";
                                                                  today=DateTime.now();
                                                                });
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:SelectedButton=="today"? Colors.blue:Color(0xffEDF8FF),

                                                              ),
                                                              child: Text('Today',style: TextStyle(color:SelectedButton=="today"? Colors.white:Colors.blueAccent ),),
                                                            ),
                                                          ),
                                                          SizedBox(width: 50,),
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  SelectedButton="Monday";
                                                                  DateTime nextMonday =
                                                                  _calculateNextWeekday(DateTime.monday);
                                                                  today = nextMonday;
                                                                });
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:SelectedButton=="Monday"? Colors.blue:Color(0xffEDF8FF),

                                                              ),
                                                              child: Text('Next Monday',style:  TextStyle(color:SelectedButton=="Monday"? Colors.white:Colors.blueAccent ),),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  SelectedButton="Tuesday";
                                                                  DateTime nextTuesday =
                                                                  _calculateNextWeekday(DateTime.tuesday);
                                                                  today = nextTuesday;
                                                                });
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:SelectedButton=="Tuesday"? Colors.blue:Color(0xffEDF8FF),

                                                              ),
                                                              child: Text('Next Tuesday',style:  TextStyle(color:SelectedButton=="Tuesday"? Colors.white:Colors.blueAccent )),
                                                            ),
                                                          ),
                                                          SizedBox(width: 50,),
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  SelectedButton="Week";
                                                                  DateTime nextWeek = DateTime.now().add(Duration(days: 7));
                                                                  today = nextWeek;
                                                                });
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:SelectedButton=="Week"? Colors.blue:Color(0xffEDF8FF),

                                                              ),

                                                              child: Text('After 1 Week',style:  TextStyle(color:SelectedButton=="Week"? Colors.white:Colors.blueAccent )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 400,
                                                  child:  Material(
                                                    child: Container(
                                                      height: 400,
                                                      color: Colors.white,
                                                      child: TableCalendar(
                                                        calendarStyle: CalendarStyle(
                                                            defaultDecoration: BoxDecoration(
                                                              color: Colors.white,
                                                            )
                                                        ),
                                                        calendarFormat: CalendarFormat.month,
                                                        availableGestures: AvailableGestures.all,
                                                        onDaySelected: (day,focusday)=> {
                                                          setState(() {
                                                            today=day;
                                                            print(today.day.toString());
                                                          })
                                                        },
                                                        selectedDayPredicate: (day)=>isSameDay(day, today),
                                                        firstDay: DateTime.utc(2010, 10, 16),
                                                        lastDay: DateTime.utc(2030, 3, 14),
                                                        focusedDay: today,
                                                        locale: 'en_US',
                                                        headerStyle: HeaderStyle(formatButtonVisible: false,titleCentered: true),
                                                        currentDay: today,

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(

                                                  color: Colors.white,

                                                  child: Column(
                                                    children: [
                                                      Divider(height: 1,color: Colors.grey,),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(Icons.calendar_month_outlined,color: Colors.blueAccent,),
                                                                SizedBox(width: 10,),
                                                                Material(child: Text(DateFormat('dd MMM yyyy').format(today).toString(),style: TextStyle(fontSize: 16),))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Color(0xffEDF8FF),

                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text('Cancel',style: TextStyle(color: Colors.blueAccent),),
                                                                ),
                                                                SizedBox(width: 10,),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    _todateController.text= DateFormat('dd MMM yyyy').format(today).toString();
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text('Save'),
                                                                ),
                                                              ],
                                                            )


                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );});
                            },
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'No date',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          contentPadding: EdgeInsets.all(0),
                          prefixIcon: SizedBox(
                              height: 25,
                              width: 25,
                              child: Icon(Icons.calendar_month_outlined,color: Colors.blueAccent,)),


                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a role';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 16.0),

              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: Offset(0, -1), // controls the position of the shadow
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.only(right: 10.0,bottom: 5.0,top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffEDF8FF),

                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel',style: TextStyle(color: Colors.blueAccent),),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {

                        DateFormat format = DateFormat('dd MMM yyyy');
                        DateTime date1 = format.parse(_fromdateController.text);
                        DateTime date2 = format.parse(_todateController.text);
                        int comparisonResult = date1.compareTo(date2);
                        if(comparisonResult.isNegative){
                          final employee = Employee(
                            name: _nameController.text,
                            role: _roleController.text,
                            fromDate: DateFormat("dd MMM yyyy").parse(_fromdateController.text),
                            toDate: DateFormat("dd MMM yyyy").parse(_todateController.text),
                          );
                          if(widget.purpose!="edit"){
                            BlocProvider.of<EmployeeBloc>(context).add(AddEmployee(employee));
                          }
                          else{
                           employee.id=int.parse(widget.id);
                            BlocProvider.of<EmployeeBloc>(context).add(UpdateEmployee(employee));
                          }

                          Navigator.pop(context);
                        }
                       else{
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Valid Date Rang ")));
                        }

                        
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }


  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
              itemCount: Roles.length,
              itemBuilder:(context,index){
                return GestureDetector(
                  onTap: (){
                    _roleController.text=Roles[index].toString();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height*0.065,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(child: Text(Roles[index].toString(),textAlign: TextAlign.center,)),
                          Divider(height: 2,color: Colors.grey,)
                        ],
                      ),
                    ),
                  ),
                );
              } ),
        ],
      )
    );
  }

  DateTime _calculateNextWeekday(int weekday) {
    DateTime currentDate = DateTime.now();
    int daysToAdd = (weekday - currentDate.weekday + 7) % 7;
    return currentDate.add(Duration(days: daysToAdd));
  }





}
