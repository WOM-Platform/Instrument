import 'package:equatable/equatable.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super(props);
}

class RequestLoading extends HomeState {}

class RequestLoaded extends HomeState {
  final List<WomRequest> requests;

  RequestLoaded({@required this.requests}) : super([requests]);

  RequestLoaded copyWith({
    List<WomRequest> requests,
  }) {
    return RequestLoaded(
      requests: requests ?? this.requests,
    );
  }
}
