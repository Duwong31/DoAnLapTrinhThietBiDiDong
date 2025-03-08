import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_button.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/otp.dart';

class ForgotPassPage extends StatelessWidget{
  const ForgotPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicBackButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          
          horizontal: 20
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _loginText(),
            SizedBox(height: 20),
            Text(
              'What’s your phone number?',
            ),
            SizedBox(height: 20),
            _phoneNumberOrEmailField(),
            SizedBox(height: 20),
            BasicButton(
              onPressed: (){
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const OTPPage()
                      )
                    );
              }, 
              title: 'Next  '),
            SizedBox(height: 10),

            Text(
              'We\'ll send you a code to confirm your phone number'
            )
          ],
        ),
      ),
    );
  }
  Widget _phoneNumberOrEmailField(){
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightBackground, 
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),  
      ),
    );
  }
  Widget _loginText(){
    return const Text(
      'Let’s change your passwrod',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 32
      ),
      textAlign: TextAlign.center,
    );
  }
}  