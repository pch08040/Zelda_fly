import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';

class LeaderBoardScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'leaderBoard';

  LeaderBoardScreen({super.key, required this.game});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  final _authentication = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  User? loggedUser;

  String userName = '';
  var userScore;
  List<Map<String, dynamic>> Leaderboard = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getData();
  }

  void getData() async {
  try {
    var result = await firestore
        .collection('userinfo')
        .orderBy('score', descending: true)
        .limit(7)
        .get();

    setState(() {
      Leaderboard.clear(); // 기존 데이터 초기화 시켜야 중복 방지됨
      for (var doc in result.docs) {
        Leaderboard.add({
          'name': doc['name'],
          'score': doc['score'],
        });

        userName = doc['name'];
        userScore = doc['score'];
      }
    });

  } catch (e) {
    print(e);
  }
}

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void sortboard() {
  //   var result = await firestore.collection('userinfo').get();
  // }

  @override
  Widget build(BuildContext context) {
    widget.game.pauseEngine();
    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.leaderboard),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 나의 점수
          Positioned(
            top: MediaQuery.of(context).size.height - 720,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                '${userName}의 점수 ${userScore}',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontFamily: 'Game',
                ),
              ),
            ),
          ),

          // 순위
          Positioned(
            top: MediaQuery.of(context).size.height - 630,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: 500,
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(15.0),
                itemCount: Leaderboard.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    // 이름 출력
                    title: Text(
                      Leaderboard[i]['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Game',
                      ),
                    ),
                    // 점수 출력
                    trailing: Text(
                      Leaderboard[i]['score'].toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Game',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 로그아웃
          Positioned(
            top: MediaQuery.of(context).size.height - 100,
            right: 0,
            left: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  _authentication.signOut();
                  widget.game.overlays.remove('leaderBoard');
                  widget.game.overlays.add('mainMenu');
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Game',
                  ),
                ),
              ),
            ),
          ),

          // 뒤로가기
          Positioned(
            top: 60,
            right: 15,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.green[900],
              ),
              onPressed: () {
                widget.game.overlays.remove('signUpIn');
                widget.game.overlays.add('mainMenu');
              },
            ),
          ),
        ],
      ),
    );
  }
}
