import 'package:finance_app/presentation/components/components.dart';
import 'package:finance_app/presentation/modules/settings/settings.dart';
import 'package:finance_app/presentation/modules/transaction/widgets/add_transaction_action_widget.dart';
import 'package:finance_app/presentation/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  String _amount = '';

  static const _segments = [
    SegmentItem<TransactionType>(
      value: TransactionType.expense,
      label: 'Expense',
      icon: Icons.arrow_downward,
    ),
    SegmentItem<TransactionType>(
      value: TransactionType.income,
      label: 'Income',
      icon: Icons.arrow_upward,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>().currency;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add Transaction'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizing.defaultPadding),
            child: PrimaryButton(
              text: 'Save',
              size: PrimaryButtonSize.xSmall,
              rounded: true,
              fullWidth: false,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizing.spaceBtwSections),
              SegmentedControl<TransactionType>(
                segments: _segments,
                height: AppSizing.heightM,
                selectedValue: TransactionType.expense,
                onChanged: (_) {},
              ),
              const SizedBox(height: AppSizing.spaceBtwSections),
              AmountDisplay(amount: _amount, currency: currency),
              const Spacer(),
              AddTransactionActionWidget(),
              const SizedBox(height: AppSizing.spaceBtwElements),
              AmountKeyboard(onKeyPressed: _onKeyPressed),
            ],
          ),
        ),
      ),
    );
  }

  void _onKeyPressed(String key) {
    if (key == 'backspace') {
      if (_amount.isNotEmpty) {
        setState(() => _amount = _amount.substring(0, _amount.length - 1));
      }
      return;
    }

    if (key == '.') {
      if (_amount.contains('.') || _amount.contains(',')) return;
      final currency = context.read<CurrencyProvider>().currency;
      final decimalSep = currency.decimalSeparator == DecimalSeparator.comma
          ? ','
          : '.';
      setState(() {
        _amount = _amount.isEmpty ? '0$decimalSep' : '$_amount$decimalSep';
      });
      return;
    }

    final currency = context.read<CurrencyProvider>().currency;
    if (_amount.contains('.') || _amount.contains(',')) {
      final parts = _amount.split(RegExp(r'[.,]'));
      if (parts.length == 2 && parts[1].length >= currency.decimalPlaces) {
        return;
      }
    } else if (_amount.length >= 12) {
      return;
    }

    setState(() {
      if (_amount.isEmpty || _amount == '0') {
        _amount = key == '0' ? '0' : key;
      } else {
        _amount = '$_amount$key';
      }
    });
  }
}

enum TransactionType { income, expense }
