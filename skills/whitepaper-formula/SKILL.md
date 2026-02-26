---
name: whitepaper-formula
description: Generate branded, research-backed PDF white papers for any company. Extracts real brand guidelines, matches citations to audience, produces print-ready PDFs via Chrome headless.
author: mikeygonz
---

# White Paper Creation Formula

_A repeatable process for generating branded, research-backed PDF white papers for any company._

## The Formula

### 1. Brand Extraction (5 min)
- **Visit the company's actual website** — screenshot it, absorb the vibe
- **Pull the real logo** — SVG from their site source, not a recreation. Embed as inline SVG so it renders in PDF
- **Extract the color system** — primary, secondary, accent. Usually 3-4 colors max
- **Identify typography** — what font do they use? Load it from Google Fonts or embed it
- **Note layout patterns** — do they use cards? Full-bleed images? Gradient headers? Match their specific style
- **Cross-reference brand guidelines** — check for official brand documentation, press kits, or style guides. Many companies publish these publicly
- **Extract from existing assets** — if no formal guidelines exist, pull colors/fonts/patterns from their website, marketing materials, or existing PDFs

### 2. Audience Research (5 min)
- **Who is this for?** — their role, their daily pain, their vocabulary
- **What sources do they trust?** — match citation sources to the audience's world. Every industry and persona has different credibility signals
- **What's their reading context?** — PDF on laptop? Mobile? Print? This affects density and layout

### 3. Real Research & Citations (10 min)
- **Find 2-3 credible sources** — major research firms, surveys with large sample sizes
- **Pull specific stats** — not vague claims. "31,000 respondents across 31 countries" beats "a recent study"
- **Include expert quotes** — named people from recognized institutions
- **Footnote everything** — superscript references with a proper endnotes section
- **Match sources to audience** — the same stat from different sources carries different weight depending on who's reading. Choose citations your specific reader would respect

### 4. Narrative Arc (5 min planning)
Structure every white paper the same way:
1. **The Problem** — quantified pain the reader already feels
2. **Why Now** — the shift that makes this urgent (market data)
3. **The Solution** — what this actually is, explained clearly
4. **Use Cases** — concrete applications mapped to their daily life
5. **Capabilities** — specific, not vague. Table format with modes/categories
6. **The Unexpected Angle** — something personal that connects (relevant to the recipient's world)
7. **Getting Started** — timeline that makes it feel achievable
8. **CTA** — soft close, not salesy

### 5. Visual Design System
- **Cover page** — full-bleed brand color, real logo, title, subtitle, personalization, date
- **Stock photography** — 3-4 images from Unsplash, embedded as base64 so PDF renders them
- **Pull quotes** — dark background blocks with expert quotes break up text
- **Stat cards** — 3-up grid with big numbers + labels for scannability
- **Capability table** — color-coded tags matching brand palette
- **Use case cards** — numbered, 2-column grid. No emoji — use CSS-styled number badges
- **Timeline** — for implementation, use a vertical timeline with dot markers
- **Callout boxes** — left-border accent color, light background
- **Back cover** — full brand color, centered logo, clean close

### 6. Production
- Build as single HTML file with all assets embedded (base64 images, inline SVG logos)
- Use Chrome headless for PDF generation: `--no-pdf-header-footer --no-margins`
- Print CSS: `page-break-inside: avoid` on individual cards/stats, NOT on grids/sections
- QC every page — extract with pymupdf or similar, check for blank pages, split content, broken images
- Iterate: usually takes 2-3 passes to get pagination right

### 7. Quality Checklist
- [ ] Real company logo (SVG, not text)
- [ ] Real brand colors (not approximations)
- [ ] Real research with footnotes
- [ ] Expert quotes with attribution
- [ ] Stock photography (not AI-generated)
- [ ] No emoji anywhere
- [ ] No browser artifacts in PDF (headers, footers, file paths)
- [ ] No blank pages
- [ ] Personalized to recipient
- [ ] Back cover matches front cover aesthetic
- [ ] Every page has content — no half-empty spreads

## Key Insight

The magic isn't any single element — it's the **combination of real brand assets + real research + professional layout patterns**. Any one of those alone looks like a mockup. All three together looks like it came from their marketing department.
