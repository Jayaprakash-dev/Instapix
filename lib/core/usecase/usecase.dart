abstract interface class UseCase<Type, Param> {
  Future<Type> call({Param param});
}