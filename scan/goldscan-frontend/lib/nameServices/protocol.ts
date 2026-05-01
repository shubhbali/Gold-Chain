import type * as bens from '@goldchain-scan/bens-types';
import type * as multichain from '@goldchain-scan/multichain-aggregator-types';

type ProtocolInfo = bens.ProtocolInfo | multichain.ProtocolInfo | undefined;

export function getProtocolExplorerBaseUrl(protocol: ProtocolInfo): string {
  if (!protocol) {
    return '';
  }

  const record = protocol as unknown as Record<string, unknown>;
  const preferredValue = record.deployment_explorer_base_url;
  if (typeof preferredValue === 'string') {
    return preferredValue;
  }

  const fallbackValue = Object.entries(record).find(([ key, value ]) => {
    return key.startsWith('deployment_') && key.endsWith('_base_url') && typeof value === 'string';
  })?.[1];

  return typeof fallbackValue === 'string' ? fallbackValue : '';
}
