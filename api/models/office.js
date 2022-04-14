import mongoose from 'mongoose';
import organization from './organization';

const Schema = mongoose.Schema;

const officeSchema = new Schema({
    name: {type: String, required: true},
    organizationID: {type: mongoose.Types.ObjectId, ref: organization, required: true}
});

export default mongoose.model('Office', officeSchema);
