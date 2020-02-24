import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:things/style/colors.dart';

final titleStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'CM Sans Serif',
  fontSize: 26.0,
  height: 1.2,
);

final subtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  height: 1.2,
);

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();

}

class _WelcomeScreenState extends State <WelcomeScreen> {

  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : mainDarkBlue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Container(
        color: mainBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },

                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height * 0.18),

                        Container(
                          child: Image(
                            image: AssetImage(
                              'assets/img/app.png',
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                        Center(
                          child: Text(
                            'Live your life smarter\nwith us!',
                            style: titleStyle,
                            textAlign: TextAlign.center
                          ),
                        ),

                        SizedBox(height: 15.0),

                        Center(
                          child: Text(
                            'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                            style: subtitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height * 0.18),

                        Container(
                          child: Image(
                            image: AssetImage(
                              'assets/img/app.png',
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                        Center(
                          child: Text(
                            'Live your life smarter\nwith us!',
                            style: titleStyle,
                            textAlign: TextAlign.center
                          ),
                        ),

                        SizedBox(height: 15.0),

                        Center(
                          child: Text(
                            'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                            style: subtitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height * 0.18),

                        Container(
                          child: Image(
                            image: AssetImage(
                              'assets/img/app.png',
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                        Center(
                          child: Text(
                            'Live your life smarter\nwith us!',
                            style: titleStyle,
                            textAlign: TextAlign.center
                          ),
                        ),

                        SizedBox(height: 15.0),

                        Center(
                          child: Text(
                            'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                            style: subtitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),

            SizedBox (height: MediaQuery.of(context).size.height * 0.1)
          ],
        ),
      ),
        

      bottomSheet: _currentPage == _numPages - 1
        ? Container(
            height: MediaQuery.of(context).size.height * 0.16,
            width: double.infinity,
            color: Colors.white,
            child: GestureDetector(
              onTap: () => print('Get started'),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    'Get started',
                    style: TextStyle(
                      color: mainBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Text(''),
    );
  }
}