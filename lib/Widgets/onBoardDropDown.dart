import 'package:classinsight/utils/fontStyles.dart';
import 'package:flutter/material.dart';

class onBoardDropDown extends StatefulWidget {
  final List<String> items;
  final Function(String?)? onChanged;

  const onBoardDropDown({
    Key? key,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  _onBoardDropDownState createState() => _onBoardDropDownState();
}

class _onBoardDropDownState extends State<onBoardDropDown> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;


    return Container(
      width: screenWidth*0.65,
      height: screenHeight*0.055,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Black border
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            focusColor: Colors.white,
          
            value: _selectedItem,
            icon: Icon(Icons.arrow_drop_down, color: Colors.black,), // Custom dropdown icon
            iconSize: screenHeight*0.03,
            elevation: 16,
            style: Font_Styles.labelHeadingLight(context), // Dropdown text style
            hint: Text(
              'Select', // Initial text
            // Hint text style
            ),
            items: widget.items
                .map((item) => DropdownMenuItem(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(item),
                      ),
                      value: item,
                    ))
                .toList(),
            onChanged: (selectedItem) {
              setState(() {
                _selectedItem = selectedItem as String?;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedItem);
              }
            },
          ),
        ),
      ),
    );
  }
}
