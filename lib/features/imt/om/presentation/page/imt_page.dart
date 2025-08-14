import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/usecase/imt_usecase.dart';
import 'package:apps_mobile/features/imt/om/domain/usecase/om_usecase.dart';
import 'package:apps_mobile/features/imt/om/presentation/bloc/om_bloc.dart';
import 'package:apps_mobile/features/imt/om/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/imt/om/presentation/widget/imt_form.dart';

class IMTPage extends StatefulWidget {
  @override
  State<IMTPage> createState() => _IMTPageState();
}

class _IMTPageState extends State<IMTPage> {
  List<ImtLineEntity> _movementLines = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text(
                  'Warning !',
                  style: TextStyle(fontFamily: 'Oswald'),
                ),
                content: const Text(
                  'Do you really want to exit?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'No',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300]),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(c, true),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        body: BlocProvider<OmBloc>(
          create: (context) => OmBloc(
            poUseCase: sl<OmUseCase>(),
            receiptUseCase: sl<ImtUseCase>(),
            attributeSetUseCase: sl<AttributeSetUseCase>(),
          ),
          child: BlocListener<OmBloc, OmState>(
            listener: (context, state) => _handleOmState(context, state),
            child: ImtForm(movementLines: _movementLines),
          ),
        ),
      ),
    );
  }

  void _handleOmState(BuildContext context, OmState state) {
    if (state is OmStateScanCanceled) {
      _showSnackBar(context, state.message, 'Scan canceled', Colors.amber);
    } else if (state is OmStateSerialNoDuplication) {
      _showSnackBar(context, state.message, '', Colors.amber);
    } else if (state is OmStateFailed) {
      _showSnackBar(context, state.message, 'Error');
    }
  }

  void _showSnackBar(BuildContext context, String message, String notify,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        content: RichText(
          text: TextSpan(
            children: [
              if (notify.isNotEmpty)
                TextSpan(
                    text: '$notify. ',
                    style: const TextStyle(color: Colors.white)),
              const TextSpan(
                  text: 'Click ', style: TextStyle(color: Colors.white)),
              TextSpan(
                text: 'here',
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => buildAlertDialog(
                        context,
                        title: notify.isNotEmpty ? notify : 'Details',
                        content: message,
                        proceedText: 'OK',
                        proceedCallback: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
              ),
              const TextSpan(
                  text: ' for details.', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        backgroundColor: color,
      ),
    );
  }
}
