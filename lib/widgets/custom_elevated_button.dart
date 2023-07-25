import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title1,
    this.isSelected = false,
    this.title2,
    this.radius = 10,
  });
  final VoidCallback onPressed;
  final List<String> title1;
  final String? title2;
  final double radius;
  final isSelected;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 1.5,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title1.length > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          ...List.generate(title1.length, (index) {
                            return Text(title1[index],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold));
                          })
                        ])
                  : Text(title1[0],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              title2 != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title2!,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(.9)),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: isSelected
                ? BorderSide(color: Colors.red, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
