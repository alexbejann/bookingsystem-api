'use strict';

import Organization from "../models/organization";

export default {
    Query: {
        organizations: async (parent, args) => {
            return Organization.find();
        },
    },
    Mutation: {
        addOrganization: async (parent, args) => {
            try {
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
