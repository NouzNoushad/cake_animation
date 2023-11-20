import 'dart:ui';

import 'package:cake_transition_animation/utils/cake_list.dart';
import 'package:flutter/material.dart';

class WindowScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class CakeAnimation extends StatefulWidget {
  const CakeAnimation({super.key});

  @override
  State<CakeAnimation> createState() => _CakeAnimationState();
}

class _CakeAnimationState extends State<CakeAnimation> {
  late final PageController _cakeController;
  late final PageController _headingController;

  late double _currentPosition;
  late int _headingPosition;

  @override
  void initState() {
    _cakeController = PageController(viewportFraction: 0.4, initialPage: 8);
    _headingController = PageController(viewportFraction: 1, initialPage: 8);
    _currentPosition = _cakeController.initialPage.toDouble();
    _headingPosition = _headingController.initialPage;
    _cakeController.addListener(() {
      setState(() {
        _currentPosition = _cakeController.page!;
        if (_currentPosition.round() != _headingPosition) {
          _headingPosition = _currentPosition.round();
          _headingController.animateToPage(_headingPosition,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          ..._background(),
          Transform.scale(
            scale: 2.1,
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
                controller: _cakeController,
                scrollBehavior: WindowScrollBehaviour(),
                clipBehavior: Clip.none,
                scrollDirection: Axis.vertical,
                itemCount: cakeItems.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox.shrink();
                  }
                  final double distance = (_currentPosition - index + 1).abs();
                  final notOnScreen = (_currentPosition - index + 1) > 0;
                  final double scale =
                      1 - distance * 0.345 * (notOnScreen ? 1 : -1);
                  final double translateY = (1 - scale).abs() *
                          MediaQuery.of(context).size.height /
                          1.5 +
                      20 * (distance - 1).clamp(0.0, 1);

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.1),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..translate(0.0, !notOnScreen ? 0.0 : translateY)
                        ..scale(scale),
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/${cakeItems[index].image}',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                }),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                  0.6,
                  1
                ],
                    colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.1),
                ])),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    child: PageView.builder(
                        controller: _headingController,
                        itemCount: cakeItems.length,
                        scrollBehavior: WindowScrollBehaviour(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Text(
                              index != 9 ? cakeItems[index + 1].name : "",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 1,
                                color: Color.fromARGB(255, 53, 37, 31),
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _headingPosition != 9
                          ? "\$${cakeItems[_headingPosition + 1].price.toStringAsFixed(2)}"
                          : "",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: Color.fromARGB(255, 53, 37, 31),
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      )),
    );
  }

  List<Widget> _background() => [
        Align(
          alignment: Alignment.bottomCenter + const Alignment(0, 0.7),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(233, 189, 234, 1),
                blurRadius: 90,
                spreadRadius: 90,
                offset: Offset.zero,
              )
            ], shape: BoxShape.circle),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft + const Alignment(-0.35, -0.5),
          child: Container(
            width: 60,
            height: 200,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(233, 189, 234, 1),
                blurRadius: 50,
                spreadRadius: 20,
                offset: Offset(5, 0),
              )
            ]),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft + const Alignment(5.8, -0.45),
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(233, 189, 234, 1),
                blurRadius: 60,
                spreadRadius: 20,
                offset: Offset(5, 0),
              )
            ], shape: BoxShape.circle),
          ),
        ),
      ];
}
