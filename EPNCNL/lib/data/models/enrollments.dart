import 'package:meowlish/data/models/transactions.dart';

class Enrollment {
  String? id;
  String? transactionId;
  String? enrolledDate;
  String? status;
  bool? refundStatus;
  int? totalGrade;
  Transaction? transaction;

  Enrollment(
      {this.id,
        this.transactionId,
        this.enrolledDate,
        this.status,
        this.refundStatus,
        this.totalGrade,
        this.transaction});

  Enrollment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transactionId'];
    enrolledDate = json['enrolledDate'];
    status = json['status'];
    refundStatus = json['refundStatus'];
    totalGrade = json['totalGrade'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transactionId'] = this.transactionId;
    data['enrolledDate'] = this.enrolledDate;
    data['status'] = this.status;
    data['refundStatus'] = this.refundStatus;
    data['totalGrade'] = this.totalGrade;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}