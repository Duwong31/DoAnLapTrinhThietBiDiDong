import 'package:get/get.dart';
import '../core/styles/style.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.title,
    this.body,
    this.actions,
    this.leading,
    this.onBack,
  });
  final String title;
  final Widget? body, leading;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: .1,
        leading: IconButton(
          onPressed: onBack ?? Get.back,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: AppTheme.appBar,
        title: Text(
          title,
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
    );
  }
}
