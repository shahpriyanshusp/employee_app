class Employee {
   int? id;
   String? name;
   String? role;
   DateTime? fromDate;
   DateTime? toDate;

  Employee({
    this.id,
    this.name,
    this.role,
    this.fromDate,
    this.toDate,
  });

   Map<String, dynamic> toMap() {
     return {
       'id': id,
       'name': name,
       'fromDate': fromDate.toString(),
       'toDate': toDate.toString(),
       'role': role,
     };
   }

}
