import { Box, Flex, Text } from '@chakra-ui/react';
import { useRouter } from 'next/router';
import React from 'react';

import getQueryParamString from 'lib/router/getQueryParamString';
import { generateListStub } from 'stubs/utils';
import DataListDisplay from 'ui/shared/DataListDisplay';
import AddressStringOrParam from 'ui/shared/entities/address/AddressStringOrParam';
import TxEntity from 'ui/shared/entities/tx/TxEntity';
import PageTitle from 'ui/shared/Page/PageTitle';
import Pagination from 'ui/shared/pagination/Pagination';
import useQueryWithPages from 'ui/shared/pagination/useQueryWithPages';
import TimeWithTooltip from 'ui/shared/time/TimeWithTooltip';

const ValidatorsGoldchain = () => {
  const router = useRouter();
  const validatorAddressHash = getQueryParamString(router.query.id)?.toLowerCase();

  const { data, isError, isPlaceholderData, pagination } = useQueryWithPages({
    resourceName: 'general:goldchain_validator_events',
    filters: validatorAddressHash ? { address_hash: validatorAddressHash } : undefined,
    options: {
      placeholderData: generateListStub<'general:goldchain_validator_events'>(
        {
          event_id: '0x',
          transaction_hash: '0x',
          log_index: 0,
          block_number: 0,
          block_timestamp: null,
          event_type: 'validator_set_updated',
          validator_address_hash: null,
          operator_address_hash: null,
          amount: null,
          slash_type: null,
          finality_status: 'pending',
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

  const actionBar = pagination.isVisible ? (
    <Flex justifyContent="flex-end" mb={ 4 }>
      <Pagination { ...pagination }/>
    </Flex>
  ) : null;

  const content = data?.items ? (
    <Flex flexDir="column" rowGap={ 3 }>
      { data.items.map((item, index) => (
        <Box key={ `${ item.event_id }-${ index }` } borderWidth="1px" borderRadius="md" p={ 3 }>
          <Flex alignItems="center" justifyContent="space-between" columnGap={ 3 } rowGap={ 2 } flexWrap="wrap">
            <Text fontWeight={ 600 }>{ item.event_type }</Text>
            <Text color="text.secondary">{ item.finality_status }</Text>
          </Flex>
          <Flex alignItems="center" columnGap={ 3 } rowGap={ 2 } flexWrap="wrap" mt={ 2 }>
            <TxEntity hash={ item.transaction_hash } isLoading={ isPlaceholderData } truncation="constant_long" textStyle="sm"/>
            { item.validator_address_hash && (
              <AddressStringOrParam address={ item.validator_address_hash } isLoading={ isPlaceholderData } noCopy truncation="constant_long"/>
            ) }
            <TimeWithTooltip timestamp={ item.block_timestamp } isLoading={ isPlaceholderData } display="inline-block"/>
          </Flex>
        </Box>
      )) }
    </Flex>
  ) : null;

  return (
    <Box>
      <PageTitle title={ validatorAddressHash ? 'Validator details' : 'Validators' }/>
      <DataListDisplay
        isError={ isError }
        itemsNum={ data?.items.length }
        emptyText="There are no validator events."
        actionBar={ actionBar }
      >
        { content }
      </DataListDisplay>
    </Box>
  );
};

export default ValidatorsGoldchain;
