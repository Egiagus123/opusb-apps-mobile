import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/usecase/imf_usecase.dart';
import 'package:apps_mobile/features/imf/om/domain/usecase/om_usecase.dart';
import 'package:apps_mobile/features/imf/om/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/imf/om/presentation/bloc/om_bloc.dart';
import 'package:apps_mobile/features/imf/om/presentation/widget/imf_form.dart';

class IMFPage extends StatefulWidget {
  @override
  State<IMFPage> createState() => _IMFPageState();
}

class _IMFPageState extends State<IMFPage> {
  final List<ImfLineEntity> _movementLines = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: BlocProvider<OmBloc>(
          create: (context) => OmBloc(
            poUseCase: sl<OmIMFUseCase>(),
            receiptUseCase: sl<ImfUseCase>(),
            attributeSetUseCase: sl<AttributeSetUseCase>(),
          ),
          child: BlocListener<OmBloc, OmState>(
            listener: _handleOmState,
            child: MovementForm(movementLines: _movementLines),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => buildAlertDialog(
        ctx,
        title: 'Warning',
        content: 'Do you really want to exit?',
        cancelText: 'No',
        cancelCallback: () => Navigator.of(ctx).pop(false),
        proceedText: 'Yes',
        proceedCallback: () => Navigator.of(ctx).pop(true),
      ),
    );
    return shouldExit ?? false;
  }

  void _handleOmState(BuildContext context, OmState state) {
    if (state is OmStateScanCanceled) {
      _showSnackBar(context, state.message, 'Scan canceled', Colors.amber);
    } else if (state is OmStateSerialNoDuplication) {
      _showSnackBar(context, state.message, 'Duplicate serial', Colors.amber);
    } else if (state is OmStateFailed) {
      _showSnackBar(context, state.message, 'Error', Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, String notify,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white),
            children: [
              TextSpan(text: notify),
              const TextSpan(text: '. Click '),
              TextSpan(
                text: 'here',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => buildAlertDialog(
                        ctx,
                        title: notify,
                        content: message,
                        proceedText: 'OK',
                        proceedCallback: () => Navigator.of(ctx).pop(),
                      ),
                    );
                  },
              ),
              const TextSpan(text: ' for details.')
            ],
          ),
        ),
        backgroundColor: color,
      ),
    );
  }
}
