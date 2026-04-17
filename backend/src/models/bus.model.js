import mongoose from 'mongoose';

const busSchema = new mongoose.Schema(
  {
    busId: { type: String, required: true, unique: true, index: true },
    busName: { type: String, required: true },
    seats: { type: Number, default: 40 },
  },
  { timestamps: true }
);

export const Bus = mongoose.model('Bus', busSchema);
