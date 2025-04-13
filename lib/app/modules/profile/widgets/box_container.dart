part of 'widgets.dart';

class BoxContainer extends StatelessWidget {
  const BoxContainer({
    super.key,
    required this.child,
    this.isShowHeader = false,
    this.isShowDivider = true,
    this.isLoading = false,
    this.headerTitle = '',
    this.headerButtonTitle = '',
    this.headerButtonTap,
    this.headerButtonIcon,
  });

  final Widget child;
  final bool isShowHeader, isShowDivider, isLoading;
  final IconData? headerButtonIcon;
  final String headerTitle, headerButtonTitle;
  final VoidCallback? headerButtonTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 4,
          ),
        ],
        border: Border.all(
          color: const Color(0xffD6DEED),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (isShowHeader) ...[
            Row(
              children: [
                headerTitle.text
                    .size(18)
                    .medium
                    .color(AppTheme.primary)
                    .make()
                    .expand(),
                isLoading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: Loading(padding: 0.0, strokeWidth: 2),
                      )
                    : Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: headerButtonTap,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            child: Row(
                              children: [
                                Icon(headerButtonIcon,
                                    color: AppTheme.secondary),
                                Dimes.width5,
                                headerButtonTitle.text
                                    .color(AppTheme.secondary)
                                    .size(16)
                                    .medium
                                    .make(),
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ),
            if (isShowDivider) const Divider(height: 20)
          ],
          child,
        ],
      ),
    );
  }
}
