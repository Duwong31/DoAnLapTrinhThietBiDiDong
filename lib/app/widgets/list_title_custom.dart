import 'package:barcode_widget/barcode_widget.dart';

import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';
import 'app_button.dart';

class ListTitleCustom extends StatelessWidget {
  const ListTitleCustom({
    super.key,
    this.title,
    this.status,
    this.content,
    this.isShowMap = false,
    this.isBarCode = false,
    this.showBorder = true,
    this.showTracking = false,
    this.quantity = 0,
    this.statusColor = AppTheme.primary,
    this.trackingUrl,
    this.trackingTap,
    this.copayment,
  });
  final String? title, content, status;
  final bool isShowMap, isBarCode, showBorder, showTracking;
  final int quantity;
  final Color statusColor;
  final String? trackingUrl, copayment;
  final VoidCallback? trackingTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (title ?? '')
                      .text
                      .size(11)
                      .minFontSize(11)
                      .semiBold
                      .color(AppTheme.titleColor)
                      .make(),
                  Dimes.height3,
                  Row(
                    children: [
                      if (status != null)
                        status!.text
                            .color(statusColor)
                            .semiBold
                            .size(13)
                            .make()
                            .box
                            .padding(Vx.mSymmetric(v: 6, h: 12))
                            .border(color: statusColor, width: 2)
                            .withRounded(value: 20)
                            .make()
                            .pOnly(right: 5, top: 5),
                      if (isShowMap)
                        Image.asset(AppImage.map, height: 16).pOnly(right: 10),
                      if (isBarCode)
                        BarcodeWidget(
                          barcode: Barcode.code93(),
                          data: "HELLO WORLD",
                          width: context.screenWidth * .5,
                          drawText: false,
                          height: 45,
                        ),
                      if (!isBarCode)
                        (content ?? '-')
                            .text
                            .medium
                            .size(16)
                            .color(AppTheme.primary)
                            .make()
                            .expand(),
                    ],
                  ),
                ],
              ),
            ),
            if (quantity != 0)
              Column(
                children: [
                  'Quantity'
                      .text
                      .size(11)
                      .minFontSize(11)
                      .semiBold
                      .color(AppTheme.titleColor)
                      .make(),
                  '$quantity'
                      .text
                      .medium
                      .size(16)
                      .color(AppTheme.primary)
                      .make()
                ],
              ),
            if (showTracking)
              SizedBox(
                width: 150,
                height: 42,
                child: AppButton(
                  'Track Delivery',
                  onPressed: trackingTap,
                ),
              ),
          ],
        ),
        if (showBorder) const Divider(),
      ],
    );
  }
}
