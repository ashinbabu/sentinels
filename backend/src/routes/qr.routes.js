import { Router } from 'express';
import { query, validationResult } from 'express-validator';
import { QRCode } from '../models/qr-code.model.js';
import { Trip } from '../models/trip.model.js';
import { failure, success } from '../utils/response.js';

const router = Router();

router.get('/get-qr-details', query('qr_code').trim().notEmpty(), async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json(failure(errors.array()[0].msg, 'ERR_VALIDATION'));

  const qr = await QRCode.findOne({ token: req.query.qr_code }).lean();
  if (!qr) return res.status(404).json(failure('QR not found', 'ERR_QR_NOT_FOUND'));
  if (new Date(qr.expiresAt).getTime() < Date.now()) {
    return res.status(410).json(failure('QR expired', 'ERR_QR_EXPIRED'));
  }

  const trip = await Trip.findOne({ tripId: qr.tripId }).lean();
  if (!trip) return res.status(404).json(failure('Trip not found', 'ERR_TRIP_NOT_FOUND'));

  return res.json(
    success([
      {
        qr_code: req.query.qr_code,
        trip_id: trip.tripId,
        bus_id: trip.busId,
        bus_name: trip.busName ?? '',
        source: trip.source,
        fare: trip.baseFare,
        destinations: trip.destinations ?? [],
      },
    ])
  );
});

router.get('/fare', query('trip_id').trim().notEmpty(), query('destination').trim().notEmpty(), async (req, res) => {
  const trip = await Trip.findOne({ tripId: req.query.trip_id }).lean();
  if (!trip) return res.status(404).json(failure('Trip not found', 'ERR_TRIP_NOT_FOUND'));
  return res.json(success({ fare: trip.baseFare, currency: 'INR' }));
});

export default router;
