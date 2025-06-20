// Copyright 2025 Deutsche Telekom IT GmbH
//
// SPDX-License-Identifier: Apache-2.0

const fs = require('fs');
const path = require('path');

function getCharts(dir = './charts') {
  return fs.readdirSync(dir).filter(name => {
    const fullPath = path.join(dir, name, 'Chart.yaml');
    return fs.existsSync(fullPath);
  });
}

module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    ['@semantic-release/exec', {
      prepareCmd: `
        node scripts/update-horizon-all-versions.js \${nextRelease.version} &&
        node scripts/update-parent-chart-dependencies.js \${nextRelease.version} &&
        node scripts/prepend-changelog-license.js
      `
    }],
    ['@semantic-release/git', {
      assets: ['charts/**/Chart.yaml', 'CHANGELOG.md'],
      message: 'chore(release): ${nextRelease.version} [skip ci]'
    }],
    '@semantic-release/github'
  ]
};

