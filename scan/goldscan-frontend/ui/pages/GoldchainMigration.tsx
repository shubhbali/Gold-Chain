import { Box, Flex, Text } from '@chakra-ui/react';
import React from 'react';

import { generateListStub } from 'stubs/utils';
import DataListDisplay from 'ui/shared/DataListDisplay';
import TxEntity from 'ui/shared/entities/tx/TxEntity';
import PageTitle from 'ui/shared/Page/PageTitle';
import Pagination from 'ui/shared/pagination/Pagination';
import useQueryWithPages from 'ui/shared/pagination/useQueryWithPages';

const GoldchainMigration = () => {
  const { data, isError, isPlaceholderData, pagination } = useQueryWithPages({
    resourceName: 'general:goldchain_decoded_actions',
    options: {
      placeholderData: generateListStub<'general:goldchain_decoded_actions'>(
        {
          hash: '0x',
          protocol: 'goldchain',
          type: 'migration',
          log_index: 0,
          data: {},
        },
        50,
        {
          next_page_params: {
            block_number: 0,
            log_index: 0,
            items_count: 50,
          },
        },
      ),
    },
  });

  const items =
    data?.items?.filter((item) => {
      const eventType = String(item.type || '').toLowerCase();
      return eventType.includes('migration') || eventType.includes('redeem') || eventType.includes('redemption');
    }) || [];

  const actionBar = pagination.isVisible ? (
    <Flex justifyContent="flex-end" mb={ 4 }>
      <Pagination { ...pagination }/>
    </Flex>
  ) : null;

  const content = items.length > 0 ? (
    <Flex flexDir="column" rowGap={ 3 }>
      { items.map((item, index) => (
        <Box key={ `${ item.hash }-${ item.log_index }-${ index }` } borderWidth="1px" borderRadius="md" p={ 3 }>
          <Flex alignItems="center" justifyContent="space-between" columnGap={ 3 } rowGap={ 2 } flexWrap="wrap">
            <Text fontWeight={ 600 }>{ item.type }</Text>
            <Text color="text.secondary">{ item.protocol }</Text>
          </Flex>
          <Flex alignItems="center" columnGap={ 3 } rowGap={ 2 } flexWrap="wrap" mt={ 2 }>
            <TxEntity hash={ item.hash } isLoading={ isPlaceholderData } truncation="constant_long" textStyle="sm"/>
            <Text color="text.secondary">Log #{ item.log_index }</Text>
          </Flex>
        </Box>
      )) }
    </Flex>
  ) : null;

  return (
    <Box>
      <PageTitle title="Migration / Redemption"/>
      <DataListDisplay
        isError={ isError }
        itemsNum={ items.length }
        emptyText="There are no migration or redemption actions."
        actionBar={ actionBar }
      >
        { content }
      </DataListDisplay>
    </Box>
  );
};

export default GoldchainMigration;
