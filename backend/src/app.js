import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';
import authRoutes from './routes/auth.routes.js';
import qrRoutes from './routes/qr.routes.js';
import ticketRoutes from './routes/ticket.routes.js';
import { env } from './config/env.js';
import { errorHandler } from './middleware/error-handler.js';
import { apiRateLimit } from './middleware/rate-limit.js';
import { success } from './utils/response.js';

export function createApp() {
  const app = express();
  app.use(helmet());
  const allowedOrigins = env.corsOrigin
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
  app.use(
    cors({
      origin(origin, callback) {
        if (!origin || allowedOrigins.includes(origin)) return callback(null, true);
        return callback(new Error('CORS blocked'));
      },
    })
  );
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(morgan('combined'));
  app.use('/api', apiRateLimit);

  app.get('/health', (_req, res) => res.json(success({ up: true })));
  app.use('/api', authRoutes);
  app.use('/api', qrRoutes);
  app.use('/api', ticketRoutes);
  app.use(errorHandler);
  return app;
}
