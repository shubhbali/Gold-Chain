import { promises as fs } from 'node:fs';
import path from 'node:path';

export class JsonRelayerStore {
  constructor(filePath) {
    if (!filePath) throw new Error('state file path is required');
    this.filePath = filePath;
    this.state = { processed: {}, cursors: {} };
  }

  async load() {
    try {
      const raw = await fs.readFile(this.filePath, 'utf8');
      const parsed = JSON.parse(raw);
      this.state = {
        processed: parsed.processed && typeof parsed.processed === 'object' ? parsed.processed : {},
        cursors: parsed.cursors && typeof parsed.cursors === 'object' ? parsed.cursors : {},
      };
    } catch (error) {
      if (error.code !== 'ENOENT') throw error;
    }
  }

  async save() {
    await fs.mkdir(path.dirname(this.filePath), { recursive: true });
    await fs.writeFile(this.filePath, `${JSON.stringify(this.state, null, 2)}\n`);
  }

  hasProcessed(key) {
    return this.state.processed[key] === true;
  }

  markProcessed(key) {
    this.state.processed[key] = true;
  }

  getCursor(name, fallback = 0) {
    return Number(this.state.cursors[name] ?? fallback);
  }

  setCursor(name, blockNumber) {
    if (!Number.isSafeInteger(blockNumber) || blockNumber < 0) throw new Error('invalid cursor block');
    this.state.cursors[name] = blockNumber;
  }
}

export class MemoryRelayerStore {
  constructor() {
    this.state = { processed: {}, cursors: {} };
  }
  async load() {}
  async save() {}
  hasProcessed(key) { return this.state.processed[key] === true; }
  markProcessed(key) { this.state.processed[key] = true; }
  getCursor(name, fallback = 0) { return Number(this.state.cursors[name] ?? fallback); }
  setCursor(name, blockNumber) { this.state.cursors[name] = blockNumber; }
}
