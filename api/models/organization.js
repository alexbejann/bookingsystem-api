import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const organizationSchema = new Schema({
    name: {type: String, unique: true, required: true}
});

export default mongoose.model('Organization', organizationSchema);
