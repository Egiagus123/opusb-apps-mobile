import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class ApprovalDoc extends Equatable {
  final int id;
  final int attachmentID;
  final int tableID;
  final int recordID;
  final String tableName;
  final String user;
  final String bp;
  final String description;
  final String approvalType;
  final String documentNo;
  final String referenceNo;
  final String currency;
  final double amount;
  final DateTime created;

  ApprovalDoc({
    required this.id,
    required this.attachmentID,
    required this.tableID,
    required this.recordID,
    required this.tableName,
    required this.user,
    required this.bp,
    required this.description,
    required this.approvalType,
    required this.documentNo,
    required this.referenceNo,
    required this.currency,
    required this.amount,
    required this.created,
  });

  @override
  List<Object> get props => [
        id,
        attachmentID,
        tableID,
        recordID,
        tableName,
        user,
        bp,
        description,
        approvalType,
        documentNo,
        referenceNo,
        currency,
        amount,
        created
      ];

  @override
  String toString() {
    return 'ApprovalDoc[id: $id, documentNo: $documentNo]';
  }

  String getKeywords() {
    return '$user#$bp#$documentNo';
  }

  factory ApprovalDoc.fromJson(Map<String, dynamic> json) {
    ApprovalDoc model = ApprovalDoc(
      id: ((json['AD_WF_Activity_ID'] as Map<String, dynamic>)['id'] as num)
          .toInt(),
      attachmentID: (json['AD_Attachment_ID'] as num).toInt(),
      tableID:
          ((json['AD_Table_ID'] as Map<String, dynamic>)['id'] as num).toInt(),
      recordID: (json['Record_ID'] as num).toInt(),
      tableName: (json['AD_Table_ID'] as Map<String, dynamic>)['identifier'],
      user: json['name'],
      bp: json['bPName'],
      description: json['textMsg'],
      approvalType: json['nodeName'],
      documentNo: json['documentNo'],
      referenceNo: '',
      currency: json['curSymbol'],
      amount: NumberFormat("#,##0.00", "en_US")
          .parse(json['grandTotal'])
          .toDouble(),
      created:
          DateFormat('MMM dd, yyyy hh:mm:ss a vvvv').parse(json['created']),
    );
    return model;
  }

  static List<ApprovalDoc> listFromJson(List<dynamic> json) {
    json.map((a) => print(a));
    return json.map((e) => ApprovalDoc.fromJson(e)).toList();
  }
}
