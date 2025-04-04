import '../styles/style.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.title, this.onTap});
  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          title.text.color(context.primary).medium.size(20).make().expand(),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}
