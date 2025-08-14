import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import '../../../business_logic/cubit/setup_cubit.dart';

class SetupBody extends StatefulWidget {
  @override
  _SetupBodyState createState() => _SetupBodyState();
}

class _SetupBodyState extends State<SetupBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _host = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetupCubit, SetupState>(
      builder: (context, state) {
        if (state is SetupInitial) {
          return buildData(context, _host);
        } else if (state is SetupLoadInProgress) {
          return LoadingIndicator();
        } else if (state is SetupLoadSuccess) {
          return buildData(context, state.host);
        } else {
          return buildData(context, _host);
        }
      },
      listener: (context, state) {
        if (state is SetupStateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    );
  }

  Widget buildData(BuildContext context, String host) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(fontFamily: 'Montserrat'),
                decoration: const InputDecoration(labelText: 'Host'),
                keyboardType: TextInputType.url,
                initialValue: host,
                validator: (String? arg) {
                  if (arg == null || arg.isEmpty)
                    return 'Mandatory field';
                  else
                    return null;
                },
                onSaved: (String? val) {
                  _host = val ?? '';
                },
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _validateInputs(context),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: purewhiteTheme,
                      fontFamily: 'Oswald',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInputs(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      BlocProvider.of<SetupCubit>(context).saveHost(_host);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
