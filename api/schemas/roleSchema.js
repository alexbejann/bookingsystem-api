'use strict';
import {gql} from 'apollo-server-express';

export default gql`  
  extend type Mutation {
    addRole(roleName: String!) : Role
    deleteRole(roleID: ID!) : Role
  }
  
  type Role {
    id: ID
    name: String 
  }
  
  input RoleInput {
    id: ID
    name: String
  }
`;
