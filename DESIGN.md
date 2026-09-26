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
typography:
  title:
    fontFamily: '"Noto Sans KR", "Apple SD Gothic Neo", sans-serif'
    fontSize: 28px
    lineHeight: 1.3
  body:
    fontFamily: '"Noto Sans KR", "Apple SD Gothic Neo", sans-serif'
    fontSize: 15px
    lineHeight: 1.65
rounded:
  control: 8px
  surface: 8px
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

Evidence: [WebContent/css/desk.css](WebContent/css/desk.css) and [portfolio-demo/src/demo.css](portfolio-demo/src/demo.css). This document records the implemented cascade on 2026-09-26. Browser control, rendering and screenshots were excluded by the user; visual layout, screen-reader output and real keyboard behavior remain unverified.

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

The companion [.impeccable/design.json](.impeccable/design.json) contains 6 isolated HTML/CSS samples of these implemented patterns. They are illustrative samples, not live application controls.

## Do's and Don'ts

- Do preserve original route, field and listener contracts.
- Do identify synthetic data and the selected execution environment.
- Do retain visible focus and reduced-motion treatment.
- Do use source values when extending an existing component.
- Don't claim a native provider succeeded from a synthetic demo result.
- Don't treat this code-only review as visual approval.
