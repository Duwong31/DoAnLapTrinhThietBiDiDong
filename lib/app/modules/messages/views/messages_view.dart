import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_loading_list_content.dart';
import '../../../widgets/widgets.dart';
import '../controllers/messages_controller.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView>
    with AutomaticKeepAliveClientMixin {
  MessagesController get ctr => Get.find();
  @override
  void initState() {
    Get.lazyPut<MessagesController>(() => MessagesController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: ctr.getList,
            child: ctr.obx(
              (state) => ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state!.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = state[index];
                  return _MessageItem(item);
                },
              ),
              onLoading: const AppLoadingListContent(10),
              onEmpty: LayoutBuilder(
                builder: (_, BoxConstraints constraints) {
                  final height = constraints.maxHeight;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: height,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message,
                            size: context.screenHeight * 0.2,
                            color: Colors.grey,
                          ),
                          'Your messages will appear here'
                              .text
                              .gray400
                              .size(16)
                              .make(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MessageItem extends StatelessWidget {
  const _MessageItem(this.item);
  final MessageModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.chatBox,
          parameters: {'id': item.id, 'name': item.name},
        );
      },
      child: Padding(
        padding: Vx.mSymmetric(h: 20),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  AppUtils.getInitials(item.name)
                      .text
                      .color(AppTheme.appBarTintColor)
                      .bold
                      .makeCentered()
                      .box
                      .color(AppTheme.appBar)
                      .roundedFull
                      .size(50, 50)
                      .border()
                      .make(),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: VxBox()
                  //       .size(12, 12)
                  //       .border(color: Colors.white, width: 2)
                  //       .green500
                  //       .roundedFull
                  //       .make()
                  //       .marginOnly(right: 5),
                  // )
                ],
              ),
            ),
            Dimes.width10,
            Expanded(
                child: Padding(
              padding: Vx.mSymmetric(v: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: item.name.text
                            .color(AppTheme.primary)
                            .medium
                            .size(16)
                            .make(),
                      ),
                      item.date.text.italic
                          .size(13)
                          .color(AppTheme.labelColor)
                          .make(),
                    ],
                  ),
                  Dimes.height10,
                  const Divider(height: .5, thickness: .5),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
