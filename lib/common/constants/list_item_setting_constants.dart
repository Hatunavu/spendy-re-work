import 'package:spendy_re_work/presentation/journey/personal/dashboard/personal_page_constants.dart';

import 'icon_constants.dart';

class ItemPersonalEntity {
  final String icon;
  final String name;
  final int? id;
  ItemPersonalEntity({this.id, this.icon = '', this.name = ''});
}

class ListItemPersonal {
  static List<ItemPersonalEntity> listItemPersonal = [
    ItemPersonalEntity(
        name: PersonalPageConstants.textCategoryMenu,
        icon: IconConstants.categoryIcon,
        id: 0),
    ItemPersonalEntity(
        name: PersonalPageConstants.group, icon: IconConstants.icGroup, id: 1),
    ItemPersonalEntity(
        name: PersonalPageConstants.textCurrency,
        icon: IconConstants.currencyIcon,
        id: 2),
    ItemPersonalEntity(
        name: PersonalPageConstants.textNotification,
        icon: IconConstants.notificationIcon,
        id: 3),
    ItemPersonalEntity(
        name: PersonalPageConstants.textSecurity,
        icon: IconConstants.securityIcon,
        id: 4),
    ItemPersonalEntity(
        name: PersonalPageConstants.textShare,
        icon: IconConstants.shareIcon,
        id: 5),
    ItemPersonalEntity(
        name: PersonalPageConstants.textHelpSupport,
        icon: IconConstants.helpIcon,
        id: 6),
    ItemPersonalEntity(
        name: PersonalPageConstants.textReview,
        icon: IconConstants.reviewIcon,
        id: 7),
    ItemPersonalEntity(
        name: PersonalPageConstants.textPolicy,
        icon: IconConstants.policyIcon,
        id: 8),
  ];
}
