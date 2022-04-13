'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    user(id: ID!): User
    login(username: String!, password: String!): User
  }
  
  extend type Mutation {
    addOrganization(name: String!): Organization
  }
  
  type Organization {
    id: ID
    name: String,
  }
`;
