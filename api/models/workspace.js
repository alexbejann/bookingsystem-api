'use strict';
import mongoose from 'mongoose';
import office from './office';

const Schema = mongoose.Schema;
/*
    {
        name: "Workspace 1",
        officeID: '625689f1bc5bb6b2cdd790cf'
    }
 */
const workspaceSchema = new Schema({
    name: String,
    officeID: { type: mongoose.Types.ObjectId, ref: office, required: true},
});

export default mongoose.model('Workspace', workspaceSchema);