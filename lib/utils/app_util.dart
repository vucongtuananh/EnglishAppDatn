

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AppUtil {
  static final String DATABASE_VERSION = '';
  // static final String titleNoPermission = "no_permission".tr();

  static int AppRatingRequestInterval = 31 * 1000 * 60 * 60 * 24; // 1 tháng
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  static pushPage(page) {
    return navigatorKey.currentState!.push(
      CupertinoPageRoute(
        builder: (_) {
          return page;
        },
      ),
    );
  }



  static void showToastError(String msg) {
    showToast(msg, AppStyle.color.danger, Colors.white, 2, ToastGravity.TOP);
  }

  static void showToastSuccess(String msg) {
    showToast(msg, AppStyle.color.success, Colors.white, 2, ToastGravity.TOP);
  }

  static void showToastNotification(String msg) {
    showToast(msg, AppStyle.color.primary, Colors.white, 2, ToastGravity.TOP);
  }

  static void showToast(String msg, dynamic _backgroundColor, dynamic _textColor, int _timeInSecForIosWeb, ToastGravity _gravity) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: _gravity, timeInSecForIosWeb: _timeInSecForIosWeb, backgroundColor: _backgroundColor, textColor: _textColor, fontSize: 16.0);
  }

  static void showToastInformation(String msg) {
    showToast(msg, AppStyle.color.info, Colors.white, 2, ToastGravity.BOTTOM);
  }

  static String toLocaleString(dynamic value, {bool currency = true, bool revenue = false, bool isString = false, shortValue = false}) {
    dynamic val = value != null ? value : 0;
    var result = '';

    if (isString) {
      val = int.tryParse(val) ?? 0;
      result = NumberFormat.currency(locale: 'vi').format(val);
    }

    if (revenue) {
      if (val >= 1000000000000) {
        result = NumberFormat("#,###").format((val / 1000000000).toInt()) + "tỷ";
      } else {
        result = NumberFormat.compact().format(val).replaceAll("M", "tr").replaceAll("B", "tỷ").replaceAll("K", "k");
      }
    } else if (currency) {
      result = NumberFormat.currency(locale: 'vi').format(val);
    } else
      result = NumberFormat("#,###").format(val);
    if (shortValue) result = result.replaceAll("VND", "đ");
    return result;
  }

  static String formatNumber(String s) => s != "" ? NumberFormat.decimalPattern('vi').format(int.parse(s.replaceAll('.', ''))) : "";

  static bool isVietnamese(String? str) {
    if (str != null && str != "") {
      var VNchars = ' ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ';
      var arrStr = str.split('');
      int index = arrStr.length - 1;
      while (index > -1) {
        if (VNchars.indexOf(arrStr[index]) != -1) {
          return true;
        }
        index -= 1;
      }
    }
    return false;
  }

  static widthScreen() {
    return MediaQuery.of(AppUtil.navigatorKey.currentContext!).size.width;
  }

  static String? removeVnchar(String? str) {
    var VietNamChar = ["aAeEoOuUiIdDyY", "áàạảãâấầậẩẫăắằặẳẵ", "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ", "éèẹẻẽêếềệểễ", "ÉÈẸẺẼÊẾỀỆỂỄ", "óòọỏõôốồộổỗơớờợởỡ", "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ", "úùụủũưứừựửữ", "ÚÙỤỦŨƯỨỪỰỬỮ", "íìịỉĩ", "ÍÌỊỈĨ", "đ", "Đ", "ýỳỵỷỹ", "ÝỲỴỶỸ"];
    //Thay thế và lọc dấu từng char
    for (int i = 1; i < VietNamChar.length; i++) {
      for (int j = 0; j < VietNamChar[i].length; j++) {
        str = str!.replaceAll(VietNamChar[i][j], VietNamChar[0][i - 1]);
      }
    }
    return str;
  }

  static unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(AppUtil.navigatorKey.currentContext!);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) currentFocus.focusedChild!.unfocus();
  }

  // static isAdminOrManager({permission}) {
  //   if (DataClient.salework.currentUser == null) return false;
  //   if (DataClient.salework.currentUser!.admin!) {
  //     if (permission != null) permission.add("chart_admin");
  //     return true;
  //   }
  //   for (var value in DataClient.salework.currentUser!.role!.permissions!) {
  //     if (value.code == "EMPLOYEE_ACCOUNT_MANAGE" || value.code == "INVENTORY_REPORT" || value.code == "FINANCE_MANAGE" || value.code == "FINANCE_DASHBOARD") {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // static popupRatingApp() async {
  //   Future(() => showDialog(
  //       context: AppUtil.navigatorKey.currentContext!,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(4), // Bỏ border
  //           ),
  //           contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //           title: Center(
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   width: 60,
  //                   height: 60,
  //                   child: Image(image: AssetImage('lib/images/inforact.png')),
  //                 ),
  //                 SizedBox(
  //                   height: 12,
  //                 ),
  //                 Text(
  //                   'rating_title'.tr(),
  //                   style: TextStyle(
  //                     fontSize: AppStyle.dimen.fontSizeTitle,
  //                     color: AppStyle.color.textDark,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           content: Container(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   "rating_message_1".tr(),
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: AppStyle.color.textMuted,
  //                     fontSize: AppStyle.dimen.fontSizeBody,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 8,
  //                 ),
  //                 Text(
  //                   "rating_message_2".tr(),
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: AppStyle.color.textMuted,
  //                     fontSize: AppStyle.dimen.fontSizeButton,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Text(
  //                   "rating_message_3".tr(),
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: AppStyle.color.textMuted,
  //                     fontSize: AppStyle.dimen.fontSizeButton,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     inAppReview.openStoreListing(appStoreId: '1563351759');
  //                     Navigator.pop(context, false);
  //                   },
  //                   child: Container(
  //                     height: 48,
  //                     margin: EdgeInsets.symmetric(horizontal: 8),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(8),
  //                       color: AppStyle.color.primary,
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         'rate_now'.tr(),
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             // fontSize: AppStyle.dimen.fontSizeButton,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 8),
  //               ],
  //             ),
  //           ),
  //         );
  //       }));
  // }

  // static askToReview() async {
  //   String? lastReviewTime = await SettingRepository.get("lastReviewRequestTime");
  //   if (lastReviewTime == null || int.parse(lastReviewTime) - DateTime.now().millisecondsSinceEpoch > AppRatingRequestInterval) {
  //     //1week
  //     await SettingRepository.add(AppSetting(name: "lastReviewRequestTime", val: DateTime.now().millisecondsSinceEpoch.toString()));
  //     Future.delayed(Duration(seconds: 15)).then((value) async {
  //       if (await inAppReview.isAvailable()) {
  //         inAppReview.requestReview();
  //       }
  //     });
  //   }
  // }

  // static openLink(link) {
  //   launch(link);
  // }

  static updatePhone(dataPhone) {
    String phone = dataPhone;
    if (phone != '') {
      if (phone.startsWith("(+84)")) {
        phone = phone.substring(5);
      } else if (phone.startsWith("+84")) {
        phone = phone.substring(3);
      } else if (phone.startsWith("84")) {
        phone = phone.substring(2);
      }
      if (!phone.startsWith("0")) {
        phone = "0" + phone;
      }
    }
    return phone;
  }
}
