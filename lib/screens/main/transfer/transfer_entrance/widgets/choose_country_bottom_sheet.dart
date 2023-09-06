import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_country_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/widgets/common_list_item.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

typedef OnCountrySelected = void Function(AbroadTransferCountryEntity);

class ChooseAbroadTransferCountryBottomSheet extends StatelessWidget {
  final List<AbroadTransferCountryEntity> abroadTransferCountries;
  final OnCountrySelected onCountrySelected;

  const ChooseAbroadTransferCountryBottomSheet(
      {Key? key,
      required this.abroadTransferCountries,
      required this.onCountrySelected})
      : super(key: key);

  static Future show({
    required BuildContext context,
    required List<AbroadTransferCountryEntity> abroadTransferCountries,
    required OnCountrySelected onCountrySelected,
  }) =>
      viewModalSheet(
        context: context,
        child: ChooseAbroadTransferCountryBottomSheet(
          abroadTransferCountries: abroadTransferCountries,
          onCountrySelected: onCountrySelected,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.unit2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.unit2),
          Text(
            locale.getText('where_to_transfer'),
            style: TextStyles.title4,
          ),
          const SizedBox(height: Dimensions.unit3_5),
          countryList(),
        ],
      ),
    );
  }

  Widget countryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: abroadTransferCountries.length,
      itemBuilder: (_, int index) {
        final country = abroadTransferCountries[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonListItem(
              key: Key(
                  '${WidgetIds.transferEntranceTransferCountriesList}_$index'),
              icon: country.icon,
              bodyText: country.country.countryLabel,
              onTap: () => onCountrySelected(country),
            ),
            const SizedBox(height: Dimensions.unit3),
          ],
        );
      },
    );
  }
}
