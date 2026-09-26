// 브라우저 localStorage 에만 저장한다. 서버로 보내는 곳은 없다.
import { seedState } from './fixtures.js';

export const STORAGE_KEY = 'socialmap-demo:v1';

export function loadState(storage) {
  try {
    const raw = storage.getItem(STORAGE_KEY);
    if (!raw) return { state: seedState(), restored: false };
    const state = JSON.parse(raw);
    if (!state || state.version !== 1 || !Array.isArray(state.projectteam)) throw new Error('형식이 다릅니다');
    return { state, restored: true };
  } catch (e) {
    storage.removeItem(STORAGE_KEY);
    return { state: seedState(), restored: false, error: e };
  }
}

export function saveState(storage, state) {
  storage.setItem(STORAGE_KEY, JSON.stringify(state));
}

export function resetState(storage) {
  storage.removeItem(STORAGE_KEY);
  return seedState();
}
