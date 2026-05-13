import { Box } from '@chakra-ui/react';
import React from 'react';

import type { GoldchainBridgeTransferItem } from 'types/api/goldchain';
import type { ShibariumWithdrawalsItem } from 'types/api/shibarium';

import useApiQuery from 'lib/api/useApiQuery';
import { layerLabels } from 'lib/rollups/utils';
import { generateListStub } from 'stubs/utils';
import { Skeleton } from 'toolkit/chakra/skeleton';
import { nbsp, rightLineArrow } from 'toolkit/utils/htmlEntities';
import { ACTION_BAR_HEIGHT_DESKTOP } from 'ui/shared/ActionBar';
import DataListDisplay from 'ui/shared/DataListDisplay';
import PageTitle from 'ui/shared/Page/PageTitle';
import useQueryWithPages from 'ui/shared/pagination/useQueryWithPages';
import StickyPaginationWithText from 'ui/shared/StickyPaginationWithText';
import WithdrawalsListItem from 'ui/withdrawals/shibarium/WithdrawalsListItem';
import WithdrawalsTable from 'ui/withdrawals/shibarium/WithdrawalsTable';

const PLACEHOLDER_ITEM = {
  canonical_transfer_id: 'xfer-placeholder',
  block_number: 0,
  log_index: 0,
  l1_block_number: 0,
  l2_block_number: 0,
  l1_transaction_hash: '0x',
  l2_transaction_hash: '0x',
  user: '0x0000000000000000000000000000000000000000',
  timestamp: null,
  finality_status: 'pending' as const,
  bridge_state: 'burned_or_debited' as const,
  route_asset: 'XAUT' as const,
  root_amount: '0',
  child_amount: '0',
};

function toWithdrawalsRow(item: GoldchainBridgeTransferItem): ShibariumWithdrawalsItem {
  return {
    l2_block_number: item.l2_block_number || 0,
    l2_transaction_hash: item.l2_transaction_hash || '0x',
    l1_transaction_hash: item.l1_transaction_hash || '0x',
    timestamp: item.timestamp || '',
    user: item.user || '0x0000000000000000000000000000000000000000',
  };
}

const GoldchainWithdrawals = () => {
  const { data, isError, isPlaceholderData, pagination } = useQueryWithPages({
    resourceName: 'general:goldchain_withdrawals',
    options: {
      placeholderData: generateListStub<'general:goldchain_withdrawals'>(
        PLACEHOLDER_ITEM,
        50,
        {
          next_page_params: {
            block_number: 0,
            log_index: 0,
            canonical_transfer_id: 'xfer-placeholder',
            items_count: 50,
          },
        },
      ),
    },
  });

  const countersQuery = useApiQuery('general:goldchain_withdrawals_count', {
    queryOptions: {
      placeholderData: 0,
    },
  });

  const content = data?.items ? (
    <>
      <Box hideFrom="lg">
        { data.items.map(((item, index) => (
          <WithdrawalsListItem
            key={ `${ item.canonical_transfer_id }-${ index }` }
            item={ toWithdrawalsRow(item) }
            isLoading={ isPlaceholderData }
          />
        ))) }
      </Box>
      <Box hideBelow="lg">
        <WithdrawalsTable
          items={ data.items.map(toWithdrawalsRow) }
          top={ pagination.isVisible ? ACTION_BAR_HEIGHT_DESKTOP : 0 }
          isLoading={ isPlaceholderData }
        />
      </Box>
    </>
  ) : null;

  const text = (() => {
    if (countersQuery.isError) {
      return null;
    }

    return (
      <Skeleton loading={ countersQuery.isPlaceholderData } display="inline-block">
        A total of { countersQuery.data?.toLocaleString() } withdrawals found
      </Skeleton>
    );
  })();

  const actionBar = <StickyPaginationWithText text={ text } pagination={ pagination }/>;

  return (
    <>
      <PageTitle title={ `Bridge withdrawals (${ layerLabels.current }${ nbsp }${ rightLineArrow }${ nbsp }${ layerLabels.parent })` }/>
      <DataListDisplay
        isError={ isError }
        itemsNum={ data?.items.length }
        emptyText="There are no bridge withdrawals."
        actionBar={ actionBar }
      >
        { content }
      </DataListDisplay>
    </>
  );
};

export default GoldchainWithdrawals;
