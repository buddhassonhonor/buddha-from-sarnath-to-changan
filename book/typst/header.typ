// header.typ — 注入到 Quarto Typst 编译流程的自定义样式
// 东方禅意主题样式覆盖
// 字体：使用系统已有 SimSun/SimHei/KaiTi 系列

// ── 色彩定义 ────────────────────────────────────────────────
#let vermilion = rgb("#8B2523")
#let celadon   = rgb("#6B8E7F")
#let gold      = rgb("#C9A84C")
#let stone     = rgb("#4A6FA5")
#let mist      = rgb("#E8E0D0")
#let ink-dark  = rgb("#1C1917")
#let charcoal  = rgb("#3D3530")
#let paper-bg  = rgb("#F5F0E8")

// ── 全局正文字体（宋体 + 仿宋回退） ──────────────────────────
#set text(
  font: ("STSong", "SimSun", "FangSong"),
  fill: ink-dark,
  size: 11pt,
  lang: "zh",
  region: "CN",
)

// ── 全局段落设置 ─────────────────────────────────────────────
#set par(
  first-line-indent: 2em,
  justify: true,
  leading: 0.65em,
)

// ── 彻底关闭标题自动编号（取消 Quarto 生成的 16.1/16.2 等） ──
#set heading(numbering: none)


// ── 目录条目：重写以去掉数字编号 ───────────────────────────
// 说明：Quarto book 模式会给 heading 设置编号（如 "1.1"），
// 此规则拦截目录条目渲染，只显示标题文字，不显示编号。
#show outline.entry: it => {
  let elem = it.element
  let body-text = elem.body  // 这是去掉编号的纯标题文字
  let indent-em = (it.level - 1) * 1.2em
  
  if it.level == 1 {
    // 章级（H1）：加粗、蓝色，不缩进
    v(0.3em, weak: true)
    link(elem.location())[
      #text(weight: "bold", fill: stone)[#body-text]
      #box(width: 1fr, repeat[.])
      #text(weight: "bold", fill: stone)[#it.page]
    ]
  } else {
    // 节级（H2 及以下）：正常字重，缩进
    link(elem.location())[
      #h(indent-em)
      #body-text
      #box(width: 1fr, repeat[.])
      #it.page
    ]
  }
}

// ── 标题样式（H1 章节） ───────────────────────────────────────
#let part-change = state("part-change", false)

#show heading.where(level: 1): it => {
  pagebreak(to: "odd")
  v(1.5cm)
  line(length: 100%, stroke: 0.4pt + gold)
  v(0.7em)
  text(
    font: ("SimHei", "Microsoft YaHei"),
    size: 20pt,
    weight: "bold",
    fill: vermilion,
  )[#it.body]
  v(0.4em)
  line(length: 3cm, stroke: 2pt + celadon)
  v(1.2em)
  
  // 更新 part-change 状态为 false，避免目录中每章都重复显示所属“部分”
  part-change.update(x => false)
}

// ── 标题样式（H2 小节） ───────────────────────────────────────
#show heading.where(level: 2): it => {
  v(0.8em)
  text(
    font: ("SimHei", "Microsoft YaHei"),
    size: 13pt,
    weight: "bold",
    fill: stone,
  )[#it.body]
  v(0.3em)
}

// ── 标题样式（H3） ────────────────────────────────────────────
#show heading.where(level: 3): it => {
  v(0.6em)
  text(
    font: ("SimHei", "Microsoft YaHei"),
    size: 11pt,
    weight: "bold",
    fill: celadon,
  )[#it.body]
  v(0.2em)
}

// ── 引言块样式（blockquote → 金线左边框） ────────────────────
#show quote: it => {
  block(
    width: 100%,
    inset: (left: 1.4em, right: 1em, top: 0.8em, bottom: 0.8em),
    stroke: (left: 3pt + gold, rest: 0.5pt + mist),
    fill: rgb("#FAF7F2"),
    radius: 2pt,
  )[
    #set text(
      font: ("KaiTi", "STKaiti", "FangSong"),
      size: 10.5pt,
      fill: charcoal,
    )
    #set par(leading: 0.8em, first-line-indent: 0em)
    #it.body
  ]
}

// ── 图片居中与说明文字 ────────────────────────────────────────
#show figure: it => {
  v(0.8em)
  align(center)[
    #it.body
    #if it.caption != none {
      v(0.3em)
      text(
        font: ("KaiTi", "STKaiti", "FangSong"),
        size: 9pt,
        fill: charcoal,
      )[#it.caption.body]
    }
  ]
  v(0.8em)
}

// ── 页码格式由 template.typ 统一控制 ───────────────────────
// 前言开始使用阿拉伯数字从 1 开始，封面/版权页/目录页不显示页码。
