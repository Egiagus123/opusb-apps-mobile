class ListDataGetReceiving {
  int? _id;
  int? _clientID,
      _orgID,
      _toolRequestID,
      _toolRequestLineID,
      _installBaseID,
      _locatorNewID,
      _locatorIntransitID;
  String? _serNo,
      _installBaseName,
      _trxtype,
      _locationToName,
      _dateReceived,
      _trfdatedoc,
      _trfdocno;
  num? _qtyEntered;

  ListDataGetReceiving(
      this._clientID,
      this._orgID,
      this._toolRequestLineID,
      this._toolRequestID,
      this._installBaseID,
      this._installBaseName,
      this._locatorNewID,
      this._locationToName,
      this._trxtype,
      this._serNo,
      this._qtyEntered,
      this._locatorIntransitID,
      this._dateReceived,
      this._trfdatedoc,
      this._trfdocno);

  int get clientId => _clientID!;
  int get orgId => _orgID!;
  int get toolRequestLineID => _toolRequestLineID!;
  int get toolRequestId => _toolRequestID!;
  int get installBaseID => _installBaseID!;
  int get locatorNewID => _locatorNewID!;
  int get locatorIntransitID => _locatorIntransitID!;

  String get installBaseName => _installBaseName!;
  String get locationToName => _locationToName!;
  String get trxtype => _trxtype!;
  String get serNo => _serNo!;
  String get dateReceived => _dateReceived!;
  String get trfdatedoc => _trfdatedoc!;
  String get trfdocno => _trfdocno!;

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

  set locatorNewID(int locatorNewID) {
    this._locatorNewID = locatorNewID;
  }

  set locationToName(String locationToName) {
    this._locationToName = locationToName;
  }

  set serNo(String serNo) {
    this._serNo = serNo;
  }

  set qtyEntered(num qtyEntered) {
    this._qtyEntered = qtyEntered;
  }

  set trxtype(String trxtype) {
    this._trxtype = trxtype;
  }

  set locatorIntransitID(int locatorIntransitID) {
    this._locatorIntransitID = locatorIntransitID;
  }

  set dateReceived(String dateReceived) {
    this._dateReceived = dateReceived;
  }

  set trfdatedoc(String trfdatedoc) {
    this._trfdatedoc = trfdatedoc;
  }

  set trfdocno(String trfdocno) {
    this._trfdocno = trfdocno;
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
    map['locatorNewID'] = _locatorNewID;
    map['locationToName'] = _locationToName;
    map['trxtype'] = _trxtype;
    map['serNo'] = _serNo;
    map['qtyEntered'] = _qtyEntered;
    map['locatorIntransitID'] = _locatorIntransitID;
    map['dateReceived'] = _dateReceived;
    map['trfdatedoc'] = _trfdatedoc;
    map['trfdocno'] = _trfdocno;
    return map;
  }

  //extract data from map object
  ListDataGetReceiving.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._clientID = map['clientId'];
    this._orgID = map['orgId'];
    this._toolRequestLineID = map['toolRequestLineID'];
    this._toolRequestID = map['toolRequestId'];
    this._installBaseID = map['installBaseID'];
    this._installBaseName = map['installBaseName'];
    this._locatorNewID = map['locatorNewID'];
    this._locationToName = map['locationToName'];
    this._trxtype = map['trxtype'];
    this._serNo = map['serNo'];
    this._qtyEntered = map['qtyEntered'];
    this._locatorIntransitID = map['locatorIntransitID'];
    this._dateReceived = map['dateReceived'];
    this._trfdatedoc = map['trfdatedoc'];
    this._trfdocno = map['trfdocno'];
  }
}
