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
      admin: Boolean,
      organizationID: ID!
    ): User
    changePassword(
      userID: ID!,
      password: String!,
    ): User
  }
  
  type User {
    id: ID
    username: String,
    admin: Boolean
    token: String
    organizationID: ID
  }
`;
