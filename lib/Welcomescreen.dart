import 'package:flutter/material.dart';
import 'homescreen.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDAB5FF), Color(0xFF2C124D)],
          ),
        ),
        child: Stack(
          children: [
            //moon + title
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: InvertedCurve(),
                child: Container(
                  height: 180,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "EARTHEYE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 27,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.brightness_2_outlined, color: Colors.white, size: 28),


                    ],
                  ),
                ),
              ),
            ),

            // Stars
            const Positioned(
              top: 270,
              left: 40,
              child: Icon(Icons.star, size: 16, color: Colors.white54),
            ),
            const Positioned(
              top: 250,
              right: 40,
              child: Icon(Icons.star_border, size: 20, color: Colors.white54),
            ),
            const Positioned(
              top: 330,
              right: 330,
              child: Icon(Icons.star_border_purple500, size: 14, color: Colors.white38),
            ),
            const Positioned(
              top: 500,
              right: 100,
              child: Icon(Icons.star, size: 13, color: Colors.white38),
            ),
            const Positioned(
              top: 600,
              right: 60,
              child: Icon(Icons.star_border_sharp, size: 16, color: Colors.white38),
            ),
            const Positioned(
              top: 600,
              right: 360,
              child: Icon(Icons.star_border, size: 20, color: Colors.white38),
            ),

            // Main text in lines
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "your place",
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "in the",
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Universe",
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFFB3E5FC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.6,
              left: screenWidth / 2 - 100,
              child: Image.asset(
                'assets/images/moon.png',
                width: 190,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen()),);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Get started",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward, color: Colors.black,size: 22,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvertedCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2, size.height + 60,
      size.width, size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
