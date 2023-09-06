import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/quick_actions_shimmer.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uikit;

class FavoriteList extends StatelessWidget {
  const FavoriteList({
    required this.favoritesState,
    required this.createFavorite,
    required this.onFavoriteTap,
    required this.openFavorites,
    super.key,
  });

  final EntityStateNotifier<List<FavoriteEntity>> favoritesState;

  final VoidCallback createFavorite;

  final void Function(FavoriteEntity favorite) onFavoriteTap;

  final VoidCallback openFavorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: openFavorites,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: uikit.HeadlineV2.Chevron(
              title: locale.getText('templates'),
            ),
          ),
        ),
        EntityStateNotifierBuilder<List<FavoriteEntity>>(
          listenableEntityState: favoritesState,
          loadingBuilder: (context, state) {
            return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 124),
              child: const QuickActionsShimmer(
                itemCount: 3,
              ),
            );
          },
          builder: (context, state) {
            state = state ?? [];

            final favoritesList = <Widget>[];

            for (int i = 0; i < state.length; i++) {
              favoritesList.add(
                GestureDetector(
                  onTap: () => onFavoriteTap(state![i]),
                  child: state[i].isTransfer
                      ? uikit.QuickActionButtonV2.TransfersIcon(
                          key: Key(
                              '${WidgetIds.paymentsTransferTemplateList}_$i'),
                          text: favoriteTemplateName(state[i]),
                        )
                      : uikit.QuickActionButtonV2(
                          key: Key(
                              '${WidgetIds.paymentsFavoriteTemplateList}_$i'),
                          text: favoriteTemplateName(state[i]),
                          icon: CircleImage(
                            merchantId: state[i].merchantData!.merchantId,
                          ),
                        ),
                ),
              );
            }

            return uikit.QuickActionButtonsSliderV2(
              children: [
                Row(
                  children: favoritesList,
                ),
                GestureDetector(
                  key: const Key(WidgetIds.paymentsAddNewTemplate),
                  onTap: createFavorite,
                  child: uikit.QuickActionButtonV2.PlusIcon(
                    text: locale.getText('new_template'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
