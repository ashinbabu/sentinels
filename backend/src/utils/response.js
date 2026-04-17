export function success(data = {}, message = 'ok') {
  return { status: 'success', message, data };
}

export function failure(error = 'Something went wrong', code = 'ERR_GENERIC') {
  return { status: 'failure', error, code };
}
