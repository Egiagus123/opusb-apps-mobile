class ShipmentOfflineModel {
  int? id;
  int? clientId;
  int? orgId;
  String? container;
  String? shipmentDate;
  double? qtyentered;
  double? weight1;
  double? tareweight;
  double? quantity;
  bool? status;

  ShipmentOfflineModel({
    this.id,
    this.clientId,
    required this.orgId,
    required this.container,
    required this.qtyentered,
    required this.quantity,
    required this.tareweight,
    required this.weight1,
    required this.status,
    required this.shipmentDate,
  });

  factory ShipmentOfflineModel.fromMap(Map<String, dynamic> map) {
    return ShipmentOfflineModel(
      id: map['id'],
      orgId: map['orgId'],
      clientId: map['clientId'],
      container: map['container'],
      qtyentered: map['qtyentered'],
      quantity: map['quantity'],
      tareweight: map['tareweight'],
      weight1: map['weight1'],
      shipmentDate: map['shipmentDate'],
      status: map['status'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgId': orgId,
      'clientId': clientId,
      'weight1': weight1,
      'tareweight': tareweight,
      'quantity': quantity,
      'qtyentered': qtyentered,
      'container': container,
      'shipmentDate': shipmentDate,
      'status': status! ? 1 : 0,
    };
  }
}
