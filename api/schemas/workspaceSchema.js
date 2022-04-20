'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    workspaces(organizationID : ID!): [Workspace]
  }
  
  extend type Mutation {
    addWorkspace(name: String!): Workspace
    renameOffice(name: String!): Workspace
    deleteOffice(id: ID!): Workspace
  }
  
  type Workspace {
    id: ID
    name: String
  }
`;
