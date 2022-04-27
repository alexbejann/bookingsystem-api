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

const String addOffice = r'''
mutation Mutation($name: String!, $organizationId: ID!) {
  addOffice(name: $name, organizationID: $organizationId) {
    id
    name
  }
}
''';
