import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../bloc/employee_bloc.dart';
import 'employee_form_screen.dart';


class EmployeeListScreen extends StatelessWidget {
  DateTime today=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoadSuccess ) {
            final employees = state.employees;
            return Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.2),
                      height: MediaQuery.of(context).size.height*0.08,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text("Current employees",style: TextStyle(color: Color(0xff1DA1F2),fontWeight: FontWeight.w500,fontSize: 20),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.32,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          int comparisonResult = today.compareTo(employee.toDate!);
                          return comparisonResult.isNegative? Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion:  ScrollMotion(),
                              children:  [
                                SlidableAction(
                                  onPressed: (context){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EmployeeFormScreen("edit",name:employee.name!,fromdate: employee.fromDate.toString(),id: employee.id.toString(),role: employee.role.toString(),todate: employee.toDate.toString(),)),
                                    ).then((value) {
                                      BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
                                    });
                                  },
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion:  ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee data has been deleted Undo")));
                                BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(employee.id!));
                                BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
                              }),
                              children:  [
                                SlidableAction(
                                  onPressed: (context){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee data has been deleted Undo")));
                                    BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(employee.id!));
                                    BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(employee.name!,style: TextStyle(fontSize: 20,color: Color(0xff323238),fontWeight: FontWeight.w500,)),
                                        SizedBox(height: 5,),
                                        Text(employee.role!,style: TextStyle(fontSize: 16,color: Color(0xff949C9E),fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5,),
                                        Text("From "+DateFormat('d MMM, yyyy').format(employee.fromDate ?? DateTime.now()),style: TextStyle(fontSize: 12,color: Color(0xff949C9E),fontWeight: FontWeight.w400,)),
                                      ],


                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ):Container();
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.2),
                      height: MediaQuery.of(context).size.height*0.08,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text("Previous employees",style: TextStyle(color: Color(0xff1DA1F2),fontWeight: FontWeight.w500,fontSize: 20),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.32,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];

                          int comparisonResult = today.compareTo(employee.toDate!);

                          return !comparisonResult.isNegative?  Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion:  ScrollMotion(),
                              children:  [
                                SlidableAction(
                                  onPressed: (context){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EmployeeFormScreen("edit",name:employee.name!,fromdate: employee.fromDate.toString(),id: employee.id.toString(),role: employee.role.toString(),todate: employee.toDate.toString(),)),
                                    ).then((value) {
                                      BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
                                    });
                                  },
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion:  ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee data has been deleted Undo")));
                                BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(employee.id!));
                                BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
                              }),
                              children:  [
                                SlidableAction(
                                  onPressed: (context){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee data has been deleted Undo")));
                                    BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(employee.id!));
                                    BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(employee.name!,style: TextStyle(fontSize: 20,color: Color(0xff323238),fontWeight: FontWeight.w500,)),
                                        SizedBox(height: 5,),
                                        Text(employee.role!,style: TextStyle(fontSize: 16,color: Color(0xff949C9E),fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5,),
                                        Text(DateFormat('d MMM, yyyy').format(employee.fromDate ?? DateTime.now())+" - "+DateFormat('d MMM, yyyy').format(employee.toDate  ?? DateTime.now()),style: TextStyle(fontSize: 12,color: Color(0xff949C9E),fontWeight: FontWeight.w400,)),
                                      ],


                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ):Container();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is EmployeeOperationFailure) {
            return Text('Failed to load employees');
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/NoDataFound.png",height: MediaQuery.of(context).size.height*0.265,width:MediaQuery.of(context).size.height*0.265 ,)),
              Text("No employee records found",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xff323238),fontSize: 15),)
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.07,
        color: Colors.grey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal:15),
          child: Text("Swip left to delete",style: TextStyle(fontSize: 15,color: Color(0xff949C9E)),),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeFormScreen("add")),
          ).then((value) {
            BlocProvider.of<EmployeeBloc>(context).add(GetEmployees());
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Icon(Icons.add),
      ),
    );
  }

  void doNothing(BuildContext context) {}
}
