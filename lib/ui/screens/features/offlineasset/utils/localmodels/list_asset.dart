class ListAssetTrf {
  int? _id;
  int? _clientID, _orgID, _toolRequestID, _locatorID, _locatorNewID;
  String? _documentNo,
      _dateDoc,
      _dateRequired,
      _dateReceived,
      _locationfromName,
      _locationToName,
      _trxtype;

  ListAssetTrf(
      this._clientID,
      this._orgID,
      this._toolRequestID,
      this._locatorID,
      this._locatorNewID,
      this._documentNo,
      this._dateDoc,
      this._dateReceived,
      this._dateRequired,
      this._locationfromName,
      this._locationToName,
      this._trxtype);

  // ListAssetTrf.withId(
  //   this._id,
  //   this._clientID,
  //   this._orgID,
  //   this._locatorID,
  //   this._locatorNewID,
  //   this._documentNo,
  //   this._dateDoc,
  //   this._dateReceived,
  //   this._dateRequired,
  //   this._locationfromName,
  //   this._locationToName,
  // );

  int get clientId => _clientID!;
  int get orgId => _orgID!;
  int get toolRequestId => _toolRequestID!;
  int get locatorID => _locatorID!;
  int get locatorNewID => _locatorNewID!;
  String get docNo => _documentNo!;
  String get dateDocument => _dateDoc!;
  String get dateReq => _dateRequired!;
  String get dateRec => _dateReceived!;
  String get locationfromName => _locationfromName!;
  String get locationToName => _locationToName!;
  String get trxtype => _trxtype!;

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

  set toolRequestId(int toolRequestId) {
    this._toolRequestID = toolRequestId;
  }

  set locatorID(int locatorID) {
    this._locatorID = locatorID;
  }

  set locatorNewID(int locatorNewID) {
    this._locatorNewID = locatorNewID;
  }

  set docNo(String docNo) {
    this._documentNo = docNo;
  }

  set dateDocument(String dateDocument) {
    this._dateDoc = dateDocument;
  }

  set dateReq(String dateReq) {
    this._dateRequired = dateReq;
  }

  set dateRec(String dateRec) {
    this._dateReceived = dateRec;
  }

  set locationfromName(String locationfromName) {
    this._locationfromName = locationfromName;
  }

  set locationToName(String locationToName) {
    this._locationToName = locationToName;
  }

  set trxtype(String trxtype) {
    this._trxtype = trxtype;
  }

  //convert data to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['clientId'] = _clientID;
    map['orgId'] = _orgID;
    map['toolRequestId'] = _toolRequestID;
    map['locatorID'] = _locatorID;
    map['locatorNewID'] = _locatorNewID;
    map['docNo'] = _documentNo;
    map['dateDocument'] = _dateDoc;
    map['dateReq'] = _dateRequired;
    map['dateRec'] = _dateReceived;
    map['locationfromName'] = _locationfromName;
    map['locationToName'] = _locationToName;
    map['trxtype'] = _trxtype;

    return map;
  }

  //extract data from map object
  ListAssetTrf.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._clientID = map['clientId'];
    this._orgID = map['orgId'];
    this._toolRequestID = map['toolRequestId'];
    this._locatorID = map['locatorID'];
    this._locatorNewID = map['locatorNewID'];
    this._documentNo = map['docNo'];
    this._dateDoc = map['dateDocument'];
    this._dateRequired = map['dateReq'];
    this._dateReceived = map['dateRec'];
    this._locationfromName = map['locationfromName'];
    this._locationToName = map['locationToName'];
    this._trxtype = map['trxtype'];
  }
}
