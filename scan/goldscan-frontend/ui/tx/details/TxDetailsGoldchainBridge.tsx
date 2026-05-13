import React from 'react';

import type { GoldchainBridgeTransferItem } from 'types/api/goldchain';

import config from 'configs/app';
import useApiQuery from 'lib/api/useApiQuery';
import * as DetailedInfo from 'ui/shared/DetailedInfo/DetailedInfo';
import TxEntity from 'ui/shared/entities/tx/TxEntity';
import TxEntityL1 from 'ui/shared/entities/tx/TxEntityL1';
import TextSeparator from 'ui/shared/TextSeparator';

interface Props {
  hash: string;
  isLoading: boolean;
}

function actionSummary(item: GoldchainBridgeTransferItem) {
  const direction = item.bridge_state === 'released' || item.bridge_state === 'burned_or_debited' ? 'withdrawal' : 'deposit';
  const route = item.route_asset ? ` (${ String(item.route_asset).toUpperCase() })` : '';
  return `${ direction }${ route }: ${ item.bridge_state }`;
}

const TxDetailsGoldchainBridge = ({ hash, isLoading }: Props) => {
  const rollupFeature = config.features.rollup;

  const query = useApiQuery('general:goldchain_bridge_transfers', {
    queryParams: {
      transaction_hash: hash,
    },
    queryOptions: {
      enabled: rollupFeature.isEnabled && rollupFeature.type === 'goldchain',
      staleTime: Infinity,
    },
  });

  if (!(rollupFeature.isEnabled && rollupFeature.type === 'goldchain')) {
    return null;
  }

  const transfer = query.data?.items?.[0];
  if (!transfer && !query.isPlaceholderData && !query.isPending) {
    return null;
  }

  return (
    <>
      <DetailedInfo.ItemLabel isLoading={ isLoading || query.isPlaceholderData }>Gold bridge action</DetailedInfo.ItemLabel>
      <DetailedInfo.ItemValue>
        { transfer ? actionSummary(transfer) : 'Pending decode' }
      </DetailedInfo.ItemValue>

      <DetailedInfo.ItemLabel isLoading={ isLoading || query.isPlaceholderData }>Gold bridge finality</DetailedInfo.ItemLabel>
      <DetailedInfo.ItemValue>
        { transfer ? transfer.finality_status : 'pending' }
      </DetailedInfo.ItemValue>

      <DetailedInfo.ItemLabel isLoading={ isLoading || query.isPlaceholderData }>Gold bridge links</DetailedInfo.ItemLabel>
      <DetailedInfo.ItemValue>
        { transfer?.l1_transaction_hash ? <TxEntityL1 hash={ transfer.l1_transaction_hash } isLoading={ isLoading || query.isPlaceholderData }/> : 'N/A' }
        <TextSeparator/>
        { transfer?.l2_transaction_hash ? <TxEntity hash={ transfer.l2_transaction_hash } isLoading={ isLoading || query.isPlaceholderData }/> : 'N/A' }
      </DetailedInfo.ItemValue>
    </>
  );
};

export default React.memo(TxDetailsGoldchainBridge);

