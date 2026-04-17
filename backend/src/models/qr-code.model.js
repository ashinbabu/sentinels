import mongoose from 'mongoose';

const qrCodeSchema = new mongoose.Schema(
  {
    token: { type: String, required: true, unique: true, index: true },
    tripId: { type: String, required: true, index: true },
    expiresAt: { type: Date, required: true, index: true },
  },
  { timestamps: true }
);

export const QRCode = mongoose.model('QRCode', qrCodeSchema);
