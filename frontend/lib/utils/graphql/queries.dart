const getOrganizations = '''
query Organizations {
  organizations {
    id
    name
  }
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

const String workspacesByOrg = r'''
query Query($organizationId: ID!) {
  workspacesByOrg(organizationID: $organizationId) {
    id
    name
    officeID {
      id
      name
    }
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


