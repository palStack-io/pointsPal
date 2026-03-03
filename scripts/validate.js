#!/usr/bin/env node
/**
 * pointPal — Program Validator
 * Validates all JSON files in /programs against the schema rules.
 * Run: node scripts/validate.js
 * Run single file: node scripts/validate.js programs/my_card.json
 */

const fs   = require('fs');
const path = require('path');

const PROGRAMS_DIR = path.join(__dirname, '..', 'programs');

// ── Approved slugs ──────────────────────────────────────────────────────────
const VALID_CATEGORY_SLUGS = new Set([
  'travel_portal', 'flights_direct', 'hotels_direct', 'dining', 'groceries',
  'gas', 'streaming', 'transit', 'online_shopping', 'advertising', 'drugstores',
  'home_improvement', 'office_supplies', 'phone_internet', 'fitness',
  'entertainment', 'rotating', 'mobile_wallet', 'rent_mortgage', 'other',
]);

const VALID_NETWORKS     = new Set(['Visa', 'Mastercard', 'Amex', 'Discover']);
const VALID_CURRENCIES   = new Set(['Points', 'Miles', 'Cash Back']);
const VALID_EXPIRY       = new Set(['account_closure', 'no_expiry', 'inactivity_18mo', 'inactivity_24mo', 'varies']);
const VALID_CAP_PERIODS  = new Set(['monthly', 'quarterly', 'annual']);
const VALID_PARTNER_TYPES = new Set(['airline', 'hotel']);
const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

// ── Validator ────────────────────────────────────────────────────────────────
function validateProgram(filePath, data) {
  const errors   = [];
  const warnings = [];
  const file = path.basename(filePath);

  const err  = (msg) => errors.push(`  ✗ ${msg}`);
  const warn = (msg) => warnings.push(`  ⚠ ${msg}`);

  // Check for leftover template keys
  const templateKeys = Object.keys(data).filter(k => k.startsWith('_'));
  if (templateKeys.length > 0)
    err(`Template instruction keys found (delete before submitting): ${templateKeys.join(', ')}`);

  // program_id must match filename
  const expectedId = file.replace('.json', '');
  if (!data.program_id)          err('Missing required field: program_id');
  else if (data.program_id !== expectedId)
    err(`program_id "${data.program_id}" does not match filename "${expectedId}"`);
  if (!/^[a-z0-9_]+$/.test(data.program_id || ''))
    err('program_id must be snake_case (lowercase letters, numbers, underscores only)');

  // Required string fields
  for (const field of ['program_name', 'issuer', 'currency_name', 'network']) {
    if (!data[field]) err(`Missing required field: ${field}`);
  }

  // Network / currency
  if (data.network && !VALID_NETWORKS.has(data.network))
    err(`Invalid network "${data.network}". Must be one of: ${[...VALID_NETWORKS].join(', ')}`);
  if (data.currency_name && !VALID_CURRENCIES.has(data.currency_name))
    err(`Invalid currency_name "${data.currency_name}". Must be one of: ${[...VALID_CURRENCIES].join(', ')}`);

  // Numeric fields
  if (typeof data.annual_fee !== 'number' || data.annual_fee < 0)
    err('annual_fee must be a non-negative number');
  if (typeof data.base_cpp !== 'number' || data.base_cpp <= 0)
    err('base_cpp must be a positive number');

  // Date fields
  if (!data.data_as_of)          err('Missing required field: data_as_of (YYYY-MM-DD)');
  else if (!DATE_RE.test(data.data_as_of)) err(`data_as_of must be YYYY-MM-DD format, got: "${data.data_as_of}"`);
  if (!data.last_updated)        warn('last_updated is missing — add YYYY-MM-DD');
  else if (!DATE_RE.test(data.last_updated)) err(`last_updated must be YYYY-MM-DD format`);
  if (data.issuer_effective_date && !DATE_RE.test(data.issuer_effective_date))
    err(`issuer_effective_date must be YYYY-MM-DD format`);

  // Check data_as_of is not in the future
  if (data.data_as_of && new Date(data.data_as_of) > new Date())
    err(`data_as_of "${data.data_as_of}" is in the future`);

  // Warn if data is stale (> review_frequency_months old)
  if (data.data_as_of && data.review_frequency_months) {
    const asOf   = new Date(data.data_as_of);
    const cutoff = new Date();
    cutoff.setMonth(cutoff.getMonth() - data.review_frequency_months);
    if (asOf < cutoff)
      warn(`data_as_of is older than ${data.review_frequency_months} months — please re-verify earn rates`);
  }

  // Expiry policy
  if (data.expiry_policy && !VALID_EXPIRY.has(data.expiry_policy))
    warn(`Unusual expiry_policy "${data.expiry_policy}". Common values: ${[...VALID_EXPIRY].join(', ')}`);

  // earn_categories — required
  if (!Array.isArray(data.earn_categories) || data.earn_categories.length === 0) {
    err('earn_categories must be a non-empty array');
  } else {
    const hasBaseRate = data.earn_categories.some(ec => ec.category === 'other' && !ec.card_variant);
    if (!hasBaseRate)
      warn('No base "other" earn category found. Consider adding a catch-all rate.');

    data.earn_categories.forEach((ec, i) => {
      const prefix = `earn_categories[${i}]`;
      if (!ec.category)               err(`${prefix}: missing category`);
      else if (!VALID_CATEGORY_SLUGS.has(ec.category))
        err(`${prefix}: unknown category slug "${ec.category}". See SLUG_REFERENCE.md for valid slugs.`);
      if (typeof ec.multiplier !== 'number' || ec.multiplier <= 0)
        err(`${prefix}: multiplier must be a positive number`);
      if (ec.cap_amount !== null && ec.cap_amount !== undefined) {
        if (typeof ec.cap_amount !== 'number' || ec.cap_amount <= 0)
          err(`${prefix}: cap_amount must be a positive number or null`);
        if (!ec.cap_period)
          err(`${prefix}: cap_amount is set but cap_period is missing`);
        else if (!VALID_CAP_PERIODS.has(ec.cap_period))
          err(`${prefix}: cap_period must be one of: ${[...VALID_CAP_PERIODS].join(', ')}`);
        if (typeof ec.multiplier_fallback !== 'number')
          err(`${prefix}: multiplier_fallback must be a number when cap_amount is set`);
      }
      // Check for leftover template keys inside earn_categories
      const ecTemplateKeys = Object.keys(ec).filter(k => k.startsWith('_'));
      if (ecTemplateKeys.length > 0)
        err(`${prefix}: template instruction keys found: ${ecTemplateKeys.join(', ')}`);
    });
  }

  // transfer_partners
  if (data.transfer_partners) {
    if (!Array.isArray(data.transfer_partners))
      err('transfer_partners must be an array (use [] if none)');
    else data.transfer_partners.forEach((tp, i) => {
      const prefix = `transfer_partners[${i}]`;
      if (!tp.partner_name) err(`${prefix}: missing partner_name`);
      if (!tp.type)         err(`${prefix}: missing type`);
      else if (!VALID_PARTNER_TYPES.has(tp.type))
        err(`${prefix}: type must be "airline" or "hotel"`);
      if (!tp.ratio)        warn(`${prefix}: ratio is missing (assume 1:1?)`);
      if (tp.est_cpp !== null && tp.est_cpp !== undefined && typeof tp.est_cpp !== 'number')
        err(`${prefix}: est_cpp must be a number or null`);
    });
  }

  // tpg_cpp warning without source
  if (data.tpg_cpp && !data.source_url)
    warn('tpg_cpp is set but source_url is empty — please add a citation');

  return { errors, warnings };
}

// ── Main ─────────────────────────────────────────────────────────────────────
function main() {
  const targetFile = process.argv[2]; // optional single-file mode
  let files;

  if (targetFile) {
    files = [path.resolve(targetFile)];
  } else {
    files = fs.readdirSync(PROGRAMS_DIR)
      .filter(f => f.endsWith('.json') && !f.startsWith('_'))
      .map(f => path.join(PROGRAMS_DIR, f));
  }

  let totalErrors   = 0;
  let totalWarnings = 0;
  let passed        = 0;
  let failed        = 0;

  for (const filePath of files) {
    const file = path.basename(filePath);
    let data;
    try {
      data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    } catch (e) {
      console.log(`\n❌ ${file}`);
      console.log(`  ✗ JSON parse error: ${e.message}`);
      failed++;
      totalErrors++;
      continue;
    }

    const { errors, warnings } = validateProgram(filePath, data);

    if (errors.length === 0 && warnings.length === 0) {
      console.log(`✅ ${file}`);
      passed++;
    } else if (errors.length === 0) {
      console.log(`✅ ${file} (${warnings.length} warning${warnings.length > 1 ? 's' : ''})`);
      warnings.forEach(w => console.log(w));
      passed++;
    } else {
      console.log(`\n❌ ${file}`);
      errors.forEach(e => console.log(e));
      if (warnings.length) warnings.forEach(w => console.log(w));
      failed++;
    }

    totalErrors   += errors.length;
    totalWarnings += warnings.length;
  }

  console.log(`\n${'─'.repeat(60)}`);
  console.log(`Validated ${files.length} file${files.length !== 1 ? 's' : ''}: ${passed} passed, ${failed} failed`);
  if (totalWarnings) console.log(`${totalWarnings} warning${totalWarnings !== 1 ? 's' : ''} (non-blocking)`);

  if (totalErrors > 0) {
    console.log(`\n${totalErrors} error${totalErrors !== 1 ? 's' : ''} found. Fix before submitting your PR.`);
    process.exit(1);
  } else {
    console.log('\nAll validations passed ✨');
    process.exit(0);
  }
}

main();

