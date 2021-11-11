import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';

part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabChanged(index: 0));

  @override
  Stream<TabState> mapEventToState(
    TabEvent event,
  ) async* {
    if(event is TabPressed){
      if(state is TabChanged && (state as TabChanged).index != event.index) {
        yield TabChanged(index: event.index);
      }
    }
  }
}
