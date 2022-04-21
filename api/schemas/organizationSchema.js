'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    organizations: Organization
  }
  
  extend type Mutation {
    addOrganization(name: String!): Organization
  }
  
  type Organization {
    id: ID
    name: String,
  }
`;
