'use strict';
import Workspace from '../models/workspace';
import {checkPermission} from "../utils/auth";
import Timeslot from "../models/timeslot";

export default {
    Query: {
        workspaces: async (parent, args, {user}) => {
            checkPermission(user, false);
            console.log('workspaces', parent, args);
            return await Workspace.find({officeId: args.officeID}).populate('officeID');
        },
        workspacesByOrg: async (parent, args, {user}) => {
            checkPermission(user, false);
            console.log('workspaces', parent, args);
            return await Workspace.find().populate('officeID').where({organizationId: args.organizationID});
        }
    },
    Mutation: {
        addWorkspace: async (parent, args, {user}) => {
            checkPermission(user, true);
            console.log('addWorkspace', parent, args);
            const newWorkspace = new Workspace(args);
            console.log('newWorkspace', newWorkspace);
            const savedWork = await newWorkspace.save();
            return await Workspace.findOne({_id: savedWork._id}).populate('officeID');
        },
        renameWorkspace: async (parent, args, {user}) => {
            checkPermission(user, true);
            console.log('renameWorkspace', parent, args);
            return await Workspace
                .findByIdAndUpdate(args.workspaceID,
                    {
                        name: args.newName
                    },
                    {
                        new: true,
                    }).populate('officeID');
        },
        deleteWorkspace: async (parent, args, {user}) => {
            checkPermission(user, true);
            console.log('deleteWorkspace', parent, args);
            await Timeslot.deleteMany({workspaceID: args.id});
            return await Workspace.findOneAndDelete({_id: args.id});
        }
    },
};
