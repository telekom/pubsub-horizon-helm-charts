const path = require('path');
const fs = require('fs');

const charts = ['horizon-starlight', 'horizon-galaxy'];

module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    ['@semantic-release/exec', {
      prepareCmd: 'node scripts/update-all-chart-versions.js ${nextRelease.version}'
    }],
    ['@semantic-release/git', {
      assets: ['**/Chart.yaml', 'CHANGELOG.md'],
      message: 'chore(release): ${nextRelease.version} [skip ci]'
    }],
    '@semantic-release/github'
  ]
};
