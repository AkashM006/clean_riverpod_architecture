import 'package:clean_riverpod_architecture/src/utils/classes/errors.dart';

abstract class DataState<T> {
  final T? data;
  final CustomError? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailure<T> extends DataState<T> {
  const DataFailure(CustomError error) : super(error: error);
}
