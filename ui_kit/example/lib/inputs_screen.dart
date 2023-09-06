import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

class InputsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InputsScreenState();
}

class InputsScreenState extends State<InputsScreen> {
  final phoneController = TextEditingController(text: '+998915443699');
  late final amountBigController = AmountBigController(
    symbol: ' сум',
    focusNode: amountBigFocus,
    hintText: '500 - 1 500 000',
  );

  final cardOrPhoneController = TextEditingController();
  final searchController = TextEditingController();
  final ordinatyController = TextEditingController();
  final cardOrPhoneFocus = FocusNode();
  final seearchFocus = FocusNode();

  final ordinatyFocus = FocusNode();

  final phoneInputFocus = FocusNode();

  final amountBigFocus = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    phoneController.dispose();
    cardOrPhoneController.dispose();
    amountBigController.dispose();
    ordinatyController.dispose();

    cardOrPhoneFocus.dispose();
    phoneInputFocus.dispose();
    ordinatyFocus.dispose();
    amountBigFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Card Phone Input',
                style: Typographies.title5,
              ),
              SearchInputV2(
                controller: searchController,
                focusNode: seearchFocus,
                hintText: 'Введите имя',

              ),
              Text(
                'Ordinary Input',
                style: Typographies.title5,
              ),
              OrdinaryInput(
                controller: ordinatyController,
                focusNode: ordinatyFocus,
                label: 'Label',
                helperText: 'Helper text',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return 'Error';
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Phone Input',
                style: Typographies.title5,
              ),
              PhoneInput(
                onGetContactTap: () => Future.value('+998112345588'),
                controller: phoneController,
                focusNode: phoneInputFocus,
                validator: (v) => v,
              ),
              Text(
                'Amoint Big Input',
                style: Typographies.title5,
              ),
              AmountBigInput(
                amountController: amountBigController,
                focusNode: amountBigFocus,
              ),
              Text(
                'Card Phone Input',
                style: Typographies.title5,
              ),
              CardOrPhoneInput(
                controller: cardOrPhoneController,
                focusNode: cardOrPhoneFocus,
                onGetContactTap: () async {
                  return '915443699';
                },
                onScanCardTap: () async {
                  return '9860111199993333';
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
