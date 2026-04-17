import mongoose from 'mongoose';

const routeSchema = new mongoose.Schema(
  {
    routeId: { type: String, required: true, unique: true, index: true },
    source: { type: String, required: true },
    stops: [{ type: String, required: true }],
  },
  { timestamps: true }
);

export const Route = mongoose.model('Route', routeSchema);
