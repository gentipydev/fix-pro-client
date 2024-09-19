import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDatefield extends StatefulWidget {
  final String label;
  final TextEditingController yearController;
  final TextEditingController monthController;
  final TextEditingController dayController;
  final bool whiteBackground;
  final bool greyBackground;
  final ValueNotifier<String?>? errorMessage;
  final FocusNode? nextYearFocus;

  
  const CustomDatefield({
    super.key,
    required this.label,
    required this.yearController,
    required this.monthController,
    required this.dayController,
    this.errorMessage,
    this.whiteBackground = true,
    this.greyBackground = false,
    this.nextYearFocus,
  });

  @override
  State<CustomDatefield> createState() => _CustomDatefieldState();
}

class _CustomDatefieldState extends State<CustomDatefield> {
  final yearFocus = FocusNode();
  final monthFocus = FocusNode();
  final dayFocus = FocusNode();

  @override
  void dispose() {
    widget.yearController.removeListener(() {});
    widget.monthController.removeListener(() {});
    widget.dayController.removeListener(() {});

    yearFocus.dispose();
    monthFocus.dispose();
    dayFocus.dispose();
    super.dispose();
}

@override
void initState() {
  super.initState();

  widget.yearController.addListener(() {
    if (widget.yearController.text.length == 4) {
      yearFocus.unfocus();
      FocusScope.of(context).requestFocus(monthFocus);
    }
  });

  widget.monthController.addListener(() {
    if (widget.monthController.text.length == 2) {
      monthFocus.unfocus();
      FocusScope.of(context).requestFocus(dayFocus);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

      double adaptWidth(double value) {
      return (screenWidth / 411.4) * value;
    }

      double adaptHeight(double value) {
      return (screenHeight / 867.4) * value;
    }

    return ValueListenableBuilder<String?>(
      valueListenable: widget.errorMessage ?? ValueNotifier<String?>(null),
      builder: (context, error, child) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(adaptWidth(38), 0, adaptWidth(38), 0),
              height: adaptHeight(70),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.whiteBackground
                    ? AppColors.white
                    : widget.greyBackground
                        ? AppColors.grey300.withOpacity(0.3)
                        : AppColors.black,
                borderRadius: BorderRadius.circular(adaptWidth(5)),
                border: Border.all(width: adaptWidth(1), color: AppColors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: adaptWidth(150),
                    padding:  EdgeInsets.only(left: adaptWidth(20.0), right: adaptWidth(10.0)),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: adaptWidth(16),
                        color: widget.whiteBackground || widget.greyBackground
                            ? AppColors.black
                            : AppColors.white,
                        fontWeight: FontWeight.w300,
                        height: 1.2142857142857142,
                      ),
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false),
                      softWrap: false,
                    ),
                  ),
                  SizedBox(
                    width: adaptWidth(50),
                    child: TextFormField(
                        controller: widget.yearController,
                        maxLength: 4,
                        focusNode: yearFocus,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: widget.whiteBackground || widget.greyBackground
                              ? AppColors.black
                              : AppColors.white,
                        ),
                        decoration:  InputDecoration(
                          hintText: "V",
                          hintStyle: GoogleFonts.roboto(
                            fontSize: adaptWidth(14),
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w400,
                            height: 1.4166666666666667,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding:  EdgeInsets.symmetric(horizontal: adaptWidth(4)),
                        ),
                      ),
                  ),
                  SizedBox(width: adaptWidth(2.0)),
                  const Text("/"),
                  SizedBox(
                    width: adaptWidth(35),
                    child: TextFormField(
                        controller: widget.monthController,
                        maxLength: 2,
                        focusNode: monthFocus,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: widget.whiteBackground || widget.greyBackground
                              ? AppColors.black
                              : AppColors.white,
                        ),
                        decoration:  InputDecoration(
                          hintText: "M",
                          hintStyle:  TextStyle(
                            fontSize: adaptWidth(14),
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w400,
                            height: 1.4166666666666667,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: adaptWidth(4)),
                        ),
                      ),
                  ),
                  const Text("/"),
                  SizedBox(
                    width: adaptWidth(35),
                    child: TextFormField(
                        controller: widget.dayController,
                        maxLength: 2,
                        focusNode: dayFocus,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: widget.whiteBackground || widget.greyBackground
                              ? AppColors.black
                              : AppColors.white,
                        ),
                        decoration:  InputDecoration(
                          hintText: "D",
                          hintStyle:  TextStyle(
                            fontSize: adaptWidth(14),
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w400,
                            height: 1.4166666666666667,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: adaptWidth(4)),
                        ),
                    ),
                  ),
                ],
              ),
            ),
            if (error != null)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: adaptWidth(8)),
                child: Text(
                  error,
                  style: GoogleFonts.roboto(
                    fontSize: adaptWidth(14),
                    color: AppColors.tomatoRed,
                    fontWeight: FontWeight.w500,
                    height: 1.2142857142857142,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

