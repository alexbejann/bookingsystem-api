import mongoose from 'mongoose';
import office from './office';

const Schema = mongoose.Schema;
/*
    {
        title: Alex,
        from: 2022-12-21 12:00:00
        to: 2022-12-21 12:00:00
        userID: "3dfs231few"
        officeID: "211f3wr435243"
    }
 */
const timeslotSchema = new Schema({
    title: {type: String, required: true},
    from: {type: Date, required: true},
    to: {type: Date, required: true},
    userID: {type: mongoose.Types.ObjectId, ref: 'User'},
    officeID: {type: mongoose.Types.ObjectId, ref: office}
});

export default mongoose.model('Timeslot', timeslotSchema);
