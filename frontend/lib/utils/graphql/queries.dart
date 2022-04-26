const getOrganizations = '''
query Organizations {
  organizations {
    id
    name
  }
}
''';

const String getUserById = r'''
  query User($id: String!) {
    user(id: $id) {
      id
      email
      name
      profile {
        id
        fileName
        filePath
        createdAt
        updatedAt
      }
      settings {
        id
        title
        description
        data
      }
      updatedAt
    }
  }
''';

const String logout = '''
  query SignOut {
    signOut()
  }
''';

const String workspacesByOfficeId = r'''
query Workspaces($officeId: ID!) {
  workspaces(officeID: $officeId) {
    id
    name
    officeID
  }
}
''';

const String userBookings = r'''
  query UserBookings($userId: ID!) {
  userBookings(userID: $userId) {
    id
    title
    from
    to
    userID
    officeID
  }
}
''';

const String workspaceTimeslots = r'''
query WorkspaceTimeslots($workspaceId: ID!) {
  workspaceTimeslots(workspaceID: $workspaceId) {
    id
    title
    from
    to
    userID
    officeID
  }
}
''';


