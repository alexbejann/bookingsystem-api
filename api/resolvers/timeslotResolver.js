'use strict';

import Timeslot from '../models/timeslot';
export default {
    Query: {
        userBookings: async (parent, args) => {
            console.log('userBookings', parent, args);
            return await Timeslot.find({userID: args.userID});
        },
        workspaceTimeslots: async (parent, args) => {
            console.log('workspaceTimeslots', parent, args);
            return await Timeslot.find({workSpaceID: args.workSpaceID});
        },

    },
    Mutation: {
        addTimeslots: async (parent, args) => {
            console.log('addTimeslots', parent, args);
            const newTimeslot = new Timeslot(args);
            console.log('newTimeslot', newTimeslot);
            return await newTimeslot.save();
        },
        removeTimeslot: async (parent, args) => {
            console.log('removeTimeslot', parent, args);
            return await Timeslot.findOneAndDelete({_id: args.timeslotID});
        }
    }
};
