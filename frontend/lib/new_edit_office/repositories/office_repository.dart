
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/user.dart';
import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:frontend/utils/graphql/mutations.dart' as mutations;
import 'package:frontend/utils/graphql/queries.dart' as queries;
import 'package:graphql_flutter/graphql_flutter.dart';

class OfficeRepository {
  final graphQLService = GraphQLService();

  Future<List<Office>> getOffices() async {
    final user = await User.getUser();
    QueryResult? result = await graphQLService.performQuery(
      queries.officesByOrg
      variables: <String, dynamic>{
        'organizationId': user.organizationID,
      },
    );
    print(result.data);
    assert(result.data != null, 'getOffices null');
    final resultOffice = result.data!['offices'] as List<dynamic>;
    return Office.fromListDynamic(resultOffice);
  }

  Future<Office> addOffice({
    required Map<String, dynamic> variables,
  }) async {
    final user = await User.getUser();
    variables['organizationId'] = user.organizationID;
    QueryResult? result = await graphQLService.performMutation(
      mutations.addOffice
      variables: variables,
    );
    assert(result.data != null, 'addOffice null');
    final resultOffice = result.data!['office'] as Map<String, dynamic>;
    return Office.fromJson(resultOffice);
  }

  Future<Office> renameOffice({
    required Map<String, dynamic> variables,
  }) async {
    QueryResult? result = await graphQLService.performMutation(
      mutations.renameOffice
      variables: variables,
    );
    assert(result.data != null, 'renameOffice null');
    final resultOffice = result.data!['renameOffice'] as Map<String, dynamic>;
    return Office.fromJson(resultOffice);
  }

  Future<Office> deleteOffice({
    required Map<String, dynamic> variables,
  }) async {
    QueryResult? result = await graphQLService.performMutation(
      mutations.deleteOffice
      variables: variables,
    );
    assert(result.data != null, 'deleteOffice null');
    final resultOffice = result.data!['deleteOffice'] as Map<String, dynamic>;
    return Office.fromJson(resultOffice);
  }
}
