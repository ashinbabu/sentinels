import { Router } from 'express';
import jwt from 'jsonwebtoken';
import { body, validationResult } from 'express-validator';
import { env } from '../config/env.js';
import { User } from '../models/user.model.js';
import { hashPassword, verifyPassword } from '../utils/password.js';
import { failure, success } from '../utils/response.js';

const router = Router();

router.post(
  '/register',
  body('name').trim().notEmpty(),
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json(failure(errors.array()[0].msg, 'ERR_VALIDATION'));
    }
      return User.create({
      name: req.body.name,
      email: req.body.email,
      passwordHash: hashPassword(req.body.password),
    })
      .then(() => res.status(201).json(success({ registered: true })))
      .catch((err) =>
        res.status(400).json(failure(err.code === 11000 ? 'Email already exists' : 'Register failed'))
      );
  }
);

router.post('/login', body('email').isEmail(), body('password').notEmpty(), async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json(failure(errors.array()[0].msg, 'ERR_VALIDATION'));

  const user = await User.findOne({ email: req.body.email }).lean();
  if (!user || !verifyPassword(req.body.password, user.passwordHash)) {
    return res.status(401).json(failure('Invalid credentials', 'ERR_INVALID_CREDENTIALS'));
  }

  const token = jwt.sign({ userId: user._id.toString(), role: user.role }, env.jwtSecret, {
    expiresIn: env.jwtExpiresIn,
  });
  return res.json(success({ token, user_id: user._id.toString() }));
});

export default router;
