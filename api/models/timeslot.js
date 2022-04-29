import mongoose from 'mongoose';
import workspace from './workspace';
import user from './user';

const Schema = mongoose.Schema;
/*
    {
        title: Alex,
        from: 2022-12-21 12:00:00
        to: 2022-12-21 12:00:00
        userID: "3dfs231few"
        workspaceID: "211f3wr435243"
    }
 */
const timeslotSchema = new Schema({
    title: {type: String, required: true},
    from: {type: Date, required: true},
    to: {type: Date, required: true},
    userID: {type: mongoose.Types.ObjectId, ref: user},
    workspaceID: {type: mongoose.Types.ObjectId, ref: workspace}
});

export default mongoose.model('Timeslot', timeslotSchema);
