import { Router } from 'express';
import crypto from 'crypto';
import { body, validationResult } from 'express-validator';
import { authenticate } from '../middleware/auth.js';
import { Ticket } from '../models/ticket.model.js';
import { Payment } from '../models/payment.model.js';
import { failure, success } from '../utils/response.js';

const router = Router();

router.post('/get-tickets', body('user_id').notEmpty(), async (req, res) => {
  const tickets = await Ticket.find({ userId: req.body.user_id }).sort({ createdAt: -1 }).lean();
  return res.json(success(tickets));
});

router.post(
  '/create-ticket',
  body('userId').notEmpty(),
  body('source').trim().notEmpty(),
  body('destination').trim().notEmpty(),
  body('fare').isFloat({ min: 0 }),
  body('seat_no').trim().notEmpty(),
  body('trip_id').optional().trim(),
  body('idempotency_key').optional().trim(),
  authenticate,
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json(failure(errors.array()[0].msg, 'ERR_VALIDATION'));
    }
    if (req.user.userId !== req.body.userId) {
      return res.status(403).json(failure('Forbidden', 'ERR_FORBIDDEN'));
    }

    const bookingKey =
      req.body.idempotency_key ||
      crypto
        .createHash('sha256')
        .update(
          `${req.body.userId}|${req.body.trip_id || 'NA'}|${req.body.destination}|${req.body.seat_no}`
        )
        .digest('hex');

    const existing = await Ticket.findOne({ bookingKey }).lean();
    if (existing) return res.json(success(existing, 'idempotent_replay'));

    const payment = await Payment.create({
      paymentId: `pay_${Date.now()}`,
      userId: req.body.userId,
      tripId: req.body.trip_id || '',
      amount: Number(req.body.fare),
      status: 'success'
    });

    const ticket = await Ticket.create({
      ticketId: `tkt_${Date.now()}`,
      userId: req.body.userId,
      tripId: req.body.trip_id || '',
      source: req.body.source,
      destination: req.body.destination,
      fare: Number(req.body.fare),
      bus_id: req.body.bus_id,
      bus_name: req.body.bus_name,
      seat_no: req.body.seat_no,
      bookingKey,
      paymentId: payment.paymentId,
    });
    return res.status(201).json(success(ticket));
  }
);

router.get('/tickets/:ticketId/verify', authenticate, async (req, res) => {
  const ticket = await Ticket.findOne({ ticketId: req.params.ticketId });
  if (!ticket) return res.status(404).json(failure('Ticket not found', 'ERR_NOT_FOUND'));
  ticket.verifiedAt = new Date();
  await ticket.save();
  return res.json(success(ticket));
});

export default router;
