import 'package:flutter/material.dart';
import 'package:sunshine/sunshine.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  AccountService _accountService;
  TextEditingController _passwordController;
  TextEditingController _passwordAgainController;
  String _errText;
  @override
  void initState() {
    super.initState();
    _accountService = GetIt.I.get<AccountService>();
    _passwordController = TextEditingController();
    _passwordAgainController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Update Password'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FittedBox(
            fit: BoxFit.fitWidth,
            child: HeaderText('Enter your new password'),
          ),
          SizedBox(height: 30.h.toDouble()),
          Input(
            hintText: 'Password',
            obscureText: true,
            errorText: _errText,
            controller: _passwordController,
            onChanged: (v) {
              if (_errText != null) {
                setState(() {
                  _errText = null;
                });
              }
            },
          ),
          SizedBox(height: 14.h.toDouble()),
          Input(
            hintText: 'Password Again',
            obscureText: true,
            errorText: _errText,
            controller: _passwordAgainController,
            onChanged: (v) {
              if (_errText != null) {
                setState(() {
                  _errText = null;
                });
              }
            },
          ),
          SizedBox(height: 30.h.toDouble()),
          const Center(
            child: HintText('Password must be at least 8 characters'),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Builder(
            builder: (context) => Button(
              text: 'Update',
              variant: ButtonVariant.success,
              onPressed: () => _updatePassword(context),
            ),
          ),
          SizedBox(height: 15.h.toDouble())
        ],
      ),
    );
  }

  Future<void> _updatePassword(BuildContext context) async {
    final isLessThan8 = _passwordController.text.length < 8 ||
        _passwordAgainController.text.length < 8;
    if (isLessThan8) {
      setState(() {
        _errText = 'Please choose a password that at least 8 characters';
      });
      return;
    }
    if (_passwordController.text != _passwordAgainController.text) {
      setState(() {
        _errText = 'Passwords dose not match';
      });
      return;
    }
    // hide keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final changed = await _accountService.updatedPassword(
        _passwordController.text,
      );
      if (changed) {
        await Future.delayed(
          const Duration(milliseconds: 50),
          () async {
            const snackbar = SnackBar(
              content: Text('Password Updated..'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            );
            final result = Scaffold.of(context).showSnackBar(snackbar);
            await result.closed;
            ExtendedNavigator.root.pop();
          },
        );
      } else {
        const snackbar = SnackBar(
          content: Text('Failed to update your password..'),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 5),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      }
    } catch (_) {
      const snackbar = SnackBar(
        content: Text("Couldn't update your password"),
        backgroundColor: AppColors.danger,
        duration: Duration(seconds: 5),
      );
      final result = Scaffold.of(context).showSnackBar(snackbar);
      await result.closed;
      ExtendedNavigator.root.pop();
    }
  }
}
