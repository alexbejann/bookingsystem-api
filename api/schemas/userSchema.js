import {gql} from 'apollo-server-express';

export default gql`
  extend type Query {
    user(id: ID!): User
    login(username: String!, password: String!): User
  }
  
  extend type Mutation {
    registerUser(
      username: String!,
      password: String!,
      admin: Boolean,
      organizationID: ID!
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
