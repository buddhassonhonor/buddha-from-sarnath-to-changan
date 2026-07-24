// ============================================================
// template.typ — 主排版模板
// 《从鹿野苑到长安城》东方禅意书籍模板
// ============================================================

#import "theme.typ": *
#import "components.typ": *

// ── 主函数：Quarto 调用入口 ──────────────────────────────────
#let book-template(
  title: "从鹿野苑到长安城",
  subtitle: "一部写给普通人的佛教简史",
  author: "著",
  date: "",
  cover-image: none,
  doc,
) = {

  // ── 页面基础设置 ──────────────────────────────────────────
  set page(
    paper: "a4",
    margin: page-margin,
    background: {
      // 宣纸色背景
      rect(width: 100%, height: 100%, fill: paper)
    },
    header: context {
      let page-num = here().page()
      if page-num > 2 {
        let is-even = calc.rem(page-num, 2) == 0
        grid(
          columns: (1fr, 1fr),
          gutter: 0pt,
          align(left)[
            #if is-even {
              text(font: font-kai, size: 8pt, fill: celadon)[#title]
            }
          ],
          align(right)[
            #if not is-even {
              // 章节标题由 Quarto 自动注入
              text(font: font-kai, size: 8pt, fill: celadon)[]
            }
          ],
        )
        v(-0.5em)
        line(length: 100%, stroke: 0.4pt + mist)
      }
    },
    footer: context {
      let page-num = here().page()
      if page-num > 2 {
        let is-even = calc.rem(page-num, 2) == 0
        v(-0.5em)
        line(length: 100%, stroke: 0.4pt + mist)
        v(0.2em)
        align(if is-even { left } else { right })[
          #text(font: font-latin, size: 8pt, fill: celadon)[#page-num]
        ]
      }
    },
  )

  // ── 正文排版设置 ──────────────────────────────────────────
  set text(
    font: font-body,
    size: body-size,
    fill: ink,
    lang: "zh",
    region: "CN",
  )

  set par(
    leading: lead-size,
    first-line-indent: indent-size,
    justify: true,
    spacing: 0.6em,
  )

  // ── 标题层级设置 ──────────────────────────────────────────
  // H1 = 章节标题（大字、朱砂）
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2cm)
    // 章号装饰线
    line(length: 100%, stroke: 0.4pt + gold)
    v(0.8em)
    block[
      #set text(font: font-heading, size: 22pt, weight: "bold", fill: vermilion)
      #it.body
    ]
    v(0.3em)
    line(length: 3cm, stroke: 2pt + celadon)
    v(1.5em)
  }

  // H2 = 小节标题（石青色、无缩进）
  show heading.where(level: 2): it => {
    v(1.2em)
    block[
      #set text(font: font-heading, size: 14pt, weight: "bold", fill: stone)
      #it.body
    ]
    v(0.4em)
  }

  // H3 = 三级标题（青瓷色小字）
  show heading.where(level: 3): it => {
    v(0.8em)
    block[
      #set text(font: font-heading, size: 11.5pt, weight: "bold", fill: celadon)
      #it.body
    ]
    v(0.2em)
  }

  // ── 引言块（blockquote）────────────────────────────────────
  show quote: it => {
    quote-box(it.body)
  }

  // ── 图片居中 ──────────────────────────────────────────────
  show figure: it => {
    v(0.8em)
    align(center)[
      #it.body
      #if it.caption != none {
        v(0.3em)
        text(font: font-kai, size: 9pt, fill: charcoal)[#it.caption.body]
      }
    ]
    v(0.8em)
  }

  // ── 封面页 ────────────────────────────────────────────────
  page(
    margin: 0cm,
    background: rect(width: 100%, height: 100%, fill: ink),
    header: none,
    footer: none,
  )[
    // 左侧朱砂竖纹
    place(left + top)[
      #rect(width: 8mm, height: 100%, fill: vermilion)
    ]
    // 封面内容区
    pad(left: 2cm, right: 1.5cm, top: 0cm)[
      #v(1fr)
      // 书名
      #text(font: font-heading, size: 32pt, weight: "bold", fill: paper)[
        #title
      ]
      #v(0.6em)
      // 副标题
      #text(font: font-kai, size: 15pt, fill: celadon)[
        #subtitle
      ]
      #v(0.8em)
      // 金线
      #line(length: 8cm, stroke: 1pt + gold)
      #v(1fr)
      // 封面图（如有）
      #if cover-image != none {
        image(cover-image, width: 60%, fit: "contain")
        v(1em)
      }
      #v(1fr)
      // 作者
      #text(font: font-kai, size: 12pt, fill: mist)[#author]
      #v(2cm)
    ]
  ]

  // ── 版权页 ────────────────────────────────────────────────
  page(header: none, footer: none)[
    #v(1fr)
    #align(center)[
      #text(font: font-kai, size: 10pt, fill: charcoal)[
        #title \
        #subtitle \
        \
        #author \
        #if date != "" [#date]
        \
        \
        本书内容基于公开佛教经典与历史文献编写，\
        仅供学习参考，不代表任何宗派立场。
      ]
    ]
    #v(2cm)
  ]

  // ── 目录 ──────────────────────────────────────────────────
  page(header: none, footer: none)[
    #heading(level: 1, outlined: false, bookmarked: false)[目　录]
    #set text(font: font-body, size: 10.5pt)
    #outline(
      depth: 2,
      indent: 1.5em,
      fill: repeat[#text(fill: mist)[·]],
    )
  ]

  // ── 正文 ──────────────────────────────────────────────────
  // 前言从第 1 页开始，使用阿拉伯数字
  counter(page).update(1)
  set page(numbering: "1")
  doc
}
