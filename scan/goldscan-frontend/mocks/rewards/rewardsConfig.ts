import type { GetConfigResponse } from '@goldchain-scan/points-types';

export const base = {
  rewards: {
    registration: '100',
    registration_with_referral: '200',
    daily_claim: '10',
    referral_share: '0.1',
    streak_bonuses: {},
    sent_transactions_activity_rewards: {
      '1': '100',
    },
    verified_contracts_activity_rewards: {
      '1': '100',
    },
    goldscan_usage_activity_rewards: {
      '1': '100',
    },
    goldscan_activity_pass_id: '1',
  },
  auth: {
    shared_siwe_login: true,
  },
  activity: {
    sent_transactions_activity_enabled: true,
    verified_contracts_activity_enabled: true,
    goldscan_usage_activity_enabled: true,
  },
} as unknown as GetConfigResponse;
