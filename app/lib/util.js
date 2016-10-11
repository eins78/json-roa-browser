export function Try (func) {
  try { return func() } catch (e) { /* ignore */ }
}
