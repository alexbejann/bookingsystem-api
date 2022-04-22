'use strict';
import Workspace from '../models/workspace';

export default {
    Query: {
        workspaces: async (parent, args) => {
            console.log('workspaces', parent, args);
            return await Workspace.find({officeId: args.officeID});
        }
    },
    Mutation: {
        addWorkspace: async (parent, args) => {
            console.log('addWorkspace', parent, args);
            const newWorkspace = new Workspace(args);
            console.log('newWorkspace', newWorkspace);
            return await newWorkspace.save();
        },
        renameWorkspace: async (parent, args) => {
            console.log('renameWorkspace', parent, args);
            return await Workspace
                .findByIdAndUpdate(args.workspaceID,
                    {
                        name: args.newName
                    },
                    {
                        new: true,
                    });
        },
        deleteWorkspace: async (parent, args) => {
            console.log('deleteWorkspace', parent, args);
            return await Workspace.findOneAndDelete({_id: args.id});
        }
    },
};
