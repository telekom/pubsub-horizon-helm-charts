// Copyright 2025 Deutsche Telekom IT GmbH
//
// SPDX-License-Identifier: Apache-2.0

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const version = process.argv[2];

if (!version) {
  console.error('❌ Error: You must provide a version, e.g. `node update-horizon-all-versions.js 1.2.3`');
  process.exit(1);
}

const chartPath = path.resolve(__dirname, '../horizon-all/Chart.yaml');

if (!fs.existsSync(chartPath)) {
  console.error('❌ horizon-all/Chart.yaml not found');
  process.exit(1);
}

const chart = yaml.load(fs.readFileSync(chartPath, 'utf8'));

// Update all dependency versions
if (Array.isArray(chart.dependencies)) {
  chart.dependencies.forEach(dep => {
    dep.version = version;
  });
}

fs.writeFileSync(chartPath, yaml.dump(chart, { lineWidth: -1 }), 'utf8');

console.log(`✅ Updated horizon-all/Chart.yaml and all dependencies to version ${version}`);
