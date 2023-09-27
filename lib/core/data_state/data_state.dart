base class DataState<T> {
  final T? data;
  final Exception? exception;

  DataState({
    this.data,
    this.exception,
  });
}

final class DataSuccessState<T> extends DataState<T> {
  DataSuccessState({T? data}): super(data: data);
}

final class DataExceptionState<T> extends DataState<T> {
  DataExceptionState({Exception? exception}): super(exception: exception);
}