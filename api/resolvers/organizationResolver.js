'use strict';
import Organization from "../models/organization";
import {checkPermission} from "../utils/auth";

export default {
    Query: {
        organizations: async (parent, args, {user}) => {
            await checkPermission(user, 'ROOT');
            return Organization.find();
        },
    },
    Mutation: {
        addOrganization: async (parent, args, {user}) => {
            try {
                await checkPermission(user,'ROOT');
                console.log(parent, args);
                const newOrg = new Organization(args);
                console.log(newOrg);
                return await newOrg.save();
            } catch (err) {
                throw new Error(err);
            }
        },
    },
};
