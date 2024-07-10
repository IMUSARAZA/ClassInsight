import 'package:flutter/material.dart';
import 'package:classinsight/Const/AppColors.dart';

class CustomBlueButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomBlueButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.75; // 75% of screen width

    return Container(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Appcolors.appLightBlue,
          elevation: 5, // Adjust the elevation for the shadow
          shadowColor: Colors.grey.withOpacity(0.5), // Shadow color with opacity
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded edges
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
