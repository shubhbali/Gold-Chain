import type { NextPage } from 'next';
import dynamic from 'next/dynamic';
import React from 'react';

import PageNextJs from 'nextjs/PageNextJs';

import config from 'configs/app';

const rollupFeature = config.features.rollup;

const Governance = dynamic(() => {
  if (rollupFeature.isEnabled && rollupFeature.type === 'goldchain') {
    return import('ui/pages/GoldchainGovernance');
  }

  throw new Error('Governance feature is not enabled.');
}, { ssr: false });

const Page: NextPage = () => {
  return (
    <PageNextJs pathname="/governance">
      <Governance/>
    </PageNextJs>
  );
};

export default Page;

export { rollup as getServerSideProps } from 'nextjs/getServerSideProps/main';
