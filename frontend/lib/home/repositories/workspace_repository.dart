import 'dart:async';
import 'dart:convert';

import 'package:frontend/app/model/user.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceRepository {
  final graphQLService = GraphQLService();
  String token = '';

  Future<List<Workspace>> getWorkspaces() async {
    final user = await User.getUser();
    QueryResult? result = await graphQLService.getWorkspaces(
      variables: <String, dynamic>{
        'organizationId': user.organizationID,
      },
    );
    assert(result.data != null, 'Never null');
    final resultWorkspaces = result.data!['workspacesByOrg'] as List<dynamic>;
    return Workspace.fromListDynamic(resultWorkspaces);
    //return token;
  }
}
