import { failure } from '../utils/response.js';

export function errorHandler(err, _req, res, _next) {
  const status = err.statusCode ?? 500;
  const message = err.message ?? 'Internal server error';
  return res.status(status).json(failure(message, 'ERR_INTERNAL'));
}
