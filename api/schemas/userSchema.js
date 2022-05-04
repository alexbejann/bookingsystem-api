import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    user(id: ID!): User
  }
  
  extend type Mutation {
    login(
    username: String!, 
    password: String!
    ): User
    registerUser(
      username: String!,
      password: String!,
      role: ID
      organizationID: ID!
    ): User
    changePassword(
      userID: ID!,
      password: String!,
    ): User
    changeUserRole(
      userID: ID!,
      roleID: ID!,
    ): User
  }
  
  type User {
    id: ID
    username: String
    admin: Boolean
    role: ID
    token: String
    organizationID: ID
  }
`;
