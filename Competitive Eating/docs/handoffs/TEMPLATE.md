# Session Handoff — YYYY-MM-DD HH:MM — <topic>

Copy this file to `YYYYMMDD-HHMM-<topic>.md` at the END of each session. Next session reads the LATEST handoff first thing, then state-audits anything it intends to touch.

---

## Accomplished
- Bullet list of things that were actually finished and verified
- "Verified" means: tested in play mode + assertion passed, OR user confirmed visually

## Current State (verified facts only)
Anything written here was confirmed via MCP this session. Tag uncertain claims explicitly.

Example:
- `Workspace.BigWheel.WheelHinge.AngularVelocity = 0.4` (verified via inspect_instance 17:42)
- `RideController.luau:103 partCentroid` filters on Structural tag (verified via Read)
- TiltAWhirl position unverified this session — re-inspect before touching

## Lessons (write these to memory if generalizable)
- What broke, what worked, what surprised you
- Promote durable lessons to `~/.claude/projects/.../memory/feedback_*.md`

## Next Steps
Ordered list. Each item must be either:
- a specific FIX: with file/line, OR
- a specific BUILD: with a PLAN gate, OR
- a research question for an agent

## Files Modified
Path + 1-line summary of what changed.

```
src/Server/Services/RideController.luau — refactored partCentroid to filter on Structural tag
src/Common/Palettes.luau                 — new file; locked color palettes per theme
```

## Blockers / Open Questions
- Things requiring user decision before next session can proceed
- Bugs discovered but not fixed (with reproduction steps)
- Mystery state needing user clarification (e.g. "did you move TiltAWhirl manually?")
