import 'package:frontend/utils/graphql/mutations.dart' as mutations;
import 'package:frontend/utils/graphql/queries.dart' as queries;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLService {
  GraphQLService() {
    final httpLink = HttpLink(
      'http://localhost:3000/graphql/',
    );
    Link _link;

    final authLink = AuthLink(
      getToken: () async {
        final prefs = await SharedPreferences.getInstance();
        return 'Bearer ${prefs.get('token') ?? ''}';
      },
    );

    _link = authLink.concat(httpLink);
    _client = GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  late GraphQLClient _client;

  Future<QueryResult> performQuery(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = QueryOptions(document: gql(query), variables: variables);

    final result = await _client.query(options);

    return result;
  }

  Future<QueryResult> performMutation(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = MutationOptions(document: gql(query), variables: variables);

    final result = await _client.mutate(options);

    print(result);

    return result;
  }

  // Future<QueryResult> signUpMutation(
  //     String email, String username, String password) async {
  //   final MutationOptions _options = MutationOptions(
  //     document: gql(mutations.signUp),
  //     variables: <String, String>{
  //       'email': email,
  //       'name': username,
  //       'password': password,
  //     },
  //   );
  //   final result = await _client.mutate(_options);
  //   return result;
  // }

  Future<QueryResult> loginMutation({
    required Map<String, dynamic> variables,
  }) async {
    final options =
        MutationOptions(document: gql(mutations.login), variables: variables);
    final result = await _client.mutate(options);
    return result;
  }

  Future<QueryResult> getWorkspaces({
    required Map<String, dynamic> variables,
  }) async {
    final options = MutationOptions(
        document: gql(queries.workspacesByOrg), variables: variables,);
    final result = await _client.mutate(options);
    return result;
  }

  // Future<QueryResult> getUserById(String id) async {
  //   final options = QueryOptions(
  //     document: gql(queries.getUserById),
  //     variables: <String, String>{
  //       'id': id,
  //     },
  //   );
  //   final result = await _client.query(options);
  //   return result;
  // }

  // Future<QueryResult> refreshToken() async {
  //   QueryOptions options = QueryOptions(
  //     documentNode: gql(queries.refreshToken),
  //     variables: {},
  //   );
  //   final result = await _client.query(options);
  //   return result;
  // }

  // Future<QueryResult> logOut() async {
  //   final options = QueryOptions(
  //     document: gql(queries.logout),
  //     variables: const <String, String>{},
  //   );
  //   final result = await _client.query(options);
  //   return result;
  // }
}
