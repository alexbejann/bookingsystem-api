'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    offices(organizationID : ID!) : [Office]
  }
  
  extend type Mutation {
    addOffice(name: String!, organizationID: ID!): Office
    renameOffice(newName: String!, officeID: ID!) : Office
    deleteOffice(id: ID!) : Office
  }
  
  type Office {
    id : ID
    name: String
    organizationID: Organization
  }
`;
