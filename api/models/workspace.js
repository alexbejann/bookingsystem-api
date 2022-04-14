'use strict';
import mongoose from 'mongoose';
import office from './office';

const Schema = mongoose.Schema;

const workspaceSchema = new Schema({
    name: String,
    officeID: { type: mongoose.Types.ObjectId, ref: office, required: true},
});

export default mongoose.model('Workspace', workspaceSchema);