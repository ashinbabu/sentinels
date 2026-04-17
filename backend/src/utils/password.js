import crypto from 'crypto';

export function hashPassword(plainTextPassword) {
  const salt = crypto.randomBytes(16).toString('hex');
  const derived = crypto.pbkdf2Sync(plainTextPassword, salt, 120000, 64, 'sha512').toString('hex');
  return `${salt}:${derived}`;
}

export function verifyPassword(plainTextPassword, storedHash) {
  const [salt, digest] = storedHash.split(':');
  if (!salt || !digest) return false;
  const derived = crypto.pbkdf2Sync(plainTextPassword, salt, 120000, 64, 'sha512').toString('hex');
  return crypto.timingSafeEqual(Buffer.from(derived, 'hex'), Buffer.from(digest, 'hex'));
}
