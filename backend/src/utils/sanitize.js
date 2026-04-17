const SAFE_ID_PATTERN = /^[A-Za-z0-9._:-]+$/;

export function safeId(input, name = 'id') {
  const value = String(input ?? '').trim();
  if (!value || !SAFE_ID_PATTERN.test(value)) {
    const error = new Error(`Invalid ${name}`);
    error.statusCode = 400;
    throw error;
  }
  return value;
}
