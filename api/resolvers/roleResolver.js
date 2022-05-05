'use strict';

import Role from '../models/role';
import {checkPermission} from "../utils/auth";
export default {
    Query: {

    },
    Mutation: {
        addRole: async (parent, args, {user}) => {
            // TODO allow org admin to add role only to his users
            await checkPermission(user, 'ORGANIZATION_ADMIN')
            console.log('addRole', parent, args);
            const newRole = new Role({ name: args.roleName });
            return await newRole.save();
        },
        deleteRole: async (parent, args, {user}) => {
            /// TODO let org admin to delete only to users from his organization
            await checkPermission(user, 'ORGANIZATION_ADMIN')
            console.log('deleteRole', parent, args);
            return await Role.findOneAndDelete({_id: args.roleID});
        }
    }
};
