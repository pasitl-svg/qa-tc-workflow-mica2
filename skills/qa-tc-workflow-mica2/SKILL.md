---
name: qa-tc-workflow-mica2
description: |
  QA Test Case Workflow (MICA2) สร้าง TC จาก Jira ticket ครบวงจร พร้อม Technique, Traceability Matrix, Regression Impact, Security และ Prod safety — เขียนลง Master Regression Suite, CR แก้ TC เดิมพร้อม version, เลือกระดับ Lite / Standard / Detailed ได้ ภาษาราชการพร้อมส่งลูกค้า
  ใช้แทน qa-tc-full-workflow, -lite, -standard, -detailed

  ใช้ skill นี้เมื่อ:
  - ผู้ใช้ให้ Jira ticket URL/key หรือวาง requirement มาให้วิเคราะห์
  - ผู้ใช้บอกให้ "เขียน TC จาก ticket นี้" หรือ "ช่วยวิเคราะห์ requirement แล้วเขียน TC"
  - ผู้ใช้ต้องการ workflow ครบ: clarify req → scenario → technique → เขียน TC → review → ส่ง
  - ผู้ใช้พูดถึง Jira, Figma, subtask, CR, Change Request, สรุป meet ร่วมกับการเขียน TC
  - ผู้ใช้ต้องการ handle Change Request (CR) ที่กระทบ feature เดิม
  - ต้องการ output เป็น Google Sheets (upload .xlsx ขึ้น Drive) หรือ status report เป็น Google Doc

  Trigger ทุกครั้งที่มีการเริ่ม workflow ใหม่จาก requirement/ticket ไม่ว่าจะบอกตรงๆ หรือโดยนัย
---

# QA TC Workflow — MICA2 (discovery stub)

**Thin entry for agent skill discovery.** Full procedure: [WORKFLOW.md](../procedures/qa-tc-workflow-mica2/WORKFLOW.md).

When invoked:

1. Announce once: `Using **qa-tc-workflow-mica2** to prepare test cases from the ticket.`
2. Read and follow [WORKFLOW.md](../procedures/qa-tc-workflow-mica2/WORKFLOW.md) **end-to-end** — every step, gate, and reference.

## Contents

Every must-read file for this workflow, linked directly from here.

- [WORKFLOW.md](../procedures/qa-tc-workflow-mica2/WORKFLOW.md) — always: the full procedure, read end to end.
- [level-lite.md](../procedures/qa-tc-workflow-mica2/references/level-lite.md) — when the user picks level `Lite` in Step 1.1.2.
- [level-standard.md](../procedures/qa-tc-workflow-mica2/references/level-standard.md) — when the level is `Standard` (default).
- [level-detailed.md](../procedures/qa-tc-workflow-mica2/references/level-detailed.md) — when the user picks level `Detailed`.
