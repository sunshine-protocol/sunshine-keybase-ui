import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunshine/sunshine.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _value = '0';
  final _numberFormat = NumberFormat.compactCurrency(
    decimalDigits: 0,
    symbol: '☼',
    name: 'Token',
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Home',
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: () {
            ExtendedNavigator.root.push(Routes.accountScreen);
          },
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 20.h.toDouble()),
          _TokensValue(_numberFormat.format(_numberFormat.parse(_value))),
          SizedBox(height: 4.h.toDouble()),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              '$_value Tokens',
              style: TextStyle(
                fontSize: 14.ssp.toDouble(),
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(height: 4.h.toDouble()),
          const Expanded(child: SizedBox()),
          Numpad(
            length: 16,
            onChange: (v) {
              setState(() {
                if (v.isEmpty) {
                  _value = '0';
                } else {
                  _value = v;
                }
              });
            },
          ),
          SizedBox(height: 30.h.toDouble()),
          Button(
            text: 'Transfer',
            enabled: int.parse(_value) > 0,
            onPressed: () {
              ExtendedNavigator.root.push(
                Routes.walletTransferScreen,
                arguments: WalletTransferScreenArguments(
                  amount: _value,
                ),
              );
            },
            variant: ButtonVariant.success,
          ),
          SizedBox(height: 70.h.toDouble()),
        ],
      ),
    );
  }
}

class _TokensValue extends StatelessWidget {
  const _TokensValue(String value) : _value = value;
  final String _value;
  static final TextStyle _textStyle = TextStyle(
    fontSize: 74.ssp.toDouble(),
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text(_value, style: _textStyle),
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }
}
