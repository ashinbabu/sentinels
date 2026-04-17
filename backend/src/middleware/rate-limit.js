import rateLimit from 'express-rate-limit';
import { failure } from '../utils/response.js';

export const apiRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: failure('Too many requests', 'ERR_RATE_LIMIT'),
});

export const authRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: failure('Too many auth requests', 'ERR_RATE_LIMIT'),
});
