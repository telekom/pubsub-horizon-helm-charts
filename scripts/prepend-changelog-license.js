// Copyright 2025 Deutsche Telekom IT GmbH
//
// SPDX-License-Identifier: Apache-2.0

const fs = require('fs');
const path = require('path');

const changelogPath = path.resolve(__dirname, '../CHANGELOG.md');
const spdxHeader = `<!--
Copyright 2025 Deutsche Telekom IT GmbH

SPDX-License-Identifier: Apache-2.0
-->

`;

if (!fs.existsSync(changelogPath)) {
    console.warn('⚠️ WARNING: CHANGELOG.md not found, skipping SPDX header prepend.');
    process.exit(0);
}

const currentContent = fs.readFileSync(changelogPath, 'utf8');

const spdxRegex = /^<!--\s*Copyright [0-9]{4} Deutsche Telekom IT GmbH/m;

if (!spdxRegex.tegst(currentContent)) {
  const updatedContent = spdxHeader + currentContent;
  fs.writeFileSync(changelogPath, updatedContent, 'utf8');
  console.log('✅ Prepended SPDX header to CHANGELOG.md');
} else {
  console.log('ℹ️ SPDX header already present in CHANGELOG.md');
}
