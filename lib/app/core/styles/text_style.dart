import 'style.dart';

enum TGTextStyle { header, title, title2, body, body2, body3 }

extension TextStyle on VxTextBuilder {
  VxTextBuilder style(TGTextStyle style) {
    color(AppTheme.labelColor);
    switch (style) {
      case TGTextStyle.header:
        bold.size(32);
        break;
      case TGTextStyle.title:
        bold.size(16);
        break;
      case TGTextStyle.title2:
        bold.size(17);
        break;
      case TGTextStyle.body:
        bold.size(14);
        break;
      case TGTextStyle.body2:
        size(14);
        break;
      case TGTextStyle.body3:
        size(12);
        break;
      default:
    }
    return this;
  }
}
