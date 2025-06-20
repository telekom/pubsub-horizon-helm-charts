// Copyright 2025 Deutsche Telekom IT GmbH
//
// SPDX-License-Identifier: Apache-2.0

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const version = process.argv[2];

if (!version) {
  console.error('❌ Error: You must provide a version (e.g. `node update-all-chart-versions.js 1.2.3`)');
  process.exit(1);
}

const chartsDir = path.resolve(__dirname, '../charts');

const charts = fs.readdirSync(chartsDir).filter(dir => {
  const chartYamlPath = path.join(chartsDir, dir, 'Chart.yaml');
  return fs.existsSync(chartYamlPath);
});

charts.forEach(chart => {
  const chartPath = path.join(chartsDir, chart, 'Chart.yaml');
  const chartContent = yaml.load(fs.readFileSync(chartPath, 'utf8'));

  // Update the version
  chartContent.version = version;

  fs.writeFileSync(chartPath, yaml.dump(chartContent, { lineWidth: -1 }), 'utf8');
  console.log(`✅ Updated ${chart}/Chart.yaml to version ${version}`);
});
