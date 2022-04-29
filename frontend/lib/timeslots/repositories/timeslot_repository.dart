import 'dart:async';

import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/app/model/user.dart';
import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TimeslotRepository {
  final graphQLService = GraphQLService();
  String token = '';

  Future<List<Timeslot>> getTimeslots({
    required Map<String, dynamic> variables,
  }) async {
    print(variables);
    QueryResult? result = await graphQLService.getTimeslots(
      variables: variables,
    );

    assert(result.data != null, 'workspaceTimeslots null');
    final resultWorkspaces =
        result.data!['workspaceTimeslots'] as List<dynamic>;
    return Timeslot.fromListDynamic(resultWorkspaces);
  }

  Future<Timeslot> addTimeslot({
    required Map<String, dynamic> variables,
  }) async {
    final user = await User.getUser();
    variables['title'] = user.username;
    variables['userId'] = user.id;
    print(variables);
    QueryResult? result = await graphQLService.addTimeslotMutation(
      variables: variables,
    );
    print(result);
    assert(result.data != null, 'addTimeslot null');
    final resultTimeslots = result.data!['addTimeslot'] as Map<String, dynamic>;
    return Timeslot.fromJson(resultTimeslots);
  }
}