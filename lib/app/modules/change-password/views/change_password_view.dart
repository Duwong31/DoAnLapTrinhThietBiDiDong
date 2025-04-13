// import 'package:get/get.dart';

// import '../../../core/styles/style.dart';
// import '../../../widgets/app_button.dart';
// import '../../../widgets/bottom_well_success.dart';
// import '../../../widgets/input_custom.dart';
// import '../../../widgets/main_scaffold.dart';
// import '../controllers/change_password_controller.dart';

// class ChangePasswordView extends GetView<ChangePasswordController> {
//   const ChangePasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       title: 'CHANGE PASSWORD',
//       leading: IconButton(
//         onPressed: Get.back,
//         icon: const Icon(Icons.arrow_back_ios),
//       ),
//       body: const SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           padding: EdgeInsets.all(20),
//           child: Wrap(
//             runSpacing: 20,
//             children: [
//               InputCustom(
//                 hintText: 'Old Password',
//                 isPassword: true,
//                 isShowSuffixIcon: true,
//               ),
//               InputCustom(
//                 hintText: 'New Password',
//                 isPassword: true,
//                 isShowSuffixIcon: true,
//               ),
//               InputCustom(
//                 hintText: 'New Password Confirm',
//                 isPassword: true,
//                 isShowSuffixIcon: true,
//               ),
//               AppButton(
//                 'UPDATE',
//                 onPressed: () {
//                   BottomWellSuccess.show(
//                     'Your password has been changed successfully.',
//                     buttonTitle: 'LOGIN',
//                     callback: () {
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
