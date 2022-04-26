'use strict';

import Timeslot from '../models/timeslot';
import {checkPermission} from "../utils/auth";
export default {
    Query: {
        userBookings: async (parent, args, {user}) => {
            checkPermission(user, false);
            console.log('userBookings', parent, args);
            return await Timeslot.find({userID: args.userID});
        },
        workspaceTimeslots: async (parent, args, {user}) => {
            checkPermission(user, false);
            console.log('workspaceTimeslots', parent, args);
            return await Timeslot.find({workSpaceID: args.workSpaceID});
        },

    },
    Mutation: {
        addTimeslot: async (parent, args, {user}) => {
            checkPermission(user, false)
            console.log('addTimeslots', parent, args);
            const newTimeslot = new Timeslot(args);
            console.log('newTimeslot', newTimeslot);
            return await newTimeslot.save();
        },
        removeTimeslot: async (parent, args, {user}) => {
            checkPermission(user, false)
            console.log('removeTimeslot', parent, args);
            return await Timeslot.findOneAndDelete({_id: args.timeslotID});
        }
    }
};
