part of 'widgets.dart';

class AddressItem extends StatelessWidget {
  const AddressItem({
    super.key,
    this.title = '',
    this.content = '',
    this.activated = false,
    this.loading = false,
    this.onTap,
  });
  final String title, content;
  final bool activated, loading;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 60,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      )
                    : Image.asset(
                        activated ? AppImage.check : AppImage.empty,
                        color: activated
                            ? AppTheme.secondary
                            : AppTheme.deactivate,
                        width: 20,
                      ),
                Dimes.width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty)
                        title.text
                            .size(11)
                            .minFontSize(11)
                            .color(AppTheme.deactivate)
                            .make(),
                      content.text
                          .size(16)
                          .medium
                          .color(AppTheme.primary)
                          .make(),
                      Dimes.height10,
                      const Divider(height: 1),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
