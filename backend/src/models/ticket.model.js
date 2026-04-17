import mongoose from 'mongoose';

const ticketSchema = new mongoose.Schema(
  {
    ticketId: { type: String, required: true, unique: true, index: true },
    userId: { type: String, required: true, index: true },
    tripId: { type: String, required: true, index: true },
    source: { type: String, required: true },
    destination: { type: String, required: true },
    fare: { type: Number, required: true },
    bus_id: { type: String, required: true },
    bus_name: { type: String, required: true },
    seat_no: { type: String, required: true },
    bookingKey: { type: String, index: true, unique: true },
    paymentId: { type: String, default: '' },
    verifiedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

ticketSchema.index({ userId: 1, createdAt: -1 });
ticketSchema.index({ tripId: 1 });

export const Ticket = mongoose.model('Ticket', ticketSchema);
