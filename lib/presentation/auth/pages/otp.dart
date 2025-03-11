import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_button.dart';

class OTPPage extends StatelessWidget {
  const OTPPage({super.key});

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: BasicBackButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(  
          horizontal: 20  
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
              "Verification code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Mô tả ngắn
            const Text(
              "We have sent the code verification to",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // Row: Hiển thị số điện thoại và "Change phone number?"
            Row(
              children: [
                // Số điện thoại
                const Text(
                  "+84908969499",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                // "Change phone number?"
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: const Text(
                    "Change phone number?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
              
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
         ],
          )
      ),
    );
  }


  
}