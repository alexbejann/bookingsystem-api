import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const timeslotSchema = new Schema({
    timestamp: Date,
    userID: {type: mongoose.Types.ObjectId, ref: 'User'},
    officeID: {type: mongoose.Types.ObjectId, ref: 'Office'}
});

export default mongoose.model('Timeslot', timeslotSchema);
