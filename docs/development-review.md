# Development repair review — 2 October 2026

Reviewed the restored local app at http://localhost:3001 using the requested
account. Changes are in the working tree, ready for review. Tests write only to
the separate test database. No restored skills or history were deleted or rewritten.

## Completed

- Replaced the fragile drawer and placeholder navigation with an accessible menu.
- Reworked overview, skills, progress, activity history, session history, and forms
  for desktop and narrow screens. Removed fake dashboard values and mastery levels.
- Implemented skill search, tag filtering, and sorting; all list buttons perform
  real actions. Added empty states, validation feedback, and readable resource links.
- Fixed session ownership and scoped session history, skill edits, activity edits,
  skillset switching, and practice lists to the signed-in account.
- Fixed nested session activities: server assigns user/date/type, preserves edits,
  supports removing persisted rows, uses unique rating controls, and saves titles.
  Disabled Rails STI for the existing session type column.
- Kept old standalone activities usable without requiring a parent session.
- Added basic practice lists: one per skillset, add/remove skills, log practice.
  Fixed the legacy skillsets_id association without a database migration.
- Replaced bulk inserts with validated, atomic skill creation.
- Recovered missing/deleted current skillsets safely; new skillsets start empty.
- Required password verification for API login; supported Bearer tokens; prevented
  arbitrary activity skill assignment; kept API tokens stable except explicit refresh.
- Connected the previously missing token-refresh route/controller.
- Sanitized rendered Markdown and scoped @skill references to the signed-in user.
- Fixed AI draft response parsing and visible status/error feedback. AI is disabled
  without OPENAI_API_KEY; automated checks use a stub and make no external API calls.
- Added real labels and corrected form markup for login, registration, and reset.
- Made local dates use Pacific/Auckland instead of UTC.

## Verification

- 15 targeted regression checks pass. Request tests cover the main screens, registration, search/filtering,
  session creation/editing/removal, standalone activities, bulk input, practice
  lists, private account records, API authentication, error states, and weekly totals.
- Rails autoload check and Tailwind build pass.
- Browser verification covers desktop search, skill details, session form layout,
  nested rows, navigation, and existing restored data. Saved screenshot:
  /private/tmp/skylz-skills-after.jpg.
- The full legacy RSpec suite still has 7 failing scaffold specs and 15 pending
  examples. The failures assume unauthenticated access or create sessions without
  the required associations/form setup. Minitest has stale fixtures, including
  PracticeList instead of practice_list; it needs a separate cleanup.

## Larger improvements to prioritize

1. **Upgrade Ruby/Rails and dependencies; rebuild the legacy tests.** The app is
   still on its original Ruby 3.1.4 / Rails 7.0.4 stack. Establish CI and stronger
   browser tests before deploying it again. Extend authorization coverage and add
   API throttling and consistent error responses.
2. **Practice planning and reusable session templates.** The basic list now works,
   but ordering, repeatable sessions, due dates, spaced repetition, and reminders
   need a cohesive workflow. Kanban was only a placeholder and has been removed.
3. **Historical ratings.** Old standalone activity forms used 0–10; session forms
   used 1–5, with no stored scale. New forms use 1–5 and preserve legacy values.
   History shows raw ratings rather than inventing a denominator. Decide how to
   identify/normalize old ratings before treating averages as mastery scores.
4. **Backup/import/export and PDF.** Complete user-friendly export/download,
   versioned backups, import validation, and printable sessions. The PDF action
   was unimplemented; its dead route was removed. Database dumps do not include
   externally stored media.
5. **Onboarding and data organization.** Let new users choose their first skillset
   instead of receiving the original BJJ example automatically. Add pagination,
   consistent tags, duplicate-skillset cleanup, and archive/restore for deletion.
6. **AI and account recovery.** Configure an API key and a chosen model, then test
   the provider response end to end. Add request limits/cost controls and explicit
   draft review. Configure mail delivery before relying on password-reset emails.
