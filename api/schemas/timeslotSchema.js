'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  scalar DateTime
    
  extend type Query {
    userBookings(userID: ID!): [Timeslot]
    workspaceTimeslots(workspaceID: ID!): [Timeslot]
  }
  
  extend type Mutation {
    addTimeslot(
    title: String!
    from: DateTime!
    to: DateTime!
    userID: ID
    workspaceID: ID
    ): Timeslot
    
    removeTimeslot(timeslotID: ID!): Timeslot
  }
  
  type Timeslot {
    id: ID
    title: String 
    from: DateTime
    to: DateTime
    userID: User
    workspaceID: Workspace
  }
`;
