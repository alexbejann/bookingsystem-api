import mongoose from 'mongoose';
import office from './office';

const Schema = mongoose.Schema;

const timeslotSchema = new Schema({
    timestamp: Date,
    userID: {type: mongoose.Types.ObjectId, ref: 'User'},
    officeID: {type: mongoose.Types.ObjectId, ref: office}
});

export default mongoose.model('Timeslot', timeslotSchema);
