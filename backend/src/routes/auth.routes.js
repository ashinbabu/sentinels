import { Router } from 'express';
import jwt from 'jsonwebtoken';
import { body, matchedData, validationResult } from 'express-validator';
import { env } from '../config/env.js';
import { authRateLimit } from '../middleware/rate-limit.js';
import { User } from '../models/user.model.js';
import { hashPassword, verifyPassword } from '../utils/password.js';
import { failure, success } from '../utils/response.js';

const router = Router();

router.post(
  '/register',
  authRateLimit,
  body('name').trim().notEmpty(),
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json(failure(errors.array()[0].msg, 'ERR_VALIDATION'));
    }
    const data = matchedData(req);
    return User.create({
      name: data.name,
      email: data.email,
      passwordHash: hashPassword(data.password),
    })
      .then(() => res.status(201).json(success({ registered: true })))
      .catch((err) =>
        res.status(400).json(failure(err.code === 11000 ? 'Email already exists' : 'Register failed'))
      );
  }
);

router.post('/login', authRateLimit, body('email').isEmail(), body('password').notEmpty(), async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json(failure(errors.array()[0].msg, 'ERR_VALIDATION'));
  const data = matchedData(req);

  const user = await User.findOne({ email: data.email }).lean();
  if (!user || !verifyPassword(data.password, user.passwordHash)) {
    return res.status(401).json(failure('Invalid credentials', 'ERR_INVALID_CREDENTIALS'));
  }

  const token = jwt.sign({ userId: user._id.toString(), role: user.role }, env.jwtSecret, {
    expiresIn: env.jwtExpiresIn,
  });
  return res.json(success({ token, user_id: user._id.toString() }));
});

export default router;
