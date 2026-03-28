import 'package:flutter/material.dart';
import 'package:petalalyze/core/constants/app_colors.dart';

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({
    super.key,
    required this.title,
    required this.step1Title,
    required this.step1Text,
    required this.step1Image,
    required this.step2Title,
    required this.step2Text,
    required this.step2Image,
    required this.step3Title,
    required this.step3Text,
    required this.step3Image,
  });

  final String title;
  final String step1Title;
  final String step1Text;
  final String step1Image;

  final String step2Title;
  final String step2Text;
  final String step2Image;

  final String step3Title;
  final String step3Text;
  final String step3Image;

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection> {
  late PageController _controller;
  double _page = 0;

  static const _steps = 3;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.7,
      initialPage: 0,
    );
    _controller.addListener(() {
      setState(() {
        _page = _controller.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (String title, String text, String image) _stepAt(int index) {
    final i = index % _steps;
    switch (i) {
      case 0:
        return (widget.step1Title, widget.step1Text, widget.step1Image);
      case 1:
        return (widget.step2Title, widget.step2Text, widget.step2Image);
      default:
        return (widget.step3Title, widget.step3Text, widget.step3Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _controller,
            itemCount: 3,
            itemBuilder: (context, index) {
              final distance = (_page - index).abs();
              final scale = (1 - distance * 0.25).clamp(0.75, 1.0);
              final (title, text, image) = _stepAt(index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Transform.scale(
                    scale: scale,
                    child: HowItWorksCard(title: title, text: text, image: image),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class HowItWorksCard extends StatelessWidget {
  const HowItWorksCard({super.key, required this.title, required this.text, required this.image});

  final String title;
  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-9, -9),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Color(0xFFBEBEBE),
            offset: Offset(9, 9),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              image,
              height: 50,
              width: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.mediumDarkGreen,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
