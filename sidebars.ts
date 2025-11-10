import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  docs: [
    {
      type: 'category',
      label: 'Getting Started',
      items: [
        'usage/installation',
        'usage/user-management',
      ],
    },
  ],
};

export default sidebars;
