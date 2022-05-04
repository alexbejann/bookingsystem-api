import mongoose from 'mongoose';

const Schema = mongoose.Schema;
/*
    {
        name: "Carpenter BV"
    }
 */
const roleSchema = new Schema({
    name: {type: String, unique: true, required: true}
});

export default mongoose.model('Role', roleSchema);
