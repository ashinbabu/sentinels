import mongoose from 'mongoose';

const tripSchema = new mongoose.Schema(
  {
    tripId: { type: String, required: true, unique: true, index: true },
    busId: { type: String, required: true, index: true },
    busName: { type: String, default: '' },
    routeId: { type: String, required: true, index: true },
    source: { type: String, required: true },
    destinations: [{ service_id: String, service_name: String }],
    baseFare: { type: Number, default: 0 },
    startsAt: { type: Date, required: true },
  },
  { timestamps: true }
);

export const Trip = mongoose.model('Trip', tripSchema);
