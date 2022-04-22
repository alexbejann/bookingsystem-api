'use strict';
import Office from '../models/office';

export default {
    Query: {
        offices: async (parent, args) => {
            console.log('offices', parent, args);
            return await Office.find({organizationID: args.organizationID});
        }
    },
    Mutation: {
        addOffice: async (parent, args) => {
            console.log('addOffice', parent, args);
            const newOffice = new Office(args);
            console.log('newOffice', newOffice);
            return await newOffice.save();
        },
        renameOffice: async (parent, args) => {
            console.log('renameOffice', parent, args);
            return await Office.findByIdAndUpdate(args.officeID, {name: args.newName}, {new: true,});
        },
        deleteOffice: async (parent, args) => {
            console.log('deleteOffice', parent, args);
            return await Office.findOneAndDelete({_id: args.ID});
        }
    },
};
