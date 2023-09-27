import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color.fromARGB(255, 251, 245, 255),
      pinned: false,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/images/menu.svg',
          height: 20,
          width: 20,
        ),
      ),
      leadingWidth: 60,
      title: const Text(
        'InstaPix',
        style: TextStyle(
          color: Color.fromARGB(255, 114, 72, 252),
          fontFamily: 'InstaSans',
          fontWeight: FontWeight.w600,
          fontSize: 24,
          letterSpacing: 0.5
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: _profileBtnHandler,
            child: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 114, 72, 252),
              child: Text('J', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 17)),
            ),
          ),
        )
      ],
    );
  }

  void _profileBtnHandler() {

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<AuthBloc>(context).add(UserLogOutRequest());
                },
                isDefaultAction: true,
                child: const Text('Log Out'),
              ),
            ],
          );
        },
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color.fromRGBO(27, 28, 30, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical( 
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 150,
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    BlocProvider.of<AuthBloc>(context).add(UserLogOutRequest());
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(150, 247, 247, 247),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
// 7248FC - menu color