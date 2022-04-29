'use strict';

import Timeslot from '../models/timeslot';
import {checkPermission} from "../utils/auth";
export default {
    Query: {
        userBookings: async (parent, args, {user}) => {
            checkPermission(user, false);
            console.log('userBookings', parent, args);
            return await Timeslot.find().populate('userID').where({userID: args.userID});
        },
        workspaceTimeslots: async (parent, args, {user}) => {
            checkPermission(user, false);
            console.log('workspaceTimeslots', parent, args);
            return await Timeslot.find().populate('workspaceID').where({workspaceID: args.workspaceID});
        },

    },
    Mutation: {
        addTimeslot: async (parent, args, {user}) => {
            checkPermission(user, false)
            console.log('addTimeslots', parent, args);
            const existingTimeslot = await Timeslot.findOne({from: args.from, workspaceID: args.workspaceID})
            console.log('existing ',existingTimeslot);
            if (existingTimeslot) {
                throw new Error('There is already a booking for this timeslot.');
            }
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
