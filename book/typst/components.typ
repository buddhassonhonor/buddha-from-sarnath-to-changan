// ============================================================
// components.typ — 可复用排版组件
// 引言框、边注、分隔纹饰、拓展阅读栏
// ============================================================

#import "theme.typ": *

// ── 引言框（章首金线引言）──────────────────────────────────
#let quote-box(body) = {
  block(
    width: 100%,
    inset: (x: 1.4em, y: 1.0em),
    stroke: (left: 3pt + gold, rest: 0.5pt + mist),
    fill: paper.lighten(30%),
    radius: 2pt,
  )[
    #set text(font: font-kai, size: 10.5pt, fill: charcoal)
    #set par(leading: 1.6em)
    #body
  ]
}

// ── 知识小栏（灰底常识框）────────────────────────────────────
#let info-box(title: "", body) = {
  block(
    width: 100%,
    inset: (x: 1.2em, y: 0.9em),
    fill: mist.lighten(40%),
    stroke: 0.5pt + mist,
    radius: 3pt,
  )[
    #if title != "" {
      text(font: font-heading, size: 9.5pt, weight: "bold", fill: celadon)[#title]
      v(0.4em)
    }
    #set text(font: font-body, size: 9.5pt, fill: charcoal)
    #set par(leading: 1.5em)
    #body
  ]
}

// ── 常见误解栏（朱砂左边线）──────────────────────────────────
#let myth-box(body) = {
  block(
    width: 100%,
    inset: (x: 1.2em, y: 0.8em),
    stroke: (left: 3pt + vermilion.lighten(30%), rest: none),
    fill: vermilion.lighten(90%),
  )[
    #text(font: font-heading, size: 9pt, fill: vermilion, weight: "bold")[▸ 常见误解]
    #v(0.3em)
    #set text(font: font-body, size: 9.5pt, fill: charcoal)
    #set par(leading: 1.5em)
    #body
  ]
}

// ── 经典名句（居中展示，金色装饰）────────────────────────────
#let sutra-line(body) = {
  v(0.8em)
  align(center)[
    #line(length: 4cm, stroke: 0.5pt + gold)
    #v(0.5em)
    #text(font: font-kai, size: 11pt, fill: charcoal)[#body]
    #v(0.5em)
    #line(length: 4cm, stroke: 0.5pt + gold)
  ]
  v(0.8em)
}

// ── 章节分隔纹饰（小莲花符号）────────────────────────────────
#let lotus-divider() = {
  v(1.2em)
  align(center)[
    #text(size: 14pt, fill: celadon.lighten(20%))[❀]
  ]
  v(1.2em)
}

// ── 部分标题页（Part）─────────────────────────────────────────
#let part-page(number: "", title: "", subtitle: "") = {
  pagebreak(to: "odd")
  v(1fr)
  align(center)[
    #text(font: font-latin, size: 13pt, fill: gold)[PART #number]
    #v(0.6em)
    #line(length: 6cm, stroke: 0.5pt + gold)
    #v(0.8em)
    #text(font: font-heading, size: 22pt, weight: "bold", fill: ink)[#title]
    #if subtitle != "" {
      v(0.5em)
      text(font: font-kai, size: 13pt, fill: celadon)[#subtitle]
    }
  ]
  v(1fr)
  pagebreak()
}
