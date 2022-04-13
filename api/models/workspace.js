'use strict';
import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const workspaceSchema = new Schema({
    name: String,
    officeID: { type: mongoose.Types.ObjectId, ref: 'Office' },
});

export default mongoose.model('Workspace', workspaceSchema);