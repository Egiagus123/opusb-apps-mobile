import 'package:apps_mobile/business_logic/cubit/inventory/approval_cubit.dart';
import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'approval_confirmation.dart';

class ApprovalDetailBody extends StatefulWidget {
  final ApprovalDoc approvalDoc;
  final String printFormatPath;

  const ApprovalDetailBody(
      {Key? key, required this.approvalDoc, required this.printFormatPath})
      : super(key: key);

  @override
  _ApprovalDetailBodyState createState() => _ApprovalDetailBodyState();
}

class _ApprovalDetailBodyState extends State<ApprovalDetailBody> {
  late ApprovalCubit approvalCubit;
  late PdfController _pdfController;
  late String newDir;

  late List<String> _dataFile, _tempImages;

  @override
  void initState() {
    super.initState();
    _dataFile = [];
    _tempImages = [];
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.printFormatPath),
    );
    approvalCubit = BlocProvider.of<ApprovalCubit>(context);
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApprovalCubit, ApprovalState>(
      listener: (context, state) async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if (state is ApprovalFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${state.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        } else if (state is ApprovalProcessInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Processing...'),
            ),
          );
        } else if (state is ApprovalGetAttchProcessInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Processing...'),
            ),
          );
        } else if (state is ApprovalProcessSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ApprovalGetAttachSuccess) {
          final zippedFile = state.printFormatPath;
          File file = new File(zippedFile);
          _tempImages.clear();
          _dataFile.clear();
          await unarchive(file);
          setState(() {
            _dataFile.addAll(_tempImages);
          });
          return _showQuickDownload();
        }
      },
      child: _buildData(context, widget.approvalDoc),
    );
  }

  unarchive(var zippedFile) async {
    Directory tempDir = await getTemporaryDirectory();
    File extractedFile;
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    for (var file in archive) {
      var fileName = '${file.name}';
      if (file.isFile) {
        final filename = file.name;
        final data = file.content as List<int>;
        var outFile = File(fileName);
        _tempImages.add(outFile.path);
        extractedFile = File('${tempDir.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);

        print('direktorinya $extractedFile');

        String newpaths = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD,
        );
        print('newpath $newpaths');
      }
    }
  }

  _showQuickDownload() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              contentPadding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
              title: Center(child: Text("Attachment List")),
              content: Stack(children: [
                setupAlertDialoadContainer(),
                Padding(
                    padding: EdgeInsets.only(top: 300, right: 100, left: 100),
                    child: bottomAlert())
              ]),
            ));
  }

  Widget _buildData(BuildContext context, ApprovalDoc approvalDoc) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        title: Text(
          'Approval ${approvalDoc.documentNo}',
          style: TextStyle(color: purewhiteTheme),
        ),
      ),
      body: PdfView(
        controller: _pdfController,
      ),
      persistentFooterButtons: [
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: () async {
                  _openAttachment(approvalDoc);
                }),
            MaterialButton(
              onPressed: () {
                _displayProcessDialog(context, approvalDoc, false);
              },
              color: Theme.of(context).colorScheme.error,
              child: Text('Reject'),
            ),
            MaterialButton(
              onPressed: () {
                _displayProcessDialog(context, approvalDoc, true);
              },
              child: Text('Approve'),
            )
          ],
        ),
      ],
    );
  }

  _displayProcessDialog(
    BuildContext parentContext,
    ApprovalDoc approvalDoc,
    bool isApprove,
  ) async {
    return await showDialog(
        context: parentContext,
        builder: (parentContext) {
          return ApprovalConfirmation(
              approvalCubit: BlocProvider.of<ApprovalCubit>(context),
              approvalDoc: approvalDoc,
              isApprove: isApprove);
        });
  }

  void _openAttachment(ApprovalDoc approvalDoc) async {
    await approvalCubit.getAttachment(approvalDoc);
  }

  Future<void> viewFile(String namefile) async {
    Directory tempDir = await getTemporaryDirectory();
    final filePath = ('${tempDir.path}/$namefile');
    OpenFilex.open(filePath);
  }

  Widget bottomAlert() {
    return MaterialButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          'Close',
          style: TextStyle(color: Colors.grey),
        ));
  }

  Widget setupAlertDialoadContainer() {
    return Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        height: 300, // Change as per your requirement
        width: 300, // Change as per your requirement

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _dataFile.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 3,
                      color: Colors.white,
                      child: new InkWell(
                          onTap: () {
                            viewFile(_dataFile[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _dataFile[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          )));
                },
              ),
            ],
          ),
        ));
  }
}
