'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    workspaces(officeID : ID!): [Workspace]
  }
  
  extend type Mutation {
    addWorkspace(name: String!, officeID : ID!): Workspace
    renameWorkspace(newName: String!, workspaceID: ID!): Workspace
    deleteWorkspace(id: ID!): Workspace
  }
  
  type Workspace {
    id: ID
    name: String
    officeID: Office
  }
`;
