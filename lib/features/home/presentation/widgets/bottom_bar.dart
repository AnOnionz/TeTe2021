import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/home/presentation/blocs/tab_bloc.dart';

class BottomBar extends StatefulWidget {
  final TabBloc bloc;

  const BottomBar({Key? key, required this.bloc}) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, TabState>(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is TabChanged) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (index) {
                    widget.bloc.add(TabPressed(index: index));
                  },
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0.0,
                  selectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedItemColor: kRedColor.withOpacity(0.7),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedItemColor: Colors.black.withOpacity(0.8),
                  items: const [
                    BottomNavigationBarItem(
                        icon: AnimatedOpacity(
                            duration: Duration.zero,
                            opacity: 0.8,
                            child: Icon(IconlyBroken.home)),
                        activeIcon: Icon(
                          IconlyBold.home,
                        ),
                        label: 'Trang chủ'),
                    BottomNavigationBarItem(
                        icon: AnimatedOpacity(
                            duration: Duration.zero,
                            opacity: 0.8,
                            child: Icon(IconlyBroken.notification)),
                        activeIcon: Icon(
                          IconlyBold.notification,
                        ),
                        label: 'Thông báo'),
                    BottomNavigationBarItem(
                      icon: AnimatedOpacity(
                          duration: Duration.zero,
                          opacity: 0.8,
                          child: Icon(IconlyBroken.setting)),
                      activeIcon: Icon(IconlyBold.setting),
                      label: 'Cá nhân',
                    ),
                  ]),
            );
          }
          return const Center(child: Text("Đã xảy ra lỗi"));
        });
  }
}
