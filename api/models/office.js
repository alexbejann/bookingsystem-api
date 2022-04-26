import mongoose from 'mongoose';
import organization from './organization';

const Schema = mongoose.Schema;
/*
    {
        name: "Office 1",
        organizationId: "32rfwve432"
    }
 */
const officeSchema = new Schema({
    name: {type: String, required: true},
    organizationID: {type: mongoose.Types.ObjectId, ref: 'Organization', required: true}
});

export default mongoose.model('Office', officeSchema);
