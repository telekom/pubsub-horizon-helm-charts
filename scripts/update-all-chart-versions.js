// Copyright 2025 Deutsche Telekom IT GmbH
//
// SPDX-License-Identifier: Apache-2.0

const fs = require('fs');
const path = require('path');

const version = process.argv[2];
const chartsDir = path.resolve(__dirname, '../charts');

const charts = fs.readdirSync(chartsDir).filter(dir => {
  const chartYaml = path.join(chartsDir, dir, 'Chart.yaml');
  return fs.existsSync(chartYaml);
});

charts.forEach(chart => {
  const chartPath = path.join(chartsDir, chart, 'Chart.yaml');
  const yaml = fs.readFileSync(chartPath, 'utf8');
  const updated = yaml.replace(/^version: .*/m, `version: ${version}`);
  fs.writeFileSync(chartPath, updated);
  console.log(`✅ Updated ${chart}/Chart.yaml to version ${version}`);
});
