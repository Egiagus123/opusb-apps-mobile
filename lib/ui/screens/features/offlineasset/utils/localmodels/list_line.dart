class ListDataMovReqLine {
  int? _id;
  int? _clientID, _orgID, _toolRequestID, _toolRequestLineID, _installBaseID;
  String? _installBaseName, _serNo;
  num? _qtyEntered, _qtyDelivered;

  ListDataMovReqLine(
      this._clientID,
      this._orgID,
      this._toolRequestLineID,
      this._toolRequestID,
      this._installBaseID,
      this._installBaseName,
      this._serNo,
      this._qtyDelivered,
      this._qtyEntered);

  // ListDataMovReqHeader.withId(
  //   this._id,
  //   this._clientID,
  //   this._orgID,
  //   // this._toolRequestID,
  //   // this._locatorID,
  //   // this._dateDoc,
  //   // this._dateReceived,
  //   // this._dateRequired,
  //   // this._documentNo,
  //   // this._locatorNewID
  // );

  int get clientId => _clientID!;
  int get orgId => _orgID!;
  int get toolRequestLineID => _toolRequestLineID!;
  int get toolRequestId => _toolRequestID!;
  int get installBaseID => _installBaseID!;
  String get installBaseName => _installBaseName!;
  String get serNo => _serNo!;
  num get qtyDelivered => _qtyDelivered!;
  num get qtyEntered => _qtyEntered!;

  int get id => _id!;
  set id(int newId) {
    this._id = newId;
  }

  set clientId(int clientId) {
    this._clientID = clientId;
  }

  set orgId(int orgId) {
    this._orgID = orgId;
  }

  set toolRequestLineID(int toolRequestLineID) {
    this._toolRequestLineID = toolRequestLineID;
  }

  set toolRequestId(int toolRequestId) {
    this._toolRequestID = toolRequestId;
  }

  set installBaseID(int installBaseID) {
    this._installBaseID = installBaseID;
  }

  set installBaseName(String installBaseName) {
    this._installBaseName = installBaseName;
  }

  set serNo(String serNo) {
    this._serNo = serNo;
  }

  set qtyDelivered(num qtyDelivered) {
    this._qtyDelivered = qtyDelivered;
  }

  set qtyEntered(num qtyEntered) {
    this._qtyEntered = qtyEntered;
  }

  //convert data to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['clientId'] = _clientID;
    map['orgId'] = _orgID;
    map['toolRequestLineID'] = _toolRequestLineID;
    map['toolRequestId'] = _toolRequestID;
    map['installBaseID'] = _installBaseID;
    map['installBaseName'] = _installBaseName;
    map['serNo'] = _serNo;
    map['qtyDelivered'] = _qtyDelivered;
    map['qtyEntered'] = _qtyEntered;

    return map;
  }

  //extract data from map object
  ListDataMovReqLine.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._clientID = map['clientId'];
    this._orgID = map['orgId'];
    this._toolRequestLineID = map['toolRequestLineID'];
    this._toolRequestID = map['toolRequestId'];
    this._installBaseID = map['installBaseID'];
    this._installBaseName = map['installBaseName'];
    this._serNo = map['serNo'];
    this._qtyDelivered = map['qtyDelivered'];
    this._qtyEntered = map['qtyEntered'];
  }
}
