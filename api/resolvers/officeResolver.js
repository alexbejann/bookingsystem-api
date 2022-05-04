'use strict';
import Office from '../models/office';
import {checkPermission} from '../utils/auth';
import Workspace from '../models/workspace';

export default {
    Query: {
        offices: async (parent, {organizationID}, {user}) => {
            await checkPermission(user);
            console.log('offices', parent, organizationID);
            return await Office.find({organizationID: organizationID}).populate('organizationID');
        }
    },
    Mutation: {
        addOffice: async (parent, args, {user}) => {
            checkPermission(user, 'ORGANIZATION_ADMIN');
            console.log('addOffice', parent, args);
            const newOffice = new Office(args);
            console.log('newOffice', newOffice);
            return await newOffice.save();
        },
        renameOffice: async (parent, args, {user}) => {
            await checkPermission(user, 'ORGANIZATION_ADMIN');
            console.log('renameOffice', parent, args);
            return await Office.findByIdAndUpdate(args.officeID, {name: args.newName}, {new: true,});
        },
        deleteOffice: async (parent, args, {user}) => {
            await checkPermission(user, 'ORGANIZATION_ADMIN');
            console.log('deleteOffice', parent, args);
            await Workspace.deleteMany({officeID: args.id});
            return await Office.findOneAndDelete({_id: args.id});
        }
    },
};
