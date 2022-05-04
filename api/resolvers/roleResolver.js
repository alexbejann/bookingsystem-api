'use strict';

import Role from '../models/role';
import {checkPermission} from "../utils/auth";
export default {
    Query: {

    },
    Mutation: {
        addRole: async (parent, args, {user}) => {
            checkPermission(user, true)
            console.log('addRole', parent, args);
            const newRole = new Role({ name: args.roleName });
            return await newRole.save();
        },
        deleteRole: async (parent, args, {user}) => {
            checkPermission(user, false)
            console.log('deleteRole', parent, args);
            return await Role.findOneAndDelete({_id: args.roleID});
        }
    }
};
