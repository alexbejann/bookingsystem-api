import {gql} from 'apollo-server-express';
import userSchema from './userSchema';
import organizationSchema from "./organizationSchema";

const linkSchema = gql`
  type Query {
    _: Boolean
  }
  type Mutation {
    _: Boolean
  }
`;

export default [
    linkSchema,
    userSchema,
    organizationSchema,
];