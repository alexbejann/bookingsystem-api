import {gql} from 'apollo-server-express';
import userSchema from './userSchema';
import organizationSchema from './organizationSchema';
import officeSchema from "./officeSchema";
import workspaceSchema from "./workspaceSchema";
import timeslotSchema from "./timeslotSchema";
import roleSchema from "./roleSchema";

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
    officeSchema,
    workspaceSchema,
    timeslotSchema,
    roleSchema,
];