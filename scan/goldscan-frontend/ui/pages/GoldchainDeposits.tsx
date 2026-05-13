import { Box } from '@chakra-ui/react';
import React from 'react';

import type { GoldchainBridgeTransferItem } from 'types/api/goldchain';
import type { ShibariumDepositsItem } from 'types/api/shibarium';

import useApiQuery from 'lib/api/useApiQuery';
import { layerLabels } from 'lib/rollups/utils';
import { generateListStub } from 'stubs/utils';
import { Skeleton } from 'toolkit/chakra/skeleton';
import { nbsp, rightLineArrow } from 'toolkit/utils/htmlEntities';
import DepositsListItem from 'ui/deposits/shibarium/DepositsListItem';
import DepositsTable from 'ui/deposits/shibarium/DepositsTable';
import { ACTION_BAR_HEIGHT_DESKTOP } from 'ui/shared/ActionBar';
import DataListDisplay from 'ui/shared/DataListDisplay';
import PageTitle from 'ui/shared/Page/PageTitle';
import useQueryWithPages from 'ui/shared/pagination/useQueryWithPages';
import StickyPaginationWithText from 'ui/shared/StickyPaginationWithText';

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
  bridge_state: 'locked' as const,
  route_asset: 'PAXG' as const,
  root_amount: '0',
  child_amount: '0',
};

function toDepositsRow(item: GoldchainBridgeTransferItem): ShibariumDepositsItem {
  return {
    l1_block_number: item.l1_block_number || 0,
    l1_transaction_hash: item.l1_transaction_hash || '0x',
    l2_transaction_hash: item.l2_transaction_hash || '0x',
    timestamp: item.timestamp || '',
    user: item.user || '0x0000000000000000000000000000000000000000',
  };
}

const GoldchainDeposits = () => {
  const { data, isError, isPlaceholderData, pagination } = useQueryWithPages({
    resourceName: 'general:goldchain_deposits',
    options: {
      placeholderData: generateListStub<'general:goldchain_deposits'>(
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

  const countersQuery = useApiQuery('general:goldchain_deposits_count', {
    queryOptions: {
      placeholderData: 0,
    },
  });

  const content = data?.items ? (
    <>
      <Box hideFrom="lg">
        { data.items.map(((item, index) => (
          <DepositsListItem
            key={ `${ item.canonical_transfer_id }-${ index }` }
            isLoading={ isPlaceholderData }
            item={ toDepositsRow(item) }
          />
        ))) }
      </Box>
      <Box hideBelow="lg">
        <DepositsTable
          items={ data.items.map(toDepositsRow) }
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
        A total of { countersQuery.data?.toLocaleString() } deposits found
      </Skeleton>
    );
  })();

  const actionBar = <StickyPaginationWithText text={ text } pagination={ pagination }/>;

  return (
    <>
      <PageTitle title={ `Bridge deposits (${ layerLabels.parent }${ nbsp }${ rightLineArrow }${ nbsp }${ layerLabels.current })` }/>
      <DataListDisplay
        isError={ isError }
        itemsNum={ data?.items.length }
        emptyText="There are no bridge deposits."
        actionBar={ actionBar }
      >
        { content }
      </DataListDisplay>
    </>
  );
};

export default GoldchainDeposits;
