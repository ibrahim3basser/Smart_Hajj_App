import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TasbihPage extends StatefulWidget {
  static const String id = 'TasbihPage';
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _counter = 0;
  int _loops = 0;
  int _selectedCount = 33; // Default count

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter % _selectedCount == 0) {
        _loops++;
      }
      if(_counter == _selectedCount) {
        _counter = 0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _loops = 0;
    });
  }

  void _updateSelectedCount(int count) {
    setState(() {
      _resetCounter();
      _selectedCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    double percent = (_counter % _selectedCount) / _selectedCount;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('التسبيح ', style: TextStyle(color: KTextBrown, fontSize: 24),),
        centerTitle: true,
        backgroundColor: KPrimaryColor,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/sepha.webp',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Column(
            children: <Widget>[
              const SizedBox(height: 180),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _updateSelectedCount(33),
                    child: const Text('33',style: TextStyle(color: KTextBrown),),
                  ),
                  ElevatedButton(
                    onPressed: () => _updateSelectedCount(99),
                    child: const Text('99',style: TextStyle(color: KTextBrown),),
                  ),
                  ElevatedButton(
                    onPressed: () => _updateSelectedCount(100),
                    child: const Text('100',style: TextStyle(color: KTextBrown),),
                  ),
                  ElevatedButton(
                    onPressed: _resetCounter,
                    child: const Text('Reset',style: TextStyle(color: KTextBrown),),
                  ),
                  Text(
                    'Loop $_loops',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 12,
                ),
                child: Container(
                  width: 280.0,
                  height: 280.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    ),
                  child: ElevatedButton(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                    ),
                    child: CircularPercentIndicator(
                          radius: 140.0,
                          lineWidth: 6.0,
                          percent: percent,
                          backgroundColor: Colors.grey,
                          progressColor: KIconColor,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                              'Click to praise',
                              style: TextStyle(
                                color: KTextBrown
                              ),
                              ),
                              Text(
                                '${(_counter % _selectedCount)+1}',
                                style: const TextStyle(
                                  fontSize: 40.0,
                                  color: KTextBrown,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                  ),
                ),
            ],
          ),
        ]
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class TasbihPage extends StatefulWidget {
//   static const String id = 'TasbihPage';
//   const TasbihPage({super.key});

//   @override
//   State<TasbihPage> createState() => _TasbihPageState();
// }

// class _TasbihPageState extends State<TasbihPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: BackgroundWithCounter(),
//     );
//   }
// }

// class BackgroundWithCounter extends StatefulWidget {
//   const BackgroundWithCounter({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _BackgroundWithCounterState createState() => _BackgroundWithCounterState();
// }

// class _BackgroundWithCounterState extends State<BackgroundWithCounter> {
//   int _counter = 0;
//   int _loops = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//       if (_counter % 99 == 0) {
//         _loops++;
//       }
//     });
//   }

//   void _resetCounter() {
//     setState(() {
//       _counter = 0;
//       _loops = 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         title: const Text('التسبيح ', style: TextStyle(color: Colors.black, fontSize: 24),),
//         centerTitle: true,
//         backgroundColor: const Color(0xff51B1E3),
        
        
//       ),
//       body: Stack(
//         children: <Widget>[
//           Image.asset(
//             'assets/images/HD-wallpaper-ramadan-mosque.jpg',
//             fit: BoxFit.cover,
//             height: double.infinity,
//             width: double.infinity,
//             alignment: Alignment.center,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   ElevatedButton(
//                     style: const ButtonStyle(),
//                     onPressed: _resetCounter,
//                     child: const Text('Reset'),
//                   ),
//                   Text(
//                     'Loop $_loops',
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).size.height / 12,
//                 ),
//                 child: Container(
//                   width: 300.0,
//                   height: 300.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.white,
//                       width: 3.0,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(32.0),
//                         child: Text(
//                           '$_counter',
//                           style: const TextStyle(
//                             fontSize: 40.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _incrementCounter,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: const Text('Tap here to begin tasbih'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }






