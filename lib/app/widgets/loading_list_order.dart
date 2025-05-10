import 'package:shimmer/shimmer.dart';

import '../core/styles/style.dart';

class LoadingListOrder extends StatelessWidget {
  const LoadingListOrder(
    this.itemCount, {
    super.key,
    this.isScroll = true,
  });

  final int itemCount;
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        physics: isScroll
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (_, __) => VxBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 10, width: 100, color: Colors.white),
                        Dimes.height5,
                        Container(height: 15, width: 100, color: Colors.white),
                      ],
                    ),
                  ),
                  VxBox().size(80, 30).white.withRounded(value: 16).make(),
                ],
              ),
              const Divider(color: Color(0xffEFE6D8)),
              Wrap(
                runSpacing: 10,
                children: [
                  for (int i = 0; i < 3; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 10, width: 100, color: Colors.white),
                        Dimes.height3,
                        Container(
                          height: 20,
                          width: context.screenWidth,
                          color: Colors.white,
                        ),
                      ],
                    )
                ],
              )
            ],
          ),
        )
            .margin(Vx.mOnly(bottom: 12.0))
            .padding(Vx.mSymmetric(v: 15, h: 15))
            .width(double.infinity)
            .color(Colors.grey)
            .withRounded(value: 10)
            .make(),
      ),
    );
  }
}
