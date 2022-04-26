'use strict';
import Office from '../models/office';
import {checkPermission} from "../utils/auth";

export default {
    Query: {
        offices: async (parent, {organizationID}, {user}) => {
            checkPermission(user, false);
            console.log('offices', parent, organizationID);
            return await Office.find({organizationID: organizationID}).populate('organizationID');
        }
    },
    Mutation: {
        addOffice: async (parent, args, {user}) => {
            checkPermission(user, true);
            console.log('addOffice', parent, args);
            const newOffice = new Office(args);
            console.log('newOffice', newOffice);
            return await newOffice.save();
        },
        renameOffice: async (parent, args, {user}) => {
            checkPermission(user, true);
            console.log('renameOffice', parent, args);
            return await Office.findByIdAndUpdate(args.officeID, {name: args.newName}, {new: true,});
        },
        deleteOffice: async (parent, args, {user}) => {
            checkPermission(user, true);
            console.log('deleteOffice', parent, args);
            return await Office.findOneAndDelete({_id: args.id});
        }
    },
};
