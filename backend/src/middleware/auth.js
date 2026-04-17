import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';
import { failure } from '../utils/response.js';

export function authenticate(req, res, next) {
  const header = req.headers.authorization ?? '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : '';
  if (!token) return res.status(401).json(failure('Unauthorized', 'ERR_UNAUTHORIZED'));

  try {
    const payload = jwt.verify(token, env.jwtSecret);
    req.user = payload;
    return next();
  } catch (_) {
    return res.status(401).json(failure('Invalid token', 'ERR_INVALID_TOKEN'));
  }
}

export function authorize(...roles) {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json(failure('Forbidden', 'ERR_FORBIDDEN'));
    }
    return next();
  };
}
