---
name: SocialMap
description: 업무 배정 데스크
colors:
  ink: '#242132'
  muted: '#625d73'
  action: '#543391'
  action-hover: '#412573'
  line: '#ddd9e6'
  surface: '#ffffff'
  sidebar: '#f1eff6'
  error: '#a32b39'
  field: '#aaa3bb'
  focus: '#7958b5'
  open-tint: '#e9e1f6'
  open-ink: '#40236f'
  closed-tint: '#f3e9eb'
  closed-ink: '#852a36'
  done-tint: '#e3efe9'
  done-ink: '#1f5a40'
  chip: '#efedf4'
  chip-ink: '#3c3650'
  pill-line: '#cfc6e0'
  panel: '#f7f6fa'
typography:
  title:
    fontFamily: '"Noto Sans KR", "Apple SD Gothic Neo", sans-serif'
    fontSize: 28px
    lineHeight: 1.3
  body:
    fontFamily: '"Noto Sans KR", "Apple SD Gothic Neo", sans-serif'
    fontSize: 15px
    lineHeight: 1.65
  home-title:
    fontSize: 30px
  page-title-narrow:
    fontSize: 24px
  stat:
    fontSize: 22px
  section:
    fontSize: 20px
  section-small:
    fontSize: 19px
  card-title:
    fontSize: 18px
  track-title:
    fontSize: 17px
  lead:
    fontSize: 16px
  small:
    fontSize: 14px
  meta:
    fontSize: 13px
  chip:
    fontSize: 12.5px
  caption:
    fontSize: 12px
  micro:
    fontSize: 11px
rounded:
  control: 8px
  surface: 8px
  chip: 4px
  pill: 999px
spacing:
  field: 12px
  group: 16px
  section: 24px
  column: 40px
components:
  button-primary:
    backgroundColor: '{colors.action}'
    textColor: '#ffffff'
    rounded: '{rounded.control}'
    padding: 10px 16px
  button-primary-hover:
    backgroundColor: '{colors.action-hover}'
  input:
    backgroundColor: '#ffffff'
    textColor: '{colors.ink}'
    rounded: '{rounded.control}'
    padding: 10px 12px
---

# Design System: SocialMap

## Overview

**Creative North Star: "업무 배정 데스크"**

White work surfaces, a pale violet sidebar and deep violet actions organize recruitment and team work. Project rows prioritize titles, roles and remaining capacity; the work panel keeps personal tasks close. State and role changes belong to the task content rather than decorative charts.

The original EUC-KR JSP/Struts templates supply native presentation. UTF-8 static conversion and new compatibility actions supply the synthetic demo. The shared desk stylesheet is identical to demo.css at this review; preserve EUC-KR bytes when editing JSP files.

Evidence: [WebContent/css/desk.css](WebContent/css/desk.css) and [portfolio-demo/src/demo.css](portfolio-demo/src/demo.css). This document records the implemented cascade on 2026-09-26. The 2026-09-26 recruitment refresh was written without browser access; root performs the rendered desktop/mobile review. Screen-reader output and real keyboard behavior remain unverified until then.

## Colors

The frontmatter is the normative inventory: action for primary work, ink for readable content, muted for secondary facts, line for separation, and surface for supporting regions. Errors retain textual feedback alongside color. No new raster assets were added.

## Typography

Use the actual system/Korean sans stack in the frontmatter. Do not require a downloaded font to complete a task. Titles establish hierarchy through size and weight. Form controls inherit the body face; tabular records remain readable at the body scale.

## Layout

A 216px sidebar anchors the 72px header and task content. Content padding is 36px 40px. At 1000px the sidebar becomes 184px; at 680px it becomes a horizontal scrollable navigation row. Home feed and a 240px work panel use 40px separation and stack at 900px. Tables retain a 540px minimum at the narrow breakpoint inside scrolling containers.

## Elevation & Depth

Surfaces are flat; only feedback toasts use `0 8px 24px #24213224`. Dialog backdrop is `#24213266`.

## Shapes

Controls use 8px corners; supporting surfaces use 8px. Rows use a bottom divider. Avoid nesting additional panels inside the existing task structure.

## Components

- Primary action: action fill, white label, action-hover state and visible focus ring.
- Inputs: white fill, field border, control radius and accent caret. Keep labels and errors adjacent.
- Navigation: preserve the current-state indication and native links.
- Records: use separators and concrete status text. Empty content has an explicit message.
- Responsive and reduced-motion rules remain in the source stylesheet.
- Home: heading and search share one row; a pale-violet pulse sentence states open projects and open seats from stored projects, followed by region pills linking to `ProjList.action?loc=`; featured project entries show place · competition, a two-line description from `cont`, and a facts row (찾는 전공, 인원 현재/추가, 기간). Logged-in work panel shows received/sent application counts and the current project; visitors see guidance only.
- Project detail: status chip (모집 중 · 추가 N명 violet, 모집 마감/해산 red, 완료 green), competition chip and leader; description with preserved line breaks beside a grey conditions panel (dl) that holds the original action buttons.
- My project: original table plus a numbered lifecycle track (모집 등록/참여 신청 → 수락/합류 → 모집 중 or 마감 → 완료 → 팀원 평가) chosen from the project's status; vertical below 680px.
- Received applications add 신청일 and 전공 · 경력 from the sender's member record.
- Chips: 4px radius, 13px/650. Region pills: 999px radius, white on the pulse band.

The companion [.impeccable/design.json](.impeccable/design.json) contains 6 isolated HTML/CSS samples of these implemented patterns. They are illustrative samples, not live application controls.

## Do's and Don'ts

- Do preserve original route, field and listener contracts.
- Do identify synthetic data and the selected execution environment.
- Do retain visible focus and reduced-motion treatment.
- Do use source values when extending an existing component.
- Don't claim a native provider succeeded from a synthetic demo result.
- Don't treat this code-only review as visual approval.
