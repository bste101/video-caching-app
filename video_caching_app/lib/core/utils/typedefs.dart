import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef TaskResult<T> = Either<Failure, T>;