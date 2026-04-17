import mongoose from 'mongoose';

const paymentSchema = new mongoose.Schema(
  {
    paymentId: { type: String, required: true, unique: true, index: true },
    userId: { type: String, required: true, index: true },
    tripId: { type: String, required: true, index: true },
    amount: { type: Number, required: true },
    status: { type: String, enum: ['created', 'success', 'failed'], default: 'created' },
    providerRef: { type: String, default: '' },
  },
  { timestamps: true }
);

export const Payment = mongoose.model('Payment', paymentSchema);
