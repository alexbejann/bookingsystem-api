
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/user.dart';
import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OfficeRepository {
  final graphQLService = GraphQLService();
  String token = '';

  Future<List<Office>> getOffices() async {
    final user = await User.getUser();
    QueryResult? result = await graphQLService.getOffices(
      variables: <String, dynamic>{
        'organizationId': user.organizationID,
      },
    );
    assert(result.data != null, 'Never null');
    final resultOffice = result.data!['offices'] as List<dynamic>;
    print(resultOffice);
    return Office.fromListDynamic(resultOffice);
    //return token;
  }

  // Future<List<Office>> addOffice({
  //   required Map<String, dynamic> variables,
  // }) async {
  //   final user = await User.getUser();
  //   variables['organizationId'] = user.organizationID;
  //   QueryResult? result = await graphQLService.addOffice(
  //     variables: variables,
  //   );
  //   assert(result.data != null, 'Never null');
  //   final resultOffice = result.data!['office'] as List<dynamic>;
  //   print(resultOffice);
  //   return Office.fromListDynamic(resultOffice);
  //   //return token;
  // }
}
