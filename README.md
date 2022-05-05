# BookingSystem

## Description 


### Story 
During the COVID lockdown many companies have reshaped their offices due to the remote working. As a result the office space became a lot smaller and many of the employees would like to keep the remote working in place and come maybe once or twice a week to the office. Therefore, the problem is that everyone has to know which and what desks and rooms are free in the office when they are coming.

### Functionality
The user would be able to login into his account.

The user would be able to see his bookings in 'My Bookings' section. 

The user would be able to book desks/rooms which are free from the 'Book' section.

The user is able to select the dates that he wants to book a desk/room for. 

The administrator/project manager is able to see his team when each one of them are in the office, on-site (based on booking dates).

### Platform users 
The platform is meant for employees of a company that are seeking to book their office time and the office/station that they are going to use during that day at the office.
The platform can be used also for tenants of a building to book the laundry or anything else that can be booked. 

The platform is designed to be used by multiple organizations/buildings/companies meaning that there are roles involved.

___Note: All the Mutations and Queries for the API require the Authorization header followed by Bearer and your token e.g.: Authorization: Bearer <AUTH_TOKEN>, exception from this is the LOGIN mutation___

In the production I've set up an environment. There are 2 organizations (Tapio and ECom) both of the have admin users and normal users

### Credentials
#### ROOT user
```
username: alex
password: admin123
```

#### Normal User
```
username: normalUser
password: admin123
```

#### Normal User Tapio 
```
username: normalUserTapio
password: admin123
```
#### Admin Tapio 
```
username: adminTapio
password: admin123
```

### Queries: 
#### Office
```
offices(organizationID : ID!) : [Office]
```
#### Example 

#### Organizations
```
organizations: [Organization]
```
#### Example 

#### Timeslot

##### User's Bookings
```
userBookings(userID: ID!): [Timeslot]
```
##### Timeslots/Bookings for a workspace
```
workspaceTimeslots(workspaceID: ID!): [Timeslot]
```
#### Example 

##### User's Bookings
```
```
##### Timeslots/Bookings for a workspace
```
```
#### User
```
user(id: ID!): User
```
#### Example 
```
```

#### Workspace
##### All Workspaces by Office Id
```
workspaces(officeID : ID!): [Workspace]
```
##### Workspaces by Organization Id
```
workspacesByOrg(organizationID : ID!): [Workspace]
```
#### Example 
##### All Workspaces by Office Id
```

```
##### Workspaces by Organization Id
```

```

### Mutations: 

#### Office 

##### Add 
```
addOffice(name: String!, organizationID: ID!): Office
```
##### Rename 
```
renameOffice(newName: String!, officeID: ID!) : Office
```
#### Delete by id
```
deleteOffice(id: ID!) : Office
```


#### Organization

___Note: Organization supports only creation at the moment which is perfomed by the company owning the software___
```
addOrganization(name: String!): Organization
```
#### Role

##### Add
```
addRole(roleName: String!) : Role
```
##### Delete
```
deleteRole(roleID: ID!) : Role
```

#### Timeslot

##### Add
```
addTimeslot(
    title: String!
    from: String!
    to: String!
    userID: ID!
    workspaceID: ID!
    ): Timeslot
```
##### Remove/Delete
```
removeTimeslot(timeslotID: ID!): Timeslot
```

#### User

##### Login
```
login(
    username: String!, 
    password: String!
    ): User
```
##### Registratio of a User
___Note: This action is done by the ORGANIZATION_ADMIN role, users are not allowed to do this on their own___
```
registerUser(
      username: String!,
      password: String!,
      role: ID
      organizationID: ID!
    ): User
```
#### Password change
```
changePassword(
      userID: ID!,
      password: String!,
    ): User
```
#### Change role
___Note: Action by Organization Admin___
```
changeUserRole(
      userID: ID!,
      roleID: ID!,
    ): User
```

#### Workspace
##### Add
```
addWorkspace(name: String!, officeID : ID!): Workspace
```
##### Rename
```
renameWorkspace(newName: String!, workspaceID: ID!): Workspace
```
##### Delete
```
deleteWorkspace(id: ID!): Workspace
```

### Schema Types

```
type Office {
  id : ID
  name: String
  organizationID: Organization
}
```

```
type Organization {
  id: ID
  name: String,
}
```

```
input RoleInput {
  id: ID
  name: String
}
```

```
  type Role {
    id: ID
    name: String 
  }
```

```
type Timeslot {
    id: ID
    title: String 
    from: String
    to: String
    userID: User
    workspaceID: Workspace
  }
```

```
  type User {
    id: ID
    username: String
    admin: Boolean
    role: ID
    token: String
    organizationID: ID
  }
```

```
type Workspace {
    id: ID
    name: String
    officeID: Office
  }
```

### Example Platforms

[FlowScape](https://flowscapesolutions.com/solutions/desk-management)

[Condeco](https://www.condecosoftware.com/products/desk-booking/)

[Joan](https://getjoan.com/desk-booking-solution/)

[NSpace](https://getnspace.com/desk-booking/)

[Robin](https://robinpowered.com/products/desks)

[Skedda](https://www.skedda.com/home/desk-booking-system)

[SpaceIQ](https://spaceiq.com/products/employee-experience/hoteling/)

[Tribeloo](https://tribeloo.com/solutions)

[Fischer](https://fischerkerrn.com/products/desk-booking/)

[Envoy](https://envoy.com/products/hot-desk-booking-software/)
