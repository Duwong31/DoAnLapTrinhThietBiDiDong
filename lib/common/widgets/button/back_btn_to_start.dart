import 'package:flutter/material.dart';
import 'package:soundflow/presentation/auth/pages/signup_or_login.dart';

class BackToStartPage extends StatelessWidget implements PreferredSizeWidget{
  const BackToStartPage({
    super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: (){
          Navigator.push(
            context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const StartPage()
                      )
          );
        }, 
        icon: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            // color: context.isDarkMode ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
            shape: BoxShape.circle
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            // color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ), 
      ), 
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}