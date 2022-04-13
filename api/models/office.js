import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const officeSchema = new Schema({
    name: {type: String, required: true},
    organizationID: {type: mongoose.Types.ObjectId, ref: 'Office'}
});

export default mongoose.model('Office', officeSchema);
