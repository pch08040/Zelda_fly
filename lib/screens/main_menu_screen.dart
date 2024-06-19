import 'package:flame_audio/flame_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeldafly/common/animation_state.dart';

class MainMenuScreen extends StatefulWidget {
  // 부모위젯의 state등록
  final FlappyBirdGame game;
  static const String id = 'mainMenu';

  const MainMenuScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final _authentication = FirebaseAuth.instance;
  // 널값 허용
  User? loggedUser;
  bool result = true;
  bool justLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlameAudio.bgm.play(Assets.bgm, volume: 50);
    // 최초 시작시 일시정지 안하면 바닥에 떨어져 죽음;;
    widget.game.pauseEngine();
    getCurrentUser();
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
    void _startGame() {
      setState(() {
        result = false;
      });

      Future.delayed(Duration(milliseconds: 1000), () {
        // 서서히 사라짐
        if (mounted) {
          FlameAudio.bgm.stop();
          widget.game.overlays.remove('mainMenu');
          widget.game.overlays.remove('leaderBoard');
          widget.game.overlays.remove('signUpIn');
          // 게임 시작
          widget.game.resumeEngine();
        }
      });
    }

    void _signUp() {
      // 로그인이 되어있다면? 클릭했을때
      if (loggedUser != null) {
        widget.game.overlays.remove('mainMenu');
        widget.game.overlays.add('leaderBoard');
      } else {
        widget.game.overlays.remove('mainMenu');
        widget.game.overlays.add('signUpIn');
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: _startGame,
            child: AnimatedOpacity(
              // width: double.infinity,
              // height: double.infinity,
              opacity: result ? 1 : 0,
              duration: Duration(milliseconds: 1000),
              child: Container(
                // width: double.infinity,
                // height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.menu2),
                    fit: BoxFit.cover,
                  ),
                ),

                child: AnimationState(
                  builder: (state) => Center(
                    child: AnimatedOpacity(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 1000),
                      opacity: state ? 1 : 0,
                      child: Image.asset(Assets.message2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: loggedUser != null ? (
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: _signUp,
                )

            ) : (
                TextButton(
                onPressed: _signUp,
                child: Text(
                '로그인',
                style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'GAME',
            ),
          ),
    )
            ),
          ),
        ],
      ),
    );
  }
}