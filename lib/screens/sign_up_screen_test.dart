import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:zeldafly/game/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSignupScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'signUpIn';
  const LoginSignupScreen({super.key, required this.game});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;

  bool isSignupScreen = true;
  // 한 위젯 내부에있는 변수나 메서드를 외부위젯에서 접근 할 수 있게 하는게 글로벌 키임
  // 이 StatefulWidget에 글로벌키를 주면 currentState속성에 접근 할 수 있고
  // currentState에 근거해서만 validate 메소드가 호출 될 수 있으므로 null체크 해야됨
  // FormState 타입으로 지정해야 TextFromField에 접근하여 벨리데이션 기능을 작동가능하다.
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  final firestore = FirebaseFirestore.instance;

  void addData() async {
    await firestore
        .collection('userinfo')
        .add({'name': userName, 'email': userEmail, 'score': 0});
  }

  void _tryValidation() {
    // 사용자가 텍스트 폼필드에 입력한 정보의 유효성을 확인하기 위해서는
    // currentState 속성을 통해서 FormState에 접근을 해야 됨
    // Globalkey를 사용할 시 currentState속성을 가지고 다른 Stateful위젯의 State에 접근 가능
    // 이렇게 쓰면 form안의 validator에 접근할 수 있음(실행이 아님 접근임 실행은 전송버튼에서 할거임)
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // 배경
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              // 배경이미지 & 텍스트
              child: GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.signupback),
                      fit: BoxFit.cover,
                    ),
                  ),

                  // 기존 실습 글귀
                  // child: Container(
                  //   padding: const EdgeInsets.only(top: 90, left: 20),
                  //   child: Column(
                  //     // 텍스트를 왼쪽 시작점으로 이동
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       RichText(
                  //         text: TextSpan(
                  //             text: 'Welcome',
                  //             style: TextStyle(
                  //                 letterSpacing: 1.0,
                  //                 fontSize: 25,
                  //                 color: Colors.black),
                  //             children: [
                  //               TextSpan(
                  //                 text: isSignupScreen
                  //                     ? 'to Yummy chat!'
                  //                     : ' back',
                  //                 style: TextStyle(
                  //                   letterSpacing: 1.0,
                  //                   fontSize: 25,
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ]),
                  //       ),
                  //       const SizedBox(
                  //         height: 5.0,
                  //       ),
                  //       Text(
                  //         isSignupScreen
                  //             ? 'Signup to continue'
                  //             : 'Signin yo continue',
                  //         style: TextStyle(
                  //             letterSpacing: 1.0, color: Colors.black),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),
              ),
            ),
            
            // 텍스트 폼 필드
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: 300,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(20.0),
                height: isSignupScreen ? 280.0 : 250.0,
                // MediaQuery 사용 시 각 디바이스의 실제 너비 값을 구할 수 있음
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

                // 여기부터 Container 안쪽 구현
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  '로그인',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    // 여기에 삼항연산자 넣어서 색상 제어 할 예정
                                    color: !isSignupScreen
                                        ? Colors.green[900]
                                        : Palette.textColor1,
                                  ),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.green[900],
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  '회원가입',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Colors.green[900]
                                        : Palette.textColor1,
                                  ),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.green[900],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      if (isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(1),
                                  // 사용자가 입력한 값 유효성 검사
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return 'Please enter at least 4 characters.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    userName = value!;
                                  },
                                  onChanged: (value) {
                                    userName = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.account_circle,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),

                                    // TextFormField가 선택 되었을때 모양이 변하는걸 방지
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    hintText: '닉네임',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1),
                                    // TextFormField의 폭을 줄여줌
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  // 이메일 쓰기 쉬운 키보드 주세요~
                                  keyboardType: TextInputType.emailAddress,
                                  key: ValueKey(2),
                                  validator: (value) {
                                    // email이 @를 포함하지 않을때
                                    if (value!.isEmpty || !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.mail,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),

                                    // TextFormField가 선택 되었을때 모양이 변하는걸 방지
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    hintText: '이메일',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1),
                                    // TextFormField의 폭을 줄여줌
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  // 비밀번호 숨겨주세요~
                                  obscureText: true,
                                  key: ValueKey(3),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return 'Please must be at least 7 characters long.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),

                                    // TextFormField가 선택 되었을때 모양이 변하는걸 방지
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    hintText: '비밀번호',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1),
                                    // TextFormField의 폭을 줄여줌
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Login을 위한 위젯구현
                      if (!isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(4),
                                  validator: (value) {
                                    // email이 @를 포함하지 않을때
                                    if (value!.isEmpty || !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.mail,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),

                                    // TextFormField가 선택 되었을때 모양이 변하는걸 방지
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    hintText: '이메일',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1),
                                    // TextFormField의 폭을 줄여줌
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  key: ValueKey(5),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return 'Please must be at least 7 characters long.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),

                                    // TextFormField가 선택 되었을때 모양이 변하는걸 방지
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    hintText: '비밀번호',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1),
                                    // TextFormField의 폭을 줄여줌
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 전송버튼
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen ? 550 : 515,
              right: 0,
              left: 0,
              // Positioned위젯의 위치를 0,0이런식으로 주어서 가로로 길게 변했음 해결을 위해 Center 사용
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (isSignupScreen) {
                      _tryValidation();

                      try {
                        // 사용자 등록이 완료되야 그 다음 과정이 진행됨에 따라 await씀
                        final newUser = await _authentication
                            .createUserWithEmailAndPassword(
                          email: userEmail,
                          password: userPassword,
                        );
                        if (newUser.user != null) {
                          widget.game.overlays.remove('signUpIn');
                          widget.game.overlays.add('mainMenu');
                          addData();
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please check your email and password'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    }

                    // 로그인 전송기능 구현
                    if (!isSignupScreen) {
                      _tryValidation();
                      try {
                        final newUser =
                            await _authentication.signInWithEmailAndPassword(
                          email: userEmail,
                          password: userPassword,
                        );
                        if (newUser.user != null) {
                          widget.game.overlays.remove('signUpIn');
                          widget.game.overlays.add('mainMenu');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          // gradient는 여러 색상을 가지므로 colors가 list형식이 됨
                          colors: [
                            Colors.green,
                            Colors.lightGreen,
                          ],
                          // gradient의 방향을 맞춰줘야 되므로 시작과 끝의 위치를 표시
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            // 버튼그림자가 가지는 버튼에서의 수직수평거리
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 구글버튼
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen
                  ? MediaQuery.of(context).size.height - 125
                  : MediaQuery.of(context).size.height - 165,
              // 가로방향으로 전체를 차지 할 수 있도록 조치
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Text(isSignupScreen ? 'or Signup with' : 'or Signin with'),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Palette.googleColor),
                    icon: Icon(Icons.add),
                    label: Text('Google'),
                  ),
                ],
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
      ),
    );
  }
}
