import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(top: 75, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "muSi",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Co",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent.shade700),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(top: 20, left: 20, right: 100),
                child: Image.asset(
                  'assets/images/music.png',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 150.0,
                height: 50.0,
                child: ElevatedButton(
                    onPressed: () {
                      // await Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //         builder: (_) => const NotesScreen()));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber.shade900),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Let's Start",
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    'assets/images/happy_music.png',
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
