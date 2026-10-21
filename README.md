# qa-tc-workflow-mica2

QA Test Case Workflow (MICA2) สำหรับ Claude Code และ Claude Desktop — สร้าง Test Case จาก Jira ticket ครบวงจร ตั้งแต่อ่าน requirement จนส่งมอบ TC ที่พร้อมส่งลูกค้า

## ความสามารถของ skill

- **ดึง requirement อัตโนมัติ** — อ่าน Jira ticket ผ่าน Atlassian Rovo MCP ครบทั้ง description, Acceptance Criteria, subtask, linked issue, comment และ attachment รวมถึงหน้า Confluence ที่ลิงก์ไว้ และไฟล์ Figma (ถ้าเชื่อม Figma MCP ไว้)
- **Workflow 6 ขั้น**
  1. อ่านและสรุป requirement ให้ยืนยัน
  2. ถามจุดที่กำกวม โดยเสนอ 2-3 ทางเลือกพร้อมข้อดีข้อเสีย
  3. ระบุ Test Technique (EP / BVA / Decision Table / State Transition / Use Case) พร้อมเหตุผล และรายการ scenario (Happy path, Edge, Negative, State)
  4. เขียน TC
  5. ตรวจเอง 10 ข้อ + automated lint
  6. ส่งมอบและแก้ตาม feedback
- **Master Regression Suite** — เขียน TC ลง Google Sheets ไฟล์เดียวต่อ product (1 tab ต่อ module) ไม่สร้างไฟล์ TC ใหม่ทุก ticket
- **รองรับ Change Request (CR)** — วิเคราะห์ Regression Impact แล้วแก้ TC เดิมในแถวเดิมพร้อมเพิ่ม version หรือตั้งเป็น Deprecated
- **ครอบคลุมด้านอื่น** — Permission/Role Matrix (ระบบหลาย role), Security considerations, Prod safety (Read-only / Test-tenant write / Not on prod) และ Automation status ทุก TC
- **รูปแบบมาตรฐาน** — TC ID แบบ `TC-<PROJECT>-<MODULE>-<NNN>` (เช่น `TC-MICA2-LOGIN-001`) มี column สำหรับลูกค้า 13 ตัว (รวม Test Type ที่แยก Core / Edge) และ column ภายใน 10 ตัว
- **เลือกระดับความละเอียดได้** — `Lite` (กระชับ), `Standard` (ค่าเริ่มต้น), `Detailed` (ละเอียดสูงสุด เหมาะกับงานที่ต้อง audit)
- **Status Report** — Google Doc บน Drive อัปเดตทุก step พร้อม Traceability Matrix
- **ภาษาราชการ** — เขียน TC เป็นภาษาไทยทางการ พร้อมส่งลูกค้าหรือหน่วยงาน

## สิ่งที่ต้องมีก่อนใช้

| สิ่งที่ต้องมี | Claude Code | Claude Desktop |
|---|---|---|
| Atlassian Rovo (อ่าน Jira / Confluence) | เชื่อมเป็น MCP server หรือ connector ของบัญชี claude.ai | เปิด connector Atlassian ใน Settings → Connectors |
| Google Drive (อ่านและอัปโหลด Master Suite / Status Doc) | เชื่อมเป็น MCP server หรือ connector ของบัญชี claude.ai | เปิด connector Google Drive ใน Settings → Connectors |
| Python 3 + `openpyxl` (สร้างไฟล์ xlsx) | ติดตั้งในเครื่อง `pip install openpyxl` | ไม่ต้องติดตั้ง ใช้ sandbox ของ Code execution (มี `openpyxl` อยู่แล้ว) |
| Figma (ไม่บังคับ) | Figma MCP | connector Figma — ถ้าไม่มี skill จะขอ screenshot หรือคำอธิบาย UI แทน |

## ติดตั้งใน Claude Code

เลือกแบบใดแบบหนึ่ง **อย่าติดตั้งทั้งสองแบบพร้อมกัน** เพราะ skill จะซ้ำกัน ติดตั้งเสร็จแล้วให้ restart Claude Code

### แบบ A: ติดตั้งเป็น plugin (แนะนำ)

พิมพ์ใน Claude Code:

```
/plugin marketplace add pasitl-svg/qa-tc-workflow-mica2
/plugin install qa-tc-workflow-mica2@qa-tc-workflow-mica2
```

อัปเดตเวอร์ชันใหม่:

```
/plugin marketplace update qa-tc-workflow-mica2
/plugin update qa-tc-workflow-mica2@qa-tc-workflow-mica2
```

### แบบ B: clone repo

```
git clone https://github.com/pasitl-svg/qa-tc-workflow-mica2.git
cd qa-tc-workflow-mica2
./scripts/link-skills.sh
```

สคริปต์จะสร้าง symlink เข้า `~/.claude/skills` (ถ้ามีโฟลเดอร์ชื่อเดียวกันอยู่แล้ว จะเปลี่ยนชื่อเป็น `.bak-<เวลา>` เก็บไว้ ไม่ลบ) หลังจากนี้แค่ `git pull` skill ก็อัปเดตตามทันที

### ตรวจว่าติดตั้งสำเร็จ

พิมพ์ `/` ใน Claude Code แล้วต้องเห็น `qa-tc-workflow-mica2` ในรายการ

## ติดตั้งใน Claude Desktop

Claude Desktop (และ claude.ai บนเว็บ) ติดตั้ง skill ด้วยการอัปโหลดไฟล์ ZIP ไม่ใช้ plugin และ skill ที่อัปโหลดจะใช้ได้กับบัญชีนั้นทั้งบน Desktop และเว็บ

### 1. สร้างไฟล์ ZIP

ต้องสร้างจากสคริปต์ เพราะ `SKILL.md` ใน repo เป็นแค่ stub ที่ลิงก์ไปยัง `WORKFLOW.md` ซึ่งจะหาไม่เจอถ้าอัปโหลดแยก สคริปต์จะรวมเป็น `SKILL.md` ไฟล์เดียวพร้อมโฟลเดอร์ `references/`

```
git clone https://github.com/pasitl-svg/qa-tc-workflow-mica2.git
cd qa-tc-workflow-mica2
./scripts/build-desktop-zip.sh
```

ได้ไฟล์ `dist/qa-tc-workflow-mica2.zip`

### 2. เปิดใช้ Code execution

Settings → Capabilities → เปิด **Code execution and file creation** (skill ต้องใช้สร้างไฟล์ xlsx) — ถ้าเป็นบัญชี Team / Enterprise ผู้ดูแลองค์กรต้องเปิดให้ใช้ Skills ก่อน

### 3. อัปโหลด skill

Settings → Capabilities → หัวข้อ **Skills** → **Upload skill** → เลือกไฟล์ `qa-tc-workflow-mica2.zip` แล้วตรวจว่าสวิตช์ของ skill เปิดอยู่ (ชื่อเมนูอาจต่างกันเล็กน้อยตามเวอร์ชันของแอป)

### 4. เปิด connector

Settings → Connectors → เชื่อม **Atlassian** และ **Google Drive** (และ Figma ถ้ามี) แล้วเปิดใช้ connector เหล่านี้ในแชตที่จะใช้ skill

### อัปเดตเวอร์ชันใหม่

`git pull` → รัน `./scripts/build-desktop-zip.sh` ใหม่ → ใน Settings → Capabilities → Skills ลบ skill เดิมแล้วอัปโหลด ZIP ใหม่

## วิธีใช้งาน

### เรียกใช้ skill

- Claude Code แบบ clone: พิมพ์ `/qa-tc-workflow-mica2`
- Claude Code แบบ plugin: พิมพ์ `/qa-tc-workflow-mica2:qa-tc-workflow-mica2`
- Claude Desktop: พิมพ์คำขอในแชตตามปกติ แล้ว Claude จะเลือกใช้ skill เอง
- ทุกแบบพิมพ์คำขอตามปกติได้ เช่น

```
เขียน TC จาก ticket MICA2-123
มี CR ใน MICA2-456 ที่กระทบหน้า Login เดิม ช่วยอัปเดต TC ให้หน่อย
ช่วยวิเคราะห์ requirement นี้แล้วเขียน TC: <วาง requirement>
```

### สิ่งที่ skill จะถามระหว่างทาง

1. link Master Suite (Google Sheets) ของ product — ถ้ายังไม่มี ตอบ "ไม่มี" แล้ว skill จะสร้างให้
2. ระดับความละเอียด (Lite / Standard / Detailed)
3. ยืนยันสรุป requirement
4. ตอบจุดที่กำกวมใน requirement
5. ยืนยัน Regression Impact และรายการ TC ที่จะแก้ (เฉพาะกรณี CR)

### ผลลัพธ์ที่ได้

- link Master Suite ที่เพิ่มหรือแก้ TC แล้ว และ link Status Doc
- สรุปจำนวน TC และ coverage เทียบกับ Acceptance Criteria
- รายการ TC ที่ควรทำ automation (Playwright)
- รายการที่ยังรอข้อมูล (TBC) และข้อแนะนำ

## โครงสร้าง repo

```
.claude-plugin/                            # plugin manifest
scripts/link-skills.sh                     # ติดตั้งแบบ clone (Claude Code)
scripts/build-desktop-zip.sh               # สร้าง ZIP สำหรับ Claude Desktop
skills/
├── qa-tc-workflow-mica2/SKILL.md          # discovery stub
└── procedures/
    └── qa-tc-workflow-mica2/
        ├── WORKFLOW.md                    # ขั้นตอนเต็ม
        └── references/level-{lite,standard,detailed}.md
```
