## pointPal PR — Card Submission

### Type
- [ ] ➕ New card
- [ ] 🔄 Update to existing card (earn rates, caps, cpp)
- [ ] 🐛 Fix (incorrect data, typo)
- [ ] 🔧 Infrastructure (scripts, GitHub Actions, README)

### Card(s) Changed
<!-- List the program_id(s) this PR touches -->
- `program_id_here`

### What Changed
<!-- For updates: describe what was wrong and what the correct value is -->

### Source / Citation
<!-- Required for any earn rate or cpp change. Link to issuer page, TPG, NerdWallet, etc. -->
- 

### Issuer Effective Date
<!-- If the issuer made a change, when did it take effect? YYYY-MM-DD -->

---

### PR Checklist

**File basics**
- [ ] `program_id` is snake_case and matches the filename exactly
- [ ] All required fields are present (`program_id`, `program_name`, `issuer`, `network`, `currency_name`, `annual_fee`, `base_cpp`, `data_as_of`, `earn_categories`)
- [ ] `data_as_of` reflects today's date (or the date you verified the data)
- [ ] No template instruction keys (`_note_*`) left in the file

**Earn categories**
- [ ] All `category` values use only approved slugs from [SLUG_REFERENCE.md](./SLUG_REFERENCE.md)
- [ ] Every card has a base `"other"` catch-all category
- [ ] Spending caps have both `cap_amount` AND `cap_period` set
- [ ] `multiplier_fallback` is set for any capped categories

**Sources**
- [ ] `source_url` is populated if `tpg_cpp` is set
- [ ] Source cited in PR description for any earn rate changes

**Community standards**
- [ ] No affiliate links anywhere in the JSON
- [ ] `review_frequency_months` is appropriate (3 for rotating categories, 6 for recent changes, 12 for stable)
- [ ] `contributor` field has my GitHub username

---

*Maintained by the palStack community · [palstack.io](https://palstack.io)*

