part of '../styles/style.dart';

extension ContextEx on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  double get scale => MediaQuery.of(this).devicePixelRatio;
  Orientation get orientation => MediaQuery.of(this).orientation;
  Color get dividerColor => Theme.of(this).dividerColor;
  Color get canvasColor => Theme.of(this).canvasColor;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  Size get size => MediaQuery.of(this).size;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  Color get primary => colorScheme.primary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get secondary => colorScheme.secondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get surface => colorScheme.surface;
  Color get background => colorScheme.background;
  Color get error => colorScheme.error;
  Color get onPrimary => colorScheme.onPrimary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onSurface => colorScheme.onSurface;
  Color get onBackground => colorScheme.onBackground;
  Color get onError => colorScheme.onError;

  TextStyle get overline => textTheme.labelSmall!;
  TextStyle get caption => textTheme.bodySmall!;
  TextStyle get button => textTheme.labelLarge!;
  TextStyle get bodyText2 => textTheme.bodyMedium!;
  TextStyle get bodyText1 => textTheme.bodyLarge!;
  TextStyle get subtitle2 => textTheme.titleSmall!;
  TextStyle get subtitle1 => textTheme.titleMedium!;
  TextStyle get headline1 => textTheme.displayLarge!;
  TextStyle get headline2 => textTheme.displayMedium!;
  TextStyle get headline3 => textTheme.displaySmall!;
  TextStyle get headline4 => textTheme.headlineMedium!;
  TextStyle get headline5 => textTheme.headlineSmall!;
  TextStyle get headline6 => textTheme.titleLarge!;

  double get width => size.width;
  double get height => size.height;

  double get widthScale => width > height ? height : width;

  double get heightScale => width < height ? height : width;

  int get widthPixels => (width * height).toInt();
  int get heightPixels => (height * scale).toInt();
}

extension FileExt on String {
  Uint8List get toBytes => File(this).readAsBytesSync();
  File get toFile => File(this);
}

class HexColor extends Color {
  static int _getColorFromHex(String? hexColor) {
    hexColor = hexColor ?? 'ffffff';
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String? hexColor) : super(_getColorFromHex(hexColor));
}

extension IntExt on int {
  DateTime get toDate => DateTime.fromMillisecondsSinceEpoch(this);

  String get unread => this > 99 ? '99+' : '$this';
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  String get capitalizeFirstEach =>
      split(" ").map((str) => str.inCaps).join(" ");
}
extension DiscountTypeExtension on DiscountType {
  static DiscountType? fromString(String? status) {
    if(status==null) return null;
    switch (status.toLowerCase()) {
      case 'fixed':
        return DiscountType.fixed;
      case 'percent':
        return DiscountType.percent;
      default:
        return null;
    }
  }
}
extension EventTypeExtension on EventType {
  static EventType? fromString(String? event) {
    if(event==null) return null;
    switch (event) {
      case 'BookingCreatedEvent':
        return EventType.bookingCreatedEvent;
      case 'BookingUpdatedEvent':
        return EventType.bookingUpdatedEvent;
      case 'BookingCancelledEvent':
        return EventType.bookingCancelledEvent;
      case 'BookingPickupTimeEvent':
        return EventType.bookingPickupTimeEvent;
      case 'BookingReturnLateEvent':
        return EventType.bookingReturnLateEvent;
      case 'BookingInvoiceEvent':
        return EventType.bookingInvoiceEvent;
      case 'CreateReviewEvent':
        return EventType.createReviewEvent;
      case 'PaymentSuccessEvent':
        return EventType.paymentSuccessEvent;
      default:
        return null;
    }
  }
}
