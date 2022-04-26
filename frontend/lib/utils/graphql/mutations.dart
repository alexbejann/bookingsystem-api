const String login = r'''
mutation Mutation($username: String!, $password: String!) {
  login(username: $username, password: $password) {
    username
    admin
    token
    id
    organizationID
  }
}
''';
