import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  static const double topDesignWidth = 400;
  static const double topDesignHeight = 240;

  static const double bottomDesignWidth = 400;
  static const double bottomDesignHeight = 240;

  // 🔧 Adjust padding to control whitespace around the art (left/right)
  static const double topPadding = 0;
  static const double bottomPadding = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ============ TOP GRAPHIC — full width band, art inset with padding ============
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: size.height * 0.20,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: topPadding),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: topDesignWidth,
                height: topDesignHeight,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset("assets/images/top1.png", width: topDesignWidth,),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset("assets/images/top2.png", width: topDesignWidth,),
                    ),
                   /* Positioned(
                      top: 50,
                      right: 30,
                      child: Image.asset(
                        "assets/images/main.png",
                        width: topDesignWidth * 0.35,
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),

        // ============ MIDDLE FORM ZONE ============
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(child: child),
                ),
              );
            },
          ),
        ),

        // ============ BOTTOM GRAPHIC — full width band, art inset with padding ============
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: size.height * 0.20,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: bottomPadding),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: bottomDesignWidth,
                height: bottomDesignHeight,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/images/bottom1.png",
                        width: bottomDesignWidth,
                        color: Colors.red,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/images/bottom2.png",
                        width: bottomDesignWidth,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}