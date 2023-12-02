import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';

@immutable
abstract class UserState extends Equatable {}

class UserLoadingState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadedState extends UserState {
  final List<JobModel> jobs;
  UserLoadedState(this.jobs);
  @override
  List<Object?> get props => [jobs];
}

class UserErrorState extends UserState {
  final String error;
  UserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
