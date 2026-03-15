# Job Application Form Answers — Canonical Answers

This file is the source of truth for form questions. Agents MUST reference this before answering any form question.
If a question is not in this file and cannot be answered from profile.json or CV, the agent must PAUSE and ask the candidate via Telegram.

---

## Personal Info (always safe — from profile.json)
- **First Name:** [from profile.json]
- **Last Name:** [from profile.json]
- **Email:** [from profile.json]
- **Phone:** [from profile.json]
- **Location / City:** [from profile.json]
- **Country:** [from profile.json]
- **LinkedIn:** [from profile.json]
- **Website / Portfolio:** [from profile.json — default to LinkedIn URL]

## Work Authorization
- **Require visa/immigration sponsorship?** [Yes/No — from profile.json]
- **Right to work in target country?** [from profile.json]
- **Work authorization status:** [from profile.json]

## Compensation
- **Expected salary (EUR):** [from config.json salary_eur]
- **Expected salary (GBP):** [from config.json salary_gbp]
- **Expected salary (USD):** [from config.json salary_usd]
- **Salary input rule:** ALWAYS use the floor of the job's listed salary range
  - Example: job says £120k-140k → input £120,000
  - Example: job says €75k-95k → input €75,000
  - Example: job says $100k-130k → input $100,000
- **If no range is listed:** use defaults from config.json
- **Current salary:** Do not disclose — leave blank or say "competitive" if required

## Availability
- **Notice period:** [from profile.json additional.notice_period]
- **Availability / Start date:** Available with [notice_period] notice
- **Willing to relocate?** [from profile.json personal.willing_to_relocate]

## References
- **Do you have professional references?** ASK CANDIDATE — do not assume Yes or No

## Common "How did you hear" Questions
- **How did you hear about this role?** Job board
- **How did you hear about the company?** Online research / job board

## GDPR / Data Consent
- **GDPR data storage consent:** Accept / Yes
- **GDPR Article 13:** Accept / Yes
- **Data processing consent:** Yes

## Company-Specific / Essay Questions — ALWAYS ASK CANDIDATE, NEVER AUTO-FILL
These questions require the candidate's real experiences and opinions. Do NOT invent stories, do NOT assume answers from the CV.

**Always ask candidate for:**
- "Why do you want to work at [Company]?"
- "What excites you about this role?"
- "Describe your experience with [specific product domain]"
- "Tell us about a product you built / feature you shipped"
- "Describe a challenge you overcame"
- "How do you use data in your product decisions?"
- "Describe your experience with AI/ML products"
- "What is your management / leadership style?"
- "What are your career goals / where do you see yourself in 5 years?"
- "Tell us about a time you [behavioral question]"
- Any open-ended text field asking for a story, example, or opinion
- Any question that requires describing a SPECIFIC situation not explicitly in the CV

Do NOT invent plausible-sounding stories from CV bullet points.
Do NOT extrapolate beyond what's literally written in the CV.
Only use CV metrics for factual questions (e.g. "how many experiments did you run?").

## How to handle essay questions during an application:
1. **Check "Stored Answers" section below** — if a similar question exists, use that answer (adapt slightly for the company/role, but keep the core answer)
2. **If no similar answer exists** → ask candidate via Telegram: "⚠️ [Company] — essay question needs your input: '[exact question]'. Please reply with your answer."
3. **After candidate replies** → use their answer, then **append it to this file** under "Stored Answers" so future agents can reuse it
4. Wait up to 15 minutes for reply. If no reply → skip the field, log it as "Unanswered — needs candidate input", mark application as Flagged.

---

## Stored Answers

_This section grows over time as the candidate answers custom questions. Agents: read these before asking the candidate._

<!-- ANSWERS WILL BE APPENDED HERE BY AGENTS AFTER CANDIDATE RESPONDS -->

## Background / Screening
- **Criminal background check consent:** Yes (standard)
- **Relatives working at company?** No (unless candidate says otherwise)
- **Currently employed?** [Yes/No — from profile.json]

## MUST ASK CANDIDATE (never auto-fill these)
- Salary history
- Specific story-based interview questions in form format
- "Why this company specifically?" (must be genuine, not generic)
- Any question requiring information not in CV, profile.json, or this file
- Anything you're not 100% certain about
