import type { ArrayElement } from 'types/utils';

export const PROVIDERS = [
  'goldscan',
  'noves',
  'none',
] as const;

export type Provider = ArrayElement<typeof PROVIDERS>;
