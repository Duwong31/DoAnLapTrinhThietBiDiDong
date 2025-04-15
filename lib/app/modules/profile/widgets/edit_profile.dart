part of 'widgets.dart';

class EditProfileBottom extends StatefulWidget {
  const EditProfileBottom({super.key});
  static void showBottom() {
    Get.bottomSheet(
      const EditProfileBottom(),
      isScrollControlled: true,
    );
  }

  @override
  State<EditProfileBottom> createState() => _EditProfileBottomState();
}

class _EditProfileBottomState extends State<EditProfileBottom> {
  ProfileController get ctr => Get.find();
  final _formKey = GlobalKey<FormState>();
  final _stateObx = RxStatus.success().obs;
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _birthDay;
  late TextEditingController _email;
  late TextEditingController _gender;
  late TextEditingController _mediaRecord;

  DateTime? birthDay;
  @override
  void initState() {
    _firstName = TextEditingController(text: ctr.user.value?.firstName);
    _lastName = TextEditingController(text: ctr.user.value?.lastName);
    _birthDay = TextEditingController(text: ctr.user.value?.birthDay);
    _email = TextEditingController(text: ctr.user.value?.email);
    _gender = TextEditingController(text: ctr.user.value?.gender);
    _mediaRecord =
        TextEditingController(text: ctr.user.value?.medicalRecordNumber);

    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _birthDay.dispose();
    _gender.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<DateTime?> _showDatePicker() async {
    final startDate = DateTime.now();
    var selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      initialDate: birthDay ?? startDate,
      lastDate: DateTime.now(),
    );

    return selectedDate;
  }

  Future<void> updateUser() async {
    Get.focusScope?.unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        _stateObx.value = RxStatus.loading();
        final data = {
          "recipient": UserModel(
            firstName: _firstName.text,
            lastName: _lastName.text,
            dateOfBirth: birthDay,
            email: _email.text,
            gender: _gender.text.toLowerCase(),
            medicalRecordNumber: _mediaRecord.text,
          ).toMap()
        };
        final res = await Repo.user.updateUser(data);
        if (res != null) {
          Get.back();
          ctr.getUserDetail();
          BottomWellSuccess.show('Your profile has been updated successfully.');
        }
        _stateObx.value = RxStatus.success();
      } catch (e) {
        _stateObx.value = RxStatus.success();
        AppUtils.toast(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * .9,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxBox()
                .size(38, 5)
                .color(AppTheme.primary)
                .withRounded(value: 20)
                .makeCentered(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                child: Wrap(
                  runSpacing: 15,
                  children: [
                    'Edit Profile'
                        .text
                        .size(20)
                        .medium
                        .color(AppTheme.secondary)
                        .make()
                        .pSymmetric(v: 15),
                    InputCustom(
                      controller: _firstName,
                      prefixIcon: Image.asset(AppImage.worker),
                      isShowPrefixIcon: true,
                      hintText: 'First Name',
                      validator: (val) {
                        return val!.isEmpty ? 'Required' : null;
                      },
                    ),
                    InputCustom(
                      controller: _lastName,
                      prefixIcon: Image.asset(AppImage.worker),
                      isShowPrefixIcon: true,
                      hintText: 'Last Name',
                      validator: (val) {
                        return val!.isEmpty ? 'Required' : null;
                      },
                    ),
                    InputCustom(
                      controller: _gender,
                      prefixIcon: Image.asset(AppImage.gender),
                      isShowPrefixIcon: true,
                      readOnly: true,
                      hintText: 'Gender',
                      onTap: () {
                        BottomChangeSelect.show(
                          items: const ['Female', 'Male'],
                          active: _gender.text,
                          callback: (val) {
                            _gender.text = val;
                          },
                        );
                      },
                    ),
                    InputCustom(
                      controller: _birthDay,
                      prefixIcon: Image.asset(AppImage.calendar),
                      isShowPrefixIcon: true,
                      readOnly: true,
                      hintText: 'Birthday',
                      onTap: () async {
                        final pickupDate = await _showDatePicker();
                        if (pickupDate != null) {
                          var formattedDate =
                              DateFormat('MM/dd/yyyy').format(pickupDate);

                          _birthDay.text = formattedDate;
                          birthDay = pickupDate;
                          setState(() {});
                        }
                      },
                    ),
                    InputCustom(
                      controller: _mediaRecord,
                      prefixIcon: Image.asset(AppImage.recordNumber),
                      isShowPrefixIcon: true,
                      hintText: 'Medical Record Number (optional)',
                    ),
                    InputCustom(
                      controller: _email,
                      prefixIcon: Image.asset(AppImage.email),
                      isShowPrefixIcon: true,
                      hintText: 'Email', 
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: ctr.gotoDeleteAccountView,
                        child: const Text(
                          'Managing your account',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => AppButton(
                'UPDATE',
                loading: _stateObx.value.isLoading,
                onPressed: updateUser,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget address(String title, String content, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(AppImage.address, width: 20),
                Dimes.width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title.text
                          .size(11)
                          .minFontSize(11)
                          .color(AppTheme.deactivate)
                          .make(),
                      content.text
                          .size(16)
                          .medium
                          .color(AppTheme.primary)
                          .make()
                    ],
                  ),
                )
              ],
            ),
            Dimes.height10,
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
