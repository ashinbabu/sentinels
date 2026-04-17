import { Router } from 'express';
import crypto from 'crypto';
import { body, validationResult } from 'express-validator';
import { authenticate } from '../middleware/auth.js';
import { Ticket } from '../models/ticket.model.js';
import { Payment } from '../models/payment.model.js';
import { safeId } from '../utils/sanitize.js';
import { failure, success } from '../utils/response.js';

const router = Router();

router.post('/get-tickets', authenticate, body('user_id').notEmpty(), async (req, res) => {
  const userId = safeId(req.body.user_id, 'user_id');
  if (req.user.userId !== userId) {
    return res.status(403).json(failure('Forbidden', 'ERR_FORBIDDEN'));
  }
  const tickets = await Ticket.find({ userId }).sort({ createdAt: -1 }).lean();
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
    const userId = safeId(req.body.userId, 'userId');
    if (req.user.userId !== userId) {
      return res.status(403).json(failure('Forbidden', 'ERR_FORBIDDEN'));
    }
    const tripId = req.body.trip_id ? safeId(req.body.trip_id, 'trip_id') : '';
    const idempotencyKey = req.body.idempotency_key?.toString().trim() ?? '';
    const bookingKey =
      idempotencyKey.isNotEmpty
          ? crypto.createHash('sha256').update(idempotencyKey).digest('hex')
          : crypto.randomUUID();

    if (idempotencyKey.isNotEmpty) {
      const existing = await Ticket.findOne({ bookingKey }).lean();
      if (existing) return res.json(success(existing, 'idempotent_replay'));
    }

    const payment = await Payment.create({
      paymentId: `pay_${Date.now()}`,
      userId,
      tripId,
      amount: Number(req.body.fare),
      status: 'success'
    });

    const ticket = await Ticket.create({
      ticketId: `tkt_${Date.now()}`,
      userId,
      tripId,
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
  const ticketId = safeId(req.params.ticketId, 'ticketId');
  const ticket = await Ticket.findOne({ ticketId });
  if (!ticket) return res.status(404).json(failure('Ticket not found', 'ERR_NOT_FOUND'));
  ticket.verifiedAt = new Date();
  await ticket.save();
  return res.json(success(ticket));
});

export default router;
