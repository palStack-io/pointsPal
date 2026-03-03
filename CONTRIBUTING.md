# Contributing to pointPal

Thanks for helping keep the database accurate. Earn rates change constantly — the community is what makes this useful.

---

## Three Ways to Contribute

### 1. From finPal (easiest, no GitHub required)
Add your card in finPal → tap **"Share with community"** → finPal pre-fills the JSON and opens a GitHub PR for you. You just need to add your GitHub username and click submit.

### 2. Submit a PR directly
Best if you're comfortable with JSON. See the [Quick Start in the README](./README.md#quick-start-for-contributors).

### 3. File an issue
Not comfortable with JSON? [Open an issue](https://github.com/palStack-io/pointPal/issues/new?template=new_card.yml) and a maintainer will build the JSON from your info.

---

## What to Contribute

### High-value contributions
- **New cards** not yet in the database
- **Cap data** — many cards are missing `cap_amount`/`cap_period` fields
- **Transfer partner cpp estimates** — help other users know what their points are worth
- **Corrections** when an issuer changes earn rates

### Low-value / not needed
- Cards that are closed to new applicants (unless many people still hold them)
- Debit cards, prepaid cards
- Cards with no rewards
- Promotional rates that expire within 30 days

---

## Quality Standards

| Standard | Detail |
|---|---|
| **Cite your sources** | Any earn rate or cpp value needs a `source_url`. Acceptable sources: issuer's own website, TPG, NerdWallet, Bankrate, The Points Guy valuations page |
| **No affiliate links** | `source_url` and `notes` must be free of affiliate tracking parameters |
| **Be conservative on cpp** | Use median values from reputable sources, not best-case theoretical maximums |
| **Date everything** | `data_as_of` must reflect when you actually verified the rates, not when you submitted the PR |
| **One card per PR** | Makes review faster and history cleaner |
| **Use the validator** | Run `npm run validate` before submitting. The GitHub Action will also catch errors, but fixing them locally is faster |

---

## Review Process

1. You submit a PR
2. GitHub Action runs `validate.js` on your changed files — must pass to merge
3. A palStack maintainer reviews for accuracy (spot-checks source, checks caps, verifies cpp is plausible)
4. Merged PRs trigger `compile.js`, which updates `dist/programs.json`
5. finPal instances pick up changes on their next hourly sync

**Target review time: 24 hours.** PRs with cited sources and passing validation are typically merged same-day.

---

## Staleness Policy

Programs whose `data_as_of` is older than `review_frequency_months` are flagged as stale in `dist/index.json`. If you see a stale card, please re-verify and submit a PR updating `data_as_of` (and any rates that have changed).

Stale data doesn't get automatically removed, but finPal shows users a "rates may be outdated" warning for stale programs.

---

## Code of Conduct

- Be accurate, not promotional
- Credit original sources
- Be patient with maintainers — we're a small team
- If you spot a mistake in someone else's PR, comment constructively

---

*Part of the [palStack](https://palstack.io) open-source ecosystem.*

