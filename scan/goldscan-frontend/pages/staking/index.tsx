import type { NextPage } from 'next';
import dynamic from 'next/dynamic';
import React from 'react';

import PageNextJs from 'nextjs/PageNextJs';

import config from 'configs/app';

const rollupFeature = config.features.rollup;

const Staking = dynamic(() => {
  if (rollupFeature.isEnabled && rollupFeature.type === 'goldchain') {
    return import('ui/pages/GoldchainStaking');
  }

  throw new Error('Staking feature is not enabled.');
}, { ssr: false });

const Page: NextPage = () => {
  return (
    <PageNextJs pathname="/staking">
      <Staking/>
    </PageNextJs>
  );
};

export default Page;

export { rollup as getServerSideProps } from 'nextjs/getServerSideProps/main';
