import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vending_standalone/src/constants/colors.dart';

class SystemUiStyle {
  static const overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

class MaterialTheme {
  static final theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: ColorsTheme.primary,
    fontFamily: 'Anuphan',
  );
}

class CustomPadding {
  static const paddingAll_10 = EdgeInsets.all(10.0);
  static const paddingAll_15 = EdgeInsets.all(15.0);
  static const paddingSymmetricInput =
      EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0);
}

class CustomMargin {
  static const marginAll_1 = EdgeInsets.all(10.0);
  static const marginSymmetricVertical_1 = EdgeInsets.symmetric(vertical: 10.0);
  static const marginSymmetricVertical_2 = EdgeInsets.symmetric(vertical: 5.0);
  static const marginSymmetricVertical_3 = EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
}

class CustomGap {
  static const smallHeightGap = SizedBox(height: 10.0);
  static const mediumHeightGap = SizedBox(height: 30.0);
  static const largeHeightGap = SizedBox(height: 50.0);

  static const smallWidthGap = SizedBox(width: 5.0);
  static const mediumWidthGap = SizedBox(width: 30.0);
  static const largeWidthGap = SizedBox(width: 50.0);

  static const smallWidthGap_1 = SizedBox(width: 10.0);
}

class CustomRadius {
  static final smallRadius = BorderRadius.circular(18.0);
}

class CustomInputStyle {
  static const headerTitle = TextStyle(
    fontSize: 42.0,
    fontWeight: FontWeight.bold,
    color: ColorsTheme.primary,
  );

  static const headerDescription = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: ColorsTheme.grey,
  );

  // input
  static const inputWidth = double.infinity;
  static const inputHeight = 70.0;

  static const inputWidthPopup = 180.0;
  static const inputHeightPopup = 65.0;

  static final inputBoxdecoration = BoxDecoration(
    // color: Colors.white,
    border: Border.all(width: 2, color: ColorsTheme.blackAlpha),
    borderRadius: CustomRadius.smallRadius,
  );

  static final buttonBoxdecoration = BoxDecoration(
    color: ColorsTheme.primary,
    borderRadius: CustomRadius.smallRadius,
  );

  static final buttonBoxdecorationCancel = BoxDecoration(
    color: ColorsTheme.error,
    borderRadius: CustomRadius.smallRadius,
  );

  static final buttonBoxdecorationDisable = BoxDecoration(
    color: ColorsTheme.grey,
    borderRadius: CustomRadius.smallRadius,
  );

  static const inputStyle = TextStyle(
    fontSize: 24.0,
    color: ColorsTheme.grey,
  );

  static const inputHintStyle = TextStyle(
    fontSize: 20.0,
    color: ColorsTheme.grey,
  );

  static const textButtonStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
}

class ManageUserStyle {}
