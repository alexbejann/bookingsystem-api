'use strict';
import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    offices(organizationID : ID!) : [Office]
  }
  
  extend type Mutation {
    addOffice(name: String!): Office
    renameOffice(name: String!) : Office
    deleteOffice(id: ID!) : Office
  }
  
  type Office {
    id : String
    name: String
  }
`;
