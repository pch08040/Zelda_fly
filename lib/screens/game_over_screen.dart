// import 'package:flame/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'gameOver';

  GameOverScreen({super.key, required this.game});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  final _authentication = FirebaseAuth.instance;

  final firestore = FirebaseFirestore.instance;
  var myscore;

  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    myscore = widget.game.bird.score;
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SCORE: ${widget.game.bird.score}',
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(Assets.gameOver),
            const SizedBox(height: 20),
            ElevatedButton(
                // Restart 버튼을 누르면 재실행되는 함수를 전달
                onPressed: (){
                  addScore();
                  onRestart();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Restart',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            ElevatedButton(
                // Restart 버튼을 누르면 재실행되는 함수를 전달
                onPressed: () {
                  addScore();
                  onMain();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Main',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  void addScore() async {
    try {
      var result = await firestore.collection('userinfo').get();
      for (var doc in result.docs) {
        if (loggedUser != null && loggedUser!.email == doc['email'] && doc['score'] < myscore) {
          await firestore
              .collection('userinfo')
              .doc(doc.id)
              .update({'score': myscore});

          // // 잘 들어갔나 확인 코드
          // var updatedDoc = await firestore.collection('userinfo').doc(doc.id).get();
          // print('Score updated for ${updatedDoc['score']}');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void onRestart() {
    widget.game.bird.reset();
    widget.game.overlays.remove('gameOver');
    widget.game.resumeEngine();
  }

  void onMain() {
    widget.game.bird.reset();
    widget.game.overlays.remove('gameOver');
    // gameOver화면 송출
    widget.game.overlays.add('mainMenu');
    // 렌더링 일시중지
    widget.game.pauseEngine();
  }
}
