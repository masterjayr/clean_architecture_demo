import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp((){
    mockDataConnectionChecker  = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', (){

    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
      //arrange
      final tHasConnection = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) async => tHasConnection);
      //act
      final result = networkInfoImpl.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnection);
    } );
  });
}
