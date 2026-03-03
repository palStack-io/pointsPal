#!/usr/bin/env node
/**
 * pointPal — Compiler
 * Reads all programs/*.json and writes dist/programs.json + dist/index.json
 * Run: node scripts/compile.js
 */

const fs   = require('fs');
const path = require('path');

const PROGRAMS_DIR = path.join(__dirname, '..', 'programs');
const DIST_DIR     = path.join(__dirname, '..', 'dist');

function main() {
  // Ensure dist dir exists
  if (!fs.existsSync(DIST_DIR)) fs.mkdirSync(DIST_DIR, { recursive: true });

  // Load all valid program files
  const files = fs.readdirSync(PROGRAMS_DIR)
    .filter(f => f.endsWith('.json') && !f.startsWith('_'))
    .sort();

  const programs    = [];
  const errors      = [];
  const issuerCounts = {};

  for (const file of files) {
    const filePath = path.join(PROGRAMS_DIR, file);
    try {
      const raw  = fs.readFileSync(filePath, 'utf8');
      const prog = JSON.parse(raw);

      // Strip any leftover template instruction keys
      const cleaned = Object.fromEntries(
        Object.entries(prog).filter(([k]) => !k.startsWith('_'))
      );

      // Also strip from nested arrays
      if (Array.isArray(cleaned.earn_categories)) {
        cleaned.earn_categories = cleaned.earn_categories.map(ec =>
          Object.fromEntries(Object.entries(ec).filter(([k]) => !k.startsWith('_')))
        );
      }
      if (Array.isArray(cleaned.transfer_partners)) {
        cleaned.transfer_partners = cleaned.transfer_partners.map(tp =>
          Object.fromEntries(Object.entries(tp).filter(([k]) => !k.startsWith('_')))
        );
      }

      programs.push(cleaned);
      issuerCounts[cleaned.issuer] = (issuerCounts[cleaned.issuer] || 0) + 1;
      console.log(`  ✓ ${file}`);
    } catch (e) {
      errors.push({ file, error: e.message });
      console.error(`  ✗ ${file}: ${e.message}`);
    }
  }

  if (errors.length > 0) {
    console.error(`\n${errors.length} file(s) failed to compile. Fix JSON errors first.`);
    process.exit(1);
  }

  const generatedAt = new Date().toISOString();

  // Write programs.json — the main file finPal fetches
  const programsOut = {
    generated_at:  generatedAt,
    schema_version: '1.0',
    count:         programs.length,
    programs,
  };
  fs.writeFileSync(
    path.join(DIST_DIR, 'programs.json'),
    JSON.stringify(programsOut, null, 2)
  );

  // Write index.json — lightweight metadata for badges + quick checks
  const indexOut = {
    generated_at:  generatedAt,
    schema_version: '1.0',
    count:         programs.length,
    issuer_counts: issuerCounts,
    program_ids:   programs.map(p => p.program_id),
    stale_programs: programs
      .filter(p => {
        if (!p.data_as_of || !p.review_frequency_months) return false;
        const asOf   = new Date(p.data_as_of);
        const cutoff = new Date();
        cutoff.setMonth(cutoff.getMonth() - p.review_frequency_months);
        return asOf < cutoff;
      })
      .map(p => ({
        program_id: p.program_id,
        program_name: p.program_name,
        data_as_of: p.data_as_of,
        review_frequency_months: p.review_frequency_months,
      })),
  };
  fs.writeFileSync(
    path.join(DIST_DIR, 'index.json'),
    JSON.stringify(indexOut, null, 2)
  );

  console.log(`\n✅ Compiled ${programs.length} programs → dist/programs.json`);
  console.log(`✅ Index written → dist/index.json`);
  if (indexOut.stale_programs.length > 0) {
    console.log(`\n⚠  ${indexOut.stale_programs.length} stale programs (past review date):`);
    indexOut.stale_programs.forEach(p =>
      console.log(`   ${p.program_id} (as of ${p.data_as_of}, review every ${p.review_frequency_months}mo)`)
    );
  }
}

main();

