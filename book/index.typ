// ============================================================
// quarto-template.typ — 自定义 Quarto Typst 模板
// ============================================================

#import "@preview/orange-book:0.7.1": *

// 1. Quarto 标准标记定义
#let horizontalrule = line(start: (25%,0%), end: (75%,0%), stroke: 0.5pt + rgb("#C9A84C"))

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// 2. 文本转换辅助函数
#let to-string(val) = {
  let str-type = type("")
  let content-type = type([])
  let t = type(val)
  if t == str-type {
    val
  } else if t == content-type {
    if val.has("text") {
      val.text
    } else if val.has("children") {
      val.children.map(to-string).join("")
    } else if val.has("body") {
      to-string(val.body)
    } else {
      ""
    }
  } else {
    ""
  }
}

// 3. 部分页面配图映射 (全新且独立的配图)
#let part-images = (
  "第一部": "images/parts/part1_new.jpg", // 犍陀罗佛立像
  "第二部": "images/parts/part2_new.jpg", // 桑奇大塔
  "第三部": "images/parts/part3_new.jpg", // 辽代木雕观音像
  "第四部": "images/parts/part4_new.jpg", // 洛阳白马寺
  "第五部": "images/parts/part5_new.jpg", // 西安大雁塔
  "第六部": "images/parts/part6_new.jpg", // 枯山水禅意庭院
)

// 4. 重构部分（Part）页面函数
#let part(title) = {
  pagebreak(to: "odd")
  part-change.update(x => true)
  part-state.update(x => title)
  part-counter.step()
  
  // 提取文字并进行内容解析
  let title-str = to-string(title)
  let main-parts = title-str.split("——")
  let main-title = main-parts.at(0)
  let subtitle = if main-parts.len() > 1 { main-parts.at(1) } else { "" }
  
  let sub-parts = main-title.split("：")
  let part-num = sub-parts.at(0)
  let part-name = if sub-parts.len() > 1 { sub-parts.at(1) } else { "" }
  
  let part-img = part-images.at(part-num, default: none)

  page(
    margin: 0cm,
    header: none,
    footer: none,
    background: rect(width: 100%, height: 100%, fill: rgb("#FAF7F2")),
  )[
    #set text(fill: black)
    #language-state.update(x => "zh")
    #main-color-state.update(x => rgb("#C9A84C"))
    #part-font-size-state.update(x => part-font-size)
    #part-style-state.update(x => part-style)
    #supplement-part-state.update(x => supplement-part)
    #outline-small-depth-state.update(x => outline-small-depth)
    #outline-small-width-state.update(x => outline-small-width)
    #context {
      let her = here()
      part-location.update(x => her)
    }

    // A. 经典双金线边框 (古典装帧风格)
    #place(center + horizon)[
      #rect(width: 90%, height: 92%, stroke: 0.5pt + rgb("#C9A84C"))
    ]
    #place(center + horizon)[
      #rect(width: 88%, height: 90.5%, stroke: 1.2pt + rgb("#C9A84C"))
    ]
    
    // B. 左侧朱砂红竖条 (维持全书整体品牌统一)
    #place(left + top)[
      #rect(width: 8mm, height: 100%, fill: rgb("#8B261D"))
    ]
    
    // C. 页面核心内容排版
    #pad(left: 2.2cm, right: 1.8cm, top: 4.5cm, bottom: 2cm)[
      #align(center)[
        // 1. 部号 (例如：第一部)
        #text(font: ("STSong", "STSongti-SC-Regular", "SimSun", "serif"), size: 20pt, weight: "bold", fill: rgb("#C9A84C"))[
          #part-num
        ]
        
        #v(1em)
        
        // 2. 部标题 (例如：佛出世)
        #text(font: ("SimHei", "Microsoft YaHei", "sans-serif"), size: 26pt, weight: "bold", fill: rgb("#8B261D"))[
          #part-name
        ]
        
        #v(1.2em)
        #line(length: 5cm, stroke: 1pt + rgb("#C9A84C"))
        #v(1.2em)
        
        // 3. 释义副标题 (例如：佛教从一个人的觉悟开始)
        #text(font: ("KaiTi", "STKaiti", "FangSong", "serif"), size: 14pt, fill: rgb("#3D3530"))[
          #subtitle
        ]
        
        #v(3.5em)
        
        // 4. 禅意“月窗”金边插图
        #if part-img != none [
          #block(
            width: 130pt,
            height: 130pt,
            radius: 65pt,
            clip: true,
            stroke: 1.5pt + rgb("#C9A84C"),
            align(center + horizon)[
              #image(part-img, width: 100%, height: 100%, fit: "cover")
            ]
          )
        ]
      ]
    ]
  ]
  pagebreak()
}

#let book(
  title: "",
  subtitle: "",
  date: "",
  author: (),
  paper-size: "a4",
  width: none,
  height: none,
  margin: (x: 3cm, bottom: 2.5cm, top: 3cm),
  logo: none,
  cover: none,
  cover-background: auto,
  image-index: none,
  body,
  main-color: blue,
  copyright: [],
  lang: "en",
  list-of-figure-title: none,
  list-of-table-title: none,
  supplement-chapter: "Chapter",
  supplement-part: "Part",
  font-size: 10pt,
  part-style: 0,
  part-font-size: auto,
  lowercase-references: false,
  padded-heading-number: true,
  outline-font-size: auto,
  outline-small-depth: 2,
  outline-small-width: 9.5cm,
  heading-style: 0,
  first-line-indent: true,
  outline-depth: 3
) = {
  set document(author: author, title: title)
  set text(size: font-size, lang: lang)
  set par(leading: 0.5em)
  set enum(numbering: "1.a.i.")
  set list(marker: ([•], [--], [◦]))

  set ref(supplement: (it)=>{lower(it.supplement)}) if lowercase-references

  set math.equation(numbering: num =>
    numbering("(1.1)", counter(heading).get().first(), num)
  )

  set figure(numbering: num =>
    numbering("1.1", counter(heading).get().first(), num)
  )

  set figure(gap: 1.3em)

  show figure: set align(center)
  show figure: it => {
    it
    if it.placement == none {
      v(2.6em, weak: true)
    }
  }

  show terms: set par(first-line-indent: 0em)

  set page( width: width, height: height)   if (width != none and height != none)
  set page( paper: paper-size) if (width == none or height == none)

  if (part-font-size == auto){
    part-font-size = huge-text
  }

  set page(
    margin: margin,
    header: context {
      set text(size: title5)
      let page_number = counter(page).at(here()).first()
      let odd_page = calc.odd(page_number)
      let p_change = part-change.at(here())
      
      let all = query(heading.where(level: 1))
      if all.any(it => it.location().page() == page_number) or p_change {
        return
      }
      let appendix = appendix-state.at(here())      
      if odd_page {
        let before = query(selector(heading.where(level: 2)).before(here()))
        let counterInt = counter(heading).at(here())
        if before != () and counterInt.len() > 1 {
          box(width: 100%, inset: (bottom: 5pt), stroke: (bottom: 0.5pt))[
            #text(if appendix != none {numbering("A.1", ..counterInt.slice(0,2)) + " " + before.last().body} else {numbering("1.1", ..counterInt.slice(0,2)) + " " + before.last().body})
            #h(1fr)
            #page_number
          ]
        }
      } else {
        let before = query(selector(heading.where(level: 1)).before(here()))
        let counterInt = counter(heading).at(here()).first()

        if before != () and counterInt > 0 {
          box(width: 100%, inset: (bottom: 5pt), stroke: (bottom: 0.5pt))[
            #set par(justify: false)
            #grid(
              columns: (auto, 1fr),
              align: (left + horizon, right + horizon),
              column-gutter: 0.3em,
              [#page_number],
              text(weight: "bold")[
                #if appendix != none {
                  numbering("A.1", counterInt) + ". " + before.last().body
                } else {
                  before.last().supplement + " " + str(counterInt) + ". " + before.last().body
                }
              ]
            )
          ]
        }
      }
    }
  )

  show cite: it => {
    show regex("[\w\W]"): set text(main-color)
    it
  }

  set heading(
    hanging-indent: 0pt,
    numbering: (..nums) => {
      let vals = nums.pos()
      let pattern = if vals.len() == 1 { "1." }
                    else if vals.len() <= 4 { "1.1" }
      if pattern != none { numbering(pattern, ..nums) }
    }
  )

  show heading.where(level: 1): set heading(supplement: supplement-chapter)

  show heading: it => {
    set text(size: font-size)
    if it.level == 1 {
      pagebreak(to: "odd")
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
      if not it.outlined {
        // Clean centered text for TOC, Bibliography, etc.
        align(center)[
          #v(3cm)
          #text(font: ("SimHei", "Microsoft YaHei", "sans-serif"), size: 24pt, weight: "bold", fill: main-color)[#it.body]
          #v(2cm)
        ]
      } else if (heading-style == 0){
        context {
          let img = heading-image.at(here())
          if img != none {
            set image(width: 21cm, height: 9.4cm)
            place(move(dx: -3cm, dy: -3cm, img))
            place(
              move(dx: -3cm, dy: -3cm, 
                block(width: 21cm, height: 9.4cm, 
                  align(right + bottom, 
                    pad(bottom: 1.2cm, 
                      block(width: 86%,
                        stroke: ( right: none, rest: 2pt + main-color),
                        inset: (left:2em, rest: 1.6em),
                        fill: rgb("#FFFFFFAA"),
                        radius: (right: 0pt, left: 10pt),
                        align(left, 
                          text(size: title1, it)
                        )
                      )
                    )
                  )
                )
              )
            )
            v(8.4cm)
          } else {
            layout(size => {
            let full_width = size.width
            move(dx: 3cm, dy: -0.5cm, 
              align(right + top, 
                block(
                  width: 100% + 3cm,
                  stroke: (right: none, rest: 2pt + main-color),
                  inset: (left:2em, rest: 1.6em),
                  fill: white,
                  radius: (right: 0pt, left: 10pt),
                  align(left, 
                    block(width: full_width, 
                      text(size: title1, it, 
                        hyphenate: false
                      )
                    )
                  )
                )
              )
            )
            })
            v(1.5cm, weak: true)
          }
        }
      } else if (heading-style == 1){
        set par(justify: false)
        align(right + top, block(
          width: 100%,
          stroke: 2pt + main-color,
          inset: (left:2em, rest: 1.6em),
          fill: white,
          radius: 10pt,
          align(left, text(size: title1, it, hyphenate: false))
        ))
        v(1.5cm, weak: true)
      } else if (heading-style == 2){
        set par(justify: false)
        set align(right)
        if it.numbering != none {
          text(size: 64pt, weight: "bold", fill: main-color)[
          #counter(heading).display("1")
          ]
          v(-1.2em)
        }

        text(size: 24pt, weight: "bold", fill: main-color)[
          #it.body
        ]

        v(0.5em)
        line(length: 100%, stroke: 1.5pt + main-color)
        v(1.5cm, weak: true)
      }

      part-change.update(x =>
        false
      )
    }
    else if it.level == 2 or it.level == 3 or it.level == 4 {
      let size
      let space
      let color = main-color
      if it.level == 2 {
        size = title2
        space = 1em
      }
      else if it.level == 3 {
        size = title3
        space = 0.9em
      }
      else {
        size = title4
        space = 0.7em
        color = black
      }
      set text(size: size)
      let number = if it.numbering != none {
        let num = counter(heading).display(it.numbering)
        let width = measure(num).width
        let gap = 7mm
        if (padded-heading-number){
          set text(fill: main-color) if it.level < 4
          place(dx: -width - gap, num)
        }
        else{
          [#num \- ]
        }
      }
      block(number + it.body)
      v(space, weak: true)
    }
    else {
      it
    } 
  }

  set underline(offset: 3pt)

  // ── CUSTOMIZED TITLE PAGE DESIGN ───────────────────────────
  page(
    margin: 0cm,
    header: none,
    footer: none,
    background: rect(width: 100%, height: 100%, fill: rgb("#FAF7F2")),
  )[
    #set text(fill: black)
    #language-state.update(x => lang)
    #main-color-state.update(x => main-color)
    #part-font-size-state.update(x => part-font-size)
    #part-style-state.update(x => part-style)
    #supplement-part-state.update(x => supplement-part)
    #outline-small-depth-state.update(x => outline-small-depth)
    #outline-small-width-state.update(x => outline-small-width)

    // Left vermilion stripe
    #place(left + top)[
      #rect(width: 8mm, height: 100%, fill: rgb("#8B261D"))
    ]
    
    #pad(left: 2.2cm, right: 1.8cm, top: 2.2cm, bottom: 1.5cm)[
      #align(center)[
        // 1. Calligraphy Title at the very top
        #image("images/downloaded/title.png", width: 80%)
        
        #v(0.8em)
        
        // Subtitle
        #text(font: ("KaiTi", "STKaiti", "FangSong", "serif"), size: 14pt, fill: rgb("#6B8E7F"), weight: "bold")[
          #subtitle
        ]
        
        #v(0.6em)
        #line(length: 4cm, stroke: 1pt + rgb("#C9A84C"))
        #v(0.8em)
        
        // Author
        #text(font: ("KaiTi", "STKaiti", "FangSong", "serif"), size: 12pt, fill: rgb("#3D3530"))[
          #author
        ]
        
        #v(2.5em)
        
        // 2. Framed Buddha Image in the center/lower part (Uncropped, with gold border)
        #block(
          width: 95%,
          stroke: 1.5pt + rgb("#C9A84C"), // Gold border
          radius: 2pt,
          clip: true,
          image("images/cover/cover_vairocana_longmen.jpg", width: 100%, fit: "contain")
        )
        
        #v(1fr)
        
        // Year at the bottom
        #text(font: ("EB Garamond", "Garamond", "serif"), size: 10pt, fill: rgb("#6B8E7F"))[
          2025
        ]
      ]
    ]
  ]

  if (copyright!=none){
    set text(size: 10pt)
    show link: it => [
      #set text(fill: main-color)
      #it
    ]
    set par(spacing: 2em)
    align(bottom, copyright)
  }
  
  heading-image.update(x =>
    image-index
  )

  my-outline(appendix-state, appendix-state-hide-parent, part-state, part-location, part-change, part-counter, main-color, textSize1: outline-part, textSize2: outline-heading1, textSize3: outline-heading2, textSize4: outline-heading3, depth: outline-depth, outline-font-size: outline-font-size)

  show figure.where(caption: none): set figure(outlined: false)

  my-outline-sec(list-of-figure-title, figure.where(kind: image), outline-heading3)

  my-outline-sec(list-of-table-title, figure.where(kind: table), outline-heading3)

  // Main body.
  set par(
    first-line-indent: 1em,
    justify: true,
    spacing: 0.5em
  ) if first-line-indent

  set par(
    justify: true,
    spacing: 0.5em
  ) if not first-line-indent

  show list: it => {
    set par(spacing: 1em)
    it
  }

  show enum: it => {
    set par(spacing: 1em)
    it
  }

  show figure: set block(spacing: 1.2em)
  show math.equation: set block(spacing: 1.2em)

  show link: set text(fill: main-color)

  body

  // ── CUSTOMIZED BACK COVER PAGE DESIGN ───────────────────────
  page(
    margin: 0cm,
    header: none,
    footer: none,
    background: rect(width: 100%, height: 100%, fill: rgb("#FAF7F2")),
  )[
    #set text(fill: black)
    
    // Left vermilion stripe
    #place(left + top)[
      #rect(width: 8mm, height: 100%, fill: rgb("#8B261D"))
    ]
    
    // Double Gold Frame Border
    #place(center + horizon)[
      #rect(width: 90%, height: 92%, stroke: 0.5pt + rgb("#C9A84C"))
    ]
    #place(center + horizon)[
      #rect(width: 88%, height: 90.5%, stroke: 1.2pt + rgb("#C9A84C"))
    ]
    
    #align(center + horizon)[
      #block(width: 75%)[
        // 1. Serene Yungang Buddha image (rectangular framed with gold border, matches cover style)
        #block(
          width: 80%,
          stroke: 1.5pt + rgb("#C9A84C"),
          radius: 2pt,
          clip: true,
          image("images/parts/back_cover_buddha.jpg", width: 100%, fit: "contain")
        )
        
        #v(3em)
        
        // 2. Book Summary (Poetic, left-aligned, Chinese paragraph indent)
        #set align(left)
        #set text(font: ("KaiTi", "STKaiti", "FangSong", "serif"), size: 12pt, fill: rgb("#3D3530"))
        #set par(justify: true, leading: 1.2em, spacing: 1.5em, first-line-indent: 0em)
        #block(width: 90%)[
          #h(2em)从鹿野苑的初转法轮，到长安城的终南钟声。本书以温情与清明的笔触，梳理了佛教从印度起源到在中国落地生根、融入中国人精神世界的两千年历程。
          
          #h(2em)它不仅是一部写给普通人的佛教简史，更是一份关于智慧、慈悲与觉悟的心灵指南。愿你在历史的浩瀚与禅意的空灵中，照见当下的心。
        ]
      ]
    ]
  ]
}

#show: book.with(
  title: [从鹿野苑到长安城],
  subtitle: [一部写给普通人的佛教简史],
  author: "著",
  date: "2025-01-01",
  lang: "zh",
  main-color: rgb("#C9A84C"),
  outline-depth: 2,
)

// 注入 header-includes (例如 header.typ)
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
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

// 注入 include-before (例如 before-body.typ)
#pagebreak(to: "odd", weak: true)
#counter(page).update(1)
#set page(numbering: "1")
// Reset Quarto's custom figure counters at each chapter (level-1 heading).
// Orange-book only resets kind:image and kind:table, but Quarto uses custom kinds.
// This list is generated dynamically from crossref.categories.
#show heading.where(level: 1): it => {
  counter(figure.where(kind: "quarto-float-fig")).update(0)
  counter(figure.where(kind: "quarto-float-tbl")).update(0)
  counter(figure.where(kind: "quarto-float-lst")).update(0)
  counter(figure.where(kind: "quarto-callout-Note")).update(0)
  counter(figure.where(kind: "quarto-callout-Warning")).update(0)
  counter(figure.where(kind: "quarto-callout-Caution")).update(0)
  counter(figure.where(kind: "quarto-callout-Tip")).update(0)
  counter(figure.where(kind: "quarto-callout-Important")).update(0)
  counter(math.equation).update(0)
  it
}

// 主体正文
= 前言：为什么今天还要读懂佛教？
<前言为什么今天还要读懂佛教>
清晨的古寺，还笼罩在一层淡淡的薄雾里。山门半掩，石阶微湿，檐角的风铃偶尔轻响。第一缕阳光越过屋脊，落在斑驳的红墙和静默的佛像上。殿内钟声悠然传来，香烟袅袅升起，世间的纷扰仿佛也随之远去。置身其中，人会不由自主地放慢脚步，暂时忘却得失与宠辱，只愿在这一刻，让内心安静下来。

也许，这正是许多人对佛教最初的印象：古寺、钟声、香火和一份远离尘嚣的宁静。

但佛教并不只存在于寺庙之中，也不只属于那些想要远离世俗的人。

很多人一提到佛教，首先想到的是寺庙、香火、佛像、诵经，或者逢年过节时到寺院里烧一炷香，许一个愿。也有人觉得佛教离现代生活很远，似乎只属于出家人和老年人，或者只是在谈生死、轮回与来世。

可如果我们稍微走近一点就会发现，佛教从来不只是寺庙里的宗教仪式。

它早已深深进入中国人的语言、艺术、伦理和人生观之中。我们日常所说的“因果”“缘分”“放下”“执着”“慈悲”“觉悟”“烦恼”“世界”“刹那”，许多都与佛教有关。中国的石窟、造像、建筑、诗词、绘画、戏曲和小说，也处处留下了佛教的身影。

甚至一个人如何面对得失、痛苦、衰老和死亡，如何理解善恶、命运和人生无常，也都曾受到佛教思想的深刻影响。

然而，当有人认真问起：佛究竟是谁？菩萨和佛有什么不同？佛教为什么说人生是苦？“空”是不是意味着一切都不存在？因果是不是简单的善有善报、恶有恶报？学佛是不是意味着看破红尘、远离现实？

许多人又会发现，自己对佛教似乎十分熟悉，其实只知道一些零散的印象。

本书想做的，并不是把佛教讲成一种神秘莫测的学问，也不是劝每一位读者都必须成为佛教徒。它更希望像一盏温和的灯，帮助普通人看清：佛教从哪里来，怎样传入中国，又如何逐渐成为中国文化的一部分；佛、菩萨、罗汉到底有什么区别；四圣谛、八正道、因果、轮回、空、禅、净土这些常常听见、却不容易讲清楚的概念，究竟是什么意思。

佛教并不是从一座寺庙、一尊佛像或一场神迹开始的。

它开始于一个人的追问。

两千多年前，一位生活优裕的年轻人走出王宫，看见衰老、疾病和死亡。那些人人都知道、却常常不愿正视的事实，第一次如此真实地出现在他的面前。他开始追问：人为什么会痛苦？生命为什么不能永远停留在美好的时刻？有没有一种道路，能够使人不再完全被欲望、恐惧与烦恼支配？

这个年轻人后来成为释迦牟尼佛。

“佛”并不是神的名字，而是“觉悟者”的意思。佛教最初所面对的，也不是一个遥远而抽象的世界，而是每个人都无法回避的现实：生老病死，爱别离，求不得，世事无常，以及那颗总是在得到与失去之间摇摆不定的心。

全书将以汉传佛教为核心，按照“佛出世---佛灭度后---大乘兴起---佛法东来---汉地成形---现代回望”的脉络展开。

我们会从悉达多太子离开王宫讲起，走到菩提树下的觉悟和鹿野苑的第一次说法；看佛陀入灭以后，弟子们如何结集经典，佛法又如何走出恒河流域；进入大乘佛教的世界，认识文殊、普贤、观音、地藏、弥勒与阿弥陀佛；随后追随佛法东来的脚步，看鸠摩罗什、玄奘、鉴真、达摩、慧能等人物，如何改变中国佛教的面貌；最后再回到现代人的生活，重新理解无常、慈悲、因果、放下与智慧。

这是佛教传播的历史，也是一群人在不同的时代里，不断追问生命、理解痛苦和寻找出路的历史。

写这本书时，我们尽量坚持一个原则：尊重传统，而不神秘化。

重要的观点，尽可能依据佛教经典、历史资料以及历代高僧大德的解释；但在表达上，尽量不用艰深的术语，而是用普通人能够理解的语言，把佛教放回真实的人生经验之中。

尊重传统，并不意味着把所有后世传说都当成历史事实；避免神秘化，也不意味着否定信仰所具有的意义。我们所希望做的，是尽可能分清经典教义、历史事实、宗派解释、民间习俗和文学传说，同时又不失去佛教本身所具有的人文温度。

因为佛教最初面对的，并不是抽象的理论问题，而是每个人都会遇到的问题：

人为什么会痛苦？

变化为什么让人不安？

我们为什么明知世事无常，却仍希望一切永远不变？

当所爱的人终将离去，当努力未必得到回报，当衰老与死亡无法回避，我们又该如何安放自己的内心？

今天的人拥有比古人更丰富的物质、更快捷的信息和更多的选择，却并没有因此远离烦恼。我们依然会在比较中焦虑，在关系中受伤，在得失中反复，在未来的不确定里感到不安。

佛教未必能够替人消除生活中的所有困难，却试图帮助人看清：痛苦如何产生，执着如何形成，情绪又怎样一步步控制我们的心。它不是让人逃离现实，而是教人更清醒地面对现实；不是让人变得冷漠，而是希望人在看见无常以后，更懂得珍惜；不是叫人放弃责任，而是提醒我们在承担责任时，不被贪欲、愤怒和恐惧完全支配。

因此，今天读懂一点佛教，并不一定意味着成为佛教徒。

它也可以是理解中国文化的一条路径，是认识亚洲文明的一扇窗口，是重新观察自己内心的一次机会。

也许，我们读懂佛教，并不是为了离开人间，而是为了更清醒地生活在人间；不是为了躲进一座寂静的古寺，而是为了在离开寺院、重新走入喧嚣以后，心中仍能保有一点钟声般的清明，一缕香烟般的从容。

而这一切，要从一个王子为什么离开王宫说起。

#part[第一部：佛出世——佛教从一个人的觉悟开始]
= 第一章　一个王子为什么离开王宫？
<第一章-一个王子为什么离开王宫>
#figure([
#box(image("chapters/../images/downloaded/born.jpg", width: 85.0%))
], caption: figure.caption(
position: bottom, 
[
悉达多·乔达摩王子的诞生
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


清晨的迦毗罗卫城，城门缓缓开启。

车轮驶过平整的道路，年轻的太子第一次认真望向王宫之外的世界。那里没有宫廷里的歌舞，也没有为他精心布置的花园。他看到一个白发苍苍、弯腰驼背的老人，步履迟缓，仿佛每向前迈出一步，都要用尽全身的力气。

太子问身边的人：“他为什么会变成这样？”

侍从回答：“因为他老了。”

太子又问：“只是他会老，还是所有人都会老？”

侍从说：“所有人都不能免。”

后来，他又看见病人、死者和出家修行的沙门。

这就是佛教史上著名的“四门出游”。

故事中的年轻人，后来被世人称为释迦牟尼佛。但在那一刻，他还不是佛，只是一个突然发现人生并不像王宫里看起来那样安稳的年轻人。

他第一次意识到：财富可以买来舒适，却买不来永远的青春；权力可以命令人群，却不能命令身体不衰老；亲情能够给人温暖，却无法保证彼此永不分离。

于是，一个问题在他心中生起：

#strong[有没有一种道路，能使人从衰老、疾病与死亡的苦难中得到解脱？]

佛教，正是从这个问题开始的。

#horizontalrule

== 一、佛陀诞生在怎样的时代？
<一佛陀诞生在怎样的时代>
释迦牟尼生活的年代，学界一般推定在公元前五世纪前后。他出生于释迦族，活动区域大致位于今天印度与尼泊尔交界一带。佛教传统称他的父亲为净饭王，称他为“悉达多太子”；从现代历史研究来看，释迦族更可能是一个由贵族家族共同治理的小型部族政体，而不是拥有辽阔疆域的大帝国。因此，书中所说的“王子”，更接近部族首领或显贵家族之子。

不过，无论是宏伟王宫中的王子，还是小国贵族家庭中的青年，有一点大体可以确定：他出生于一个生活优裕、拥有一定社会地位的家庭。他并不是因为贫困而离家，也不是因为在人生竞争中失败才选择修行。恰恰相反，他所放下的，正是当时许多人梦寐以求的生活。

这使他的出走显得更加耐人寻味。

当时的印度，正处在思想活跃而剧烈变动的时代。

在传统的婆罗门文化中，《吠陀》被视为具有神圣权威，祭祀由婆罗门祭司主持，社会身份也常以出生的族类来划分。印顺法师曾将婆罗门传统的主要特征概括为“吠陀天启、婆罗门至上、祭祀万能”。但在恒河流域的东方地区，人们对这些传统权威并非全盘接受，新的政治力量、新的生活方式和新的思想不断出现。

在婆罗门传统之外，还有一群被称为“沙门”的修行者。

“沙门”并不是佛教僧人的专称。早期印度那些离开家庭、过着游行乞食生活、通过苦行、禅定或哲学思辨寻求解脱的人，都可以被称为沙门。佛教、耆那教以及许多后来消失的思想派别，都产生于这股沙门思潮之中。

有人认为命运由过去的行为决定，有人主张极端苦行可以洗净罪业；有人相信灵魂永恒，有人否认死后世界；也有人认为，人生既没有目的，善恶也没有真正的果报。

各种思想彼此争论，都试图回答同一个问题：

#strong[人为什么受苦？人能不能从生老病死之中获得解脱？]

悉达多太子的出家，并不是在一个没有宗教思想的世界中突然发生的奇迹。他进入的，正是这个已经持续许久的求道传统。

不同之处在于，他后来既未归入婆罗门的祭祀传统，也未停留于当时盛行的极端苦行，而是另辟蹊径------在放纵与禁欲之间，在永恒灵魂与彻底虚无之间，走出了一条被后世称为”中道”的新路。

#horizontalrule

== 二、王宫为什么留不住他？
<二王宫为什么留不住他>
后世佛传把悉达多的青年生活描绘得十分优越。

相传，他的父亲净饭王担心儿子出家，便尽力为他营造一个没有忧愁的世界。宫殿中四季舒适，园林里花木繁盛，年轻的侍从环绕左右。凡是衰老、疾病、死亡以及贫困的景象，都被有意挡在王宫之外。

净饭王希望儿子相信：人生就是青春、享乐、家庭和权力。

然而，一个被精心保护的世界，并不等于真实的世界。

佛教早期经典保存了许多佛陀说法和修行的内容，却没有留下一部从出生到涅槃的完整传记。今天人们熟悉的许多佛传故事，是在后来不同经典和传记中逐渐形成的。“四门出游”的完整故事，主要见于《过去现在因果经》《佛所行赞》《佛本行集经》等佛传文献。因此，我们不必把故事中的每一个细节------从哪一道城门出去、遇见的人是否由天神变化而成------都当作可以逐日核对的历史记录。

但是，这并不意味着故事没有价值。

佛传并不只是要告诉读者“某年某月发生了什么”，更是借由一个具体场景，表现佛陀为什么走上求道之路。

王宫象征着人们为自己营造的安全感；四门之外，则是真实而无法回避的人生。

每个人或许都有自己的“王宫”。

它可能是财富，可能是年轻，可能是一份稳定的工作，也可能是一个看似不会改变的家庭。我们知道世间存在衰老、疾病和死亡，却常常觉得那是别人的事，是很久以后才需要面对的事。

直到某一天，我们亲眼看到亲人病倒，看到熟悉的人突然离世，或者在镜子中发现自己已经不再年轻，王宫的城门才真正打开。

#horizontalrule

== 三、第一道门：每个人都会老
<三第一道门每个人都会老>
太子第一次出游时，看见一位老人。

《过去现在因果经》中的太子没有仅仅问：“这个人怎么了？”他更关心的是：“唯此人老？一切皆然？”

侍从回答：“一切皆悉应当如此。”

太子于是感叹：“老至如电，身安足恃！”

真正震动他的，不只是老人衰弱的样子，而是他突然发现：老人和自己并不是两类人。

老人不是一种与青年无关的特殊人群，而是青年继续生活下去以后可能成为的样子。

人在年轻时，很容易把青春当成自己的属性，仿佛“年轻”就是“我”。可是青春并不是一个可以永久拥有的东西。它依赖身体、饮食、环境和时间等许多条件，只能暂时存在。

佛教把这种不断变化、不能永远保持原状的性质称为“无常”。

无常并不只是说，一个杯子会打碎，一朵花会凋谢。它所指向的是：凡由各种条件形成的事物，都处在变化过程中。

身体如此，情绪如此，关系如此，社会地位也是如此。

我们并不是有一天突然开始衰老。从出生的那一刻起，身体便一直在变化。儿童变成少年，少年变成青年，青年又在不知不觉中走向中年和老年。因为变化缓慢，人们便误以为自己始终没有改变；等到改变明显时，又常常感到惊讶和抗拒。

太子看见老人时，看见的不只是生命的终点，也看见了生命每时每刻都在发生的变化。

#horizontalrule

== 四、第二道门：疾病不分贵贱
<四第二道门疾病不分贵贱>
第二次出游，太子看见一个病人。

那人身体消瘦，呼吸急促，无法自在地站立行走。太子再次问道：只有这个人才会生病，还是所有人都有可能如此？

侍从回答：“一切人民，无有贵贱，同有此病。”

王子的身份可以使他得到更好的饮食和照料，却不能使他彻底免于疾病。

这对一个从小生活在保护之中的人来说，是一种更深的冲击。

我们平时常把身体当作理所当然的工具。眼睛可以看，双腿可以走，夜晚能够入睡，吃下的食物可以消化，这一切似乎不值得特别注意。只有身体出现问题时，人们才发现，许多平凡的能力原来都依赖复杂而脆弱的条件。

疾病让人看见身体并不完全服从我们的意志。

我们可以努力锻炼、注意饮食、接受治疗，却不能命令身体永远健康。承认这一点，并不是否定医疗和努力，而是放下“只要我足够谨慎，就能完全控制一切”的幻想。

佛教所说的“苦”，也由此显现出来。

这里的苦，不只是身体疼痛。它还包括一种更普遍的不安稳：我们依赖许多事物生活，却无法保证这些事物永远按照自己的愿望存在。

健康的时候，担心失去健康；得到喜爱之物以后，又害怕它发生变化。越想牢牢控制，内心反而越容易焦虑。

这就是“苦”的一层含义。

#horizontalrule

== 五、第三道门：死亡不是别人的事情
<五第三道门死亡不是别人的事情>
第三次出游时，太子看见一队送葬的人。

亲属围绕着死者哭泣，那个曾经能够说话、行走、欢笑的人，此刻再也不能回应他们。

太子仍然问了同样的问题：只是这个人会死，还是所有人最终都会如此？

侍从回答：“一切世人，皆应如此，无有贵贱而得免脱。”

衰老和疾病有时还能被拖延，死亡却是生命无法绕开的界限。

人们知道自己终有一死，却很少真正按照这一事实生活。我们制订多年的计划，为许多细小的得失争执，仿佛时间可以无限延长。死亡似乎是一个遥远的概念，直到它突然出现在身边。

佛教谈死亡，并不是为了制造恐惧。

恰恰相反，只有正视生命有限，人才能知道什么真正重要。

如果生命没有终点，我们或许永远不会珍惜一次见面，也不会急于说出道歉和感谢。正因为时间有限，人与人的相遇才显得珍贵；也正因为所有占有最终都要放下，我们才需要思考：除了不断获得和占有，人生是否还有更值得追求的东西？

太子看见死亡以后，无法再像从前那样回到歌舞之中。

他开始明白，即使有一天继承权力，拥有更多土地和财富，也无法解决这个根本问题。

倘若生老病死是每一个生命无从绕开的归宿，那人所苦心经营的幸福，是否只是一种精巧的遗忘------用短暂的明亮，遮住那始终在场的黑暗？

#horizontalrule

== 六、第四道门：在无常之中，有没有出路？
<六第四道门在无常之中有没有出路>
如果故事只停在老、病、死，佛教确实容易显得灰暗。

但太子还看见了第四个人。

那是一位沙门。他衣着朴素，没有财产，也没有宫廷中的显贵身份，神情却安静而从容。

在《佛所行赞》中，这位沙门说自己因为看见众生受老病死逼迫，所以“出家求解脱”。

这一次，太子看到的不再只是人生的问题，也看到了一种可能的方向。

沙门的形象告诉他：一个人可以不再用享乐遮蔽无常，也不必只是被动等待衰老和死亡。他可以主动观察生命，训练自己的心，寻找痛苦产生的原因以及止息痛苦的方法。

《过去现在因果经》用一句话概括了太子的感受：

“我先见有老病死苦……今见比丘，示解脱路。”

前三次出游使他看见人生的困境，第四次出游则使他相信，困境也许并非没有答案。

这正是“四门出游”故事最重要的结构。

老人、病人和死者并不代表佛教的全部。沙门的出现说明，佛教并不满足于告诉人们“人生很苦”，而是进一步追问：

苦从哪里产生？

人为什么明知一切会变，仍然执着它永远不变？

当外在事物不能完全由我们控制时，内心是否可以获得某种自由？

这条道路是否能够被普通人学习和实践？

这些问题，后来成为佛陀一生教法的起点。

#horizontalrule

== 七、寂天菩萨的终极之问
<七寂天菩萨的终极之问>
公元八世纪，印度佛学家寂天菩萨在其所造《入菩萨行论》中写下这样两颂：

#quote(block: true)[
临终弥留际，众亲虽围绕， 命绝诸苦痛，唯吾一人受。

魔使来执时，亲朋有何益？ 唯福能救护，然我未曾修。
]

这四句出自《入菩萨行论·忏悔罪业品》，在大乘修学传统中被视为警策世人的金言。

它所描绘的，是死亡来临那一刻最真实的景象：亲人的手可以握住你的手，却无法握住你的痛苦；爱你的人可以守在床边，却无法替你经历那场身心崩解。临终时四大分离之苦，是每一个人必须独自承担的。

寂天菩萨并非在渲染恐惧，而是在勘破一种幻觉：我们最依赖的那些东西，在最关键的关口，究竟能给予我们什么？

索达吉堪布在讲解这两颂时指出，此处”魔使”并非神话中的形象，而是业力成熟时死亡的自然显现。凡夫之所以在临终时感到极度怖畏，往往正是因为：一生之中，我们把精力尽数用于维护那些终将失去的事物------财富、地位、亲情的依傍------却疏于在内心建立真正堪能依靠的力量。"唯福能救护"，是说唯有平生所修的善业与正法，才是此刻真正能陪伴自己的东西。

观修死亡的目的，不是让人陷入绝望或虚无，而是借助对死亡的清醒认识，回过头来重新审视生命的轻重缓急。当一个人真正意识到”死时唯法有用”，他自然会减少对名利得失的执取，转而思考：在有限的时间里，什么样的生活才是值得过的？

#horizontalrule

== 八、佛教说”苦”，是不是盲目悲观？
<八佛教说苦是不是盲目悲观>
有人听见佛教谈生老病死，便以为佛教只看到人生阴暗的一面。生活中明明有美食、爱情、亲情、艺术和成功，为什么佛教总是在说”苦”？

佛教并不否认快乐。

《杂阿含经》中，佛陀明确承认人生有三种感受：苦受、乐受、不苦不乐受。他从未说“世间没有快乐”，他所提醒的是：这些快乐都有条件，也都会变化。如果把暂时的快乐当作永远不会改变的保障，快乐本身便可能成为新的忧虑。

因此，“苦”并不是说人生每一秒都在疼痛，而是说：凡是依赖条件的事物，都不足以提供永远不变、完全由自己掌控的满足。

这更接近一种诊断，而不是一种情绪。

佛陀曾以医者自比。《增一阿含经》中有这样的表述：如来犹如良医，知病、知病因、知病愈、知治病之道。医生指出一个人患病，并不是因为医生悲观，而是因为只有看见病，才可能治疗。如果医生为了让病人开心，坚持说“一切都很好”，反而是不负责任。

同样，佛教谈苦，是为了寻找苦的原因和止息之道。

这正是四圣谛的内在逻辑：苦谛指出苦的存在，集谛追问苦的原因，灭谛确认苦是可以止息的，道谛则指出通往止息的道路。

#quote(block: true)[
此苦圣谛，当知；此苦集圣谛，当断；此苦灭圣谛，当证；此苦灭道圣谛，当修。

------《转法轮经》（佛陀初转法轮时的教导）
]

四圣谛的结构，不是一篇绝望宣言，而是一份完整的问题与解答：既诊断，也开方。

佛教不是从“人生有苦”得出“人生没有希望”，而是从“人生有苦”继续追问“苦能否止息”。

悲观的人看见黑暗，便认为没有出路；盲目乐观的人拒绝承认黑暗；佛教所采取的态度，是看清黑暗，同时寻找可以走出去的道路。

所以，佛教既不是悲观，也不是用美好想象掩盖现实。

它更接近一种清醒的希望。

#horizontalrule

== 九、一个王子为什么离开王宫？
<九一个王子为什么离开王宫>
现在，我们可以回到本章最初的问题。

悉达多为什么离开王宫？

不是因为王宫里没有快乐，也不是因为他憎恨自己的家人。

按照佛教传统的解释，他所面对的是一个无法由个人幸福解决的问题：即使自己能够暂时生活安乐，父母、妻子、孩子以及世间所有人，仍然无法避免老、病、死。

从现代人的家庭伦理来看，一个人在妻儿尚在时离家求道，难免令人感到不解，甚至不安。我们不必假装这种张力不存在。佛传对这一选择的解释是：悉达多并非为了逃避生活，而是试图寻找一种超越个人和家庭范围的解脱之道。后来佛教也把他的出家理解为从对少数亲人的爱，走向对一切众生的慈悲。

这种解释是否能够完全消除现代读者的疑问，可以继续讨论。

但至少有一点值得注意：悉达多并没有在离开以后寻找另一种享乐。他先后跟随老师学习禅定，又经历多年极端苦行，几乎付出了生命。直到后来，他才发现纵欲不能带来自由，自我折磨同样不能带来自由。

因此，他的离开不是故事的答案，只是求道的开始。

四门之外，他看见了人生的真相；王宫之内，他无法找到解决的方法。于是，他选择亲自去寻找。

当时的他并不知道，自己是否真的能够成功。

他只是无法再假装没有看见。

这也许正是释迦牟尼最初打动人的地方。他不是生来便坐在莲花座上的神明，而是一个看见人生困境以后，不愿继续逃避的人。

佛教从一个人的觉悟开始。

而觉悟的第一步，不是看见神迹，也不是获得某种神秘力量。

只是诚实地承认：

我会衰老。

我可能生病。

我终有一天会死。

我所爱的人，也不能永远陪伴我。

但在这一切之中，我是否能够学会不被恐惧支配？是否能够活得更加清醒、慈悲而自由？

带着这个问题，悉达多走出了王宫。

在下一章中，他将进入森林，拜访当时著名的修行者，尝试严酷的苦行，并最终发现：通向觉悟的道路，既不在纵情享乐的一端，也不在折磨身体的另一端。

那条道路，后来被称为“中道”。

#horizontalrule

== 佛教常识：悉达多、释迦牟尼和佛陀是同一个人吗？
<佛教常识悉达多释迦牟尼和佛陀是同一个人吗>
传统上，这三个名称指向同一个人，但含义不同。

#strong[悉达多]，是佛传中太子的名字，常被解释为“目的已经达成”或“一切义成”。

#strong[乔达摩]，是他的族姓或氏族名称，因此也常称“乔达摩·悉达多”。

#strong[释迦牟尼]，意思是“释迦族的圣者”。“牟尼”有沉默者、圣者之意。

#strong[佛陀]不是姓名，而是称号，意思是“觉悟者”。悉达多在菩提树下成道以后，才被称为佛陀。

因此，在出家和成道以前，本书主要称他为“悉达多太子”；成道以后，则称“释迦牟尼佛”或“佛陀”。

#horizontalrule

== 经典原文选读
<经典原文选读>
#quote(block: true)[
“诸行无常，是生灭法；生灭灭已，寂灭为乐。” ------《大般涅槃经》
]

这里的“行”，泛指由各种条件形成、处在迁流变化中的事物。“诸行无常”并不是说一切都不存在，而是说一切有条件的存在都不能永远保持原状。

无常使人失去，也使新的可能得以发生。理解无常的目的，不是增加悲伤，而是不再把短暂之物误认为永恒。

#figure([
#box(image("chapters/../images/downloaded/ch01_departure.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
犍陀罗艺术中的《大出离》浮雕（2-3世纪），巴基斯坦拉合尔博物馆藏
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


= 第二章　菩提树下，佛陀看见了什么？
<第二章-菩提树下佛陀看见了什么>
#figure([
#box(image("chapters/../images/downloaded/puti.jpg", width: 85.0%))
], caption: figure.caption(
position: bottom, 
[
菩提树下悟道成佛
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


== 从苦行到觉悟
<从苦行到觉悟>
夜色沉入尼连禅河畔。

一棵枝叶舒展的毕钵罗树下，一个消瘦的修行者结跏而坐。远处的村落渐渐安静，河水在黑暗中缓缓流过。没有王宫里的乐声，没有侍从，也没有曾经追随他的五位苦行伙伴。此时的悉达多，只剩下一具刚刚从极度虚弱中恢复的身体，以及一个仍未得到答案的问题：

人为什么会老、会病、会死？为什么明知一切终将失去，人仍会执着、恐惧、彼此伤害？这一切痛苦，究竟从哪里生起？有没有可能真正止息？

佛教传统认为，悉达多就是在这棵树下彻底觉悟，从此被称为“佛陀”------觉悟的人。这个地方后来被称为菩提伽耶，今天的摩诃菩提寺便坐落于此；寺院旁的菩提树，相传由当年那棵树的枝条扦插重植而来。

然而，菩提树下的觉悟并不是凭空发生的。

在这一个夜晚之前，他已经走过一条漫长而几乎把自己逼到死亡边缘的道路。

== 一、苦行为什么没有带来答案？
<一苦行为什么没有带来答案>
离开王宫之后，悉达多曾先后向当时著名的修行者求学。

早期经典记载，他学习并进入了极深的禅定境界。当他的老师认为他已经达到与自己相同的成就，甚至邀请他共同教导弟子时，悉达多却没有留下。

因为他发现，即使进入非常宁静、非常微细的禅定，老病死的问题仍没有从根本上解决。禅定可以使心暂时平静，却不等于烦恼已经永远止息。一旦从定中出来，生命依旧受无常支配，贪爱与执着仍有可能重新生起。

于是，他转向当时另一条广受尊敬的道路------苦行。

在古印度的沙门传统中，不少修行者相信，人的精神被肉体和欲望束缚。只要严厉折磨身体，削弱感官，烧尽过去所造的业，就有可能使灵魂获得自由。悉达多将这种修行推到了极致。

经典中描述，他曾长时间屏住呼吸，忍受剧烈痛苦；又把食物减少到极少，身体因此瘦弱得几乎不成人形。腹部紧贴脊背，四肢如同枯藤，眼窝深陷，皮肤失去光泽。人们远远看见他，甚至分辨不出他究竟是活着还是已经死去。

可是，身体越虚弱，智慧并没有因此变得更加清明。

他终于意识到：如果享乐不能使人解脱，那么折磨自己同样不能。把身体看成敌人，用痛苦惩罚身体，并没有触及无明与贪爱的根源。极端苦行带来的，可能只是另一种执着------执着于“我比别人更能忍受”“我修得比别人更苦”，甚至把痛苦本身误认为清净。

早期经典以佛陀自述的方式保存了这一段经历：他尝试过当时最严厉的苦行，却发现这条路不能导向最终的觉悟，于是重新进食，使身体恢复力量，转向一种既不沉溺欲乐，也不摧残身心的修行道路。

这不是退缩，而是一次极其困难的承认：

曾经坚信的道路，可能是错的。

真正的求道者，不是无论如何都要证明自己正确，而是在发现错误时，有勇气放下已经付出的时间、名声和痛苦，重新开始。

== 二、一碗乳糜：放弃的不是修行，而是执着
<二一碗乳糜放弃的不是修行而是执着>
后世佛传用一个温暖的故事，表现悉达多生命中的这一转折。

尼连禅河附近的一位女子，看见虚弱的悉达多，向他供养了一碗乳糜。不同佛传对供养者的姓名和具体经过记载略有差异，但“一位女子供养乳糜，菩1. #strong[无明] (#emph[Avidyā])：对生命“无常、因缘、无我”真相的无知与执着，是一切烦恼的源头。在日常中，表现为对事物的本质产生误判，误以为外物能带给自己恒常的满足。 2. #strong[行] (#emph[Saṃskāra])（缘于 #strong[无明] 而产生）：基于无明而产生的意志行为与造作（业），形成潜在的行为惯性。在日常中，表现为带着“我要得到它”的意图，开始在心中谋划并付出行动。 3. #strong[识] (#emph[Vijñāna])（缘于 #strong[行] 而产生）：分别与认知的精神主体（业识），在生死流转中携带业力惯性。在日常中，表现为行为留下的印记形成了惯性认知，潜意识里产生了自我分别的意识。 4. #strong[名色] (#emph[Nāmarūpa])（缘于 #strong[识] 而产生）：精神（名，如受、想、行）与物质（色，如肉体）的身心结合体。在日常中，表现为身心初步发育，精神世界与生理结构开始结合。 5. #strong[六入] (#emph[Ṣaḍāyatana])（缘于 #strong[名色] 而产生）：眼、耳、鼻、舌、身、意六种认识世界、接收信息的感官与思维器官。在日常中，表现为视觉、听觉等感官及思维器官发育成熟。 6. #strong[触] (#emph[Sparśa])（缘于 #strong[六入] 而产生）：感官（根）、外界（境）与心识（识）三者结合的接触。在日常中，表现为眼睛看见花朵、耳朵听到音乐、身体接触外界等感官活动。 7. #strong[受] (#emph[Vedanā])（缘于 #strong[触] 而产生）：接触外境后产生的身心感受（如痛苦的苦受、快乐的乐受、或平淡的不苦不乐受）。在日常中，表现为听到表扬感到喜悦，听到批评感到难受。 8. #strong[爱] (#emph[Tṛṣṇā])（缘于 #strong[受] 而产生）：对乐受产生的强烈贪爱与渴望，或对苦受产生的嗔恨与抗拒。在日常中，表现为极力想留住喜悦，极力想摆脱被批评的难受。 9. #strong[取] (#emph[Upādāna])（缘于 #strong[爱] 而产生）：由强烈的渴爱付诸实际行动，去追求、执着与占有。在日常中，表现为认定“我必须每次都得第一”、“他必须听我的”，开始在言行上抓取和占有。 10. #strong[有] (#emph[Bhava])（缘于 #strong[取] 而产生）：因执取造作而形成的生命存在状态，积聚了决定未来走向的业力潜能。在日常中，表现为执念在心中生根，形成了一种牢固的人格特质和行为惯性。 11. #strong[生] (#emph[Jāti])（缘于 #strong[有] 而产生）：新的生命形态在特定的生存环境下开始诞生。在日常中，表现为因业力惯性的牵引，在新的时空或状态中重新开始了一段身心历程。 12. #strong[老死] (#emph[Jarāmaraṇa])（缘于 #strong[生] 而产生）：凡生者必将经历的衰老、病痛、死亡以及忧悲苦恼。在日常中，表现为随着时间推移，一切拥有的事物、身体状态以及关系不可避免地走向变化与坏灭。

这些名词初看十分艰深，其实所说的仍是每个人都在经历的生命过程。是以清醒而坚定的心，面对自己生命中最深的疑问。

== 三、菩提树下：魔王究竟是谁？
<三菩提树下魔王究竟是谁>
就在悉达多即将觉悟的时候，佛传中的魔王波旬出现了。

在传统叙事中，波旬担心悉达多成佛之后，众生将不再受欲望和死亡支配，于是率领魔军来到菩提树下。有的经典描述风暴、兵器和恐怖的魔众，有的佛传又说魔王派遣女儿，以美色和欲乐动摇他的心。

魔王质问悉达多：你凭什么坐在这里？谁能证明你有资格获得觉悟？

悉达多没有争辩，只是伸出右手，触摸大地。

大地于是为他过去无数的善行与修持作证。魔军溃散，波旬退去。这便是佛像中常见的“触地印”，也称“降魔印”。佛传典籍长期保存并发展了菩提树下降伏魔军的故事。

这个故事应当怎样理解？

从佛教传统的信仰世界来看，波旬是欲界之魔，是阻碍众生出离生死的力量。但从修行的角度看，魔王也可以被理解为人心中的贪欲、恐惧、怀疑、傲慢与自我执着。

魔军不一定总以可怕的面目出现。

它有时是一个诱人的念头：“只要得到更多，你就会安心。”

有时是一种恐惧：“放下这些，你将一无所有。”

有时是一种自我怀疑：“别人都做不到，你又凭什么能够做到？”

有时甚至是修行者自己的骄傲：“我已经比别人清净，我已经接近圣人。”

这些力量共同守护着我们熟悉的旧生活。即使那个生活充满烦恼，人也常常宁愿留在熟悉的痛苦里，而不愿走向未知的自由。

因此，降魔并不只是战胜外面的敌人。更深的降魔，是看清心中的欲望与恐惧，却不再跟随它们。

悉达多没有拿起武器与魔王搏斗，也没有请求更强大的神灵保护自己。他只是保持觉察，不逃避，也不被动摇。

魔境依旧出现，心却不再被魔境牵走。

== 四、佛陀“看见”的，是缘起
<四佛陀看见的是缘起>
那么，在那个漫长的夜晚，悉达多究竟看见了什么？

经典对此有不同的表达。

《大萨遮迦经》等早期经典以“三明”说明成道的过程：他在初夜忆念过去的生命；中夜观察众生随自己的行为而流转；后夜则彻底明白烦恼如何生起，并断尽使生命继续流转的根本烦恼。

《阿含经》中的许多经文，则以“缘起”来说明佛陀所觉悟的真理。

所谓缘起，就是：

#quote(block: true)[
此有故彼有，此生故彼生；此无故彼无，此灭故彼灭。
]

这几句话看似简单，却是理解佛教的一把钥匙。

它的意思是：任何事物都不是孤立产生的。某些条件存在，某种现象便随之生起；当这些条件改变或消失，相应的现象也会改变或止息。《杂阿含经》以这组公式说明无明、行为、认识、贪爱、执取、生与老死之间的相互关系。

佛陀没有在菩提树下发现一位安排众生命运的主宰，也不是得到一句只能由他掌握的神秘咒语。他所觉悟的，是生命依条件而生起的规律。

《杂阿含经》甚至说，无论佛陀是否出现在世间，缘起的法则本来如此；如来只是自己觉悟了这一规律，再将它开示出来。

这就像在黑暗的房间里点亮一盏灯。

灯没有创造桌椅，也没有改变房间，只是让原本存在却看不清的事物显现出来。佛陀的觉悟，也不是创造一种新的宇宙秩序，而是如实看见生命本来的运行方式。

我们通常认为，自己的痛苦是某一个人、某一件事单独造成的。

考试失败，所以痛苦；失去工作，所以痛苦；别人不理解自己，所以痛苦；身体衰老，所以痛苦。

佛陀所看见的却更深一层。

同一件事情发生在不同的人身上，痛苦的程度并不相同。因为事情只是条件之一，在事情之外，还有我们的期待、记忆、判断、习惯、欲望和执着。外在事件与内在反应相互结合，才形成完整的苦。

一句批评传入耳中，只是“接触”；心里觉得不舒服，是“感受”；希望这种不舒服马上消失，或希望对方承认错误，是“爱”；认定“他在侮辱我”“我绝不能输”，是“取”。随着执取不断加深，愤怒、争吵与新的伤害便继续产生。

痛苦并不是无缘无故出现的。

它有形成的条件。

也正因为它由条件形成，所以它并非永远不能改变。

== 五、十二因缘：苦是怎样一环扣一环的？
<五十二因缘苦是怎样一环扣一环的>
佛教常用十二个环节说明生命流转与痛苦形成的过程，这就是“十二因缘”：

+ #strong[无明] (#emph[Avidya], 无明)：对生命「无常、因缘、无我」真相的无知与执着，是一切烦恼的源头。在日常中，表现为对事物的本质产生误判，误以为外物能带给自己恒常的满足。
+ #strong[行] (#emph[Samskara])（缘于#strong[无明]而产生）：基于无明而产生的意志行为与造作（业），形成潜在的行为惯性。在日常中，表现为带着「我要得到它」的意图，开始在心中谋划并付出行动。
+ #strong[识] (#emph[Vijnana])（缘于#strong[行]而产生）：分别与认知的精神主体（业识），在生死流转中携带业力惯性。在日常中，表现为行为留下的印记形成了惯性认知，潜意识里产生了自我分别的意识。
+ #strong[名色] (#emph[Namarupa])（缘于#strong[识]而产生）：精神（名，如受、想、行）与物质（色，如肉体）的身心结合体。在日常中，表现为身心初步发育，精神世界与生理结构开始结合。
+ #strong[六入] (#emph[Sadayatana])（缘于#strong[名色]而产生）：眼、耳、鼻、舌、身、意六种认识世界、接收信息的感官与思维器官。在日常中，表现为视觉、听觉等感官及思维器官发育成熟。
+ #strong[触] (#emph[Sparsa])（缘于#strong[六入]而产生）：感官（根）、外界（境）与心识（识）三者结合的接触。在日常中，表现为眼睛看见花朵、耳朵听到音乐、身体接触外界等感官活动。
+ #strong[受] (#emph[Vedana])（缘于#strong[触]而产生）：接触外境后产生的身心感受（苦受、乐受或不苦不乐受）。在日常中，表现为听到表扬感到喜悦（乐受），听到批评感到难受（苦受）。
+ #strong[爱] (#emph[Trsna])（缘于#strong[受]而产生）：对乐受产生的强烈贪爱与渴望，或对苦受产生的嗔恨与抗拒。在日常中，表现为极力想留住喜悦，极力想摆脱被批评的难受。
+ #strong[取] (#emph[Upadana])（缘于#strong[爱]而产生）：由强烈的渴爱付诸实际行动，去追求、执着与占有。在日常中，表现为认定「我必须每次都得第一」、「他必须听我的」，开始在言行上抓取和占有。
+ #strong[有] (#emph[Bhava])（缘于#strong[取]而产生）：因执取造作而形成的生命存在状态，积聚了决定未来走向的业力潜能。在日常中，表现为执念在心中生根，形成了一种牢固的人格特质和行为惯性。
+ #strong[生] (#emph[Jati])（缘于#strong[有]而产生）：新的生命形态在特定的生存环境下开始诞生。在日常中，表现为因业力惯性的牵引，在新的时空或状态中重新开始了一段身心历程。
+ #strong[老死] (#emph[Jaramarana])（缘于#strong[生]而产生）：凡生者必将经历的衰老、病痛、死亡以及忧悲苦恼。在日常中，表现为随着时间推移，一切拥有的事物、身体状态以及关系不可避免地走向变化与坏灭。

十二因缘在传统佛教中常被用来说明过去、现在、未来三世的生命流转，也可以帮助我们观察当下一个烦恼如何形成。本书此处先从日常心念入手，并不是要取消因果轮回的传统解释，而是让普通读者先看见：缘起并非遥远的理论，它每一天都在我们的感受、欲望和选择中发生。

例如，一个人看到朋友取得成功。

最初只是眼睛看见一条消息，这是接触；心中产生不舒服的感觉，这是受；希望自己也得到同样的荣誉，这是爱；认定“我不能比他差”，这是取；接下来不断比较、嫉妒，甚至贬低对方，便形成新的言语与行为。

如果没有觉察，这条链条会迅速运转，我们便以为：“我就是很生气”“我天生爱嫉妒。”

但在觉察中，我们能够看见：愤怒和嫉妒不是一个固定不变的“我”，而是许多条件暂时组合的结果。

条件形成，它便生起；条件改变，它也能够止息。

这正是缘起教法最重要的希望。

缘起不是宿命论。

宿命论说，一切早已注定，人无能为力；缘起则说，一切依条件而形成，因此人的理解、选择和行动，本身也是能够改变结果的重要条件。

== 六、觉悟是不是一种神秘体验？
<六觉悟是不是一种神秘体验>
说到佛陀成道，人们很容易把“觉悟”想象成一种耀眼而神奇的体验。

仿佛在某个瞬间，天空放光，大地震动，修行者突然得到宇宙全部秘密，从此拥有无所不能的力量。

佛教经典中确实有光明、震动、天人赞叹等庄严描写。这些叙事表达了佛陀觉悟在宗教传统中的伟大意义，不必草率地将它们贬低为虚构。但如果只关注这些奇异景象，也可能错过觉悟最重要的内容。

觉悟之所以称为“觉”，就像一个人从梦中醒来。

梦里的人会把梦境当真，为得到而欢喜，为失去而恐惧；醒来之后，才发现自己过去一直被错误的认识支配。

佛陀所醒来的“大梦”，正是众生对自我和世界的执着。

我们把不断变化的身体看成永远属于“我”；把因缘聚合的关系看成绝不会改变；把暂时的快乐当成永久的依靠；又把一时的失败看成整个生命的结论。

觉悟并不是进入一个与现实隔绝的神秘世界，而是比过去更加清楚地看见现实。

看见无常，却不因此绝望；看见痛苦，却不再逃避；看见一切依条件生起，也就知道可以从条件入手，使痛苦逐渐止息。

印顺法师说：“佛法是理智的宗教，不仅是信仰的。”佛教当然重视亲身体验，但这种体验并不排斥观察、理解和检验。真正的智慧不是一阵令人陶醉的感觉，而是对生命产生持久的改变：贪欲是否减少，嗔恨是否减轻，面对得失时是否更加清醒，对其他生命是否生起更多慈悲。

有些特殊体验可能令人感动，却不一定代表觉悟。

看见光影、听到声音、感到身体消失，甚至进入极深的宁静，都可能只是禅修过程中的身心现象。悉达多自己早已达到很深的禅定，却没有把禅定境界当作最终解脱。

判断觉悟的标准，不在于体验有多奇异，而在于无明与执着是否真正被照破。

== 七、天亮以后，一个“佛陀”出现了
<七天亮以后一个佛陀出现了>
黎明将近，黑暗渐渐退去。

坐在树下的悉达多，仍然是那个出生于释迦族、曾经离开王宫、经历多年求道的人。但从这一刻起，他又不再只是从前的悉达多。

“佛陀”不是他的姓名，而是对觉悟者的称呼。

他已经看清：生命的痛苦并非来自某个不可改变的诅咒，而是由无明、贪爱和执取等条件不断推动；当这些条件止息，痛苦的相续也能够止息。

他找到了自己多年追寻的答案。

然而，一个新的问题随之出现。

如此深细的道理，人们能够听懂吗？

世人习惯追逐欲望，也习惯把自己相信的一切当成真实。缘起之法不顺从人的贪求，也不满足人对简单答案的期待。佛陀一度倾向于保持沉默，因为他所觉悟的法甚深、难见，不容易用语言表达。

但如果他始终坐在菩提树下，佛教便不会出现。

最终，他还是决定起身，走向人群。

他想起了曾经陪伴自己苦行的五个人。虽然他们误以为他已经放弃修行，但他们认真求道，也许最有可能理解这条新发现的道路。

于是，佛陀离开菩提树，向鹿野苑走去。

在那里，他将第一次公开讲说自己所觉悟的道理。

佛教的第一次法轮，即将转动。

= 第三章　鹿野苑初转法轮
<第三章-鹿野苑初转法轮>
#figure([
#box(image("chapters/../images/downloaded/ch03_first_sermon.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
萨尔纳特（鹿野苑）出土的初转法轮佛陀像（5世纪，笈多王朝），萨尔纳特考古博物馆藏
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


菩提树下的觉悟，最初只是一个人的觉悟。

如果释迦牟尼佛选择沉默，那么世间或许只会多一位远离烦恼的圣者，却不会由此产生延续两千多年的佛教。佛法真正进入人间，是从佛陀离开菩提树，走向愿意倾听的人开始的。

他首先想到的，是过去曾经教导过自己的两位禅定老师。然而依照佛教经典的记载，两人都已经去世。随后，他想起了曾陪伴自己苦行的五位修行者：憍陈如、跋提、跋波、摩诃男和阿说示。不同汉译中的人名写法略有差异，但基本对应同一组五人。他们当时住在波罗奈附近的鹿野苑。

于是，佛陀起身上路。

这一次，他不再寻找老师，而是准备成为别人的老师；不再追问谁能告诉自己真理，而是准备把自己亲证的道路告诉世人。

== 一、五位旧友为什么不愿迎接佛陀？
<一五位旧友为什么不愿迎接佛陀>
鹿野苑位于古代波罗奈附近。波罗奈是当时印度北方的重要城市，而鹿野苑是一片较为清静的林地，鹿群在这里活动，也有许多出家修行者居住。后来佛教传统常把这里称作“仙人住处鹿野苑”或“仙人堕处鹿野苑”。

五位修行者曾经陪伴悉达多太子修习苦行。

他们亲眼见过他每日只吃极少食物，见过他的身体日渐消瘦，也相信只有把身体逼到极限，才能战胜欲望、获得解脱。可是后来，悉达多接受了食物，恢复体力，放弃了极端苦行。

在五人看来，这不是找到了新道路，而是退缩了。

经典记载，当他们远远看见佛陀走来时，曾彼此约定：这个人已经放弃精进、重新贪图安逸，不必起身迎接，也不必替他接取衣钵。可是当佛陀真正走到面前时，他们原先的约定却没有完全坚持下去：有人起身，有人接过衣钵，有人为他安置座位。

这是一个很有意味的场景。

五个人并不是第一次见到悉达多。他们熟悉他的声音、性格和过去，也正因为熟悉，才更加怀疑：一个曾经放弃苦行的人，凭什么宣称自己已经找到解脱之道？

佛陀没有要求他们因为自己的身份而相信，也没有诉诸神迹迫使他们屈服。他只是告诉他们：自己并不是因为贪图享受才离开苦行，而是已经发现，极端苦行同样不能使人觉悟。

随后，他开始讲述自己所发现的道路。

佛教传统把这次说法称为初转法轮。

“转法轮”不是说真的有一个轮子在林中转动。轮，意味着一种具有力量、能够前进的事物；法轮转动，意味着觉悟不再只停留在佛陀心中，而是被说出、被听见，并开始在人间传播。经典称这是一种无人能够使之倒转的法轮。

== 二、佛陀说的第一件事：不要走向两个极端
<二佛陀说的第一件事不要走向两个极端>
佛陀面对五比丘，首先没有谈宇宙从哪里来，也没有解释世界由谁创造。

他从修行者切身经历过的两个极端说起。

一个极端，是沉迷欲望和感官享受，把快乐建立在不断获得、占有和刺激之上；另一个极端，是折磨身体，认为痛苦本身能够净化心灵。

佛陀指出，这两条路都不能带来真正的解脱。

前者使人越来越依赖外在满足：得到时害怕失去，得不到时焦躁不安，即使暂时满足，也会迅速产生新的欲求。后者则误以为身体越痛苦，心就越清净，却可能使人衰弱、执著，甚至把忍受痛苦本身当成修行成就。

#strong[《佛说转法轮经》]用一句很简洁的话概括佛陀的发现：

“从两边度，自致泥洹。”

也就是说，超越两个极端，才可能走向涅槃。

这条既不纵欲、也不自我折磨的道路，就是中道。

但中道不是在享乐与苦行之间取一个算术平均数，也不是凡事各退一步、谁也不得罪。它不是“稍微贪一点，也稍微苦一点”，而是看清两种极端为什么都不能解决问题，然后找到真正有效的道路。

佛陀紧接着说明：中道并不是一句抽象口号，它有非常明确的内容，就是八正道------正见、正思惟、正语、正业、正命、正精进、正念和正定。早期经典把它称为能够通向寂静、觉悟与涅槃的道路。

由此可见，中道并不意味着漫无原则地折中。

它是一条有方向、有方法、也需要实践的道路。

== 三、四圣谛：佛教最基本的问题结构
<三四圣谛佛教最基本的问题结构>
讲明中道以后，佛陀进一步说出了四圣谛：

苦、集、灭、道。

在汉译#strong[《杂阿含经》]《佛说转法轮经》《佛说三转法轮经》以及巴利语《转法轮经》中，都保存了这一说法的相近版本。各部经典的文字和叙事细节并不完全相同，但中道、八正道与四圣谛构成了初转法轮的稳定核心。

“圣谛”的“谛”，是真实、真相的意思；“圣”，不是说它只属于少数神圣人物，而是说，这是觉悟者如实看见的真相，也是人可以通过修行亲自验证的真相。

四圣谛并不是四条彼此孤立的教义，而是一个完整的问题解决过程：

苦谛，说明问题是什么； 集谛，寻找问题从哪里产生； 灭谛，说明问题能不能真正止息； 道谛，指出止息问题的具体方法。

古代佛教论典常用医生治病来说明四圣谛。#strong[《瑜伽师地论》]说：

“譬如重病、病因、病愈、良药。”

苦，如同病症；集，是致病的原因；灭，是疾病痊愈；道，则是治疗的方法。

这也显示出佛陀说法的一个重要特点：他不是先要求人接受一套关于世界的信念，而是先请人观察自己的生命。

你是否经历过不满、焦虑、衰老、失去与分离？

这些苦恼从哪里来？

它们是否可能止息？

如果能够止息，又该如何生活和训练自己的心？

佛教就是从这些问题展开的。

== 四、苦谛：承认人生有不能回避的缺憾
<四苦谛承认人生有不能回避的缺憾>
四圣谛的第一项是苦谛。

一听到“人生是苦”，很多人会立即觉得：佛教是不是把人生说得太灰暗了？生活中明明有亲情、有爱情、有成功、有美食，也有许多值得珍惜的快乐，为什么要说苦？

这种疑问非常自然。

佛教所说的“苦”，并不等于否认人生中一切快乐，也不是说人每时每刻都在疼痛。它所揭示的，是生命中存在一种无法依靠外在事物彻底消除的不圆满。

初转法轮的经典列举了生、老、病、死，也列举了怨憎会、爱别离、求不得，最后归结为“五取蕴苦”。

生，并不是说婴儿出生本身有罪，而是有生便意味着进入一个会变化、会衰老、会受伤的生命过程。

老，并不只是头发变白。它还意味着体力下降、记忆衰退，以及逐渐失去过去能够支配的身体。

病，使人突然发现，平日最熟悉的身体也并不完全听从自己。

死，则把一切尚未完成的计划、关系和身份置于终结面前。

除此之外，还有更日常的苦：

不喜欢的人偏偏经常遇到，是怨憎会； 所爱的人终究会分离，是爱别离； 付出许多却未必得到，是求不得。

即使一切暂时顺利，人也常常无法真正安心。拥有财富，会担心失去财富；获得地位，会担心被人取代；得到感情，会担心关系改变。快乐并不是不存在，而是不能永远按照我们的愿望停留。

因此，佛教说苦，不是为了把人推向绝望，而是拒绝用短暂的快乐遮盖生命的真实处境。

一个医生指出病情，并不是悲观；隐瞒病情，才可能使人失去治疗的机会。

同样，佛陀谈苦，不是宣布人生毫无希望，而是说：只有承认苦，才有可能寻找苦的原因；只有看清问题，改变才真正开始。

== 五、集谛：真正束缚人的，是内心不断抓取
<五集谛真正束缚人的是内心不断抓取>
苦从哪里来？

很多人首先想到外在条件：因为钱不够，因为别人不理解，因为环境不公平，因为身体不好。

这些当然都可能成为痛苦的条件。佛教并不否认贫穷、疾病、暴力和不公会给人造成真实伤害。但佛陀进一步追问：为什么有些痛苦在事情结束以后，仍然长久地留在心中？为什么拥有很多的人仍然焦虑？为什么一个欲望满足以后，新的欲望又立刻出现？

在集谛中，佛陀指出，苦的重要根源是“爱”，更准确地说，是渴爱。

这里的“爱”并不是通常所说的关怀、慈爱或亲情，而是一种强烈的抓取：

一定要得到； 一定不能失去； 事情必须照我的想法发生； 别人必须按照我的期待回应； 我必须永远维持某种身份和形象。

经典把渴爱概括为欲爱、有爱和无有爱。

欲爱，是对感官享受和外在满足的不断追逐。

有爱，是执著于“我要成为怎样的人”“我要永远保持怎样的状态”，希望自我与拥有的一切固定不变。

无有爱，则是对不喜欢的经验产生强烈排斥，希望它彻底消失，甚至希望通过毁掉一切来逃离痛苦。

渴爱的共同特点，是不能接受现实处在变化之中。

我们希望喜欢的人永远不变，希望身体永远健康，希望拥有的东西永远属于自己，希望别人永远认可自己。然而一切因缘形成的事物都在变化。当变化发生时，执著便与现实发生冲突，苦也由此产生。

这并不是说人不能有愿望。

想改善生活、照顾家人、完成事业，本身并不必然是烦恼。关键在于：愿望背后是否伴随着僵硬的抓取------如果事情没有如愿，我是否就彻底否定自己？如果别人离开，我是否认为人生从此失去全部意义？

佛教不是要求人停止生活，而是帮助人看清：愿望可以引导行动，执著却可能把人捆绑在结果上。

== 六、灭谛：苦并不是不可改变的命运
<六灭谛苦并不是不可改变的命运>
如果佛教只讲苦和苦因，它确实可能成为一种悲观主义。

但四圣谛并没有停在集谛。

第三项是灭谛。

佛陀说，渴爱可以被看见，也可以被放下；执著可以减弱，苦因可以止息。经典把苦灭描述为渴爱的离贪、止息、舍弃与解脱。

这里的“灭”，不是把身体消灭，也不是让一个人变得麻木、冷漠、什么都不在乎。

真正止息的，是贪欲对人的奴役，是瞋恨对心的灼烧，是无明造成的颠倒认识。

一个人仍然可以爱家人，但不再把家人当成自己的所有物；仍然可以努力工作，但不再把成败当作自我价值的全部；仍然会经历衰老与疾病，却不再因为“这一切不应该发生在我身上”而产生第二重折磨。

外在世界未必立刻改变，人与世界的关系却发生了根本变化。

佛教把这种贪、瞋、痴止息后的自在称为涅槃。

涅槃不是一个死后才能到达的神秘地方。至少从修行的意义上说，每一次不再被贪欲牵着走，每一次瞋恨升起而没有继续伤害别人，每一次在变化中放下控制，都是朝向苦灭迈出的一步。

灭谛的意义正在于：人并不注定永远成为情绪和欲望的囚徒。

== 七、道谛：知道方向以后，还要真正走路
<七道谛知道方向以后还要真正走路>
知道有病，并不等于病已经痊愈；知道执著会带来痛苦，也不等于执著就会自动消失。

因此，四圣谛的最后一项是道谛。

道谛的内容，就是八正道：

#quote(block: true)[
#strong[正见、正思惟、正语、正业、正命、正精进、正念、正定]
]

这八项不是八条彼此无关的戒命，也不是完成一项以后才开始下一项。它们更像一个车轮的八根辐条，相互支撑，共同使生命朝着清醒与解脱的方向前进。

印顺法师在#strong[《成佛之道》]中指出，八正道可以归纳为戒、定、慧三学：正见与正思惟属于慧学；正语、正业、正命属于戒学；正念与正定属于定学；正精进则贯穿并推动整个修行过程。

=== 1. 正见：先看清方向
<正见先看清方向>
正见不是固执地认为“只有我的观点正确”，而是对人生建立符合因果和四圣谛的认识。

行为会产生结果；贪婪、伤害与欺骗会扰乱自己和他人的生命；一切事物都会变化；执著会带来苦，而苦也可以通过修行减轻和止息。

没有正见，人越努力，可能离解脱越远。

一个人如果认为幸福只等于占有，就会把全部精力用于争夺；如果认为发脾气才能显示力量，就会不断伤害关系；如果认为一切都是命中注定，就可能放弃改变。

正见，就是先校正人生的方向。

=== 2. 正思惟：观察念头将把我们带向哪里
<正思惟观察念头将把我们带向哪里>
“思惟”在这里不只是思考知识，也包括内心的意向。

一个念头升起时，可以问自己：

它来自贪欲，还是来自清醒？ 它会增加敌意，还是减少敌意？ 它会伤害自己和别人，还是带来理解？

正思惟所培养的，是少欲、慈心与不伤害的倾向。

它不是要求人永远不能出现负面念头，而是训练人在念头还没有转化为语言和行动以前，看见它、辨认它，不盲目跟随它。

=== 3. 正语：语言也会制造因果
<正语语言也会制造因果>
正语要求人远离虚假、挑拨、恶口和无意义的伤害性言论。

一句谎言可能摧毁信任，一句挑拨可能破坏多年关系，一句在愤怒中说出的话，可能在别人心里停留很久。

现代人的语言不仅发生在面对面的谈话中，也发生在短信、社交媒体和网络评论中。隔着屏幕，恶语似乎不必承担后果，但接收这些文字的仍然是真实的人。

修习正语，不只是“不说坏话”，还包括在开口以前问一句：这句话真实吗？有必要吗？适合在此刻说吗？能否用较少伤害的方式表达？

=== 4. 正业：不要把自己的快乐建立在别人的痛苦上
<正业不要把自己的快乐建立在别人的痛苦上>
正业主要规范身体行为，核心是减少杀害、掠夺和不正当的欲望行为。

佛教并不把身体视为罪恶之源，而是强调：身体能够伤害，也能够保护；能够夺取，也能够布施；能够放纵欲望，也能够承担责任。

正业的根本精神，是尊重生命、尊重他人的财物，也尊重关系中的信任与边界。

=== 5. 正命：谋生方式也是修行的一部分
<正命谋生方式也是修行的一部分>
人必须生活，也往往必须通过工作获得收入。

佛教并不反对财富，但会追问：财富是怎样获得的？一种职业是否建立在欺骗、伤害、剥削和他人的沉迷之上？

正命提醒人，不能一边在寺庙里追求清净，一边在工作中肆意伤害别人。

职业不只是赚钱的工具，也在日复一日地塑造一个人的习惯、价值和内心。

=== 6. 正精进：不是逼迫自己，而是训练心的方向
<正精进不是逼迫自己而是训练心的方向>
正精进并不等于越疲惫越好，更不是重演佛陀已经放弃的极端苦行。

它所强调的，是持续调整内心：

尚未生起的恶念，尽量不给它条件； 已经生起的恶念，学习使它减弱； 尚未生起的善法，创造条件使它生起； 已经生起的善法，努力使它保持和增长。

这种精进并不激烈，却需要长久。

改变一个习惯，往往不是靠一次强烈决心，而是在每一次选择中，少一点随顺烦恼，多一点清醒。

=== 7. 正念：如实知道此刻正在发生什么
<正念如实知道此刻正在发生什么>
正念不是简单地放空大脑，也不只是让自己暂时放松。

它是对身体、感受、心念和经验保持清楚的觉察。

愤怒时，知道愤怒正在升起；焦虑时，知道身体正在紧绷；快乐时，也知道快乐正在变化。

正念让人在经验与反应之间获得一点空间。

没有正念，人往往在情绪出现以后立刻行动：一生气就攻击，一焦虑就逃避，一孤独就抓住某种刺激不放。有了觉察，人开始能够选择：我是否一定要跟随这个念头？

=== 8. 正定：让散乱的心安定下来
<正定让散乱的心安定下来>
正定，是培养稳定、集中而清明的心。

日常的心常被各种声音牵引：过去的懊悔、未来的担忧、他人的评价、手机上的消息。心不停移动，看似想了很多，实际上很少真正看清一件事。

禅定并不是逃离现实，而是使心获得足够的稳定，从而能够深入观察现实。

水面不断摇动时，无法照见事物；水面渐渐平静，影像才会清楚。正定的作用，也正在于此。

== 八、四谛不是听懂一次就结束了
<八四谛不是听懂一次就结束了>
在初转法轮中，佛陀并不只是把苦、集、灭、道各说一遍。

经典把佛陀对四圣谛的完整觉悟概括为三转十二行相。

所谓三转，是对每一项圣谛有三个层次的认识：

第一，知道它是什么； 第二，知道应当怎样对待它； 第三，确认这项功课已经完成。

以苦谛来说，不仅要知道“这是苦”，还要“如实遍知苦”，最后达到“苦已遍知”。

对于集谛，是知道苦因、应当断除苦因，并且苦因已经断除。

对于灭谛，是知道苦可以止息、应当亲自证得苦灭，并且已经证得。

#figure([
#box(image("chapters/../images/downloaded/312.png", width: 85.0%))
], caption: figure.caption(
position: bottom, 
[
三转四圣谛（三转十二法轮）示意图
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


正如知道药方与真正服药，是两件不同的事。

== 九、八正道是不是一种道德说教？
<九八正道是不是一种道德说教>
现代人对“正确地说话”“正确地行动”一类表达，容易产生警惕：这是否又是一套要求人服从的道德规范？

八正道确实包含伦理要求，却不只是道德命令。

它没有把人分成天生高贵者和天生有罪者，也不是某位神灵颁布的禁令。它所讨论的是行为与结果之间的关系。

说谎为什么需要避免？因为说谎使信任破裂，也让说谎者长期生活在掩饰和恐惧中。

恶语为什么需要避免？因为恶语在伤害别人的同时，也不断强化自己心中的瞋恨。

正念为什么需要培养？因为不能觉察内心的人，很容易被冲动支配。

正定为什么重要？因为一颗持续散乱的心，很难看清苦及苦因。

因此，八正道不是“你必须做一个听话的好人”，而是让人亲自观察：什么样的认识、语言、行动和心理习惯会增加苦，什么样的训练能够减少苦。

它不是为了迎合外在权威，而是为了获得内在自由。 自由也不是想做什么就做什么。一个完全被贪欲、愤怒和冲动支配的人，看起来可以随心所欲，实际上并不自由。他只是烦恼要他做什么，他便做什么。 佛教所说的自由，是在欲望升起时可以不被它拖走，在愤怒升起时可以不把它变成伤害，在环境变化时仍能保持清醒和选择。

#quote(block: true)[
#strong[看见了苦，是清醒的开始； \
了解苦因，是智慧的开始； \
相信苦可以止息，是希望的开始； \
真正走上八正道，则是修行的开始。]
]

= 第四章　三宝、皈依与僧团
<第四章-三宝皈依与僧团>
#figure([
#box(image("chapters/../images/downloaded/ch04_jetavana.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
祇园精舍与香室（Gandhakuti）遗迹，舍卫国，印度
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


清晨的王舍城刚刚醒来。

城门打开，商贩开始摆放货物，行人往来于街巷。一位身披袈裟的比丘，手持钵器，安静地走在人群之中。他目不斜视，步履从容，既没有故作高深，也没有急于向人宣讲什么，只是依次乞食，然后静静前行。

路旁有一位名叫舍利弗的修行者，远远看见了他。

舍利弗当时还不是佛弟子。他与好友目犍连同在外道老师删阇耶门下学习，两人早已厌倦了空洞的争论，相约无论谁先找到真正的解脱之道，都要立刻告诉对方。

这一天，舍利弗注意到眼前这位比丘的神态与众不同。他走上前去，恭敬地问：

“你的老师是谁？他教导什么？”

这位比丘名叫阿说示，汉译佛典中也称马胜，是最早追随佛陀的五比丘之一。他谦逊地回答，自己出家不久，对老师的教法还不能作详细解释，只能说出其中最简要的意思。

随后，他诵出一首短偈：

#quote(block: true)[
诸法从缘起，如来说是因； 彼法因缘尽，是大沙门说。
]

不同部派的律典对这首偈的译文略有差异，但中心意思相同：一切事物都依条件而生，也会随着条件的消失而改变、止息。佛陀所教导的，正是看清这些因缘，并由此走向烦恼的止息。

据律典记载，舍利弗听到这里，心中顿时明白：既然痛苦是因缘所生，它便不是永恒不变的；只要找到它发生的原因，也就可能找到止息它的道路。

他立即回去寻找目犍连。

目犍连一见好友的神情，便知道他一定有了重大发现。舍利弗将那首短偈重新诵了一遍，目犍连也有所领悟。于是，两人带着追随自己的修行者前往竹林精舍，拜见佛陀，成为僧团中极为重要的两位弟子。后来，舍利弗以智慧著称，目犍连以深厚的禅定与神通著称，佛教传统常将他们并称为佛陀的“双贤弟子”。

这个故事真正重要的地方，不只是两位著名弟子的加入。

它告诉我们，佛教已经不再只是菩提树下一个人的觉悟。佛陀的觉悟开始被听见、被理解、被实践，又通过一个个真实的人继续传递。

佛教由此有了三种缺一不可的依靠：佛、法、僧。

这就是“三宝”。

#horizontalrule

== 一、从五比丘到僧团：觉悟如何成为共同的道路
<一从五比丘到僧团觉悟如何成为共同的道路>
鹿野苑初转法轮以后，最早的五比丘先后证悟，世间有了最初的佛教僧团。

此后，耶舍等人陆续出家，弟子渐渐增加。早期律典记载，当世间已有六十位获得解脱的弟子时，佛陀劝他们分头游行，不要都走在同一条路上，应当为了更多人的利益与安乐而传播佛法。

一个人明白了道理，还要把道路告诉其他人；一个人获得安定，也应当帮助更多人离开迷惑和痛苦。佛法因此从鹿野苑出发，逐渐传播到王舍城、舍卫城、毗舍离等恒河流域的重要地区。

最初的比丘并没有宏大的寺院。

他们常常游行各地，托钵为生，在树林、山洞或村落附近住宿。到了雨季，为避免行走时伤害草木虫蚁，也便于集中修学，僧众会在一处安居。后来，频婆娑罗王奉献竹林精舍，给孤独长者建立祇园精舍，僧团才逐渐拥有较稳定的居住和说法场所。

随着加入者越来越多，人与人之间的问题也随之出现。

有人生活散漫，有人言语失当，有人因利益发生争执，也有人做出不适合出家人的行为。佛陀便针对具体事件制定相应规范。换言之，完整的戒律并不是僧团成立第一天便一次公布的，而是在共同生活中逐渐形成的。

这也说明，佛教从未假设进入僧团的人会立刻变得完美。

僧团之所以需要戒律，正是因为修行者仍然是人，仍会有习气、欲望、冲突和错误。戒律不是为了证明僧众没有缺点，而是为了让有缺点的人能够共同修正自己，使僧团保持清净与和合。圣严法师也指出，早期僧团随着成员增多，才逐渐产生制戒的必要。

“僧”是“僧伽”的简称，本义是共同修行的大众。古代注疏常以“和合”说明僧团的基本精神：大家并非性格完全相同，也不必对所有事情都有相同看法，但应当在共同的戒律、见解和修行方向上彼此尊重、共同生活。印顺法师因此说，正法能否久住，有赖于“和乐清净”的僧团。

所以，僧团并不是一群离开社会、互不往来的人。

它是一种以觉悟为方向、以戒律为边界、以共同修行为生活方式的团体。

#horizontalrule

== 二、佛、法、僧为什么被称为“三宝”？
<二佛法僧为什么被称为三宝>
“宝”意味着珍贵，也意味着在迷失和困顿之中，可以成为可靠的依止。

佛教所说的三宝，是佛宝、法宝与僧宝。

=== 1. 佛宝：已经走过这条路的人
<佛宝已经走过这条路的人>
“佛”意为觉者，即已经觉悟的人。

佛陀并不是创造世界、支配命运的神，也不是能够代替众生承担一切行为后果的万能存在。他的珍贵之处，在于亲自看清了苦及苦的原因，又找到了止息痛苦的道路。

因此，皈依佛，不只是崇拜一尊佛像，更是承认：觉悟是可能的，人不必永远被贪欲、愤怒和无明支配。

佛陀像一位走出森林的人。他不能替我们走路，却能告诉我们，哪里有陷阱，哪里是歧路，哪里通向开阔之地。

=== 2. 法宝：佛陀指出的道路
<法宝佛陀指出的道路>
“法”首先指佛陀所觉悟、所教导的真理与修行方法。

四圣谛是法，八正道是法，缘起、无常、无我也是法；戒、定、慧的实践同样是法。

所以，法宝不只是供奉在藏经楼里的经书。

经书记录和保存佛法，但只有当一个人真正听闻、思考并付诸行动时，文字中的法才会转化为生命中的道路。

如果一个人熟读许多经典，却仍旧任由自己的贪心、嗔恨与傲慢不断增长，那么他拥有的是佛教知识，还不能说真正走在法上。

皈依法，就是愿意让事实、因果和智慧成为判断的标准，而不只是跟随一时的情绪与欲望。

=== 3. 僧宝：实践并传递这条道路的人
<僧宝实践并传递这条道路的人>
“僧”首先指依照佛法出家、受戒、共同修行的僧团。在更广的皈依意义上，也包含已经依佛法修行而获得圣道成果的佛弟子。

佛陀发现道路，佛法说明道路，僧团则实践、保存并传递这条道路。

如果只有佛陀而没有佛法，后人便不知道佛陀究竟觉悟了什么；如果只有佛法而没有僧团，教法便难以在漫长岁月中被学习、解释与实践；如果只有僧团而不依佛法，僧团又可能只剩下一种社会组织。

所以，三宝彼此关联，不能任意割裂。

圣严法师说，佛教虽以法宝为核心，但法由佛陀宣说，又由僧团结集和传承，因此三宝不能分开。

对于普通人来说，也可以把三宝理解为三种生命资源：

佛，是可以仰望的方向；

法，是可以行走的方法；

僧，是可以共同前行的同行者。

#horizontalrule

== 三、皈依：不是寻找保护伞，而是确定人生方向
<三皈依不是寻找保护伞而是确定人生方向>
“三皈依”就是皈依佛、皈依法、皈依僧。

“皈依”常被解释为归投、依靠。人在风雨中寻找屋舍，在黑暗中寻找灯火，在迷路时寻找方向，都有“皈依”的意味。

但佛教的皈依，并不是从此把自己的命运交给某种神秘力量。

真正的皈依，是经过理解和选择以后，愿意以佛为导师，以法为道路，以僧为修学共同体。它既有正式的仪式，也有内心方向的改变。

印顺法师说：

#quote(block: true)[
归依是回邪向正、回迷向悟的趋向。
]

因此，皈依不只是参加一次仪式、取得一个法名，或者在证书上留下姓名。仪式表达的是一个决定：从今天开始，我愿意学习觉悟，而不再完全顺从自己的无明；愿意依照正法生活，而不再只凭个人好恶判断一切。

汉传佛教日常课诵中，有一段广为人知的三皈依文：

#quote(block: true)[
自皈依佛，当愿众生，体解大道，发无上心。
]

这句话不只说“我”要皈依，还说“当愿众生”。一个人的信仰，不应变成把自己与他人隔开的围墙，而应使自己更能理解和关怀众生。

需要说明的是，东晋译《华严经·净行品》原文作“自归于佛……发无上意”；后来汉传佛教课诵逐渐通行“自皈依佛……发无上心”的形式。两种文字略有不同，所表达的都是愿自己与众生共同趋向觉悟。

具体来说：

皈依佛，是愿意以觉悟者为榜样，而不是把佛当成满足一切欲望的神灵。

皈依法，是愿意依照佛法观察和修正自己，而不是只选择听起来舒服的部分。

皈依僧，是愿意亲近正直的修行团体，从善知识处学习，但并不是把任何一位出家人都视为绝对不会犯错的权威。

皈依的是三宝，不是对某一个人的私人依附。

主持皈依仪式的法师，是引导人进入三宝之门的老师，却不是信徒所皈依的最终对象。如果某位老师的言行明显违背佛法与戒律，佛弟子应以法为准绳，而不是因为“皈依过他”便放弃判断。

#horizontalrule

== 四、皈依是不是出家？
<四皈依是不是出家>
不是。

这是许多初学者最常见的误解。

皈依以后，可以继续工作、结婚、照顾家庭，也可以拥有正常的社会生活。皈依者只是正式确认自己愿意成为佛弟子，依照佛法学习和生活。

出家则是另一种更为专门的生命选择。

出家者要离开原有的家庭生活方式，剃除须发，穿着袈裟，进入僧团，接受沙弥戒或比丘、比丘尼具足戒，按照僧团制度生活。汉传戒律文献也明确区分：三皈与五戒属于在家人的修学基础，出家还须进一步受持相应的出家戒。

佛教传统将佛弟子概括为“四众”：

出家的男性称比丘；

出家的女性称比丘尼；

在家的男性称优婆塞；

在家的女性称优婆夷。

比丘、比丘尼负责较为专门的修学、住持与弘传佛法；优婆塞、优婆夷则在家庭与社会生活中实践佛法，同时护持僧团。四众身份不同，却共同构成完整的佛教共同体。经典中也经常以“比丘、比丘尼、优婆塞、优婆夷”并称四众。

因此，佛教并不认为只有出家才能学习佛法。

出家是一条道路，在家也是一条道路。两者所受戒律和生活方式不同，但都可以学习慈悲、智慧与自我节制。

从这个意义上说，皈依不是离开生活，而是开始重新学习怎样生活。

#horizontalrule

== 五、五戒：给普通人的五条生活底线
<五五戒给普通人的五条生活底线>
皈依确定方向，戒律则把方向落实到日常行为。

在家佛弟子最基本的生活规范，称为五戒：

不杀生；

不偷盗；

不邪淫；

不妄语；

不饮酒。

在早期佛教的表达中，受戒常被称为受持“学处”。例如，“受持离杀生学处”，意思是愿意学习远离杀生。

“学处”这个词十分重要。它说明戒不是一位神向人类颁布的绝对命令，而是修行者自愿接受的训练。受戒不是宣布自己从此不会犯错，而是承认哪些行为会伤害自己和他人，并愿意不断学习远离它们。三皈五戒的传统文本，也把五戒视为在家佛弟子的基本修学。

=== 第一，不杀生：学习尊重生命
<第一不杀生学习尊重生命>
不杀生，首先是不故意杀害有情生命。

它的积极意义，是培养慈悲与尊重。一个人如果习惯把其他生命只当成满足自己需要的工具，内心便容易变得冷漠；相反，当他意识到其他生命同样害怕痛苦、恐惧死亡，慈悲心便有可能生起。

这种对生命的体恤与恻隐之心，在东方传统文化中有着广泛的共鸣。例如《孟子·梁惠王上》中记载的经典名句：

#quote(block: true)[
“君子之于禽兽也，见其生，不忍见其死；闻其声，不忍食其肉。是以君子远庖厨也。”
]

这句话所表达的，正是人心对生命苦难天然的恻隐与不忍。现实生活十分复杂，人不可能完全避免对任何微小生命造成影响。因此，持戒的重点不是陷入无休止的困扰，而是减少故意的伤害，不以残忍为乐，并在有选择时尽量选择较少伤害的方式。

=== 第二，不偷盗：不拿取别人没有给予的东西
<第二不偷盗不拿取别人没有给予的东西>
“不偷盗”在经典中常称“不与取”，即别人没有给予，自己不应擅自拿取。

它不只包括明显的偷窃，也提醒人不要利用欺骗、权力或信息差，非法占有他人的财物与劳动成果。

不偷盗所保护的，是人与人之间最基本的安全感。一个社会如果人人都担心自己的东西随时会被夺走，便不可能有真正的信任。

=== 第三，不邪淫：不以欲望伤害他人
<第三不邪淫不以欲望伤害他人>
在佛教看来，爱欲是凡夫生命中最深刻的牵缠与动力。《四十二章经》有言：“爱欲莫甚于色。色之为欲，其大无外。”然而，炽烈而未经观照的欲望，亦如“执炬逆风行，必有烧手之患”。

对在家人而言，持“不邪淫戒”并非要求断绝正当的感情与婚姻生活，而是强调爱欲当有节制、有边界、有担当------不以私欲侵犯他人，不违背伦理与承诺，不让短暂的盲目冲动倾覆自己与伴侣、家庭的幸福。

《八大人觉经》提醒：“多欲为苦，生死疲劳，从贪欲起。”邪淫的本质，在于将有血有肉的他人降格为满足私欲的工具，在放逸与背叛中割裂尊严与信任。持守此戒，不仅是对欲望的清醒提防，更是对人际责任与家庭尊严的深沉守护，使情感得以在忠贞与尊重中归于宁静与清凉。

=== 第四，不妄语：不以虚假言语欺骗他人
<第四不妄语不以虚假言语欺骗他人>
不妄语首先是不故意说谎。

更广泛的佛教语言训练，还包括减少挑拨离间、恶毒伤人的话，以及毫无意义、使人更加散乱的话。不过，在五戒中，核心首先是维护言语的真实与可信。

一句谎话有时看似解决了眼前的问题，却可能需要更多谎话来遮掩，最终使人失去他人的信任，也失去面对自己的勇气。

不妄语并不意味着在任何场合都不顾后果地说出伤人的话。佛教所重视的真实，应当与善意、时机和智慧结合。

=== 第五，不饮酒：保护清醒与不放逸
<第五不饮酒保护清醒与不放逸>
传统五戒的第五条是不饮酒。在现代生活中，也可进一步理解为远离足以使人失去判断和自制能力的酒精、毒品及其他成瘾性物质。

佛教并不是因为酒本身具有某种神秘的不洁，而是因为人在醉酒或失去理智以后，往往更容易犯下杀生、偷盗、邪淫和妄语等行为。

因此，第五戒像一道保护其他戒律的门。

它所守护的，是清醒。

#horizontalrule

== 六、戒律是不是束缚：欲望的奴役与真正的自由？
<六戒律是不是束缚欲望的奴役与真正的自由>
乍看之下，戒律似乎总是在说“不可以”：不可以杀生，不可以偷盗，不可以妄语，不可以放纵欲望。现代人极其珍视自由，难免会提出疑问：这些规矩难道不会把人束缚起来吗？

问题的关键，在于我们究竟如何理解“自由”。

如果自由被简化为“想做什么就做什么”的放任，那么人往往并未获得真正自由，反而堕入了被本能操控的深渊：当愤怒升起就立即伤人，欲望升起就不顾后果，利益当前就背弃诚信，压力来临就依赖酒精麻醉……表面上似乎无人约束、随心所欲，实际上却是在被一时的情绪与习惯牵着走。古希腊斯多葛学派哲学家艾比克泰德曾一针见血地指出：

#quote(block: true)[
“未曾战胜自我欲望的人，绝无自由可言。”
]

被盲目冲动与欲望支配的“自由”，本质上只是欲望的奴隶。戒律提供的，恰恰是打破这种奴役的清醒力量。它在冲动与行动之间，强行保留了一个清醒觉察的空间。戒不是一道把人关起来的围墙，更像一道提醒边界：不要让几分钟被欲望操控的冲动，决定自己几年甚至一生的代价。

中国传统智慧中常讲“七十而从心所欲，不逾矩”，这其中蕴含着极为深刻的辩证哲理。“不逾矩”即是持戒不破，“从心所欲”则是超越欲望奴役后获得的清净大乐与大自由。持戒并非消极的禁锢，而是通往真正自由的必由之路------当一个人不再被贪婪、嗔恨与放逸所绑架，他的内心才能迎来不逾规矩却又随处自在的解脱清凉。

《三归五戒慈心厌离功德经》中有一句很有意味的话：

#quote(block: true)[
受三归者，施一切众生无畏。
]

意思是说，一个真正持戒的人，不仅自己不再做欲望的奴隶，更会让身边的生命逐渐感到安全：不杀生，是给众生生命的安全；不偷盗，是给他人财物的安全；不邪淫，是给关系与家庭的安全；不妄语，是给彼此信任的安全；不饮酒，是给自己和他人一份清醒的安全。

戒律真正保护的，不只是某一种宗教身份，而是人心内在的安宁，以及人与人之间能够长久相处的尊严与自由。

#horizontalrule

== 七、僧团中的三种力量：舍利弗、目犍连与阿难
<七僧团中的三种力量舍利弗目犍连与阿难>
佛教僧团并不是由性格完全相同的人组成。

舍利弗善于分析义理，被称为“智慧第一”；目犍连禅定深厚，在佛教传统中被称为“神通第一”。两人不仅自己修行，也协助佛陀教导弟子、维护僧团秩序。

他们的故事说明，进入佛门并不意味着抹去每个人的特点。有人擅长思考，有人长于实践，有人善于组织，有人富有慈悲。只要共同依止佛法，不同才能都可以成为利益大众的力量。

另一位重要弟子是阿难。

阿难长期随侍佛陀，照料佛陀的日常起居，也帮助安排来访者与听法者。《中阿含经》记载，阿难曾说自己奉侍佛陀二十五年，极少受到佛陀责备。

阿难没有舍利弗那样突出的论辩形象，也不像目犍连那样以神通闻名。他最重要的特质，是细心、亲和与善于听闻记忆。

后来，正是由于阿难长期亲近佛陀、听闻教法，才在佛陀灭度后的经典结集中发挥了不可替代的作用。这将在后面的章节中详细讲述。

#horizontalrule

== 八、佛教如何成为一种生活方式？
<八佛教如何成为一种生活方式>
到这里，我们可以重新理解“三宝、皈依与戒律”的关系：三宝回答的是“我们依靠什么”，皈依回答的是“我们决定走向哪里”，戒律回答的是“我们每天应当怎样生活”，而僧团回答的则是“这条路能否由一群人共同走下去”。

如果佛教只有高深的理论，它可能成为少数学者研究的哲学；如果只有寺院仪式，它可能变成节庆和习俗的一部分；如果只有个人内心的体验，它又可能随着个人生命的结束而消失。正因为有佛陀作为导师，有佛法作为道路，有僧团实践和传承，又有皈依与戒律把这些内容落实到个人生活中，佛教才从一次觉悟，逐渐成为一种能够延续的生活方式。

这种生活方式，并不要求普通人每天都远离家庭、坐在山林中禅定。它可以从一些十分平常的地方开始：生气时，先看见自己的愤怒，而不是立即伤人；面对利益时，守住不应逾越的界线；说话以前，想一想这句话是否真实、是否有益；享受生活时，不让享受变成成瘾；面对他人的痛苦时，不再把它看成与自己毫无关系。这些看似微小的选择，就是戒律进入生活的地方。

皈依不是逃离现实，而是在现实中确定方向；戒律不是压制生命，而是帮助生命不被欲望或嗔恨所奴役；僧团不是一群完美圣人的集合，而是一群愿意依照共同道路不断修正自己的人。

从舍利弗在街头看到马胜比丘的那一刻开始，佛法便在人与人的相遇中传递：一个人的威仪，引起另一个人的疑问；一句简短的教法，改变两个求道者的方向；两个求道者的加入，又使一个初生的僧团逐渐成熟。佛教就这样从佛陀一个人的觉悟，变成了许多人的共同生活。

然而，无论僧团如何扩大，佛弟子们当时仍有一个最可靠的中心------佛陀本人。当佛陀渐渐老去，当他的生命也将走到终点，弟子们不得不面对一个更为严肃的问题：如果佛陀不再亲自带领他们，佛法又应当依靠什么继续流传？下一章，佛陀将踏上他生命中的最后一段旅程。

#horizontalrule

== 常见困惑与大德解疑
<常见困惑与大德解疑>
=== 1. 如何看待“酒肉穿肠过，佛祖心中留”？
<如何看待酒肉穿肠过佛祖心中留>
#strong[问：] 世人常拿这句话作为自己放逸、不持戒的借口，该如何看待？

#strong[答：] 这句话后半句其实是“世人若学我，如同入魔道”。高僧圣者有大神通救度众生，凡夫若缺乏高深定力和觉照，以此为借口满足私欲放逸，不过是自欺欺人。

=== 2. 害怕守不住戒，是不是干脆“不受戒”更好？
<害怕守不住戒是不是干脆不受戒更好>
#strong[问：] 现代人常担心“受戒后破戒罪加一等”，因而不敢受戒。

#strong[答：] 弘一大师在《律学要略》中曾专门解疑。受戒会在内心形成“戒体”（清醒的防线），能随时警醒身心；即使偶有违犯，发心忏悔仍可恢复清净。若不受戒，终日随顺放逸却浑然不知，如无堤之水，其害更大。

=== 3. 说“善意的谎言”（方便妄语）算犯妄语戒吗？
<说善意的谎言方便妄语算犯妄语戒吗>
#strong[问：] 例如猎人追杀猎物，为了救猎物而骗猎人“往左跑了”，算不算犯妄语戒？

#strong[答：] 圣严法师等大德指出，大乘戒律极重“发心与慈悲”。若说谎完全出于无私救护生命的慈悲心，不仅不犯戒，反而具大功德。戒律所严防的，是出于嗔恨、贪婪与欺诈的伤人谎言。

#horizontalrule

== 经典原文选读
<经典原文选读-1>
=== 一、七佛通戒偈（兼记白居易问答）
<一七佛通戒偈兼记白居易问答>
#quote(block: true)[
诸恶莫作，众善奉行； 自净其意，是诸佛教。 ------《法句经》
]

这首偈被称为“七佛通戒偈”，将庞杂的戒律与修学浓缩为最平实的十二个字：止恶、行善、自净内心。

唐代大诗人白居易曾去请教鸟巢禅师：“如何是佛法大意？”禅师曰：“诸恶莫作，众善奉行。”白居易听后笑道：“这话三岁孩儿也说得！”禅师却严肃地答道：“三岁孩儿也解得，八十老翁行不得。”白居易大为叹服。持戒与修行的核心，从来不在于玄妙的言辞，而在于日复一日在言行中脚踏实地的践行。

=== 二、推己及人慈悲偈
<二推己及人慈悲偈>
#quote(block: true)[
一切畏刀杖，一切皆惧死； 以己度他情，莫杀莫教杀。 ------《法句经·刀杖品》
]

这首偈揭示了“不杀生戒”最打动人心的起点。它没有任何说教，而是回归到人性最基础的同理与共情------因为体认到自己害怕痛苦与恐惧死亡，便能推己及人，不忍杀害或教唆伤害任何生命。

=== 三、三自皈依文
<三三自皈依文>
#quote(block: true)[
自皈依佛，当愿众生，体解大道，发无上心。 自皈依法，深入经藏，智慧如海。 自皈依僧，统理大众，一切无碍。 ------《华严经·净行品》
]

这是汉传佛教中最广为流传的“三自皈依文”。它不仅明确了对佛、法、僧三宝的依止，更在每一句中融入了“当愿众生”，把个人的皈依与修学，升华为对世间一切生命的广大关怀。

#horizontalrule

== 本章主要依据
<本章主要依据>
+ 《根本说一切有部毗奈耶出家事》卷二：舍利弗、目犍连闻缘起偈及归佛的故事。
+ 律藏《大犍度》相关记载：佛陀派遣最初弟子分头弘法，僧团逐渐形成。
+ 《中阿含经》卷八：阿难随侍佛陀二十五年的记载。
+ 《长阿含经》：三皈、五戒及阿难随侍佛陀的相关记载。
+ 《佛说三归五戒慈心厌离功德经》：三皈、五戒与“施众生无畏”的意义。
+ 《大方广佛华严经·净行品》及智顗《法华三昧忏仪》：汉传三皈依偈的早期文本与通行形式。
+ 印顺法师《佛法概论》《成佛之道》：三宝、皈依及和合僧团的解释。
+ 圣严法师《戒律学纲要》相关开示：皈依、五戒及在家与出家身份的区别。

= 第五章　佛陀最后的旅程
<第五章-佛陀最后的旅程>
#figure([
#box(image("chapters/../images/downloaded/ch05_parinirvana.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
大般涅槃寺与涅槃舍利塔，拘尸那迦，印度
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#quote(block: true)[
一切万物，无常存者，此是如来末后所说。 ------《长阿含经·游行经》
]

那是一条缓慢的路。走在路上的，已经不再是当年那个离开迦毗罗卫王宫、独自寻找解脱之道的年轻太子，也不是菩提树下初成正觉、意气坚定的修行者，而是一位年近八十、身体衰老、疾病时常发作的老人。

只是，这位老人仍在行走。他从王舍城一带出发，经过那烂陀、波吒厘村，渡过恒河，前往毗舍离，又从毗舍离继续走向波婆，最后抵达拘尸那罗。一路上，他仍在说法，仍在回答弟子的疑问，仍在关心僧团的未来。

佛陀一生都在讲无常。到了生命最后的时刻，他没有用神通让自己永远年轻，也没有把衰老和死亡藏起来。他让弟子们亲眼看见：即使是佛陀的身体，也要经历疾病、衰败和消逝。

无常不再只是经文中的一句话，而是佛陀最后一次无声的说法。

#horizontalrule

== 一、一辆勉强修补的旧车
<一一辆勉强修补的旧车>
佛陀晚年，在毗舍离附近结夏安居时，曾经患上一场重病。经中说，病势十分剧烈，身体承受着强烈的痛苦。佛陀想到，如果不向弟子作最后的交代便入灭，并不适宜，于是以定力忍受病苦，使身体暂时恢复。

阿难看到佛陀病情稍有缓解，才松了一口气。他告诉佛陀，自己先前见到世尊病重时，身体仿佛也失去了力量，四周一片昏暗，心中唯一的安慰是：佛陀在对僧团作出最后教诫之前，应当不会就此入灭。

在他心中，佛陀不仅是老师，也是僧团的中心。只要佛陀还在，一切问题似乎都有最后的答案；如果佛陀不在了，弟子们该依靠谁？僧团又将由谁来领导？

《长阿含经·游行经》中，佛陀说：“我所说法，内外已讫。”意思是，他所应当宣说的法，已经毫无保留地宣说出来，没有把某些秘密教义藏在手中，只传给少数亲近弟子。佛法不是一套必须依赖神秘权威才能获得的秘密知识。佛陀教导弟子，不是为了使众人永远依附于他，而是为了让众人最终能够依照正法，亲自观察，亲自修行，亲自觉悟。

接着，佛陀平静地谈起自己的身体：“吾已老矣，年粗八十。譬如故车，方便修治，得有所至；吾身亦然。” 一辆年久失修的旧车，必须用绳索、木条勉强加固，才能继续前进。佛陀说，自己现在的身体也是如此。

佛陀没有把觉悟包装成肉身不坏，也没有因为自己的身体衰老而感到羞耻。觉悟并不意味着一个人从此不再生病、不再衰老；它意味着，即使疾病和衰老已经到来，内心也不再被恐惧、怨恨和执著所支配。

这正是佛教教理中极其深刻的辩证。

在佛教看来，血肉组成的肉身，是因缘和合而成的“有为法”。如《金刚经》所言：“一切有为法，如梦幻泡影，如露亦如电，应作如是观。”既是有为，就必然遵循生老病死的规律，像一辆终将损坏的旧车。

然而，肉身虽有坏灭，觉者的法身与觉性却是“无为法”，本自不生不灭、不垢不净。《大般涅槃经》中有一个生动的譬喻：正如夜空中的月亮，因云层遮蔽而呈现出盈亏出没，但月亮本身的体性从未真正增减损坏。佛陀示现肉身的衰老与坏灭，恰恰是为了破除弟子对“肉身神化”的执著。正如《金刚经》所警示：“若以色见我，以音声求我，是人行邪道，不能见如来。”

修行者究竟该如何超越这梦幻泡影般的有为肉身，去证悟那不生不灭的本性？

其关键在于：不再向外求索一个永恒不坏的肉身神迹，而是在有为的生灭变幻中，透过观照与正念，直下体认那不被生灭所动摇的清净觉性。如禅宗六祖惠能大师悟道时所叹：“何期自性本不生灭！”佛陀用自己衰老坏灭的肉身作最后教诫，正是要引导弟子从依赖外在有为的“生身肉躯”，回归并证悟自己内在不生不灭的“无为法身”。

#horizontalrule

== 二、自作洲渚，依法而住
<二自作洲渚依法而住>
面对即将失去老师的恐惧，阿难真正需要的，不是一位新的最高领袖，而是一种即使佛陀不在眼前，仍能继续修行的方法。

佛陀因此教导他说：

#quote(block: true)[
“当作自洲而自依，当作法洲而法依。”
]

“洲”，是洪水之中可以立足的沙洲与岛屿。

人在顺境时，往往不觉得自己需要一座岛。等到疾病、失去、衰老和死亡如洪水般涌来，才发现自己过去依赖的许多东西都并不稳固：财富可能消散，关系可能改变，名声可能转瞬即逝，甚至一直被称为“我”的身体，也无法永远听从自己的命令。

佛陀没有告诉阿难，应当再去寻找另一个外在的权威。在这个无常泛滥的世界里，人不必寄希望于外在的神明或领袖来救赎自己，而是要在身心里建立起一座“绝不下沉的坚固岛屿（自作洲渚）”，把正法作为防洪的陆地（法作洲渚）。

究竟怎样才算“自作洲渚，法作洲渚”？佛陀明确指出，那就是修习#strong[“四念处”]------在身心上建立四种清醒的观照：

- #strong[观身不净]：观察身体只是因缘和合的生理现象，破除对色身的盲目执著与神化；
- #strong[观受是苦]：看见一切苦乐感受皆是无常变幻的体验，不被一时的欲望与情绪拖走；
- #strong[观心无常]：看见心念如水流般刹那生灭、无有常住，不被杂念与情绪所绑架；
- #strong[观法无我]：观察一切现象皆由因缘聚合而成，没有独立固定的主宰，放下对世间的执取。

四念处，就是将正法落实在一吸一呼、一念一受中的禅修路径。正是通过这种如实观察，人才能在自己的身心里建造成一座风雨不摇的清净洲渚。

同时，针对弟子们关于“佛灭度后以谁为师”的悲顾，佛陀明确指出：“我成佛来所说经戒，即是汝护，是汝所恃。”佛陀没有指定任何个人作为继承人，而是要求后世弟子#strong[“以戒为师，依法而住”]。

“戒”是防范放逸与倾覆的坚固堤坝，“法”是立足与安住的清净洲渚。“自依止、法依止、以戒为师”，构成了佛陀留给后世弟子最清晰的修行指引。

所以，“自依止”有两个不可分割的方面：

一方面，不把解脱的责任推给别人。老师可以指出道路，却不能代替任何人行走；佛可以说法，却不能替众生完成内心的觉察与转变。

另一方面，必须“法依止”与“以戒为师”。自己的想法仍要接受正法与戒律的检验，而不是把一时的情绪、习惯和欲望称为“我的真实”。

真正的自依止，不是任性，而是觉察；不是拒绝一切帮助，而是不把任何人当成可以替自己承担生命责任的救主。

佛陀将要离开，佛法却不因此失去作用。因为佛法的价值，从来不只建立在佛陀肉身的存在上，而在于它是否能够被理解、被实践、被亲自验证。

#horizontalrule

== 三、最后一餐
<三最后一餐>
佛陀离开毗舍离后，继续向北行进，来到波婆城。当地有一位工匠之子，名叫周那（亦译纯陀），他听说佛陀到来便前往礼拜，邀请佛陀与僧团第二天到家中接受供养。

关于这次供养的食物，不同传本记载有所差异。《长阿含经》说周那烹煮了一种珍贵的“栴檀树耳”供养佛陀；巴利经典则称这种食物为“苏迦罗摩达瓦”，究竟是某种菌类、植物嫩芽还是其他食品，后世一直有不同解释。经典真正关心的重点，并不在于食材考证，而在于此后的故事：佛陀受食之后病情加重，出现剧烈的腹痛，但仍保持正念忍受痛苦，继续前往拘尸那罗。

阿难担心后人会把佛陀病重归咎于周那，认为是他的供养导致佛陀入灭，使这位怀着恭敬心的供养者承受终身的自责与指责。佛陀首先想到的，正是如何避免这种伤害。他嘱咐阿难日后一定要安慰周那：不要忧悔，这次供养不是罪过，而是有大功德；佛陀成道前接受乳糜供养，与临入涅槃前接受最后供养，这两次布施的功德“正等无异”。

佛陀自己正承受剧烈病痛，却没有寻找一个应当被责备的人，而是时刻关心善意的供养者是否会陷入内疚。一般人在痛苦中很容易追问“是谁害了我”，佛陀却在生命最后的旅途中用行动说明：痛苦发生之后，仍然可以不让怨恨继续生长。他没有把因果理解成简单的归罪，更没有把自己的病苦变成对他人的控诉。真正的慈悲，是自己已经十分痛苦时，仍然不愿把痛苦转移给别人。

#horizontalrule

== 四、佛陀入涅槃
<四佛陀入涅槃>
#figure([
#box(image("chapters/../images/downloaded/80.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
犍陀罗《佛陀入涅槃》石雕
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


佛陀终于来到拘尸那罗。这里并不是当时最繁华的都城，而是末罗族的一处城镇。佛陀让阿难在两株娑罗树之间铺设卧具，自己右胁而卧，安静地躺下。经典以充满宗教色彩的语言描绘这一幕：并非花期的娑罗树忽然开花落在佛陀身上，天上的花与香也纷纷降下表示供养。但佛陀告诉阿难，花香和音乐还不是对如来最殊胜的供养；真正尊敬佛陀的人，是那些依法而行、如法生活的人。

这句话重新界定了“供养”的意义。佛教当然不否定礼拜、鲜花和香灯，人需要以可见的仪式表达感恩与敬意；但如果供养只停留在外在形式，而言行与内心仍被贪欲、伤害与欺骗支配，那么再隆重的仪式也没有真正接近佛陀的教法。供养佛，不只是把花放到佛前，更是让慈悲出现在待人接物中，让正念出现在每一个容易冲动的时刻，让智慧进入每一次选择。

这时的阿难已经无法抑制悲伤，独自走到一旁倚着门框哭泣。他想到自己修行尚未完成，而长期慈悲教导、包容自己的老师却即将离去。 佛陀把阿难叫到身边，安慰他：“凡是自己所珍爱、所欢喜的人与事，都不能永远保持原样。只要由因缘聚合，就必然经历变化；既然有相遇，就可能有分离。”他接着肯定阿难长久以来的付出，称赞阿难以慈爱的身业、口业和意业侍奉如来，积累了广大善行，并勉励他继续精进，终将获得解脱。

真正的无常教育，不是否定感情，而是帮助一个人在悲伤中不被绝望吞没。因为无常，我们会失去所爱；也正因为无常，悲伤不会永远停留在最剧烈的时刻。感情可以被珍惜，却不必被执著变成占有；离别令人痛苦，却也提醒我们，在还能相见、还能善待彼此时，不要把一切当成理所当然。

#horizontalrule

== 五、涅槃究竟是什么？
<五涅槃究竟是什么>
佛陀最后的旅程中，最容易被误解的词就是“涅槃”。许多人听到“佛陀入涅槃”，便以为“涅槃”只是死亡的委婉说法，其实涅槃不能简单等同于死亡。“涅槃”（梵语 nirvāṇa / 巴利语 nibbāna）有火焰熄灭、烦恼止息的含义。所熄灭的，首先不是生命本身，而是燃烧在心中的贪欲、瞋恨与无明。

普通人死去并不等于证得涅槃。如果贪爱和无明尚未止息，推动生命流转的因缘仍然存在，死亡只是这一期生命的结束，并不是生死问题的彻底解决。佛陀在菩提树下觉悟时已经证得涅槃，那时他仍然活着、托钵说法，也会感到饥饿与疼痛，但贪嗔痴已经止息，不再制造新的生死系缚。

后来佛教用“有余依涅槃”说明这种状态（“余依”指过去因缘形成的身体，烦恼已断，生命仍在继续）；当觉悟者这一期身体寿命终结、不再受后有，则称为“无余依涅槃”（即般涅槃）。简单来说：死亡是身体生命过程的终止；涅槃是贪嗔痴及生死系缚彻底止息；般涅槃则是觉者在寿命结束后不再进入新的生死流转。

涅槃不是另一个可用世俗方位找到的天国，佛陀所破除的正是对固定永恒“自我”的执著。如果用生活化的语言来理解，涅槃意味着心中那些不断燃烧、驱使自己追逐、排斥与恐惧的火终于熄灭了。火熄灭后，不是陷入虚无，而是清凉、寂静与自在。

=== 常见误解：涅槃是不是死亡？
<常见误解涅槃是不是死亡>
不是。所有人都会死亡，但并非所有人都能证得涅槃。把涅槃等同于死亡，会让人误以为佛教追求生命消失。实际上，佛教要止息的不是慈悲、智慧和生命价值，而是制造痛苦的贪嗔痴。佛陀在世时证得涅槃并化导众生数十年，本身就说明涅槃是一种在现实生命中即可体现的清醒与自由。

#horizontalrule

== 六、佛陀不指定继承人
<六佛陀不指定继承人>
一个团体创立者即将离世时，人们通常会关心下一任领袖是谁。佛陀却没有指定某位弟子继承最高权威。舍利弗与目犍连此前已先去世，阿难长期随侍，摩诃迦叶德高望重，但佛陀并没有要求大家无条件服从某一个人。他对阿难说，自己宣说的“法”与制定的“律”，在灭度后应当成为大家的老师（《游行经》：“我成佛来所说经戒，即是汝护，是汝所恃”）。

这并不是说佛教不需要老师或否定善知识的作用，而是警惕把某人的身份、名望与魅力置于正法之上。真正的佛教老师不会要求弟子无条件盲从，而会引导弟子核对经教与戒律，观察其是否能减少贪嗔痴、增长慈悲与智慧。佛陀在《游行经》中提出判断教说的原则：日后若有人声称听到某种教法，不应立刻赞同或斥责，而应当逐句审察、与经律核对，相合者接受，不合者舍弃。

后来大乘《大般涅槃经》将这一精神概括为“四依”：“依法不依人，依义不依语，依智不依识，依了义经不依不了义经。”其中“依法不依人”提醒我们：人的身份可以尊敬，法的原则不能取消；老师可以引路，却不能代替真理本身；即使是有声望的人，其言行也必须接受经律与正见的检验。尊师而不造神，依教而不盲从，这正是佛陀留给后世的重要原则。

#horizontalrule

== 七、最后一个求法的人
<七最后一个求法的人>
佛陀已经十分疲惫，生命即将走到终点。这时，年长的游行者须跋陀罗来到娑罗林求法，阿难担心佛陀身体虚弱而连续三次拒绝。佛陀听见对话后嘱咐阿难不要阻止，因为须跋陀罗是真心求法。

在生命最后的时刻，佛陀接见了这位求法者，向他说明：凡是没有八正道的教法，就不可能真正成就清净解脱；凡有八正道之处，便有真正的修行与圣者。须跋陀罗听后生起信心请求出家，成为佛陀亲自度化的最后一位弟子。

从鹿野苑的五比丘，到娑罗双树下的须跋陀罗，佛陀一生的教化在这里形成一个完整的圆环。第一次说法讲的是中道、四圣谛与八正道；最后一次为新弟子说法，仍然回到八正道。佛陀没有在临终前揭示此前未说过的神秘真理，他最后确认的，仍然是那条需要亲自实践的道路。

#horizontalrule

== 八、诸行无常，慎勿放逸
<八诸行无常慎勿放逸>
最后，佛陀对众比丘作出简短教诫：“一切因缘和合而成的事物都具有坏灭的性质，应当以不放逸而成就修行。”汉译《游行经》凝练为八个字：#strong[“诸行无常，慎勿放逸。”]

这八个字概括了佛陀一生的核心方向：“诸行无常”是对世界真相的观察，“慎勿放逸”是面对真相时的行动。只知道无常却不修行，容易变成消极感叹；只强调精进却不理解无常，也可能变成无止境的名利追逐。佛陀把两者连在一起：正因为一切会变、生命有限，所以更应把握当下，不把时间浪费在贪嗔和无意义的争斗中，趁身心尚能修学时培养正念与智慧。

“不放逸”是一种时刻记得行为后果、不自欺的清醒态度。它不是紧张地逼迫自己，而是明白生命不会无限延期，烦恼若不被观察就会继续支配自己。

#horizontalrule

== 九、寂静并不是虚无
<九寂静并不是虚无>
说完最后的教诫后，佛陀进入禅定，依次进入不同层次深定，最后在第四禅中般涅槃。经典真实地保存了两种反应：尚未解脱的弟子举手放声哭泣，倒地哀叹“世尊入灭太早”；而离欲的比丘则保持正念，思惟“一切因缘和合之法皆是无常”。

有悲伤也有观照，有眼泪也有清醒。佛陀的入灭在悲伤之中再次显明他一生教导的事实：凡是生起的终将消逝，凡是聚合的终将离散。接受无常不等于认为一切毫无价值------一朵花会凋谢不妨碍它开放的美，一次相遇终将结束不否定其中真实的关怀。生命有限，反而使每一次善意、理解与觉察变得更加珍贵。正如灯可以点燃另一盏灯，觉者所发现的道路已经传给弟子；只要有人依照这条道路修行，慈悲与智慧的光便不会熄灭。

#horizontalrule

== 十、摩诃迦叶赶到以后
<十摩诃迦叶赶到以后>
佛陀入灭时摩诃迦叶正带领比丘从波婆前往拘尸那罗，途中得知佛陀入灭，比丘们失声痛哭。人群中一位年老才出家的比丘（同名须跋陀罗）却说：“不必悲伤，大沙门在世时总是约束我们，现在他不在了，我们想做什么便可以做什么。”

这句轻率的话让摩诃迦叶意识到严峻的问题：佛陀刚刚入灭，已有人把他的离去理解为戒律约束的消失。如果教法与戒律不被及时整理和共同确认，不同记忆与个人欲望都可能冒充为佛陀的教说。摩诃迦叶赶到后礼敬佛陀遗体，承担起召集僧众、整理佛法的责任。

佛陀没有留下亲手书写的经典。阿难记忆说法，优波离熟悉戒律，摩诃迦叶组织结集。佛陀最后一次旅行结束了，弟子们将面对全新的问题：当说法的人不在眼前，他所说的法要怎样被保存下来？

#horizontalrule

#figure([
#box(image("chapters/../images/downloaded/080.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
公元2世纪末至3世纪初的犍陀罗浮雕
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)

#horizontalrule

== 本章经典与资料依据
<本章经典与资料依据>
+ 《长阿含经》卷二至卷四《游行经》，后秦佛陀耶舍共竺佛念译。
+ 巴利《长部》第十六经《大般涅槃经》。
+ 《杂阿含经》中“自洲自依、法洲法依”相关经文。
+ 《佛垂般涅槃略说教诫经》，亦称《佛遗教经》。

#part[第二部：佛灭度后——佛法如何被保存与传播]
= 第六章　如是我闻：佛经是怎么来的？
<第六章-如是我闻佛经是怎么来的>
#figure([
#box(image("chapters/../images/downloaded/ch06_sutra.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
12世纪《八千颂般若经》贝叶写本，大都会艺术博物馆藏
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


佛陀入灭之后，僧团第一次真正面对了一个根本问题：老师已经不在了，教法怎么办？

没有佛陀亲笔写下的著作，没有录音，也没有一部装订完成、可以交给弟子保管的“佛经”。过去遇到疑问可以直接请教佛陀，僧团争议也可由佛陀裁决；如今娑罗双树下已寂然无声，以后什么可以称为佛法，什么又不是佛法？佛陀制定的戒律，应当继续遵守，还是可以随意改变？这不只是一个保存知识的问题，更关系到佛教能否继续存在。

佛陀虽然没有指定继承人，却早已指出：他所宣说的法与制定的律，应当成为弟子们此后的依止。佛教因此没有出现一位代替佛陀、拥有最高神圣权威的“新教主”。佛陀离去以后，僧团依靠的不是某个人的个人意志，而是共同忆持、共同确认的“法”与“律”。后来流传两千多年的浩瀚佛典，正是从这样的忧虑与责任中逐渐形成的。

#horizontalrule

== 一、佛陀入灭后，谁来守护佛法？
<一佛陀入灭后谁来守护佛法>
佛陀入灭的消息传来时，有些尚未离欲的比丘悲痛哭泣，不能自已。但律藏中还记载了一段令人警醒的插曲：《四分律》说，有一位比丘听闻佛陀涅槃后，竟对众人表示：那位经常告诉我们什么应该做、什么不应该做的老人已经不在了，从今以后想做什么便可以做什么。

摩诃迦叶听到这番话，深感不安。他所忧虑的并不仅是个别比丘失去约束，而是佛陀在世时僧团以佛陀为共同导师；佛陀离去之后，如果每个人都按自己的记忆和喜好解释佛法，教法很快就可能变得面目全非------有人删去自己不喜欢的戒律，有人把个人见解说成佛陀的教导，甚至有人借佛法之名追逐名利，长此以往世人便无法分辨什么是佛说，什么只是后人的附会。

因此，摩诃迦叶提出应当召集熟悉佛陀教法与戒律的弟子，共同诵出佛陀遗教，使僧团有所遵循。《四分律》保存的理由很朴素：不能让外人讥讽说，沙门瞿昙在世时弟子们还共同学戒，世尊灭度以后便再也没有人认真遵守了。

这次集会后世称为“第一次结集”（亦称“王舍城结集”或“五百结集”）。这里的“结集”不是今天意义上的写作会议或编辑图书，其古印度语有“共同诵念”“合诵确认”的意思。众人通过一问一答、反复诵读和共同核对，将大家认可的教法确定下来。换句话说，最初的佛经不是“写”出来的，而是“诵”出来的。

#horizontalrule

== 二、王舍城里的第一次结集
<二王舍城里的第一次结集>
依佛教传统记载，佛陀入灭后不久，摩诃迦叶召集众多比丘在王舍城附近举行结集。参加者通常称为五百位，因此又称“五百结集”。不同部派保存的律藏对参与人数、地点与具体程序的记载并不完全相同（如《大智度论》叙述以千人为数），但核心情节一致：摩诃迦叶主持结集，优波离诵出戒律，阿难诵出教法。在这三人中，摩诃迦叶代表僧团的威望与修行，优波离代表对戒律的精通，阿难则代表对佛陀说法的广博记忆。

=== 摩诃迦叶：承担责任的人
<摩诃迦叶承担责任的人>
摩诃迦叶是佛陀的大弟子之一，以少欲知足、严守头陀行著称。佛陀入灭后他没有沉溺于个人悲痛，而是立即思考怎样才能使佛法久住。在传统叙事中，他不是以“继承人”的身份发号施令，而是召集僧团，由大众共同确认佛陀的教条。这一点十分重要：早期僧团强调的不是把权力集中到某个人手里，而是在戒律规定的程序中共同议事。

=== 优波离：最熟悉戒律的人
<优波离最熟悉戒律的人>
优波离出家前出身并不显赫，却因严谨持戒、善于辨析戒法被佛陀称赞为“持律第一”。戒律不是抽象的命令，往往有具体的制定因缘：在什么地方发生了什么事情，谁首先做出了不适当的行为，佛陀为什么制定相应规则。因此由优波离负责诵律并不是偶然。

=== 阿难：听得最多、记得最深的人
<阿难听得最多记得最深的人>
阿难长期随侍佛陀，照料日常起居，也有机会听闻大量说法，传统称他“多闻第一”。许多弟子只在某个时期、某个地点听说法，阿难却长期在佛陀身边，熟悉各种说法的背景、听众与内容。

然而在结集开始前，阿难仍被认为尚未证得阿罗汉果。律藏叙事说他在集会前夜精进修行，直到身体疲惫准备躺下休息、头还没触到枕头时忽然断尽烦恼证得阿罗汉果，随后才正式进入结集会场。这个故事表达了佛教传统的一种态度：保存佛法不只是依靠聪明和记忆，也要求传法者具有清净、谨慎和不夹杂私欲的品格。

#figure([
#box(image("chapters/../images/downloaded/anan.jpg", width: 65.0%))
], caption: figure.caption(
position: bottom, 
[
唐代彩绘石雕阿难像（石灰岩，唐代），纽约大都会艺术博物馆藏
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)

#horizontalrule

== 三、优波离诵律：戒律不是一张处罚清单
<三优波离诵律戒律不是一张处罚清单>
结集开始后，首先受到重视的是“律”。《四分律》记载，摩诃迦叶向优波离发问：某一条戒最初在什么地方制定？是谁首先违犯？因为什么事情而制定？优波离再一一回答。通过这样的问答，僧团将比丘戒、比丘尼戒，以及受戒、布萨、安居、自恣、衣药等僧团生活制度，分类汇集起来。

为什么要问得如此详细？因为佛教戒律并不是脱离生活、从天而降的一套法规，许多戒条都是在僧团生活中出现具体问题后，由佛陀根据起因、动机、后果及长远利益而制定。只记住“不能做什么”却不知道原因，戒律容易变成僵硬禁令；只谈背景却不遵规则，戒律又会失去作用。优波离的诵出将“规则”与“因缘”同时保留，使后人既知道戒条内容，也能理解制戒用意。

第一次结集中还出现了一个重要问题：佛陀临入灭前曾说僧团以后可以舍弃“小小戒”，但阿难当时因悲痛忙乱没有请问究竟哪些戒属于“小小戒”。结集时众人意见不一，由于无法取得确定结论，摩诃迦叶主张：佛陀没有制定的不应擅自增加，佛陀已经制定的也不应随意废除，应当依照原有戒法学习。

这项决定体现了早期僧团的谨慎。面对佛陀已经不在的现实，他们宁可暂时保守，也不愿以个人判断轻率改变佛制。但这并不意味着戒律从此完全停止发展，后来佛教传播到不同地区，僧团在气候、饮食、衣着和社会制度上遇到新情况时仍进行解释和调整，只是这种调整必须在尊重戒律精神和僧团程序的前提下进行。

#horizontalrule

== 四、阿难开口：“如是我闻”
<四阿难开口如是我闻>
律藏结集之后，轮到阿难诵出佛陀的教法。当阿难登上法座时，他没有说“这是我写的”或“以下是我的思想”，而是以一句极其克制的话开始：#strong[“如是我闻。”] 意思是：我是这样听闻的。

汉译佛经大多保留着这种经典的开头规范。例如后世家喻户晓的《金刚经》，开头便是：

#quote(block: true)[
“如是我闻：一时，佛在舍卫国祗树给孤独园，与大比丘众千二百五十人俱……”
]

这几句话看似只是交代时间、地点和人物，实际上包含了佛经最初的传承方式：“如是”表示所传述的是这样一番教法，“我闻”表示传诵者是从前人或佛陀处听闻，“一时”说明发生在某一因缘成熟之时，随后再说明说法者、地点与在场听众。汉地佛教注疏后来把这称为“六成就”（信、闻、时、主、处、众成就），用以说明说法并非无根无据。

《大智度论》还保存了一种传统解释：佛陀临入灭前阿难询问以后经典开头应当安置什么话，佛陀教他以“如是我闻，一时……”开始。因此“如是我闻”包含着一种罕见的谦逊，阿难没有把自己说成真理的创造者，他只是告诉听众：我依自己所听闻的如实传述。至于这番教法是否合理、是否能引导人离苦，听者还要在理解和实践中亲自验证。

=== “我”是不是永远只指阿难？
<我是不是永远只指阿难>
普通读者容易产生一个疑问：所有佛经开头都有“如是我闻”，难道每一部经都是阿难亲耳听到的吗？

传统通常把第一次结集中的“我”理解为阿难，但事情不能简单地一概而论。例如佛陀在鹿野苑初转法轮时阿难尚未成为侍者，甚至可能尚未出家，《大智度论》叙述阿难诵出初转法轮时特意说自己当时并未亲见，而是“展转闻”（辗转听闻）。随着佛典不断传诵，“如是我闻”逐渐成为经典的固定开头格式，这里的“我”不必机械理解成阿难一人亲耳听到，也可以理解为传承者代表整个传法系统作出的声明：这不是我临时编造的，而是我从佛法传承中如此听闻、如此领受的。

因此，“如是我闻”既是一种见证，也是一种责任。说出这四个字，就意味着传诵者不能任意增减，不能把自己的想法混入佛说，更不能借佛陀之名为个人欲望背书。

#horizontalrule

== 五、没有书本，怎样记住那么多教法？
<五没有书本怎样记住那么多教法>
现代人习惯把重要内容记录在纸张、电脑和手机里，很难想象仅凭记忆怎么可能保存数量如此庞大的经典。事实上古印度虽然已出现文字，但早期佛教主要依靠口头传诵保存教法。直到数百年后，一些佛教传统才将长期口传的经典写在贝叶等材料上。

但“口传”不等于随口讲述，更不等于只靠某一个人的记忆，早期佛教发展出了一套相当严密的记忆与校验方法：

+ #strong[反复诵读]：佛经中常有大段重复，古代传诵者借重复建立稳定的记忆节奏。重复也是一种保护机制，如果相同结构反复出现，诵者便容易发现某处缺失或错乱。
+ #strong[使用数字和次第]：教义中常见“三法印”“四圣谛”“五蕴”“六根”“七觉支”“八正道”“十二因缘”等数字结构。知道应当有八项，诵到第七项便察觉遗漏；知道十二因缘有固定次第，便不会随意颠倒。
+ #strong[使用固定句式]：“如是我闻，一时佛在……”“尔时世尊告诸比丘……”“欢喜奉行”等固定表达为经文建立了稳定框架，传诵者如同沿着铺好的道路前进。
+ #strong[分工背诵与集体合诵]：早期僧团中出现专门忆持某一类经典的传诵者（有的熟习长篇，有的熟习短篇，有的持诵戒律），不同群体各自负责某部分并通过集体合诵相互校正。有人多说少说或次序颠倒，其他人会立即察觉。

佛教学者无著比丘的研究指出，早期经典大量使用重复、固定段落、声音相似和整齐排列的句式，这些特征都有助于记忆与诵读。集体诵经不仅保存文本，也体现僧团的和合与教法的传承。

#horizontalrule

== 六、经、律、论：三藏不是三本书
<六经律论三藏不是三本书>
“三藏”（梵语 Tripiṭaka）不是三本具体的书，而是对庞大佛典的三大分类。“藏”就像大仓库或大容器，用来盛装与归类不同性质的文献：

- #strong[经藏（言教）]：记录佛陀与大弟子的言论讲记。它回答“佛陀说了什么”，就像一部部生动的讲学实录，针对不同的人回答如何面对烦恼与生死。
- #strong[律藏（戒条）]：记录出家众的行为规范与生活制度。它回答“僧团该怎样生活”，从戒律规则到集体议事、日常饮食无所不包，是保障僧团健康的基石。
- #strong[论藏（阐释）]：后世弟子与高僧对佛陀言教的整理、说明与系统化分析。它回答“该怎样系统理解佛法”，把散见在各部经典里的思想梳理出清晰的理论框架。

简单来说：#strong[经是言行讲记，律是行为规范，论是理论阐释。]

在第一次结集中，僧团主要确认的是“法（经）”与“律”；而系统化的“论藏”，则是后世弟子在漫长的传诵与研究中逐步丰富起来的。

#horizontalrule

== 七、第一次结集是完全确定的历史事实吗？
<七第一次结集是完全确定的历史事实吗>
从佛教传统内部看，王舍城结集具有极其重要的意义，它说明佛法不是某个弟子私人的创造，而是僧团共同忆持、共同确认的遗教。从现代历史研究的角度看，现存多种律藏都保存了结集故事且核心结构相似，表明早期僧团很可能确实进行过某种形式的集会与教法确认。

但各种传本在人数、地点、诵出顺序与细节上存在差异，因此较为谨慎的态度是：承认这段传统保留了早期僧团共同诵持佛法的历史记忆，同时不把所有细节都当成可以逐项核实的会议记录。

这种谨慎并不会削弱佛经的价值。恰恰相反，它让我们看到佛经不是由一个人关在屋里独自写成，而是无数僧人用记忆、诵读、修行和生命代代传递下来的成果。不同地区、不同部派的传本虽然不完全相同，却仍保存了大量共同的核心教义（如四圣谛、八正道、缘起、无常、无我、戒定慧等），经过漫长时间与广阔地域后仍能彼此印证，本身就是早期佛教传承稳定性的有力证明。

#horizontalrule

== 八、常见误解：佛经是不是佛陀亲手写的？
<八常见误解佛经是不是佛陀亲手写的>
不是。现有资料没有表明释迦牟尼佛亲自撰写过一部佛经，佛经最初来自口头教导，由僧团背诵传承，后来才写成文字。但“不是佛陀亲手写的”不等于“后人随意编造的”，这里需要区分“亲笔著作”和“教法传承”。

老师在课堂上讲授内容，学生根据亲闻整理代代传授，虽非老师亲笔，却仍能真实保存思想。佛经中的“佛说”，首先表示一项教法被佛教传统视为符合佛陀教导、具有传承权威。真正稳妥的态度，是既不把佛经想象成佛陀亲笔完成、两千多年一字未变的书稿，也不因为它经历了口传与编集便断言其中毫无可信内容。

#horizontalrule

== 九、“如是我闻”留给今天的人什么？
<九如是我闻留给今天的人什么>
今天我们打开一本佛经，首先看到的往往不是惊天动地的神迹，而是四个平静的字：“如是我闻。”这四个字提醒我们，佛法来自倾听------阿难之所以成为“多闻第一”，是因为他善于听闻、记忆和受持，暂时放下成见去理解说法者真正回答的问题。

“如是我闻”也提醒我们保持谦逊与承担传递的责任：我们所知道的许多事情都来自他人的教导与前人的经验，诚实地说明“我是这样听闻、这样理解的”，反而更接近求真的态度。阿难在结集中说出“如是我闻”，等于公开承诺不把自己的欲望伪装成佛陀的教导，只把所领受的法如实传下去。

两千多年前，王舍城中的僧众共同诵念佛陀的遗教；两千多年后，我们仍能读到“诸行无常”“此有故彼有”“苦集灭道”等教法。这并不是因为佛法被封存在一块永不变化的石头里，而是因为一代又一代的人愿意听闻、记忆、校正、翻译与实践。佛陀没有亲手写下一部书，却留下了一群愿意认真倾听的人。而佛经，正是从他们的“如是我闻”开始的。

#horizontalrule

== 本章主要依据
<本章主要依据-1>
+ 《四分律》卷五十四“集法毗尼五百人”：保存摩诃迦叶召集僧众、优波离诵律、阿难诵法及三藏分类等传统叙事。
+ 《大智度论》卷二：解释“如是我闻”的传统含义，并详细叙述王舍城结集与阿难诵法。
+ 无著比丘《巴利经藏的口传维度》：分析重复、固定段落、音韵和集体诵读在佛典口传中的作用。
+ Mark Allon等关于早期佛典形成与口传的研究：说明早期经典的程式化结构、背诵方式以及传承中可能产生的变化。
+ 关于阿含、尼柯耶及早期经典形成的佛教学研究：指出经典曾经历长期口传与逐步编集，而非一次性完成。

= 第七章　阿育王与佛塔
<第七章-阿育王与佛塔>
#figure([
#box(image("chapters/../images/downloaded/ch07_ashoka.jpg", width: 65.0%))
], caption: figure.caption(
position: bottom, 
[
阿育王石柱，毗舍离，印度比哈尔邦（公元前3世纪）
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


羯陵伽的战鼓终于停了。原野上留下的并不只是折断的兵器、焚毁的村落和来不及掩埋的尸体，成千上万的人被迫离开家园，活着的人寻找失散的亲人，战胜者押送俘虏，失败者在废墟中哭泣。站在这一切面前的，是当时印度最有权势的君王之一------孔雀王朝的阿育王。他赢得了战争，却第一次如此清楚地看见：所谓胜利，原来可以由无数人的死亡、离散和恐惧堆成。

在后世佛教徒的记忆中，阿育王的一生常被概括为一个极具戏剧性的故事：他早年残酷好战被称作“恶阿育”，后来因战争惨状而深生悔悟，皈依佛教、广建佛塔、供养僧团并派遣使者传播佛法，从此成为“法阿育”。这个故事的基本方向并非毫无根据，但真实的历史比“暴君忽然变成圣王”更加复杂。

阿育王的转变并不是一夜发生的，他对佛教的亲近、对战争的反省以及对“法”的理解是一个逐渐加深的过程。也正是在这个过程中，原本主要流传于恒河中下游一带的佛教，第一次获得了跨越广大地域的传播条件。阿育王并没有创造佛教，却让佛法第一次拥有了通往远方的道路、石柱、驿站、佛塔与公共语言。从这时起，佛教不再只是恒河岸边几个僧团所传承的教法，它开始越过山岭、河流与国界，成为一种能够影响整个南亚、并最终走向亚洲各地的文明力量。

#horizontalrule

== 一、佛陀灭度以后，佛教还只是一个地方性的教团
<一佛陀灭度以后佛教还只是一个地方性的教团>
佛陀在世时，他和弟子们活动的主要区域大致集中在恒河中下游。王舍城、舍卫城、毗舍离、迦毗罗卫、鹿野苑、拘尸那罗，这些后来被佛教徒反复称颂的地名构成了早期佛教最重要的活动范围。佛陀没有建立帝国也没有掌握军队，他带领弟子在城镇与村落之间步行托钵、说法、安居。佛法的传播依靠人与人之间的相遇：一个人听闻教法后传给另一个人，一位弟子在某地建立僧团，又有新弟子从那里出发。

佛陀灭度以后，僧团通过结集、诵持经律、建立寺院等方式保存教法。商人、城镇居民以及部分国王贵族也为僧团提供布施与保护。然而这时的佛教仍然主要是古印度众多沙门传统中的一支，它虽然已有相当规模，却远没有遍布整个印度，更谈不上成为亚洲普遍熟悉的宗教。

这是理解阿育王历史作用的关键前提：#strong[阿育王并没有创造佛教，却极大地改变了佛教传播的范围和方式。] 在他以前，佛法主要靠僧人游行、口耳相传和地方信众护持；在他以后，佛教开始借助一个横跨广大地区的政治与交通网络，获得寺院、佛塔、刻石、巡礼路线以及跨区域交往的支持。一种原本依靠行脚僧传播的教法，开始拥有一种可以被看见、被纪念、被长久保存的公共形态。

#horizontalrule

== 二、阿育王是谁？
<二阿育王是谁>
阿育王生活在公元前三世纪，是孔雀王朝的第三代重要君主。孔雀王朝由旃陀罗笈多建立，至阿育王时统治范围已覆盖印度次大陆的大部分地区。阿育王在自己的诏令中通常不直接使用“阿育”这个名字，而自称“天爱喜见王”，意思大致是“诸神所爱、以慈目观视之王”。

与许多古代帝王不同，阿育王留下了大量刻在岩壁和石柱上的诏令。这些诏令分布在今天的印度、尼泊尔、巴基斯坦和阿富汗等地，所使用的文字和语言也因地区而异（有的使用婆罗米字母，有的使用佉卢文，在西北地区还发现了希腊文和阿拉米文诏令）。这些石刻之所以重要，是因为它们不是几百年后由信徒写成的传记，而是阿育王统治时期留下的直接材料。

后世的《阿育王传》《阿育王经》《大史》等典籍保存了佛教徒心目中的阿育王形象，石刻诏令则让我们听见阿育王本人希望向臣民表达的思想。把两类材料结合起来，我们可以看到两个彼此相关又有所不同的阿育王：一个是佛教传说中的“恶王转法王”，另一个是在战争、治理、信仰与现实之间不断反省的古代君主。

佛教典籍喜欢用鲜明的对照来叙述他的前半生与后半生（早年为暴恶的“旃陀阿育”，信佛后为奉法的“达磨阿育”）。这种写法不只是记录经历，也是在表达一个佛教主题：#strong[再深重的习气也并非不能转变，再强大的人也必须面对自己行为造成的苦。] 不过从阿育王自己的诏令来看，他与佛教的关系并非某一天突然开始：他在一篇小岩诏中说自己成为在家信徒已两年多，最初并不十分精进，后来更加亲近僧团才逐渐变得热诚；在另一篇给僧团的诏令中，他明确表达了对佛法僧的敬信并列举希望大家经常诵持的教法。这说明他的信仰转变是一个渐进过程------先是接近佛教成为优婆塞，继而在现实经验中重新理解佛法，最后才把这种理解落实到政治与生活中。真正改变他的，是他开始用佛法审视自己所拥有的权力。

#horizontalrule

== 三、羯陵伽之战：一场胜利怎样变成悔恨
<三羯陵伽之战一场胜利怎样变成悔恨>
阿育王即位后的第八年，孔雀王朝征服了东部的羯陵伽。羯陵伽大致位于今天印度奥迪沙一带，临近海岸，经济与交通地位十分重要。对于一个试图扩大和巩固疆域的帝王来说，征服这里似乎是一场理所当然的胜利。

然而，阿育王在第十三岩诏中留下了一段在古代帝王文告中极为少见的话。诏令记载，羯陵伽战争造成了大批量的杀戮、死亡和人口迁徙。阿育王说，征服一个原本独立的地方必然带来屠杀与亲人离散，想到这些他感到深切的悲痛与悔恨。他尤其提到战争伤害的不只是士兵，那些恭敬父母的人、修行的沙门婆罗门、普通居士、亲友仆役以及善良生活的人，也会在战争中被杀害、流放或与所爱者分离。这使他认识到一个命令从王宫发出，最后可能变成千百个家庭的悲剧，战争造成的痛苦远远超出了战场。

过去的帝王往往只把“征服了多少土地”刻在石头上，阿育王却把自己对战争的悔恨也刻在石头上。这并不意味着他从此废除了军队或刑罚，他仍然是一位维持行政与边疆秩序的现实帝王，但他提出了一个新的理想：与其依靠兵刃征服，不如追求“法的胜利”。所谓“法的胜利”，不是让所有人都臣服于自己的宗教，而是希望通过善行、仁慈、克制与教化使人心发生改变。他在第十三岩诏中告诫子孙不要轻易追求武力征服，即使不得不施行惩罚也应尽可能宽和节制。

这个转变之所以震撼，是因为他开始承认：#strong[权力不能免除一个人的因果责任。] 普通人伤害一个人需要面对后果，帝王影响千万人更不能把痛苦从自己的责任中排除。佛教所说的“业”不只存在于私人生活中，一项政策、一道军令、一次扩张同样由动机、行为与结果构成。拥有越大力量的人，所能造成的利益和伤害也越大，因此更需要节制与觉察。阿育王最重要的变化，是他终于开始看见自己拥有的权力也必须接受道德的审视。

#horizontalrule

== 四、阿育王所说的“法”，是不是等于佛教？
<四阿育王所说的法是不是等于佛教>
阿育王的诏令中反复出现“法”（古印度语称“达摩”）。既然阿育王是一位佛教徒，人们很容易把诏令中的“法”直接理解为四圣谛、八正道等完整的佛教教义。但仔细阅读诏令就会发现，阿育王向全国臣民讲述的“法”，更多是一套不同信仰者都可以实践的公共伦理。

他所强调的内容包括：尊敬父母长者，善待亲属朋友与仆役，尊重沙门与婆罗门，减少杀害生命，诚实、清净、慈爱、慷慨，节制浪费，反省过失，以及不同宗教之间彼此倾听、避免恶意攻击。在柱诏中他直接解释：“法”就是少作恶、多行善，具有慈爱、布施、真实与清净。这与佛教伦理高度一致，但并不是一份要求所有臣民必须皈依佛教的命令。

阿育王对僧团有明确的个人信仰，但当他面对一个包含多种信仰的庞大帝国时，他倡导的是一种让不同群体都能接受的道德生活。第十二岩诏尤其强调不能为了抬高自己的宗教而随意贬低其他宗教，狂热地赞扬自己、攻击他人表面上在维护信仰，实际上反而伤害了信仰；真正有益的做法是克制言语，倾听并了解其他传统中的善法。

因此把阿育王说成“以国家力量强迫全民信佛”并不准确，他大力护持佛教，却没有把护持理解为消灭其他信仰。这也提醒我们：真正的护法首先是让法在自己身上活出来，而不是借护法之名宣泄傲慢与攻击欲。

#horizontalrule

== 五、从“游猎”到“法巡”：把信仰落实到治理中
<五从游猎到法巡把信仰落实到治理中>
阿育王并没有把悔恨停留在情绪里。过去的君王常以游猎和享乐作为巡行的重要内容，阿育王则开始进行“法巡”：探望年长者，布施修行者，接触乡村百姓，与人讨论道德生活。他还设置“法大官”关注不同宗教群体、边远地区、贫困者与受刑者的处境。

诏令中记载的措施还包括：为人和动物设置医疗条件，在缺少药草的地方移植药用植物，在道路沿线栽种树木与开凿水井，减少宫廷中宰杀动物的数量，限制某些时日与动物的屠杀，要求官员巡视听取民情，以及对司法刑罚采取更审慎的态度。

这些措施说明阿育王对信仰的理解不只是建寺、礼拜和供养，还意味着重新思考：人民怎样少受苦？动物是否也应得到保护？权力怎样由征服的工具转变为照顾众生的责任？他在诏令中把人民比作自己的孩子，希望他们在今生来世都获得安乐。虽然带有古代君王以父母自居的色彩，但他至少开始用照顾而不是单纯占有的方式理解统治。

#strong[一个相信慈悲与因果的人，应当怎样使用自己手中的力量？] 这个问题不只属于帝王。父母对子女、教师对学生、管理者对下属、掌握财富或话语权的人，都拥有影响他人命运的能力。佛法不只要求弱者忍耐，也要求强者节制。

#horizontalrule

== 六、佛塔是什么？为什么要供养舍利？
<六佛塔是什么为什么要供养舍利>
在阿育王与佛教传播之间，还有一个极其重要的载体：佛塔。今天的人走进寺院往往首先注意到佛殿和佛像，但在佛教发展早期，佛像尚未成为普遍的礼拜中心，佛塔（“窣堵波”）却很早占据了重要地位。

“塔”原本具有坟冢、纪念冢的含义。佛陀涅槃火化后，早期经典记载有多个国家请求分得佛陀舍利，最后分得的舍利被各地建塔供养。对佛教徒而言，供养舍利并不是把佛陀当成施展神力的神明，而是借由具体的遗物表达对觉者生命的敬仰与追思。当人们来到舍利塔前绕塔而行、献上花香时，那位离世的老师仿佛仍以另一种方式提醒他们：这里曾经有一个真实的人觉悟了苦的根源，他所发现的道路并没有随着肉身消失。

因此佛塔具有多重意义：它是安奉舍利的处所，也是纪念佛陀的标志；它是信众礼拜的中心，也是僧俗聚集的公共空间；它使看不见的信仰成为可以抵达的地点，把佛陀的生平教条与地方历史联系起来。人们可以不识字却能看见佛塔，可以通过礼敬与听闻故事逐渐接近佛法。佛塔不仅是一座建筑，也是一种传播佛法的媒介。

#horizontalrule

== 七、“八万四千塔”：历史事实还是佛教传说？
<七八万四千塔历史事实还是佛教传说>
关于阿育王最著名的传说之一，是他打开早期安奉佛舍利的佛塔，重新分配舍利并在天下建立八万四千座佛塔。汉译《阿育王经》与《杂阿含经》均记载了他从暴恶转向敬信三宝、广建佛塔的事迹。

“八万四千”在佛教文献中常用来表示数量极多、法门广大，不宜当作现代统计的精确数字。今天没有考古证据证明阿育王在同一时间内建成了八万四千座塔，因此稳妥的理解是：#strong[阿育王广建扩建佛塔有历史与考古依据；“八万四千塔”则属于佛教传统对其护法功德的宏大表达。]

桑奇大塔就是最著名的例子之一：其早期砖塔可追溯至阿育王时代，后来人们又增建了石栏、塔门与雕刻。传说与历史在这里并不排斥------历史研究关心遗迹的真实年代与范围，宗教叙事则关心一个曾以武力征服天下的王转而把巨大的组织能力用于安奉舍利与护持佛法，这种转变意味着什么。“八万四千塔”真正表达的是一种方向的改变：从修筑战争堡垒转向建立纪念觉者的佛塔，从以恐惧统一疆域转向以共同敬仰连接人心。

#horizontalrule

== 八、石柱、佛塔与圣地：佛法开始拥有一张“看得见的地图”
<八石柱佛塔与圣地佛法开始拥有一张看得见的地图>
佛陀在世时佛法随着人的脚步流动；阿育王时代，佛法开始被刻在石头上，也被安置在具体的地理空间中。阿育王在交通要道与人口聚集地刻写诏令，并前往与佛陀生平有关的圣地巡礼。在蓝毗尼发现的石柱铭文中，记载了阿育王即位二十年后亲自来到佛陀诞生之地礼敬并减轻当地赋税。

这段铭文意义非凡：在此之前“佛陀出生于蓝毗尼”主要靠口头记忆流传，石柱建立后这段记忆被固定在地景之中。从此人们不仅听说佛陀来过世间，还可以踏上一条道路，前往他出生（蓝毗尼）、成道（菩提伽耶）、初转法轮（鹿野苑）和涅槃（拘尸那罗）的地方。

佛教由此形成了圣地网络，佛塔、石柱、寺院与道路把这些地点连接起来，把抽象的佛教历史变成可以行走的空间。僧人可以携带经法远行，商人可以在旅途中供养，信众可以朝礼圣地，不同地方的人通过佛塔知道遥远的另一座城市也有人礼敬同一位佛陀。佛教因此不再只由分散的小型僧团组成，而逐渐形成一个跨越地区的精神共同体。

#horizontalrule

== 九、佛法怎样越过恒河流域？
<九佛法怎样越过恒河流域>
阿育王对佛教传播的推动并不只有建塔。后世南传佛教文献《大史》记载，在阿育王时代，僧团曾向迦湿弥罗、犍陀罗、南印度及兰卡岛等地派遣长老弘法。斯里兰卡传统尤其重视摩哂陀长老（阿育王之子）前往兰卡弘法、以及僧伽蜜多（阿育王之女）带菩提树分枝建立比丘尼僧团的故事。

这些叙述反映了一个历史事实：公元前三世纪后，佛教确实加速向印度次大陆南部、西北部及斯里兰卡传播。阿育王的岩诏也提到南印度的朱罗、般荼地区以及西方希腊化世界的君主，宣称“法”的影响已到达这些区域。

两类材料结合起来，展示了阿育王时代佛教传播的几条并行道路： 1. #strong[僧人的道路]：比丘携带经法和戒律前往新地区建立僧团； 2. #strong[商旅的道路]：商人往来于城市港口，把信仰带到贸易网络沿线； 3. #strong[行政与交通的道路]：连通的交通与官方交往使跨地域旅行更加可能； 4. #strong[佛塔与圣迹的道路]：佛塔提供共同礼敬中心，舍利让不同地区的人与佛陀相连； 5. #strong[伦理语言的道路]：“不杀生、敬父母、行布施、说真实语、尊重其他信仰”等朴素原则比复杂理论更易跨越文化边界。

佛教能走出恒河流域，是因为它同时具有深刻的思想、可实践的伦理、稳定的僧团、可见的圣迹以及愿意长途跋涉的传播者。一种思想要走得远，既需要智慧，也需要道路。

#horizontalrule

== 十、护法是不是用权力让所有人都信佛？
<十护法是不是用权力让所有人都信佛>
人们容易产生误解：佛教是不是依靠帝王权力才兴盛起来的？阿育王的护持确实十分重要，但佛法不能只靠权力维持------权力可以修建寺院却不能命令人觉悟，可以召集僧众却不能保证僧团清净，可以把经文刻在石头上却不能把慈悲刻进心里。

阿育王在晚年柱诏中指出：通过禁令与制度促使人行善作用有限，相较之下劝导与内心的认同更加重要。这非常接近佛教修行的本质：真正的持戒不只是害怕惩罚，而是理解伤害众生会染污自己的心，而诚实、节制与慈悲能减少苦。同样，佛教可以受国家保护，却不能成为强迫他人服从的工具。一旦完全依附权力，它可能随权力兴衰而起伏；一旦只剩宏大仪式而失去内在修行，表面繁荣反而掩盖空虚。

阿育王留给后世最宝贵的启示在于：#strong[拥有巨大权力的人也可以承认错误；一种信仰进入公共生活后，应表现为减少伤害，而不是扩大压迫。]

#horizontalrule

== 十一、诸行无常，慎勿放逸：自净其意的力量
<十一诸行无常慎勿放逸自净其意的力量>
本章选取的经典名句是：

#quote(block: true)[
诸恶莫作，众善奉行，自净其意，是诸佛教。
]

这首偈在《增一阿含经》与《法句经》中均有相近表达，能很好地概括阿育王时代“法”的核心精神。“诸恶莫作”是停止伤害（战争、杀戮、残酷与傲慢不会因权力而变善）；“众善奉行”是主动利益众生（布施、护生、照顾弱者）；而“自净其意”则是最深的一层------不仅问“做了什么”，还要问“为什么这样做”。

一个人可能外表行善内心却追求名声，可能建塔却为了证明伟大。因此佛法要求反观内心：你的心是出于慈悲还是出于恐惧？是为了减少苦还是为了扩张自我？止恶是底线，行善是实践，净心是根本。

#horizontalrule

== 十二、常见误解：佛教是不是一开始就广泛流行？
<十二常见误解佛教是不是一开始就广泛流行>
不是。佛教在佛陀时代主要流行于恒河流域城邦，灭度后仍需与许多沙门流派与婆罗门传统共存。阿育王时代是传播史上的转折点，但佛教能持续扩大，还依靠僧团讲授、信众布施、商贸延伸、圣地记忆以及代代译解释义。

阿育王的贡献是把分散的力量大幅连接起来，使佛教获得广阔空间。但他没有替代僧人的修行，也没有保证佛法永不衰微。真正让佛法延续的，始终是有人愿意听闻、理解、实践并传给下一代。

#horizontalrule

== 结语：当战鼓变成法鼓
<结语当战鼓变成法鼓>
阿育王的一生在佛教史上像一道分界线：在他以前，佛法依靠行脚僧与地方僧团口耳相传；在他以后，佛塔、石柱、圣地与使团使佛法有了广阔清晰的网络。

他不是没有缺点的圣人，曾发动残酷战争，也始终掌握军队与权力。但他的珍贵之处正在于他不是天生完美：他让后人看到一个造成巨大伤害的人仍可能反省，一个习惯武力的统治者也能意识到长久的胜利不是让人恐惧而是减少世间的苦。后世讲述“恶阿育”到“法阿育”的转变，也是告诉每个人：过去做错的事不能假装没发生，真正的忏悔必须落实为将来行为的改变。

一座座佛塔沉默立在大地上，人们来到塔前合掌绕行，忆念觉者也忆念那位学习慈悲的国王。然而阿育王终会死去，孔雀王朝也会衰落。当护法的帝王不再存在，佛法会不会随时间衰微？后人还能不能像佛陀在世时那样修行证悟？所谓正法、像法和末法又是怎样形成的？这将是下一章要讨论的问题。

#horizontalrule

== 本章主要依据
<本章主要依据-2>
+ 阿育王石刻诏令（大岩诏、小岩诏、石柱诏）：保存阿育王关于羯陵伽之战的悔恨、信仰转变、“法”的含义、宗教宽容及社会关怀的直接记录。
+ 汉译《阿育王传》《阿育王经》及《杂阿含经》卷二十三：保存佛教传统关于阿育王转变、广建八万四千塔及护持三宝的经典叙述。
+ 巴利《大史》（Mahāvaṃsa）及《岛史》（Dīpavaṃsa）：记载阿育王时代僧团派遣长老前往各方弘法及摩哂陀赴斯里兰卡的故事。
+ 桑奇（Sanchi）与蓝毗尼（Lumbini）考古报告及研究：提供阿育王时代佛塔建构与蓝毗尼石柱巡礼的实物依据。

= 第八章　正法、像法与末法
<第八章-正法像法与末法>
#figure([
#box(image("chapters/../images/downloaded/ch08_bamiyan.jpg", width: 75.0%))
], caption: figure.caption(
position: bottom, 
[
巴米扬大佛历史照片（1933年），阿富汗（已于2001年被毁）
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


阿育王时代以后，佛教逐渐走出恒河流域，向印度各地乃至更遥远的地区传播。佛塔建立起来了，经典被不断传诵，僧团的规模也越来越大。然而，佛教徒心中始终有一个无法回避的问题：#strong[佛陀已经不在人间，佛法还能流传多久？]

佛陀在世时弟子遇到疑惑可以直接请教，僧团发生争议也可以请求裁决；佛陀涅槃之后，弟子只能依靠经教、戒律和代代相传的修行经验。随着年代久远，语言、社会、人的根性与生活方式都会改变，人们是否还能准确理解佛法？修行是否会逐渐流于形式？佛教会不会有一天只剩下寺庙、佛像和经书，却失去真正改变人心的力量？

正是在这种忧虑中，佛教逐渐形成了关于#strong[正法、像法与末法]的传统说法。它并不是简单地预言世界末日或宣告佛法失效，更准确地说，这是佛教对自身历史的一种反省：当佛陀离人间越来越遥远时，后世弟子应当怎样理解、实践和保存佛法？

#horizontalrule

== 一、佛陀不在世以后，佛法靠什么延续？
<一佛陀不在世以后佛法靠什么延续>
佛陀临近涅槃时并没有指定某一位弟子成为拥有最高权威的继承者，而是教导弟子以佛法和戒律为依止。佛法能否继续住世，最终不能只依靠某一个人，而要依靠经教的保存、戒律的奉行以及一代又一代人的真实修行。

在佛教传统中，通常用“教、行、证”三个字概括佛法流传的三个层面：“教”是佛陀留下的教法（经、律、论及义理）；“行”是依照教法实际修行（持戒、禅定、布施、念佛、观照、修慈悲）；“证”是修行之后真正断除烦恼、体悟真理、获得解脱。唐代窥基大师在《大乘法苑义林章》中用“教、行、证”解释佛法流传的三个阶段，后世据此做出最常见的概括：

#table(
  columns: 4,
  align: (center,center,center,center,),
  table.header([时期], [教法], [修行], [证悟],),
  table.hline(),
  [正法], [有], [有], [有],
  [像法], [有], [有], [渐少],
  [末法], [有], [衰微], [极难],
)
- #strong[正法时代]：教法被准确传承，有人如法修行，也有人由修行而证得圣果。
- #strong[像法时代]：“像”指佛法仍保留着类似正法的形态（经典、戒律、寺院与仪式仍在），但真正获得深刻证悟的人被认为越来越少。
- #strong[末法时代]：经典与佛法名称仍在流传，但众生烦恼深重、理解力减弱，修行容易停留在表面，教法与人的生命之间出现距离。

因此，所谓正法、像法与末法，首先不是在给佛法本身分等级。佛法所揭示的缘起、无常、苦与解脱之道不会因年代久远而改变，发生变化的是人们对佛法的理解、接受和实践能力。佛法并没有衰老，衰弱的是人对佛法的信受与奉行。

#horizontalrule

== 二、正法、像法和末法各有多少年？
<二正法像法和末法各有多少年>
关于三个时期究竟持续多少年，佛教典籍和历代祖师并没有完全一致的说法。有的传统认为“正法五百年、像法一千年、末法一万年”；也有传统主张“正法一千年、像法一千年、末法一万年”；另一些经论则只谈正法与像法。

例如吉藏大师在《中观论疏》中讨论过不同分期，窥基大师在《金刚般若经赞述》中采用“正五百、像一千、末一万”说。南北朝时期南岳慧思大师在《立誓愿文》中写道“正法住世，迳五百岁”，随后说像法一千年、末法一万年，并根据当时推算的佛灭年代认为自己生在末法初期。由于佛陀涅槃的具体年代在不同传统中本有差异，三时各自年限也有不同说法，因此“末法从哪一年正式开始”并不存在统一答案。

理解三时思想的重点不应是计算自己生活在末法第多少年，而是看见它提出的警告：#strong[年代越久，佛法越容易从生命实践变成名词、知识和仪式。]

#horizontalrule

== 三、《大集经》中的“五个五百年”
<三大集经中的五个五百年>
与正法、像法、末法密切相关的，是《大方等大集经·月藏分》所说的“五个五百年”（五五百岁），把佛陀灭度后的两千五百年分成五个阶段：

+ #strong[第一个五百年（解脱坚固）]：距离佛陀较近，亲闻佛法或承接早期传承的人较多，戒律与修行传统相对完整，因此修行者证得解脱较多。
+ #strong[第二个五百年（禅定坚固）]：直接证果者减少，佛教徒仍然重视禅定与三昧，以摄心、止观和内在修行为主要方向。
+ #strong[第三个五百年（读诵多闻坚固）]：广泛研习、讲说和读诵经典，义理阐释与注解兴盛。但若知识不能转化为实践，佛法便可能停留在文字概念中（如能熟练解释无常却无法接受失去，能谈论无我却处处维护自尊）。
+ #strong[第四个五百年（多造塔寺坚固）]：佛塔、寺院、佛像和庄严仪式大量出现。建寺造塔本身能保存经典与维系信仰，但若过于重视外在建筑而忽视内在修行，佛教便可能变得宏伟而空洞。
+ #strong[第五个五百年（斗诤坚固）]：“至后五百年，坚住于斗诤。”人们忙于宗派高下、法门优劣、传承正统与寺院利益的争论，清净善法反而被遮蔽。每个人都说自己在护持正法，却在争论中增长了傲慢、愤怒与偏见。

这段经文最令人警醒之处在于：#strong[佛法未必只会被外来力量破坏，也可能在佛教徒彼此斗争时从内部衰败。]

#horizontalrule

== 四、末法思想为什么在中国受到重视？
<四末法思想为什么在中国受到重视>
末法思想传入中国后并不是立刻成为所有佛教徒的关注中心。南北朝时期政权更替频繁、战争不断且多次遭遇毁佛事件，身处动荡中的人们很容易产生强烈感受：佛陀离人间越来越远，众生烦恼越来越重。

慧思大师在《立誓愿文》中把自己定位为末法众生，但他并没有因此放弃修行；相反，正因为感到时代艰难，他更加迫切地发愿护持佛法、修行菩萨道。这说明早期中国佛教中的末法意识不仅是悲观，也包含着强烈的责任感：正因为佛法可能衰微，所以更要有人发愿守护；正因为众生难度，所以更不能舍弃众生。

到了隋唐时期，末法思想又推动佛教各宗派思考：什么样的法门更适合烦恼深重、时间有限、能力普通的后世众生？有人强调忏悔，有人提倡持戒，有人重视禅定，也有人认为应当依靠佛菩萨的愿力，这些思考成为了中国佛教宗派形成的重要思想背景。

#horizontalrule

== 五、道绰大师与净土法门
<五道绰大师与净土法门>
在末法思想的发展中，净土宗道绰大师（南北朝末至唐初）是一个关键人物。他看到佛陀离世久远、众生烦恼深重，若仅凭自力断惑证真极为困难，因此在《安乐集》中把修行概括为两条道路：一是依靠自力戒定慧断惑证真的“圣道门”，二是信受阿弥陀佛本愿往生净土继续修行的“净土门”。

道绰引《大集月藏经》意指出：“末法时代，亿亿众生起行修道，未有一人得者；唯有净土一门，可通入路。”他的意思并不是否定其他法门，而是强调“时”与“机”必须相应------法门虽然高深，如果普通人无法实践就很难成为现实中的解脱道路；净土法门依靠佛力愿力，门槛较平易，更适合后世众生。这一思想后来被善导大师进一步继承发展，对中国净土宗产生了深远影响。

#horizontalrule

== 六、末法是不是意味着修行已经没有用了？
<六末法是不是意味着修行已经没有用了>
这是理解末法思想时最容易产生的误解。如果末法时代没人能修行，历代祖师为何还要讲经持戒、参禅念佛？事实恰恰相反，经典在谈到后世衰微时，常常鼓励后世仍有人护持佛法。

《金刚经》中须菩提询问后世是否还有人能信受般若深义，佛陀回答后世仍会有“持戒修福者”能生真实信心。这说明末法并不等于善法彻底消失，也不等于再没有真诚的修行人。越是在混乱与怀疑盛行的时代，能持戒修福、闻法反省的人越显得难能可贵。

“难以证悟”和“绝对不能修行”并不是一回事。普通人也许无法短时间断尽烦恼，但仍然可以少一些贪嗔、少说伤人的话、多做利益他人的事；仍然可以观察无常、练习放下执著。只要一个人愿意依照佛法调整言行与心念，佛法就还没有离开人间。

#horizontalrule

== 七、末法也可能成为一种危险的借口
<七末法也可能成为一种危险的借口>
末法思想能提醒人谦卑，也可能被误用： 1. #strong[把问题归咎于时代]：“现在是末法，大家都做不到，所以我做不到也很正常。”懒惰被解释为根器浅薄，不愿改变却被包装成清醒认识。 2. #strong[借末法制造恐惧]：宣称世界即将毁灭，只有加入特定团体或供养个人才能得救，把佛法变成控制他人的工具。 3. #strong[以护法之名进行斗争]：坚信自己掌握唯一正法，把不同意见者视为外道，在争论中增长仇恨。

这正是末法思想最深刻的反讽：#strong[人越急于证明别人处在末法，越可能没有看见自己心中的末法。] 真正的护法不是保卫宗派名声，而是保护戒律、慈悲、智慧与不伤害众生的精神。

#horizontalrule

== 八、末法不是宇宙的判决，而是一面照心的镜子
<八末法不是宇宙的判决而是一面照心的镜子>
正法、像法与末法更像是佛教为自己设置的一套警报系统：当佛法能帮助人减少烦恼增长慈悲，教法就在生命中发挥作用；当人只会讨论佛法却不依教奉行，便开始进入“像”的状态；当佛教只剩身份、仪式与争执而失去改变人心的力量，末法就是此刻正在发生的现实。

这三个状态甚至可能同时存在：同一个时代、同一座寺院甚至同一个人的生命中，都可能一时真心修行，一时流于形式，一时陷入争执。每当我们远离慈悲、戒律与智慧时，末法就在心中发生；每当我们重新反省自己、止恶行善时，正法也就在这一念中重新出现。

#horizontalrule

== 九、普通人应当怎样面对末法时代？
<九普通人应当怎样面对末法时代>
面对末法，佛教给出的答案不是绝望，而是从自己能做到的地方开始：不必先判断别人对不对，可以先少说一句刻薄的话；不必先争论哪种法门最高，可以先诚实面对自己的烦恼；不必等到通晓经典才开始行善持戒。

我们距离佛陀已经遥远，更需要珍惜听闻佛法的机会；外界诱惑繁多，更需要守护自己的心；人与人容易争斗，更需要学习慈悲与忍耐。慧思大师与道绰大师面对末法时代并没有放弃，而是重新寻找切合时机的修行起点。

#horizontalrule

== 结语：佛法会不会消失？
<结语佛法会不会消失>
佛法是否住世，不只取决于寺院还有多少、佛像是否庄严，更取决于是否还有人愿意把佛法落实在生命中。只要还有人在愤怒中学习克制，在痛苦中观察无常，在利益面前守住良知，正法就仍然以某种方式活在人间。

相反，若经典被高供却无人实践，寺院金碧辉煌却彼此争夺，那么即使外在形式繁荣，也只是“像法”的壳子。正法、像法与末法不仅是在谈论历史，更是在追问每一个修行者：你所理解的佛法，究竟只是一个名称、一种形式，还是已经成为你对待世界的方式？

佛陀虽然已经涅槃，但佛法是否仍在人间，并不完全由年代决定，它也取决于今天的我们。

#horizontalrule

== 本章主要依据
<本章主要依据-3>
+ 《大方等大集经》卷五十五《月藏分》：保存“五个五百年”（解脱、禅定、读诵多闻、多造塔寺、斗诤坚固）的传统分期与末法衰微叙事。
+ 唐·窥基《大乘法苑义林章》卷六《三时章》：以“教、行、证”三要素系统解释正法、像法与末法的区别及判定标准。
+ 唐·道绰《安乐集》卷上：引《大集经》意说明末法时代众生修道之难，并据此提出“圣道门”与“净土门”的分判。
+ 南朝·慧思《立誓愿文》：反映中国早期佛教徒的末法危机意识与护法发愿。
+ 《金刚般若波罗蜜经》：佛陀关于后世“持戒修福者”能生真实信心的教诫。

#part[第三部：大乘兴起——从自我解脱到众生共度]
= 第九章　大乘佛教为什么兴起？菩萨道与佛菩萨群像
<第九章-大乘佛教为什么兴起菩萨道与佛菩萨群像>
#figure([
#box(image("chapters/../images/downloaded/ch09_guanyin.jpg", width: 70.0%))
], caption: figure.caption(
position: bottom, 
[
宋代彩绘木雕观音菩萨坐像，大都会艺术博物馆藏
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


在中国寺院里，人们最熟悉的往往不是佛教史上的某次结集，也不是某一部深奥论典，而是一张张慈悲庄严的面容。有人在观音菩萨像前倾诉苦恼，有人在地藏菩萨像前追思亲人，有人仰望文殊菩萨，祈愿增长智慧；普贤菩萨骑着白象，象征愿行广大；弥勒菩萨笑口常开，仿佛在提醒世人：未来仍然值得期待。

这些菩萨为什么会出现在佛教中？佛陀不是已经讲过四圣谛、八正道和涅槃了吗？为什么在佛陀灭度数百年后，佛教又逐渐出现了般若、菩萨道、六度、净土以及众多佛菩萨信仰？所谓“大乘”，是不是另外创立了一种与早期佛教完全不同的宗教？要理解这些问题，需要从一个人面对众生苦难时产生的愿望说起。

这个愿望是：

#strong[我不仅希望自己离苦，也希望一切众生都能离苦；我不仅追求个人的解脱，还愿意学习佛陀，走完通往圆满觉悟的道路。]这就是菩萨心的开始。

#horizontalrule

== 一、大乘佛教不是在某一天突然诞生的
<一大乘佛教不是在某一天突然诞生的>
佛教史上并没有一个确切的日子，可以被称为“大乘佛教成立日”。大乘也不是由某位祖师召集众人，另立教团、重新制定戒律后创立的。现代学术研究对于大乘佛教究竟起源于什么地区、什么群体，仍有不同意见。比较稳妥的说法是：在公元前后数百年间，印度不同地区的佛教修行者，围绕成佛理想、菩萨实践和新的经典传统，逐渐形成了多条相互联系而又不完全相同的发展路线。

早期大乘修行者也未必与其他佛教僧人截然分开。他们可能生活在同一座寺院，遵守相同或相近的部派戒律，只是在所诵持的经典、所发的誓愿和所追求的修行目标上有所不同。因此，与其把大乘想象成一次突然的“宗派分裂”，不如把它理解为佛教内部逐渐兴起的一种新愿景。现代研究也越来越倾向于使用“大乘运动”或“多种大乘传统”这样的说法，而不是把它看作一个从一开始便组织严密、教义完全统一的宗派。

东汉时期，来自西域的译经僧支娄迦谶已经在洛阳翻译《道行般若经》《般舟三昧经》等大乘经典。这说明到公元二世纪，大乘经典及其修行传统已经形成，并开始向中国传播。但这些经典在印度的酝酿和流传，显然还要更早。印顺法师在研究初期大乘佛教时，曾作出一个简明而重要的判断：

#quote(block: true)[
“菩萨行人的出现，就是大乘佛法的兴起。”
]

也就是说，大乘佛教最根本的标志，不是寺院里多供奉了几尊菩萨，也不是经典中出现了多少神奇世界，而是现实中出现了一批愿意发心成佛、长期实践菩萨道的人。

#horizontalrule

== 二、“大乘”的“大”，大在哪里？
<二大乘的大大在哪里>
“乘”，原意是车乘，可以把人从一个地方运送到另一个地方。佛教借用这个比喻，把教法称为“乘”：众生依教修行，如同乘车渡过生死苦海，到达解脱彼岸。“大乘”的“大”，首先体现在愿心广大。修行者不只问：“我怎样才能从烦恼中解脱？”还会进一步追问：

“既然我知道烦恼与生死是苦，其他众生也同样在苦中，我能不能在自己修行的同时，也帮助他们离苦？”其次，大乘所追求的目标是圆满成佛。在大乘经典中，菩萨不仅希望断除个人烦恼，还希望像释迦牟尼佛一样，圆满智慧与慈悲，具备教化众生的能力。因此，菩萨所追求的不只是“我获得安宁”，而是“我应当成就足以利益众生的智慧和德行”。

不过，这并不意味着早期佛教或声闻修行缺少慈悲，更不意味着追求个人解脱就是自私。佛陀时代的教法本来就包含慈、悲、喜、舍，也强调布施、持戒与利益他人。大乘真正改变的，是对最高修行理想的强调：佛陀过去所走过的成佛之路，不再只是释迦牟尼佛个人遥远的往事，而被进一步理解为所有人都可以发愿学习的道路。

从这个意义上说，大乘不是简单地否定原有佛法，而是在四圣谛、缘起、无常、无我和八正道的基础上，把佛陀因地修行的菩萨精神进一步展开。

#horizontalrule

== 三、从佛陀的过去生，到人人可以走的菩萨道
<三从佛陀的过去生到人人可以走的菩萨道>
在早期佛教中，“菩萨”主要指释迦牟尼佛尚未成佛以前的身份。悉达多太子在菩提树下成道以前是菩萨；佛陀在久远过去世中修行布施、忍辱、慈悲时，也被称为菩萨。各种本生故事讲述的，正是佛陀在过去生中如何积累福德与智慧。随着大乘佛教兴起，“菩萨”这个名称的范围发生了重要变化。

它不再只属于成佛以前的释迦牟尼，也不再只是遥远传说中的圣者。任何人，只要真正发起求成佛道、利益众生之心，并开始依此修行，就可以称为菩萨道的学习者。这是一种极为深刻的转变。过去，人们仰望佛陀，可能会觉得佛陀伟大而遥远；大乘佛教则进一步告诉人们：佛陀所走过的路虽然漫长艰难，却并非完全不可学习。菩萨不是天生的神灵，而是从发心开始，在一次次选择中逐渐成长的人。

当然，初发心的普通人与文殊、观音等大菩萨，在智慧和修行境界上相差极远。但他们所朝向的方向是一致的：上求佛道，下化众生。因此，“菩萨”既可以指已经具有高深智慧和广大功德的大菩萨，也可以指刚刚发起菩提心、开始学习菩萨行的人。它首先是一个修行身份，而不是神仙世界中的固定官阶。

#horizontalrule

== 四、菩提心：菩萨道的第一步
<四菩提心菩萨道的第一步>
一个人为什么要成佛？如果只是为了自己比别人更高、更有能力，甚至为了得到神通、名望和供养，这仍然没有离开贪著。大乘佛教所说的成佛之心，是为了使自己具备真正利益众生的智慧与能力。这样的心被称为“菩提心”。“菩提”就是觉悟。菩提心可以简要理解为：

#strong[愿成就无上觉悟，以利益一切众生。]它同时包含两个方向：

一是向上求取佛陀的智慧；二是向下关怀仍在苦难中的众生。只有慈悲而没有智慧，可能因为不了解因缘而好心办坏事；只有智慧而缺少慈悲，又可能把佛法变成冷漠的哲学。菩提心把二者结合起来：因为看见众生之苦，所以愿意成佛；因为知道自己仍有烦恼和无明，所以必须不断修学。

中国佛教常用“四弘誓愿”表达这种精神：

#quote(block: true)[
众生无边誓愿度，
]

#quote(block: true)[
烦恼无尽誓愿断，
]

#quote(block: true)[
法门无量誓愿学，
]

#quote(block: true)[
佛道无上誓愿成。
]

这一完整而固定的汉语表达，是中国佛教在长期修行仪轨中逐渐形成的。天台智者大师的著作已将四弘誓愿与苦、集、灭、道四圣谛联系起来：因为看见众生之苦，所以发愿度众生；因为知道烦恼是苦的根源，所以发愿断烦恼；因为离苦需要道路，所以发愿学法门；因为究竟解脱即是圆满觉悟，所以发愿成佛道。

这里的“度”，不是把众生当作没有能力的人，强行拖到彼岸；而是帮助众生认识苦因、增长智慧，最终获得自主离苦的能力。发愿也不是一句豪言壮语。真正的愿，必须落实到行为中。一个人每天诵念“众生无边誓愿度”，却对家人的痛苦毫不关心，对同事的困难冷眼旁观，这个愿就仍然停留在声音里。菩提心虽然广大，却总要从眼前的一人一事开始。

#horizontalrule

== 五、六度：菩萨怎样把愿望变成道路？
<五六度菩萨怎样把愿望变成道路>
只有慈悲的愿望，还不能完成菩萨道。看见别人受苦时，我们可能会一时感动；但真正帮助众生，需要品格、耐心、判断力和长期训练。大乘佛教把菩萨修行的主要内容概括为“六波罗蜜”，汉语通常称为“六度”。“波罗蜜”有到彼岸、成就、圆满之意。六度就是六类帮助修行者越过烦恼、趋向觉悟的实践：

#strong[布施、持戒、忍辱、精进、禅定、般若。]这一体系在般若类经典、《大智度论》及众多大乘经论中被反复阐释。

=== 1. 布施：松开紧抓不放的手
<布施松开紧抓不放的手>
布施不仅是捐钱。给予食物、药品和财物，是财布施；把知识、经验和正确方法分享给别人，是法布施；在他人恐惧无助时给予安慰和保护，是无畏施。布施首先对治的是悭贪。人总想把财富、时间、名声乃至感情紧紧抓住，仿佛拥有得越多，自己便越安全。但抓得越紧，害怕失去的心也越强。布施不是轻视财富，而是学习不被财富占有。

现代人的布施，可以是一笔善款，也可以是认真听一个孤独的人说话；可以是把专业知识教给年轻人，也可以是在公共空间中给别人多留一点方便。

=== 2. 持戒：不让自己的自由成为别人的灾难
<持戒不让自己的自由成为别人的灾难>
戒律常被误解为外在约束。但从菩萨道看，持戒首先是对他人负责。因为自己的贪欲、愤怒和冲动可能伤害别人，所以愿意约束身口意，不杀害、不欺骗、不侵占、不滥用关系，也不让一时情绪破坏长期信任。真正的自由不是“想做什么就做什么”，而是有能力不被欲望牵着走。

菩萨持戒，也不是为了证明自己比别人清净，而是为了使他人能够安心接近自己。一个诚实、稳重、不伤害他人的人，本身就是他人安全感的来源。

=== 3. 忍辱：有力量承受，却不让仇恨继续扩散
<忍辱有力量承受却不让仇恨继续扩散>
忍辱不是软弱，更不是要求受害者默默接受伤害。佛教所说的忍，包括面对误解与冒犯时不立即被愤怒控制，面对疾病与挫折时不轻易崩溃，以及面对深奥佛法时愿意耐心思考。忍辱不是没有立场，而是在维护正义时，尽量不让仇恨占领自己的心。愤怒有时能提醒我们不公正在发生，但若完全被愤怒支配，人便容易复制自己所反对的伤害。忍辱使人能够在行动之前看清：什么是真正有效的回应，什么只是情绪的报复。

=== 4. 精进：把一时感动变成长久行动
<精进把一时感动变成长久行动>
许多人在听闻佛法或经历重大事件时，会短暂生起善心。但热情退去以后，旧习惯又会回来。精进就是不断使善法增长，使已经生起的善心不轻易退失。它不是焦虑地逼迫自己，也不是与别人比较修行进度，而是知道方向以后，持续前行。今天少说一句伤人的话，明天多完成一件应尽的责任，后天再改掉一个长期习惯------这也是精进。

=== 5. 禅定：让散乱的心重新获得安住能力
<禅定让散乱的心重新获得安住能力>
现代人的心常被消息、声音、欲望和担忧不断拉扯。心若始终散乱，即使想帮助别人，也容易被情绪带走；即使懂得很多道理，遇到事情时仍然无法运用。禅定不是把头脑变成空白，而是训练心保持清明、稳定和专注。能够看见情绪生起而不立即跟随，能够把注意力带回当下，才能在复杂处境中作出较为明智的判断。

=== 6. 般若：看见事物真实的因缘关系
<般若看见事物真实的因缘关系>
般若常被译为智慧，但它不只是知识丰富或头脑聪明。世间的聪明可以帮助人赢得竞争，也可能被用来欺骗和控制他人。般若所要看见的，是无常、无我、缘起与空性：世间没有任何事物可以脱离因缘而独立存在，也没有一个永恒不变、完全由自己控制的“我”。六度并不是六件彼此分开的善事。

没有布施，慈悲容易停留在口头；没有持戒，善意可能伴随伤害；没有忍辱，遇到阻力便会退转；没有精进，修行难以持续；没有禅定，内心无法稳定；没有般若，前五度又可能变成对功德、名声和自我形象的执著。《大乘本生心地观经》强调，修行若能导向无上菩提，才可称为真实的波罗蜜。换句话说，同样一次布施，若只是为了炫耀财富，虽然也可能帮助别人，却还不是圆满的菩萨行；若以清净愿心利益众生，又能减少对“我做了好事”的执著，才逐渐具有波罗蜜的意义。

#horizontalrule

== 六、慈悲与智慧：菩萨道的两只翅膀
<六慈悲与智慧菩萨道的两只翅膀>
大乘佛教最常被提及的两个词，是慈悲与智慧。慈，是希望众生获得安乐；悲，是看见众生受苦而愿意帮助其离苦。慈悲不是居高临下的怜悯，而是承认自己与众生同样受到无常、欲望、恐惧和死亡的逼迫。智慧则使人看见：众生所受的苦不是无缘无故出现的，它由许多条件共同形成。真正解除痛苦，不能只处理表面，还要认识背后的因缘。

印顺法师曾把智慧与慈悲称为佛法的根本，并指出二者都建立在缘起的觉悟上。因为一切众生相互依存，所以他人的痛苦不可能与我毫无关系；也因为一切事物依因缘而生，所以痛苦并非永恒固定，仍有改变的可能。慈悲告诉我们不能抛下众生，智慧则告诉我们怎样帮助才不至于制造新的执著。

因此，菩萨道既不是只有热情的善行，也不是远离人间的抽象思辨。它要求修行者一面走入众生的苦难，一面不被贪爱、愤怒和偏见淹没。

#horizontalrule

== 七、“色即是空”：空不是什么都没有
<七色即是空空不是什么都没有>
在大乘佛教中，最容易被误解的概念是“空”。《心经》说：

#quote(block: true)[
“色即是空，空即是色。”
]

许多人据此认为，佛教是在说世界不存在，人生没有意义，善恶也都无所谓。这种理解恰好与般若思想相反。“空”所否定的，不是事物的现象和作用，而是事物具有一种不依条件、永远固定不变的自性。一只杯子由泥土、工匠、火候、运输、购买和使用等条件共同成就。离开这些条件，并不存在一个独立永恒的“杯子本体”。但正因为杯子是因缘所成，它才能被制造、使用、打碎和重新利用。

人也是如此。我们的性格、观念和情绪由身体、家庭、教育、社会经验及当下环境共同形成。它们不是毫无作用，却也不是永远无法改变的实体。一个人若认定“我天生就是这样，永远不可能改变”，便把暂时形成的状态误认为固定自性。龙树菩萨在《中论》中把缘起与空直接联系起来：

#quote(block: true)[
“众因缘生法，我说即是空。”
]

因为一切依因缘而生，所以没有独立不变的自性；因为没有固定自性，所以新的因缘可以带来新的变化。空不是虚无，反而是转变得以发生的条件。因此，“色即是空”不是让人否定现实，而是让人不再把眼前的得失、身份和情绪看成不可改变的绝对存在。“空即是色”则提醒人们，空性并不在现实世界之外。真正理解空，不是逃到一个什么都没有的地方，而是在每一种具体事物中，看见它由因缘和合而成。

空性使智慧不再执著，慈悲使空性不落冷漠。若只说众生皆空，于是对他们的痛苦漠不关心，那并不是真正的般若；若执著众生和自我都是永恒实体，又很容易在帮助中产生控制、占有和疲惫。菩萨以空性放下执著，却以慈悲承担责任。

#horizontalrule

== 八、佛菩萨群像：五种照亮人心的力量
<八佛菩萨群像五种照亮人心的力量>
随着大乘佛教发展，经典中出现了众多菩萨形象。这些菩萨并不是把印度原有的神祇简单搬进佛教，也不能只被理解为分管智慧、健康、财富和亡灵的“神仙部门”。他们首先体现菩萨道的不同面向，使抽象的慈悲、智慧和愿力，转化为可以被人理解、礼敬和学习的具体形象。

=== 1. 文殊菩萨：智慧不是聪明，而是不被成见遮蔽
<文殊菩萨智慧不是聪明而是不被成见遮蔽>
文殊师利，又称文殊菩萨、妙吉祥菩萨，在大乘佛教中常被视为般若智慧的象征。在《维摩诘经》中，文殊菩萨与维摩诘居士展开了一场著名问答。文殊问：“菩萨云何观于众生？”维摩诘以幻人、水中月、镜中像等譬喻作答，说明菩萨既要知道众生与诸法没有固定自性，又不能因此舍弃慈悲。

文殊所象征的智慧，不是处处争赢，也不是懂得许多艰深名词。真正的智慧首先愿意承认：“我的看法可能并不完整。”人与人发生冲突时，双方往往都把自己的角度当作唯一事实。文殊的智慧提醒人们，先放下坚固成见，重新观察事情由哪些条件造成。能够看见因缘，才可能找到超越对立的出路。

佛教造像中的文殊常持智慧剑。这把剑不是用来伤害众生，而是斩断无明与执著。它所斩断的，正是“我一定正确”“事情只能如此”“这个人永远不会改变”等僵硬判断。

=== 2. 普贤菩萨：再宏大的愿，也要落实为行动
<普贤菩萨再宏大的愿也要落实为行动>
如果说文殊象征智慧，普贤菩萨则特别象征实践与行愿。“普”是普遍，“贤”是善德。普贤行意味着所行善法不只针对少数亲近之人，而要逐渐扩展到一切众生。《华严经·普贤行愿品》提出“十种广大行愿”，从礼敬诸佛、称赞如来、广修供养开始，进一步包括忏悔、随喜、请法、请佛住世、随学佛行、恒顺众生和普皆回向。

这些愿看似宏大，其实都可以在日常中开始。礼敬诸佛，可以从尊重每个人觉悟的可能开始；称赞如来，可以转化为学习看见他人的善意与长处；忏悔业障，不只是仪式中的自责，而是承认过失并认真改正；随喜功德，则是看见别人成功时，不让嫉妒吞没自己的心。“恒顺众生”也不是无原则地迎合所有欲望。真正的顺，是理解众生的处境和根器，以对方能够接受的方式给予帮助，同时不违背正法。

普贤菩萨提醒人们：愿望若不进入行动，就仍然只是想象；行动若没有广大愿心，又容易局限于个人得失。

=== 3. 观音菩萨：听见世间的声音
<观音菩萨听见世间的声音>
观世音菩萨是汉传佛教中最广为人知的菩萨之一。“观世音”可以理解为观察世间众生的音声。《法华经·观世音菩萨普门品》说，众生若在苦恼中忆念观世音菩萨，菩萨即观其音声，使其得到解脱。无论人们如何理解经典中的感应，观音信仰所表现的核心精神都非常明确：#strong[众生发出的痛苦声音，应当被听见。]

很多时候，人并非完全没有解决问题的能力，只是从来没有人真正听他说话。听见，并不等于立即评价；慈悲，也不等于匆忙说教。一个人遭遇失去和创伤时，最先需要的往往不是“你应该想开一点”，而是有人愿意陪伴他，不逃避他的眼泪。观音菩萨有三十三应、千手千眼等不同形象。千眼象征看见众生不同的苦，千手象征用不同方法给予帮助。慈悲不是只有一种固定形式：面对饥饿者，应先给予食物；面对无知者，可以给予教育；面对恐惧者，需要给予保护；面对执迷者，有时则需要坚定而善巧的劝诫。

《心经》的开头也是“观自在菩萨”修行甚深般若，照见五蕴皆空。由此可见，观音所代表的慈悲并不离开般若智慧；真正自在，也不是离开众生，而是在帮助众生时不被执著束缚。

=== 4. 地藏菩萨：最幽暗的地方，也不轻易舍弃
<地藏菩萨最幽暗的地方也不轻易舍弃>
地藏菩萨常出现在墓园、超荐法会和追思亡者的场合，因此很多人以为地藏菩萨只与死亡和地狱有关。事实上，地藏信仰的核心不是死亡，而是#strong[对最苦难众生的不舍弃]。《地藏菩萨本愿经》中，地藏菩萨在过去世发愿，要为受苦众生广设方便：

#quote(block: true)[
“尽令解脱，而我自身，方成佛道。”
]

后世广为流传的“地狱不空，誓不成佛；众生度尽，方证菩提”，正是对这类本愿精神的凝练概括，但并非《地藏菩萨本愿经》中逐字出现的完整原句。这一区分很重要。尊重传统，不等于把所有流行语都说成佛经原文。流行语虽然准确表达了地藏菩萨的广大愿力，引用时仍应说明它是后世概括。

“地藏”二字，也富有象征意义。大地承载万物，不因污秽而拒绝；宝藏深埋地下，等待被发现。《地藏十轮经》传统以“安忍不动，犹如大地”形容地藏菩萨的德行。地藏菩萨的愿，尤其面向容易被世人放弃的众生：造下重业者、堕入恶趣者、身处幽暗痛苦者。其精神不是纵容恶行，而是认为即使一个人犯过严重错误，也不应被永远判定为毫无改变可能。

《地藏菩萨本愿经》中又有女子为救母亲而发愿修行的故事，使地藏信仰与中国重视孝亲、追荐亡者的文化紧密结合。但若只把地藏菩萨理解为“管理亡者的菩萨”，便缩小了地藏愿力。凡是被遗忘、被排斥、被认为无可救药的地方，都是地藏精神所面对的地方。

=== 5. 弥勒菩萨：未来仍有成佛与改善的可能
<弥勒菩萨未来仍有成佛与改善的可能>
弥勒菩萨是佛教传统中的未来佛。依弥勒经典的说法，弥勒菩萨现在居于兜率天，将在遥远未来降生人间、修行成佛，并再次宣说佛法。因此，弥勒信仰包含着鲜明的未来希望：释迦牟尼佛虽然已经入灭，佛法与觉悟的可能并未永远终止。但中国寺院天王殿里那尊袒胸露腹、笑口常开的“弥勒佛”，与印度早期头戴宝冠、庄严端坐的弥勒菩萨形象很不相同。

这尊笑佛的直接原型，是中国五代时期的布袋和尚契此。布袋和尚体态丰满，常背布袋游行民间。后世相传他是弥勒菩萨的化身，布袋和尚的形象便逐渐与弥勒信仰融合，形成中国佛教特有的笑弥勒形象。日本国立文化财机构所藏南宋至元代《布袋图》，也明确说明布袋和尚被视为弥勒佛化身而受到信众爱戴。

因此，笑呵呵的弥勒并不是说修行只要乐观开怀，更不是鼓励对一切问题一笑置之。他的笑容包含的是宽容与希望：能够容纳人与事的不圆满，不因眼前黑暗便断定未来没有光明。弥勒代表的未来，也不能只是被动等待。真正期待未来佛的人，应当从现在开始种下未来的因。今天少一点仇恨，多一点善意；少一点欺骗，多一点诚信，便是在为较好的未来准备条件。

#horizontalrule

== 九、菩萨是不是“比佛低一级的神仙”？
<九菩萨是不是比佛低一级的神仙>
这是大众理解佛教时最常见的误区之一。从成佛过程来看，佛是已经圆满觉悟者，菩萨是发愿成佛并修行菩萨道者。因此，若只从修行是否圆满而言，尚未成佛的菩萨当然仍在道路上。但这不等于佛教中存在一个类似世俗官僚体系的固定神仙等级：佛最高，菩萨次之，罗汉再次之，然后各自管理不同事务。

首先，“菩萨”所涵盖的范围很广。刚刚发心的普通修行者可以称为初发心菩萨；文殊、普贤、观音、地藏等，则是在大乘经典中具有不可思议功德的大菩萨。其次，佛菩萨受到礼敬，不只是因为他们“权力很大”，而是因为他们体现了值得学习的觉悟与德行。礼拜文殊，是提醒自己学习智慧；礼拜观音，是训练自己听见苦难；礼拜地藏，是不轻易舍弃幽暗处的众生；礼拜普贤，是让愿望成为行动；礼拜弥勒，是保持对未来的信心。

若只求菩萨替自己消灾，却不愿学习菩萨的慈悲与行为，便容易把佛教信仰变成单方面索取。

#horizontalrule

== 十、菩萨为什么还要成佛？
<十菩萨为什么还要成佛>
有人会问：菩萨既然已经如此慈悲，为什么还要追求成佛？留在人间帮助别人不就可以了吗？这个问题背后，常有一种流行说法：菩萨为了救度众生，故意“推迟成佛”或“拒绝涅槃”。这种表达虽然容易理解，却不够准确。菩萨发愿成佛，正是因为只有圆满断除无明、具足智慧与方便，才能最充分地利益众生。成佛不是离开众生的私人奖赏，而是菩萨道的圆满。

菩萨不急于只求个人寂静，也不执著某种与世界完全隔绝的安乐；但这并不意味着菩萨拒绝觉悟。相反，菩萨必须不断增长智慧，因为没有智慧的帮助十分有限；也必须不断净化烦恼，因为一个仍被贪嗔痴完全控制的人，很难长久利益别人。因此，菩萨道不是在“自我修行”和“帮助别人”之间二选一。

修正自己，是为了不把自己的烦恼传给别人；利益别人，也使自己的修行不落入自我中心。二者相互成就。

#horizontalrule

== 十一、普通人怎样开始学习菩萨道？
<十一普通人怎样开始学习菩萨道>
面对“众生无边誓愿度”这样的宏愿，普通人很容易感到遥远。我们连自己的情绪都未必能够处理，又怎么可能度尽众生？其实，菩萨道从来不是要求初学者在一天之内完成无量功德。它只是要求我们改变人生的基本方向：不再只围绕“我得到什么、我失去什么”生活，而开始把他人的安乐也纳入自己的选择。

当你准备说一句伤人的话时，愿意先停一下，这是持戒。当别人取得成就时，能够放下嫉妒，真心随喜，这是普贤行。当亲友痛苦时，不急着指责，而是认真倾听，这是观音行。当遇见被排斥的人，不立刻把他判定为无可救药，这是地藏行。当固有观念受到挑战时，愿意重新观察因缘，这是文殊行。

当现实不如人意，却仍愿意为更好的未来播种，这是弥勒行。当自己有能力时，愿意分享时间、财富与知识，这是布施。当善意受到误解，仍然不让仇恨占领内心，这是忍辱。菩萨不一定站在云端。菩萨道常常开始于一个极普通的瞬间：一个人本可以只顾自己，却愿意为另一个生命多想一步。

#horizontalrule

== 十二、大乘真正扩大的，是人的心量
<十二大乘真正扩大的是人的心量>
大乘佛教的兴起，为佛教世界带来了大量经典、哲学体系、佛菩萨形象和修行方法。《般若经》深入讨论空性与智慧；《心经》用极短篇幅凝聚般若精义；《金刚经》教人不住于相而行布施；《法华经》赞叹一切众生成佛的可能，并展开观世音菩萨的慈悲救度；《华严经》呈现广大菩萨行与普贤愿海；《地藏菩萨本愿经》和《大乘大集地藏十轮经》彰显不舍恶趣众生的深愿。

这些经典内容丰富，思想也并不完全相同，但它们共同指向一种精神：

#strong[觉悟不能只停留在个人内心，智慧必须转化为慈悲，慈悲必须落实为行动。]大乘的“大”，并不是自称比别人优越，也不只是寺院规模大、经典数量多、佛菩萨形象丰富。它真正要扩大的，是人的心量。当一个人只看见自己的得失，世界便狭窄得只剩下一个“我”；当他开始看见众生与自己一样渴望安乐、畏惧痛苦，生命的边界便逐渐打开。

大乘佛教并不要求每个人一开始就成为伟大的圣者。它只是把一个问题放在我们面前：

#strong[在这个充满无常与苦难的世界里，我愿意只求自己脱身，还是愿意在走向光明时，也为别人留下一盏灯？]菩萨道，便从这盏灯开始。

#horizontalrule

== 本章经典辨析
<本章经典辨析>
=== 一、“众生无边誓愿度”
<一众生无边誓愿度>
这是中国佛教“四弘誓愿”的第一愿，集中表达菩萨普度众生的愿心。其固定汉语形式见于中国佛教祖师的教义整理和修行仪轨，不宜简单说成某一部早期印度经典中的单独原句。

=== 二、“地狱不空，誓不成佛”
<二地狱不空誓不成佛>
这句话准确概括了地藏菩萨不舍恶趣众生的本愿精神，但并非现行《地藏菩萨本愿经》的逐字原文。经中相近原文为：

#quote(block: true)[
“尽令解脱，而我自身，方成佛道。”
]

正式出版时宜写作“后世常以‘地狱不空，誓不成佛'概括地藏菩萨的本愿”，以避免把流行概括误作经文原句。

=== 三、“色即是空，空即是色”
<三色即是空空即是色>
“空”不是不存在，而是没有脱离因缘、固定不变的自性。正因为一切法缘起性空，现实中的改变、修行与解脱才有可能。

#horizontalrule

== 本章主要参考经典与著作
<本章主要参考经典与著作>
本章历史部分主要参考印顺法师《初期大乘佛教之起源与开展》《印度佛教思想史》，并综合现代学界关于早期大乘具有多中心、多路线特征的研究。菩萨道、六度与空性部分，主要依据《般若波罗蜜多心经》《摩诃般若波罗蜜经》《大智度论》《中论》《法界次第初门》及印顺法师《中观今论》。

佛菩萨群像部分，主要依据《维摩诘所说经》《妙法莲华经·观世音菩萨普门品》《大方广佛华严经·普贤行愿品》《地藏菩萨本愿经》《大乘大集地藏十轮经》及《佛说弥勒下生经》。#strong[排印说明：本章佛典引文为便于普通读者阅读，统一按现代简体字和通行标点排印。]

= 第十章　阿弥陀佛与净土法门
<第十章-阿弥陀佛与净土法门>
#figure([
#box(image("chapters/../images/downloaded/ch10_pureland.jpg", width: 85.0%))
], caption: figure.caption(
position: bottom, 
[
极乐净土变相图（8世纪中叶），敦煌莫高窟第172窟主室北壁
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


暮色降临，寺院的晚钟缓缓响起。大殿里，僧众合掌念诵；山门外，一位老人一边走路，一边低声念着：“南无阿弥陀佛。”这句佛号，中国人实在太熟悉了。在寺院的早晚课中，在乡村老人的念珠间，在临终者的床前，在亲人送别亡者的诵念声里，人们都可能听见它。即使从未系统接触过佛教，许多人也知道“阿弥陀佛”四个字。它有时是问候，有时是祝愿，有时是面对无常时的一声安慰，有时又成为一个人终身坚持的修行。

可是，阿弥陀佛究竟是谁？极乐世界是不是佛教所说的天堂？念一句佛号，真的就能解决生死问题吗？如果净土法门只教人等待来世，它是不是一种逃避现实的信仰？为什么这样一个看似简单的法门，能够跨越地域、阶层与时代，流传一千多年，成为汉传佛教中影响最广泛的修行方式之一？

要理解这一切，必须先回到一个关于愿心的故事。

#horizontalrule

== 一、从法藏比丘的四十八愿说起
<一从法藏比丘的四十八愿说起>
净土经典中的阿弥陀佛，并不是一开始就以佛的身份出现的。按照《无量寿经》的叙述，在极其久远的过去，有一位国王听闻世自在王佛说法，心中生起了强烈的出离心与菩提心。他舍弃王位，出家修行，法名“法藏”。法藏比丘并不只想自己得到解脱。他看到众生在生死中流转：有人贫穷困苦，有人身体残缺，有人长期被贪欲、愤怒和恐惧控制；有人虽然想修行，却生在缺少佛法的地方；有人稍有进步，又因环境恶劣、烦恼深重而退转。于是，他产生了一个宏大的愿望：建立一个清净安稳的国土，使来到那里的人不再被恶劣环境逼迫，能够亲近佛法，继续修行，直至觉悟。

为了知道什么样的国土最适合众生修行，法藏比丘观察、思惟无数佛国的优点与不足，经过长久修学，最终在世自在王佛面前发下四十八大愿。这些愿望涉及的内容十分广泛：国中没有恶道，没有贫富贵贱造成的歧视；众生具有良好的身心条件，能够听闻佛法；来到这个国土的人不再轻易退失修行之心；十方众生若真诚相信、愿意往生，并忆念佛名，便能得到接引。

其中最受后世重视的是第十八愿。经文说：

#quote(block: true)[
“十方众生，至心信乐，欲生我国，乃至十念。”
]

完整愿文以一种近乎誓约的语气表达：如果十方众生真诚信受，愿生彼国，乃至十念而不能往生，法藏便不取正觉。《无量寿经》因此把法藏的成佛与众生能否获得救度联系在一起：他不是先成佛，然后偶尔帮助众生；他的佛果本身，就是由救度众生的愿行所成就的。经过不可思议的长期修行，法藏比丘圆满大愿，成就佛道，号“阿弥陀佛”，他所成就的清净国土，称为“极乐世界”或“安乐国”。

这里需要提醒读者：法藏比丘发愿，是佛教经典中的宗教叙事，不是现代历史学意义上能够考证年月、地点的传记。它的意义不在于提供一份古代人物档案，而在于表达大乘佛教的一个核心理想：

#strong[真正的觉悟，不是独自逃离苦海，而是发愿创造条件，使更多众生都能走向觉悟。]四十八愿，说到底，是一位菩萨对苦难众生作出的四十八种承诺。

#horizontalrule

== 二、“阿弥陀”是什么意思？
<二阿弥陀是什么意思>
“阿弥陀”是古代译经家对印度语言的音译。佛教文献中常见两个相关名称：Amitābha，意为“无量光”；Amitāyus，意为“无量寿”。因此，阿弥陀佛又被称为“无量光佛”或“无量寿佛”。所谓“无量光”，并不是说阿弥陀佛像一颗发出物理光线的巨大星体。佛教常以光明象征智慧：智慧能够照破无明，使人看清烦恼的来源，也能平等照见一切众生，不因贫富、身份、聪明或愚钝而有所遗漏。

所谓“无量寿”，也不仅是寿命无限延长。它象征佛的觉悟与慈悲不受普通生命期限的限制，不会因为一位教主的肉身死亡而消失。众生无尽，救度众生的愿心也无尽。因此，“阿弥陀佛”这个名字，本身便包含了两个重要意象：

#strong[以无量智慧照见众生，以无量慈悲摄受众生。]人们念诵“阿弥陀佛”，不仅是在呼唤一尊遥远的佛，也是在不断提醒自己：不要让内心完全被狭隘、怨恨和恐惧占据，应当向光明、长远和慈悲的方向转变。“南无阿弥陀佛”比“阿弥陀佛”多了“南无”二字。“南无”也是音译，含有归命、归依、礼敬之意。因此，六字佛号大体可以理解为：

#strong[我归依、礼敬无量光明与无量寿命的阿弥陀佛。]它不是一句用来命令神灵的咒语，而是一种归向：把散乱的生命重新安放在一个明确的方向上。

#horizontalrule

== 三、极乐世界究竟是什么地方？
<三极乐世界究竟是什么地方>
《阿弥陀经》说，从我们这个世界向西方，经过十万亿佛土，有一个世界名叫极乐，其中有佛，号阿弥陀。经中描绘，那里的土地清净，池水澄澈，莲花盛开，微风吹动宝树，发出和雅之音；众生没有恶道之苦，能够经常听闻佛法，与许多善人共同修行。现代读者读到这里，很容易产生两种完全相反的反应。

一种反应是把极乐世界想象成某个可以用宇宙飞船抵达的星球，甚至试图用现代天文学为它寻找坐标。另一种反应则认为，极乐世界不过是一种心理安慰，所谓“西方”与“往生”全部只是比喻，并不存在任何超越个人意识的意义。这两种解释都过于简单。在传统净土信仰中，极乐世界首先被理解为阿弥陀佛愿力所成就的清净佛国，是众生可以发愿往生的真实归趣。佛教经典以“西方”为它指定方向，使修行者的心有所归向，而不是在无边无际的想象中漂浮。

与此同时，中国佛教也发展出“唯心净土”“自性弥陀”等解释，强调净土不能完全离开人的心。一个人的内心若充满贪婪、仇恨与伤害，即使嘴上谈论净土，他所生活的世界仍会不断被烦恼染污；当人的心逐渐清净，现实中的人际关系与生活环境也会随之改变。因此，汉传佛教中常同时保留两种理解：

一方面，极乐世界是阿弥陀佛愿力成就的佛国，不能被简单取消为心理幻象；另一方面，求生净土也必须从净化当下的身口意开始，不能把净土与现实生活完全割裂。更重要的是，极乐世界并不是供人永远享乐的终点。佛教所说的“极乐”，并非纵情享受感官刺激，而是远离严重障碍，能够安心学佛。在极乐世界往生的目的，不是住进一座永不散场的快乐宫殿，而是亲近阿弥陀佛与诸大菩萨，听闻正法，不再退转，最终成佛。

所以，净土不同于一般意义上的天堂。天堂通常被理解为善人死后获得永久奖赏的地方；净土则更像一所条件完善的修行道场。往生不是毕业，而是进入一个更适合学习的环境；不是结束菩萨道，而是为了更有能力继续菩萨道。《阿弥陀经》说，往生彼国者能够与“诸上善人俱会一处”，而且多能达到不退转。由此可见，极乐世界最重要的庄严，不是黄金铺地，也不是楼阁珠宝，而是那里具备了使人持续向善、向觉悟前进的条件。

#horizontalrule

== 四、西方三圣：慈悲与智慧共同接引众生
<四西方三圣慈悲与智慧共同接引众生>
在汉传佛教寺院中，人们常看到三尊并列的佛菩萨像：中间是阿弥陀佛，一侧是观世音菩萨，另一侧是大势至菩萨，合称“西方三圣”。阿弥陀佛代表无量光明、无量寿命与摄受众生的本愿。观世音菩萨代表慈悲。所谓“观世音”，就是观察、听闻世间众生的苦难，并随缘给予帮助。观音的慈悲，使净土信仰不只是个人寻求安宁，也包含了对他人痛苦的关怀。

大势至菩萨代表智慧与精进的力量。“大势至”意味着以强大的智慧之势，使众生远离迷惑，趋向觉悟。在后世汉传佛教中，大势至菩萨尤其与念佛修行联系在一起，象征专注、忆念与不间断的道心。《观无量寿佛经》不仅教人观想极乐国土和阿弥陀佛，也分别讲述观世音、大势至二菩萨；经末还把全经称为观极乐国土、无量寿佛、观世音菩萨和大势至菩萨之经。因此，后来寺院以三尊并列的形式表现净土信仰，并非偶然。

三圣的组合，也可以看成一幅完整的修行图景：

只有愿望而没有慈悲，修行可能变得只顾自己；只有慈悲而缺少智慧，善意有时会失去方向；只有智慧而缺少持久愿力，又容易在困难面前退缩。阿弥陀佛的愿、观音菩萨的悲、大势至菩萨的智，共同构成了净土法门的精神结构。

#horizontalrule

== 五、净土三经分别讲了什么？
<五净土三经分别讲了什么>
汉传佛教通常把《无量寿经》《观无量寿佛经》《佛说阿弥陀经》合称“净土三经”。三部经典的侧重点各不相同，合在一起，构成了净土信仰的基本轮廓。现存译本及相关经典传统，后来也深刻影响了中国、日本、朝鲜半岛与越南等地的佛教实践。

=== 1.《无量寿经》：阿弥陀佛为什么建立净土？
<无量寿经阿弥陀佛为什么建立净土>
《无量寿经》篇幅较长，核心是法藏比丘发愿、修行、成佛以及极乐世界的庄严。如果说净土法门是一座建筑，《无量寿经》讲的是它的地基：阿弥陀佛为什么发愿？极乐世界为何建立？众生依靠什么因缘往生？往生之后又将走向何处？四十八愿中，有些愿解决众生身体与环境的缺陷，有些愿保证众生能够闻法，有些愿强调不退转，有些愿则与闻名、发愿和往生有关。

这说明净土并不是阿弥陀佛凭空赠送给众生的一处享乐世界，而是菩萨长期观察众生困境之后，为众生修道所设计的一套完整条件。

=== 2.《观无量寿佛经》：在苦难中怎样找到出路？
<观无量寿佛经在苦难中怎样找到出路>
《观无量寿佛经》以一场王室悲剧开始。摩揭陀国的王子阿阇世为了夺取王位，囚禁父王频婆娑罗。母亲韦提希夫人设法送食物给丈夫，也遭到儿子的怨恨与幽禁。在家庭背叛、政治暴力和巨大痛苦中，韦提希向佛陀求助，希望知道是否有一个远离恶浊、适合修行的清净国土。

佛陀于是为她显示诸佛国土，并教她选择往生阿弥陀佛的极乐世界，随后宣说十六种观法。这部经的重要性在于：净土法门不是从生活顺遂中产生的幻想，而是在现实苦难最深重之处提出的问题------当一个人无力立刻改变外部环境时，他的心还能朝向哪里？十六观包括观落日、观水、观地、观宝树、观宝池、观阿弥陀佛与二大菩萨等。经中又以九品往生说明众生根机与修行程度有所不同，甚至没有能力完成复杂观想的人，也可以通过称念佛名与发愿获得救度。

善导后来概括说，《观经》既以观佛三昧为宗，也以念佛三昧为宗。换言之，这部经既包含精细的禅观，也为称名念佛留下了广阔空间。

=== 3.《佛说阿弥陀经》：怎样把净土法门带进日常生活？
<佛说阿弥陀经怎样把净土法门带进日常生活>
《阿弥陀经》篇幅很短，却是汉传寺院中最常诵念的经典之一。它简要介绍极乐世界与阿弥陀佛的功德，劝人发愿往生，并提出持名念佛的方法。经中说：

#quote(block: true)[
“不可以少善根福德因缘，得生彼国。”
]

接着又说：

#quote(block: true)[
“若有善男子、善女人，闻说阿弥陀佛，执持名号，若一日，若二日，若三日，若四日，若五日，若六日，若七日，一心不乱。”
]

这段经文成为持名念佛最直接的经典依据。不过，“一心不乱”不宜被理解为：念佛时只要出现一个杂念，所有修行便全部失效。历代祖师对“一心不乱”有不同层次的解释。有的强调禅定功夫，有的强调信愿坚固，有的强调长期专念，不被其他方向动摇。共同点在于，它不是要求修行者在一开始就拥有完全无念的圣者境界，而是教人使散乱的心逐渐集中，让佛号从偶尔想起，变成稳定的生命方向。

#horizontalrule

== 六、净土法门怎样在中国扎根？
<六净土法门怎样在中国扎根>
净土思想并不是在某一天突然成为一个完整宗派的。佛教传入中国后，关于阿弥陀佛、念佛三昧和清净佛国的经典逐渐被翻译。东汉时期译出的《般舟三昧经》等经典，已经介绍了专念佛陀、在禅定中见佛的修行。后来，《无量寿经》《观无量寿佛经》《阿弥陀经》等相继流传，净土信仰才逐渐形成更清晰的轮廓。

=== 慧远：庐山上的念佛之约
<慧远庐山上的念佛之约>
东晋高僧慧远长期住在庐山东林寺。约在公元402年，他与一批僧人与在家信众共同发愿，修习念佛三昧，期望往生西方。慧远在《念佛三昧诗集序》中称赞念佛法门：

#quote(block: true)[
“功高易进，念佛为先。”
]

他所说的“念佛”，主要带有禅观和念佛三昧的意味，与后来普遍流行的口称佛名并不完全相同。慧远重视专注观佛，希望在三昧中见佛，并以此坚定修行。后世常把慧远的团体称为“白莲社”，并尊他为中国净土宗初祖。但从历史文献来看，慧远及其同修者当时未必已经使用“白莲社”这一名称；这一形象是在唐宋以后逐渐丰富、定型的。因此，更谨慎的说法是：慧远在庐山组织了早期具有重要影响的念佛结社，后世净土传统据此尊奉他为初祖。

这种区分并不会降低慧远的地位，反而使我们更清楚地看到：中国净土法门不是由一位祖师一次创立完成的，而是在数百年间，由许多僧人与信众不断实践、解释和发展出来的。

=== 昙鸾：仅靠自己，为什么如此困难？
<昙鸾仅靠自己为什么如此困难>
南北朝时期的昙鸾，对中国净土思想产生了重要影响。他特别强调，普通众生烦恼深重、寿命短促，仅靠自己的禅定与智慧，想在一生中彻底断除烦恼，十分困难。阿弥陀佛的本愿，为众生提供了另一种可能：修行者并非孤立地依靠自己，而是在自己的信愿与修行中，接受佛愿力的摄持。

这就是净土思想中常说的“他力”。“他力”并不是说自己什么都不用做，更不是把责任全部推给佛。一个人要相信、发愿、念佛、止恶行善，这些都属于自身的选择与实践；但他不再认为成败完全依靠有限的个人能力，而是承认自己需要佛法、善知识和清净愿力的帮助。

就像一个人渡海，仍然需要登船、辨认方向、遵守航行规则，但不必靠自己的双手游过大海。

=== 道绰：为普通人寻找可行之路
<道绰为普通人寻找可行之路>
隋唐之际的道绰进一步说明，在佛法衰微、众生根机薄弱的时代，艰深的修行不容易普遍实行，念佛求生净土却能够成为多数人可以承担的道路。道绰的意义，不在于否定其他法门，而在于不断追问：

#strong[一个没有高深学问、没有长期闭关条件、还要工作和照顾家庭的普通人，能不能修行？]净土法门给出的回答是：可以。

=== 善导：让一句佛号走入千家万户
<善导让一句佛号走入千家万户>
唐代善导是中国净土教发展中极为关键的人物。他继承道绰的思想，系统解释《观无量寿佛经》，尤其强调凡夫也可以依阿弥陀佛本愿求生净土。现代研究也普遍把善导视为中国净土思想定型过程中的核心人物。善导没有把净土修行只留给能够完成复杂观想的少数禅修者。他特别重视称名念佛，认为这是普通人最容易持续实行的正行。他在《观无量寿佛经疏》中说：

#quote(block: true)[
“一心专念弥陀名号，行住坐卧，不问时节久近，念念不舍者，是名正定之业，顺彼佛愿故。”
]

这句话把念佛从特定仪式带入了整个生活：行走时可以念，坐下时可以念；独处时可以念，忙碌间隙也可以念；不在于一时激动念了多少，而在于方向确定之后，长久不舍。善导的贡献，是让净土法门从少数人的观想三昧，进一步成为普通人可以实践的日常道路。此后，念佛不再局限于某一宗派。天台、华严、禅宗、律宗的许多僧人，也兼修或提倡净土。中国净土传统不像某些宗派那样始终具有严格单一的师承与寺院体系，它更像一条逐渐汇入整个汉传佛教的河流。

人们可以参禅而念佛，可以研习经教而念佛，也可以持戒、行善、礼佛、诵经，并把功德回向净土。这正是净土法门流传广泛的重要原因：它有自己的经典与祖师，却又不必把自己封闭在一道宗派围墙之内。

#horizontalrule

== 七、信、愿、行：一句佛号背后的三重结构
<七信愿行一句佛号背后的三重结构>
后世中国净土宗常用“信、愿、行”三个字概括净土法门。这三个字看似简单，实际上缺一不可。

=== 1.信：不是停止思考，而是建立信任
<信不是停止思考而是建立信任>
净土法门所说的“信”，首先是相信佛陀的觉悟与教法，相信阿弥陀佛的愿心，也相信烦恼深重的普通人仍有改变和觉悟的可能。这种信并不意味着拒绝提问。盲信是因为害怕怀疑而不敢思考；佛教意义上的信，则应当在听闻、理解和实践中逐渐稳固。一个人可以从“不确定但愿意了解”开始，不必强迫自己立刻产生毫无疑问的宗教体验。

更深一层说，净土之信还包括承认自己的有限。现代人习惯把独立理解为“凡事只能靠自己”。一旦失败，便把所有责任变成自我责备。净土法门则提醒人：生命本来就在相互依存中成长。我们需要父母、朋友、老师、社会，也需要佛法和善知识。接受帮助，不一定是软弱；承认有限，也可以成为真正修行的起点。

=== 2.愿：为生命选择一个最终方向
<愿为生命选择一个最终方向>
“愿”是愿生极乐世界，也是在当下决定：我的生命不再只追逐眼前得失，而要朝向清净、觉悟和利他的方向前进。愿不同于幻想。幻想只是在头脑中期待一个美好结果，却不愿改变自己的行为；愿则具有方向感，它会重新排列一个人的选择。当一个人真正愿意趋向净土，他便会开始反省：现在的生活方式，是使内心越来越清净，还是越来越混乱？说出的话，是增加理解，还是制造伤害？获得财富之后，是更加贪婪，还是愿意帮助别人？

所以，愿生净土不是等到临终才突然产生的念头，而是从现在开始，为生命确定方向。

=== 3.行：把方向落实为持续实践
<行把方向落实为持续实践>
“行”最常见的形式是持名念佛，也包括礼佛、诵经、忏悔、持戒、行善与回向。念佛看似只是重复几个字，但真正的念佛并非嘴唇的机械运动。“念”这个字，本来就有忆念、不忘的意思。口中称名，是借助声音帮助心念集中；耳朵听见自己的佛号，又把散乱的心收回来。

明末蕅益智旭在《阿弥陀经要解》中把净土修行概括为“信愿持名”，并说：

#quote(block: true)[
“得生与否，全由信愿之有无；品位高下，全由持名之深浅。”
]

这句话在后世影响极大。它强调的重点是：念佛不能与信愿分离。没有方向的重复，只是声音；有了信愿，佛号才成为整个生命的归向。信而无愿，容易停留在知识上；愿而无行，容易停留在想象中；行而无信愿，则容易变成机械习惯。三者结合，才构成完整的净土实践。

#horizontalrule

== 八、“一心不乱”是不是要求完全没有杂念？
<八一心不乱是不是要求完全没有杂念>
许多人开始念佛后，很快便感到沮丧。念了几声，脑中就想起工作；再念几声，又想起昨天与人争吵的情景；有时嘴里念佛，心里却已经安排完明天的所有事情。于是有人认为：“我的杂念这么多，念佛一定没有用。”其实，发现自己散乱，本身已经是一种进步。在没有念佛或静坐之前，人往往意识不到心中有多少念头。佛号像一面镜子，使散乱显现出来。修行并不是一开始就没有杂念，而是每当发现心已跑远，便再回到佛号上。

所谓“一心”，可以先从不同时做许多事开始。念这一声“阿弥陀佛”时，清楚地念；声音从口中发出，耳朵再清楚地听进去。妄念出现，不必愤怒，也不必与它争斗，只需重新听下一声佛号。如此反复，散乱可能仍然存在，但人不再完全被散乱牵走。因此，对普通人而言，“一心不乱”首先不是一种用来恐吓自己的合格标准，而是一条逐渐训练的道路：由散乱走向专注，由偶尔忆念走向相续忆念，由临时求助走向稳定归依。

#horizontalrule

== 九、念佛是不是逃避现实？
<九念佛是不是逃避现实>
这是净土法门最常遭遇的质疑。如果一个人在现实生活中遭遇困难，不去行动，只说“将来往生极乐世界”，这当然可能成为逃避。可是，这不是净土经典本来的全部教导。《观无量寿佛经》在讲观想与往生之前，先提出“净业三福”。其中第一部分便包括孝养父母、奉事师长、慈心不杀、修十善业；后面又包括受持三皈、遵守戒律、发菩提心、深信因果等内容。

这说明，求生净土不是绕过现实伦理的捷径。一个人若一边念佛，一边欺骗、伤害、压迫别人，却认为只要临终再念几声佛号便可解决一切，这不是信仰深厚，而是误解了因果。净土法门真正要改变的，首先是人面对现实的方式。念佛不能代替应该承担的责任。生病仍然要看医生，负债仍然要努力处理，伤害别人仍然需要道歉和补救，社会中的不公仍然需要有人以智慧和慈悲面对。

佛号的作用，不是让问题凭空消失，而是帮助人在恐惧、愤怒和混乱中保持方向，不至于被烦恼完全吞没。韦提希夫人的故事正说明了这一点。她不是因为生活太幸福才求生净土，而是在家庭与政治悲剧中寻找不被仇恨摧毁的道路。从这个意义上说，净土不是逃离现实的借口，而是面对现实之后，不让现实中的恶决定自己最终成为怎样的人。

#horizontalrule

== 十、净土法门是不是只适合老人？
<十净土法门是不是只适合老人>
很多人把念佛与老年、疾病和死亡联系在一起，仿佛年轻人一念佛，就显得暮气沉沉。这种印象的形成并不难理解。念佛简单易行，不需要识字，也不要求复杂仪式，因此特别适合年老体弱者；同时，净土法门直接面对死亡问题，也常被用于临终关怀和丧葬佛事。但“适合老人”不等于“只适合老人”。

无常从来不按年龄出现。年轻人也会经历焦虑、失恋、疾病、事业失败和亲人离世。一个人在二十岁时不思考生命方向，并不代表死亡与失去就不存在，只是暂时没有看见。净土修行所处理的问题------注意力散乱、欲望无止境、对失去的恐惧、对未来的不安------恰恰也是现代年轻人的普遍问题。

而且，从历史上看，净土信仰的参与者既有僧人，也有官员、文人和普通百姓；既有临终念佛，也有长期禅观、结社共修和日常行善。它并不是专门为人生最后几年准备的宗教服务。越早知道生命有限，人越可能认真选择如何生活。念佛不是催促人走向死亡，而是提醒人：不要等到死亡临近时，才第一次思考自己究竟要把心安放在哪里。

#horizontalrule

== 十一、念佛是不是只要嘴上念就行？
<十一念佛是不是只要嘴上念就行>
口称佛名，是净土法门最显著的修行形式，但“开口发声”不等于完成了全部修行。佛教重视身、口、意三业。口中念佛，能够影响内心；内心忆佛，也应逐渐影响行为。如果一个人念佛之后，仍然毫不反省自己的贪婪、愤怒和伤害，那么佛号还没有真正进入他的生命。反过来说，也不能因为自己暂时杂念很多，就断言所有口念都毫无意义。

口念是入口，不是终点。开始时，心可能跟不上口；长期练习后，声音会帮助收摄心念。心念逐渐稳定，又会反过来改变语言和行为。一个经常忆念慈悲与光明的人，应当逐渐减少恶口、欺骗和伤害。善导强调“念念不舍”，重点正在持续，而不是表演某一次完美状态。佛号也不是与行善相互排斥的“密码”。《阿弥陀经》说“不可以少善根福德因缘得生彼国”，提醒修行者：往生不是对现实因果的否定。持名念佛本身被历代祖师视为重要善根，同时，念佛者也应在现实中培植慈悲、诚实、忍让与责任。

真正的念佛，不只是口中有佛，也应当使心中逐渐有光，使行为逐渐少一些伤害。

#horizontalrule

== 十二、普通人怎样开始念佛？
<十二普通人怎样开始念佛>
了解净土法门，并不等于必须立刻成为净土宗信徒。不过，即使把念佛当作一种佛教文化与修心方法，普通人也可以从很简单的方式开始体验。每天选择一段相对安静的时间，不必太长。端身坐好或缓慢行走，清楚地念“南无阿弥陀佛”。速度不必追求快，声音也不必很大，以自己能够清楚听见为准。

念的时候，注意三件事：

口中念得清楚，耳中听得清楚，心中知道自己正在念。走神之后，不责备自己，只回到下一声佛号。念诵结束时，可以把心愿从自己扩展到他人：愿自己少一些烦恼，也愿正在受苦的人得到安稳；愿自己走向清净，也愿一切众生终能离苦。这种练习的重点不在计数竞赛，也不在追求神秘感受，而在于培养一种可以反复回归的内在方向。

当人愤怒时，佛号提醒他暂缓伤人的语言；当人焦虑时，佛号帮助他把注意力带回当下；当人得意时，佛号提醒他世事无常；当人面对死亡时，佛号使他知道生命并不只能在恐惧中结束。一句佛号之所以能够流传千年，正是因为它足够简单，可以进入任何人的生活；同时又足够深广，能够承载一个人对生死、慈悲与觉悟的全部追问。

#horizontalrule

== 十三、自力与他力：不是互相排斥的两条路
<十三自力与他力不是互相排斥的两条路>
净土法门经常被称为“他力法门”。有些人因此认为，净土宗不重视个人努力；也有人反过来认为，只要依靠阿弥陀佛，便不需要修正自己的行为。这两种看法都把自力与他力截然分开了。事实上，没有绝对孤立的自力。我们今天能够读书，是因为有人创造文字、保存经典、建立学校；能够生活，是因为无数人在生产食物、维护交通、提供医疗。一个人所谓“靠自己”，本来就包含了许多他人的帮助。

佛教所说的他力，更不是外在神灵任意改变人的命运，而是阿弥陀佛已经成就的愿力，为众生提供了一种可以信受和进入的修行条件。修行者发信心、立愿、念佛，是自己的选择；阿弥陀佛的本愿与净土庄严，是支持这种选择的力量。如果借用一个比喻，自力像是一个人愿意抬脚上船，他力像是船能够载人渡河。没有船，仅凭个人力量渡过惊涛骇浪极其困难；有船却拒绝登船，也无法抵达彼岸。

因此，净土法门既反对傲慢地认为“我完全不需要任何帮助”，也反对懒惰地认为“我什么都不必改变”。承认自己的有限，同时仍愿意努力，这正是净土信仰中谦卑而积极的一面。

#horizontalrule

== 十四、为什么一句佛号能够流传千年？
<十四为什么一句佛号能够流传千年>
现在，我们可以回答本章开头的问题了。一句“阿弥陀佛”能够流传千年，并不只是因为它容易念。它背后至少包含了四层力量。第一，它直接面对生死。很多思想可以帮助人获得知识，却回避死亡。净土法门则从不掩饰生命会衰老、会失去、会终结。它告诉普通人：死亡不是不吉利的话题，而是每个人都必须准备的功课。

第二，它为普通人保留希望。佛教修行体系十分广大，其中有深奥的哲学、精细的禅定和严格的戒律。普通人面对这些内容时，容易觉得觉悟遥不可及。净土法门却不断强调：即使能力有限、烦恼深重，只要愿意转身，仍有道路可走。第三，它能够进入日常生活。念佛不依赖特殊场所。行住坐卧、工作休息之间，都可以忆念。它把修行从少数人的山林禅房带到千家万户，使没有学问、没有财富、没有大量空闲时间的人，也能拥有自己的修行。

第四，它把个人安顿与众生救度联系在一起。求生净土不是为了永远离开众生。按照大乘佛教的理想，往生者在净土继续修学，最终仍要回到众生之中。真正的净土愿，不是“只要我平安”，而是希望自己具备更大的智慧与能力，帮助更多生命离苦。因此，净土法门的核心，不只是一个地方，也不只是一种临终安排，而是一种愿的教育。

法藏比丘以四十八愿建立极乐世界；修行者则在念佛中学习发愿。佛的愿是摄受众生，人的愿是归向觉悟。两种愿在一句佛号中相遇。

#horizontalrule

== 结语：给漂泊的心一个方向
<结语给漂泊的心一个方向>
人的一生，常常在许多声音中度过。有人催促我们成功，有人要求我们比较，有人不断制造恐惧，也有人告诉我们必须拥有更多，才配得到幸福。我们的心被这些声音拉扯，走得越来越快，却未必知道自己究竟要去哪里。“南无阿弥陀佛”则是另一种声音。它不许诺世间永远顺利，也不否认人生必有痛苦。它只是一次又一次提醒人：在无常中仍可选择方向，在烦恼中仍可忆念光明，在孤独中仍可相信慈悲，在面对死亡时，生命仍有超越恐惧的可能。

念佛不是把自己交给幻想，而是承认自己的有限之后，仍愿意朝向无限的智慧与慈悲。从法藏比丘的四十八愿，到慧远庐山的念佛之约；从善导所说的“行住坐卧，念念不舍”，到千百年来普通人的一声声佛号，净土法门真正延续下来的，是一种不肯舍弃众生的愿心。也许，这正是“阿弥陀佛”四个字最深的意义：

在一个充满无常的世界里，仍然相信每一个生命都不应被轻易放弃。

#horizontalrule

== 常见误解小结
<常见误解小结>
=== 1.念佛是不是逃避现实？
<念佛是不是逃避现实>
念佛若被用来逃避责任，当然会成为消极行为；但经典要求修习十善、孝养父母、慈心不杀。真正的念佛应使人更有力量面对现实，而不是拒绝现实。

=== 2.净土是不是佛教的天堂？
<净土是不是佛教的天堂>
极乐世界不是永久享乐的终点，而是远离重大修行障碍、能够闻法并达到不退转的清净佛国。往生的最终目标仍是觉悟与度众生。

=== 3.念佛是不是只适合老人？
<念佛是不是只适合老人>
念佛适合老人，但并不专属于老人。无常、焦虑、欲望和生命方向，是所有年龄的人都会面对的问题。

=== 4.是不是只要嘴上念就可以？
<是不是只要嘴上念就可以>
口念是重要入口，但完整的净土修行还包括信、愿、持戒、行善、忏悔与回向。佛号应逐渐进入内心，并影响现实行为。

=== 5.念佛有杂念是不是没有用？
<念佛有杂念是不是没有用>
杂念是普通人的常态。修行不是强迫自己立刻没有念头，而是在每次走神之后，重新回到佛号。能够觉察散乱并一次次回来，本身就是训练。

#horizontalrule

== 本章主要依据与延伸阅读
<本章主要依据与延伸阅读>
一、《佛说无量寿经》，《大正新修大藏经》第十二册，第360号。法藏比丘、四十八愿及极乐国土的主要经典依据。二、《佛说观无量寿佛经》，《大正新修大藏经》第十二册，第365号。韦提希夫人的故事、十六观、九品往生及西方三圣的主要依据。三、《佛说阿弥陀经》，《大正新修大藏经》第十二册，第366号。持名念佛、“一心不乱”及劝愿往生的主要依据。

四、慧远《念佛三昧诗集序》，收于《广弘明集》，《大正新修大藏经》第五十二册，第2103号。五、善导《观无量寿佛经疏》，《大正新修大藏经》第三十七册，第1753号。善导关于观佛、念佛及正定之业的主要著作。六、蕅益智旭《阿弥陀经要解》，《大正新修大藏经》第三十七册，第1762号。后世以信、愿、持名解释净土法门的重要著作。

七、Charles B. Jones, #emph[Chinese Pure Land Buddhism: Understanding a Tradition of Practice], University of Hawai‘i Press, 2019。该书综合讨论中国净土传统的历史、修行形态及内部多样性。

#part[第四部：佛法东来——佛教如何进入中国]
= 第十一章　白马驮经
<第十一章-白马驮经>
#figure([
#box(image("chapters/../images/downloaded/ch11_dunhuang.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
莫高窟第323窟壁画《汉武帝迎金人/张骞出使西域图》
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


洛阳城外，晨雾尚未散去。几匹马从西方缓缓而来。马背上没有金银珠宝，也没有进献皇帝的奇禽异兽，而是驮着一卷卷陌生的经书和佛像。随行的僧人深目高鼻，身披异域衣服，说着中原人听不懂的语言。传说中，驮经的马是白色的。后来，人们在洛阳城外建起一座寺院，为纪念白马驮经，取名“白马寺”。寺里的钟声从汉代一直传到今天，这匹白马也由此成为佛教东来的象征。

然而，历史上的佛教并不是在某一天突然越过国境，也不是仅靠一匹白马便进入中国。早在汉明帝派人西行以前，商队、使者、僧侣和居士已经沿着漫长的交通网络，把关于佛陀的故事、佛教的名词和零散的修行方法带到了中原。白马驮经，是一段美丽的传统记忆。在这段记忆背后，则是一场持续数百年、横跨万里的文明相遇。

#horizontalrule

== 一、白马到来以前，道路已经打开
<一白马到来以前道路已经打开>
佛教诞生于古印度。若要从印度到达中国，在两千年前并不是一件容易的事。旅人要穿过高山、荒漠和绿洲，经过大月氏、安息、龟兹、于阗、疏勒、敦煌等许多国家和地区，再从玉门关或阳关进入汉地。一路上不仅有风沙、寒暑和盗匪，还要面对语言、饮食和政治局势的不断变化。

但这条路虽然艰险，却从未真正封闭。汉武帝时，张骞出使西域，使汉朝逐渐了解到中亚各国的情况。此后，丝绸、香料、宝石、良马和药材在东西方之间流通，商人、使者、工匠和宗教人士也随着商路往来。我们今天习惯把这些陆路交通网络统称为“丝绸之路”，但它并不是一条笔直的大路，而是由许多绿洲城市、山口、驿站和贸易路线组成的巨大网络。

商品沿路传播，思想也会沿路传播。商人出售丝绸时，也会讲述自己家乡的神灵；僧人跟随商队旅行，也可能在途中为人说法；外国使者进入汉地时，会带来本国的礼仪、画像和传说。佛教最初进入中国，很可能正是通过这些零散而持续的接触发生的，而不是等待某一次朝廷正式宣布之后才开始。

关于佛教早期传入，古书中有一条著名记录：西汉哀帝元寿元年，即公元前二年，大月氏使者伊存曾向汉朝的“博士弟子”口授《浮屠经》。这件事原载于三国时鱼豢所著《魏略》，原书后来散失，相关文字由其他古籍转引保存下来。由于记录形成时间晚于事件本身，具体人物姓名和传授地点也存在异文，现代学者对它仍有讨论。因此，我们不能把“伊存授经”当作毫无疑问的精确日期，却可以把它视为一个重要线索：早在西汉末年，中国人便可能已经接触到关于“浮屠”的知识。

“浮屠”“浮图”或“佛陀”，都是外来语音译后的不同写法。它们的声音，都来自印度语言中的 Buddha，也就是“觉悟者”。一个陌生的名字，就这样沿着商路，穿越沙漠与关塞，进入了汉语世界。

#horizontalrule

== 二、真正可靠的早期身影：楚王刘英
<二真正可靠的早期身影楚王刘英>
如果说伊存授经仍带有若干疑问，那么东汉楚王刘英信奉佛教的记载，则清楚得多。楚王刘英是汉光武帝刘秀之子、汉明帝的异母弟，被封在彭城一带。根据《后汉书》记载，他年轻时喜欢结交游侠，后来转而爱好黄老之学，并开始学习“浮屠斋戒祭祀”。汉明帝永平八年，即公元六十五年，朝廷允许犯死罪者交纳缣帛赎罪。楚王刘英认为自己也有过失，便献上三十匹黄缣白纨，希望赎罪。汉明帝却没有收取，反而在诏书中称刘英“诵黄老之微言，尚浮屠之仁祠”，并命人把这些丝帛退还，用来供养“伊蒲塞、桑门”。

“伊蒲塞”是“优婆塞”的早期译音，指在家信奉佛教的男子；“桑门”就是“沙门”，指离家修道的人。这段简短的诏书非常重要。它说明最迟在公元六十五年前后，汉地已经出现了佛教斋戒、祭祀或供养活动，也出现了出家沙门和在家信徒。楚王刘英并不是独自在王宫中阅读一本陌生经书，他的周围已经形成了一个小规模的信仰群体。

更值得注意的是，刘英并没有把佛教看成与中国传统完全分离的宗教。他同时喜好黄老之学，又供奉浮屠。在当时许多人的理解中，佛陀可能被视为一种来自西方的神仙、得道者或长生圣人，佛教也常常与黄老方术、斋戒祭祀混合在一起。这并不奇怪。任何外来思想进入新的文化环境，都不可能立即被准确理解。人们总会先用自己熟悉的概念解释陌生事物。中国人第一次听到“佛”，很自然地会问：他是不是像老子一样的圣人？是不是修炼成仙的真人？他能不能保佑国家、延长寿命、消除灾祸？

早期佛教在中国的面貌，远没有后来寺院中的佛教那么清晰。佛、神仙、方士、黄老、斋戒和祭祀，常常交织在一起。但正是《后汉书》中这些略显混杂的词语，使我们看到了佛教刚刚落地时最真实的状态。

#horizontalrule

== 三、汉明帝梦见了谁？
<三汉明帝梦见了谁>
关于佛教东来，最广为人知的故事发生在汉明帝身上。相传有一天夜里，汉明帝梦见一个金色的人。他身形高大，头顶或颈后放出光明，在宫殿上空飞行。第二天，明帝召集群臣询问梦的含义。有大臣回答说，西方有一位圣者，名叫“佛”，全身金色，或许皇帝梦见的正是他。

于是，汉明帝派遣使者前往西域寻求佛法。《后汉书·西域传》记载：“世传明帝梦见金人，长大，顶有光明。”随后又说，明帝派人前往天竺询问佛法，并在中国绘制佛像。这段文字的开头是“世传”。“世传”二字很值得留意。它不是“皇帝本纪记载”，也不是“当时诏书说”，而是“社会上世代流传”。这说明范晔编写《后汉书》时，明帝梦见金人的故事已经流传很广，但它带有传统传说的性质。

后来形成的故事更加完整。南朝梁代慧皎所著《高僧传》记载，汉明帝派郎中蔡愔、博士弟子秦景等人前往天竺寻访佛法。他们在西域遇见中天竺僧人摄摩腾，邀请他来到汉地。竺法兰也随后来到洛阳，与摄摩腾同住。到了北魏杨衒之所著《洛阳伽蓝记》中，白马驮经的画面已经十分鲜明：

汉明帝梦见金神，派使者向西域求法，得到佛经和佛像，由白马驮回洛阳，寺院也因此得名“白马寺”。书中称白马寺为“佛入中国之始”。由此可以看出，明帝梦金人、遣使求法、僧人东来、白马驮经和建立白马寺，并不是一次性完整记录在同一部东汉史书中的。这个故事经历了长期积累：

最早的史书保存了“梦见金人、遣使问法”的传说；后来的僧传补充了蔡愔、秦景、摄摩腾和竺法兰；再往后的文献则把白马驮经和寺名来源连接起来。这并不意味着故事毫无价值。传说未必等于虚构。它可能保存了历史事件的核心记忆，只是在数百年的讲述中不断被整理、补充和象征化。也许汉明帝确实曾对西域佛教产生兴趣，也许朝廷确实接待过来自西域的僧人、佛像和经书。只是在缺乏东汉同时期资料的情况下，我们无法确认故事中的每一个姓名、年份和细节。

对于普通读者来说，最稳妥的理解是：

佛教在汉明帝以前已经零星进入中国；汉明帝求法的传统，则象征着佛教第一次获得东汉朝廷的公开注意和接纳。白马不是佛教进入中国的第一步，却成为历史记忆中最醒目的一步。

#horizontalrule

== 四、摄摩腾与竺法兰：最早被记住的东来僧人
<四摄摩腾与竺法兰最早被记住的东来僧人>
传统记载中的摄摩腾，又被称为迦叶摩腾，是中天竺僧人。《高僧传》说他通晓佛教经典，长期游方弘法。蔡愔等人在西域遇见他后，邀请他进入汉地。摄摩腾不畏流沙和道路艰险，最终抵达洛阳。汉明帝对他表示礼遇，在洛阳城西门外建造精舍，让他居住。《高僧传》用八个字形容当时的处境：“大法初传，未有归信。”

佛法刚刚传来，还没有多少人理解和信奉。这可能比各种神奇故事更接近一位早期来华僧人的真实生活。摄摩腾来到洛阳后，面对的是完全陌生的世界。语言不同，饮食不同，衣着不同，人们对出家制度也缺乏概念。印度僧侣以乞食为生，中国社会却可能把沿街乞食视为贫困或无业；印度佛教称赞离家修道，中国伦理则把侍奉父母、延续家族看作重要责任。

即使有人愿意听法，摄摩腾又该用什么汉字解释“涅槃”“因缘”“业”“比丘”？仅仅把声音翻译出来，人们未必明白；若完全采用中国固有词语，又可能误解佛教的原意。竺法兰面临的困难也是如此。《高僧传》说，竺法兰也是中天竺人，能够背诵大量经论，是当地学者之师。他到洛阳后与摄摩腾同住，不久便开始掌握汉语。传统上认为，他参与翻译了《十地断结》《佛本生》《法海藏》《佛本行》和《四十二章经》等经典，其中只有《四十二章经》流传下来。慧皎因此说：“汉地见存诸经，唯此为始也。”

不过，从现代学术研究的角度看，摄摩腾、竺法兰与《四十二章经》之间的具体关系仍有争议。现存《四十二章经》的文字风格相当成熟，很难想象一位刚学汉语不久的外国僧人能够独立完成。更可能的情形是，外国僧人讲述或诵出经义，熟悉西域语言的人负责传译，中国文士再把内容写成汉文。经文也可能在后来的流传过程中经过整理和润色。

因此，早期译经从来不是一个人的工作，而是一群人的合作。有人背诵原文，有人用另一种西域语言转述，有人解释佛教术语，有人执笔记录，有人校正文句。一次翻译，可能要跨越梵语、犍陀罗语、中亚语言和汉语等多重语言屏障。一卷经书从印度来到中国，不只是被马驮过一段路。

它还必须跨越语言的荒漠。

#horizontalrule

== 五、《四十二章经》为什么只有四十二章？
<五四十二章经为什么只有四十二章>
《四十二章经》篇幅不长，全文只有两千余字。它不像《法华经》那样有完整宏大的故事，也不像《华严经》那样展示重重无尽的世界，而是由四十二段简短教言组成。其中谈到出家、持戒、布施、忍辱、禅定、无常和欲望，也反复提醒修行者调伏内心。从形式上看，它更像一部佛教入门摘编：从不同经典和教法中选择若干要点，整理成便于阅读的短章。

为什么最早进入中国的经典，会是这样一本简短的小书？原因并不难理解。当时的中国人对佛教几乎一无所知。如果一开始便翻译极其庞大、概念复杂的经论，不仅翻译困难，读者也无法理解。《四十二章经》篇幅短、段落清楚，能够大致回答几个最基本的问题：

佛是什么人？沙门怎样生活？佛教劝人做什么？修行者为什么要节制欲望？人生为什么无常？怎样才能使内心清净？从这个角度看，《四十二章经》很像一本两千年前的“佛教入门读本”。不过，它的真正形成时间、译者和文本来源，历来存在不同意见。有学者认为它与汉明帝求法有关，也有人认为现存文本经过后代加工，甚至可能是从不同佛经中摘录编成。

面对这些争议，我们不必急于选定一个绝对答案。无论现存文本是否完全保持东汉初译时的原貌，《四十二章经》都真实反映了佛教进入中国以后所面对的第一个任务：先用中国人能够接受的语言，把最基本的佛法讲清楚。这一任务看似简单，实际上极其艰难。“佛陀”可以音译为“佛”，“沙门”可以保留声音，可是“涅槃”如何解释？“空”会不会被理解为虚无？“无我”会不会被看成否定人的存在？“出家”又如何面对中国人重视孝道和宗族的传统？

翻译从来不只是换几个词。翻译意味着在两个文明之间寻找可以相互理解的道路。

#horizontalrule

== 六、为什么叫“寺”？
<六为什么叫寺>
今天提到“寺”，人们首先想到佛寺。但在佛教传入以前，“寺”原本并不专指宗教场所，而是汉代官署的名称。大理寺、鸿胪寺中的“寺”，都有官署、办事机构之意。传统说法认为，摄摩腾、竺法兰到达洛阳以后，最初由负责接待外国使者的官署安置。后来他们长期居住和译经的地方逐渐成为僧人修行、供奉佛像和保存经书的场所，“寺”也就慢慢具有了佛教寺院的含义。

这种说法的具体细节未必都能由同时代史料证实，但它揭示了一个重要变化：

佛教寺院在中国并不是简单照搬印度建筑，而是在中国原有制度和语言中逐渐形成的。印度佛教僧团居住的场所，常被称为“精舍”“僧伽蓝”或“阿兰若”。进入中国以后，人们用“寺”称呼这些场所。后来，“寺院”“寺庙”逐渐成为汉语中最常见的宗教建筑名称。白马寺因此不只是一栋建筑。

它意味着来自异国的沙门在中原拥有了一处可以长期居住的空间；佛像有了安置之处；经书有了收藏之地；译经、讲法和供养活动有了固定场所。一座寺院建立以后，佛教便不再只是商旅口中的故事，也不再只是宫廷收藏的一幅异域画像。它开始在中国土地上扎根。

#horizontalrule

== 七、白马寺是不是“中国第一寺”？
<七白马寺是不是中国第一寺>
白马寺常被称为“中国第一古刹”或“中国第一寺”。这种说法需要稍作说明。从传统佛教史的角度看，白马寺被视为汉明帝建立的第一座官办佛寺，也是最早专门安置来华僧人、佛像和经书的重要寺院。《洛阳伽蓝记》直接称它为“佛入中国之始”，足见它在后世佛教记忆中的地位。

但是，如果把“第一寺”理解成“中国境内此前绝对没有任何佛教祭祀场所”，就未必准确。楚王刘英在公元六十五年前后已经供奉“浮屠之仁祠”，并供养沙门和在家信徒。这说明在白马寺传统建立年代之前，彭城等地可能已经存在某种佛教活动场所。只是这些场所规模如何、建筑形态怎样、能否称为后来意义上的佛寺，史料并未说明。

因此，更准确的说法是：

白马寺是传统上公认的中国第一座由朝廷建立的重要佛教寺院，是佛教获得官方容纳的标志性场所；但它不一定是中国土地上最早出现的所有佛教活动地点。这种区分并不会降低白马寺的意义。一个文化现象的“起点”往往很难精确到某一天。河流在成为大河以前，已经有许多细小泉水和支流。白马寺的意义，不在于排除所有更早的可能，而在于它把原本零散、隐约的佛教接触，汇聚成一个后世可以清楚看见的历史标志。

从此以后，凡是讲述佛教东来，人们便会想起洛阳、白马和经书。

#horizontalrule

== 八、佛教刚到中国时，人们怎样看待它？
<八佛教刚到中国时人们怎样看待它>
今天的人走进寺院，看见佛像、菩萨像、罗汉像，听到晨钟暮鼓，很容易把这一切视为完整成熟的佛教传统。但东汉人第一次接触佛教时，并没有这样的知识背景。他们不知道释迦牟尼与老子有什么区别，不清楚佛与神仙是否相同，也未必理解出家人为什么剃发、不婚、乞食。佛教所说的前世、来世、业力和轮回，对许多中国人来说也十分陌生。

于是，人们只能借助熟悉的思想解释佛教。佛陀常被视为“西方神人”或得道神仙；佛教修行被理解为清净无为、养生守一；涅槃有时被误解为长生不死；佛教也常与黄老之学、方术和祭祀并列。《后汉书》记载，楚王刘英同时喜好黄老与浮屠；后来汉桓帝也曾把浮屠与老子一同祭祀。这说明在东汉人的观念中，佛教一开始并没有成为边界清晰、独立完整的宗教，而是被放进了原有的神仙方术和黄老信仰框架中。

这种误解既是障碍，也是入口。如果佛教完全拒绝使用中国人熟悉的语言，它可能根本无法传播；但若过度依附黄老和方术，它的本来教义又可能被遮蔽。此后数百年，中国僧人与来华译师一直在处理这个问题：

怎样借助中国文化解释佛教，又不把佛教完全变成中国固有思想？怎样说明“空”与道家的“无”并不完全相同？怎样解释出家修行并不是逃避父母？怎样让重视家族伦理的中国人理解僧团制度？怎样把印度的轮回解脱思想，转化为汉语能够表达的概念？佛教中国化，正是从这些看似细小的语言问题开始的。

#horizontalrule

== 九、佛教不是一部经书传进来的
<九佛教不是一部经书传进来的>
白马驮经的故事容易让人产生一种印象：佛教经书被带到洛阳以后，中国便有了佛教。事实远比这复杂。即使一部佛经已经翻译出来，也不等于人们真正理解它。经书需要有人讲解，戒律需要有人实践，僧团需要建立制度，佛教名词需要不断校正，出家人与国家、家庭和社会之间的关系也需要重新安排。

到了东汉桓帝、灵帝时期，佛经翻译才逐渐形成规模。来自安息国的安世高来到洛阳，翻译禅法和阿毗昙类经典。《高僧传》称他的译文义理清楚、文字质朴，被后世视为早期译经的重要人物。来自大月氏的支娄迦谶则翻译《道行般若经》《般舟三昧经》等大乘经典，把般若、菩萨和净土等思想带入汉语世界。

有些翻译需要多人合作。外国僧人诵出原文，通晓西域语言的人负责口译，汉人居士或文士记录，再由众人讨论、校订。早期译经史中常见“口译”“传言”“笔受”等词，正说明一部汉文佛经的形成，是跨语言团队共同工作的结果。根据佛教史研究，二世纪中叶以后，安世高、支娄迦谶等人在洛阳持续译经，才使佛教经典逐渐形成可以阅读、学习和传授的汉文体系。

所以，佛教不是随着某一卷经书一次性“运进”中国的。它经历了漫长的过程：

先是听说佛的名字；然后看见佛像；再接触零散教言；接着翻译短篇经典；随后建立寺院和信徒群体；最后才逐渐形成完整的经、律、论传统。白马驮来的不是一套已经完成的“中国佛教”。它驮来的是一粒种子。

#horizontalrule

== 十、佛教是不是中国本土宗教？
<十佛教是不是中国本土宗教>
佛教并不是起源于中国的宗教。佛陀出生、修行、成道和说法的地点都在古印度。四圣谛、八正道、缘起、涅槃和僧团制度，也首先形成于印度文化环境中。佛教后来经过中亚、西域和海上交通进入中国，属于外来宗教。但“外来”并不意味着它永远与中国无关。佛教进入中国以后，经历了长达数百年的翻译、争论、选择与改造。中国僧人学习印度经典，同时也用汉语重新表达佛法；中国建筑、绘画、文学、伦理和哲学不断吸收佛教影响，佛教自身也逐渐形成具有中国文化特点的宗派和修行方式。

禅宗、天台宗、华严宗和中国净土教，都不是简单复制印度佛教的产物。观音菩萨在中国形成广泛的慈悲信仰，地藏菩萨与孝道文化相结合，佛教寺院也逐渐具有中国式的山门、天王殿、大雄宝殿和钟鼓楼。因此，佛教的来源在印度，汉传佛教的成熟却发生在中国。它既不能被说成中国自古固有的宗教，也不能被看成始终没有改变的异域文化。

更恰当的说法是：

佛教来自印度，在中国扎根，经过长期本土化，成为中华文化的重要组成部分。这正如一棵树。种子来自远方，但它吸收的是中国土地上的水分，经历的是中国历史中的风雨，最终长出的枝叶，也带有这片土地的形状。

#horizontalrule

== 十一、历史与传说，哪一个更重要？
<十一历史与传说哪一个更重要>
有人可能会问：

既然汉明帝梦金人、蔡愔西行、摄摩腾与竺法兰东来、白马驮经等细节并不都能由东汉同时代史料证明，我们是不是应该把整个故事都当成虚构？没有必要。历史研究要求我们辨别史料形成的年代和可信程度，不能把后世传说中的每一个细节都当成确定事实。但理解一种文化传统，也不能只留下冷冰冰的年代和考证。

明帝梦金人的故事，表达了中国人对佛教东来的理解：

佛法来自西方，却不是以战争和征服的方式进入中国；它由一场梦开始，由使者主动寻求，由僧人带着经书和平而来。白马驮经的故事则把漫长复杂的文明交流，凝聚成一个简单而有力量的画面：

一匹马，驮着经书，从西方走向东方。白马没有军队护送，也没有强迫任何人接受信仰。经书抵达洛阳以后，还要等待翻译、理解、讨论和选择。佛教能否在中国留下来，并不取决于马走了多远，而取决于它能否回答中国人的人生问题。历史告诉我们，佛教的传入是一个复杂过程。

传说告诉我们，后人怎样记住这个过程。二者并不必然冲突。我们可以尊重白马驮经的文化象征，同时承认佛教早在白马寺以前便可能零星进入汉地；可以敬仰摄摩腾、竺法兰的弘法精神，同时承认他们的生平主要保存在数百年后的僧传中；也可以称白马寺为“中国第一寺”，同时说明它更准确地代表第一座重要官办佛寺，而不是排除所有更早的佛教活动。

尊重传统，不等于停止辨析。进行辨析，也不等于消解信仰与文化记忆。

#horizontalrule

== 十二、从白马寺到长安城
<十二从白马寺到长安城>
佛教初入中国时，只是洛阳和彭城等地少数人接触的异域信仰。经书很少，译文生涩，僧人不多，社会影响也十分有限。许多人甚至分不清佛陀与神仙，不理解出家人为何离开家庭。但这场相遇已经无法逆转。此后的几个世纪里，一批又一批西域和印度僧人来到中国，一卷又一卷佛经被翻译成汉文。中国僧人也开始西行求法，学习戒律，搜寻经典。

佛教不再只是宫廷里的一幅金人画像，也不再只是楚王府中的斋戒祭祀。它进入城市，进入山林，进入士人的书房，也进入普通人的生老病死。后来，洛阳会出现规模宏大的译经事业；鸠摩罗什会进入长安，把深奥的般若和中观思想译成流畅汉文；玄奘会越过沙漠与雪山，重新走上佛法西来的道路；禅宗、净土宗、天台宗和华严宗也将在中国相继形成。

这一切，在后人的记忆中，都可以从一匹白马开始。黄昏时分，洛阳城外的道路渐渐隐入暮色。白马停在寺门前。僧人卸下经函，拂去一路风沙。没有人知道，这些陌生文字将在未来改变中国人的语言、艺术、哲学与生死观。一座寺院的门缓缓打开。佛法由此走入中国，也开始了被中国重新理解的漫长旅程。

#horizontalrule

== 小栏目：白马寺真的是中国第一座寺院吗？
<小栏目白马寺真的是中国第一座寺院吗>
白马寺被传统佛教史称为“中国第一古刹”，主要因为它被认为是汉明帝为安置西域僧人、佛经和佛像而建立的第一座重要官办佛寺。但《后汉书》记载，在白马寺传统建立年代以前，楚王刘英已经供奉“浮屠之仁祠”，并供养沙门和在家信徒。因此，中国境内可能更早已有规模较小的佛教活动场所。

所以，“第一寺”最适合解释为：

白马寺是传统上公认的第一座由朝廷正式建立、在后世佛教史中具有明确传承地位的汉地佛寺，而不一定是中国境内绝对最早的一处佛教祭祀场所。

#horizontalrule

== 小栏目：摄摩腾和竺法兰真的存在吗？
<小栏目摄摩腾和竺法兰真的存在吗>
摄摩腾、竺法兰的故事主要见于南朝梁代慧皎的《高僧传》等后世佛教文献，与东汉相距数百年。现存东汉官方记录没有完整记载他们的姓名和生平，因此现代研究不能确认所有细节。不过，这些僧传可能保存了早期西域僧人来华的历史记忆。东汉中后期确有安世高、支娄迦谶等外国译经师在洛阳活动，也说明西域僧人沿商路进入汉地，是当时真实存在的现象。

因此，对摄摩腾、竺法兰最稳妥的态度是：

尊重他们在佛教传统中的开创者地位，同时承认有关生平带有后世传说和整理的成分。

#horizontalrule

== 常见误解：佛教是从白马寺那一天才传入中国的吗？
<常见误解佛教是从白马寺那一天才传入中国的吗>
不是。宗教和思想的传播通常没有唯一而精确的起点。佛教可能早在西汉末年便通过商人、使者和西域居民零星进入汉地。公元六十五年的楚王刘英记载，已经明确出现沙门、在家信徒和佛教供养活动。汉明帝求法和白马寺的意义，在于佛教开始受到朝廷关注，获得相对固定的传播场所，并在后世形成清晰而完整的文化记忆。

因此，白马寺不是佛教与中国发生接触的绝对第一刻，却是佛教正式在中国历史舞台上显现的重要标志。

#horizontalrule

== 本章经典与史料摘录
<本章经典与史料摘录>
《后汉书·楚王英传》：

“楚王诵黄老之微言，尚浮屠之仁祠。”这句话反映了东汉初年佛教与黄老信仰并行、混合的情形，也证明当时已有佛教活动和信徒群体。《后汉书·西域传》：

“世传明帝梦见金人，长大，顶有光明。”“世传”表明这是当时或后世广泛流传的故事，而不是完整的宫廷实录。《高僧传·摄摩腾传》：

“大法初传，未有归信。”佛法初到中国，真正的困难并不是经书能否被带来，而是有没有人能够理解。《洛阳伽蓝记》：

“白马寺，汉明帝所立也。佛入中国之始。”它所表达的不是严格意义上的唯一传入日期，而是白马寺在中国佛教传统中的象征性起点。

#horizontalrule

== 主要参考资料
<主要参考资料>
+ 范晔：《后汉书·光武十王列传·楚王英传》。其中关于楚王刘英“学为浮屠斋戒祭祀”及供养“伊蒲塞、桑门”的记录，是研究东汉早期佛教的重要史料。2. 范晔：《后汉书·西域传》。记载天竺佛教习俗，以及“世传明帝梦见金人”的传统。3. 慧皎：《高僧传》卷一《摄摩腾传》《竺法兰传》《安世高传》《支娄迦谶传》。4. 杨衒之：《洛阳伽蓝记》卷四“白马寺”条。5. 刘屹、刘菊林：《悬泉汉简与伊存授经》，讨论西汉末年伊存口授《浮屠经》记载及其历史背景。6. 傅惠生：《论〈四十二章经〉译文的历史经典性》，讨论经文译者、翻译方式及中外人员合作的可能。7. 有关汉代佛教传播及早期译经史的研究，可参见复旦大学相关佛教史研究资料，其中强调东汉桓、灵帝时期安世高、支娄迦谶译经活动对汉传佛教形成的重要性。

= 第十二章　鸠摩罗什
<第十二章-鸠摩罗什>
#figure([
#box(image("chapters/../images/downloaded/ch12_kumarajiva.jpg", width: 65.0%))
], caption: figure.caption(
position: bottom, 
[
鸠摩罗什大师雕像，甘肃武威海藏寺
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


公元五世纪初的一个冬日，一支从河西走廊而来的队伍进入长安。队伍中有一位来自西域的僧人。他已经不再年轻，身上带着长途跋涉的风尘，也带着十多年羁留凉州的沉默岁月。他出生在龟兹，少年时代游学罽宾、沙勒等地，通晓西域语言，熟悉佛教不同部派的经论，又能够使用汉语讲说佛法。

他的名字叫鸠摩罗什。在他进入长安以前，佛教已经传入中国数百年。佛像、寺院和经书早已出现在洛阳、建康、襄阳等地，许多西域僧人与汉地学者也已经为译经付出巨大努力。然而，佛教真正进入中国人的思想世界，并不只是把一卷卷经书从西域运来，更重要的是：那些诞生于印度的概念，能否被准确而自然地说成中国话。

什么是“空”？什么是“般若”？什么是“中道”？佛经中的“无我”，与老庄所说的“无”是不是一回事？菩萨所修的“方便”，是否只是做事灵活？如果词语相似，背后的思想却完全不同，那么翻译得越顺口，反而可能离佛法越远。鸠摩罗什来到长安，改变的正是这一切。

他的工作不只是把一些经文译成汉语，而是帮助中国佛教逐渐形成了一套能够准确表达大乘佛法、又符合汉语习惯的语言。此后千百年间，人们诵读《金刚经》《法华经》《维摩诘经》，研究《中论》《百论》《十二门论》，其中许多最熟悉、最优美的句子，都出自他所主持的译场。

有时，一个文明的命运，会因为一场战争而转折；有时，也会因为一句话终于被翻译得恰到好处而改变。

== 一、佛经已经来了，佛法是否真正被读懂？
<一佛经已经来了佛法是否真正被读懂>
佛教早期传入中国时，译经是一件极为艰难的事。首先，两种语言的结构完全不同。印度与西域佛典常有复杂的长句、重复的修辞和严密的名相体系，而汉语讲求简练、含蓄和节奏。如果逐字照搬，译文可能生硬难读；如果过度润色，又可能改变原意。其次，许多佛教概念在中国传统思想中找不到完全对应的词语。早期学者为了帮助读者理解，常借用老庄、玄学中的词汇来解释佛教，这种方法后来被称为“格义”。

格义在佛教初传时期有其历史作用。面对一种完全陌生的思想，人们总要借助熟悉的概念来理解它。然而，相似并不等于相同。“空”并不只是“什么都没有”，“涅槃”也不等于道家的自然无为。如果长期依赖固有概念，佛教便可能被理解成另一种玄学。《高僧传》在记述鸠摩罗什进入长安后的译经事业时，特别提到早期部分译本存在文辞阻滞、以格义解释佛理而未能完全契合原本的问题。这并不是否定前代译师的贡献，而是说明佛经翻译需要随着语言能力、原典积累和佛学理解的加深不断改进。

在鸠摩罗什以前，中国佛教已经完成了最初的播种；到了鸠摩罗什时代，人们开始更加迫切地追问：经文究竟在说什么？那些看似相近的名词，背后是否隐藏着完全不同的世界观？鸠摩罗什的意义，正在于他既懂西域佛教，也逐渐懂得中国人的语言与思维习惯。他站在两个文化世界之间，知道原典要表达什么，也知道汉语怎样说才不会失去它的精神。

== 二、从龟兹走出的少年僧人
<二从龟兹走出的少年僧人>
鸠摩罗什的出生年代，古代记载并不完全一致，现代通常采用公元344年至413年的说法。他出生于龟兹，也就是今天新疆库车一带。龟兹位于古代丝绸之路要冲，是一个商业繁荣、文化多元、佛教兴盛的西域王国。“鸠摩罗什”是音译，意译为“童寿”，有“年少而有长者之德”的含义。

他的父亲鸠摩炎出身天竺贵族家庭，后来越过葱岭来到龟兹；母亲耆婆是龟兹王族女子，聪敏好学，后来出家修行。鸠摩罗什七岁随母亲出家，少年时期便随师游学，学习《阿含经》、阿毗达磨等传统佛教经论。早年的鸠摩罗什主要接受说一切有部的教法。这一传统重视对身心现象的细密分析，讨论色、受、想、行、识以及各种心理活动怎样生起、变化和消灭。这样的训练，使他具有极为扎实的佛学基础。

后来，他在沙勒遇见大乘法师须利耶苏摩，开始接触般若与中观思想。最初，他对“一切法空”的说法感到疑惑。他已经习惯把世界分析为一个个真实存在的法，现在却有人告诉他：这些法同样依赖因缘而成立，并没有固定不变的自性。经过反复辩论与思考，他逐渐理解了大乘佛法所说的“空”。《高僧传》记载他回顾过去的学习时感叹：

“吾昔学小乘，如人不识金，以鍮石为妙。”这句话带有古代宗派判教的色彩，并不意味着部派佛教没有价值，而是表现了鸠摩罗什个人思想转变时的强烈感受：他过去所掌握的分析方法并未被完全否定，却在般若与中观的视野中获得了新的解释。此后，他深入学习《中论》《百论》《十二门论》等大乘论典，在龟兹讲说经法，声名传遍西域。也正因为他的名声，远在中原的君主与高僧开始注意到这位西域法师。

== 三、一位法师为何成为战争的目标？
<三一位法师为何成为战争的目标>
今天的人很难想象，一位翻译家竟会成为军队远征的重要目标。前秦皇帝苻坚听说西域有一位精通佛法的鸠摩罗什，希望将他迎到长安，便派将军吕光率军西征。公元384年前后，吕光攻破龟兹，鸠摩罗什被带往东方。然而，吕光返回途中，前秦已经瓦解。吕光于是占据凉州，建立后凉。鸠摩罗什没有立即到达长安，而是在凉州度过了漫长的羁留岁月。

这段经历并不浪漫。他不是自由远游的求法者，而是战乱中的俘虏。传统传记中还记载，吕光曾以种种方式逼迫和侮辱他。对这些带有宗教传记色彩的细节，现代读者不必全部作实录理解，但有一点可以确定：从龟兹到长安的道路，并不是一条平静的文化交流之路，而是伴随着战争、政权更替和个人苦难。

鸠摩罗什在凉州停留十多年。吕光父子并不重视译经，他虽然具有深厚学问，却长期无法展开大规模的佛典翻译。直到后秦君主姚兴击败后凉，鸠摩罗什才终于得以东行。《高僧传》记载，后秦弘始三年，即公元401年，鸠摩罗什进入长安。姚兴以国师之礼相待，经常与他讨论佛法，并在西明阁、逍遥园等处组织译经。

从龟兹被俘到进入长安，已经过去大约十七年。如果只看结果，人们容易说这是“佛法东来的因缘”；但从一个人的生命来看，这十七年意味着青春消逝、故国远去，也意味着长期身不由己。鸠摩罗什没有选择自己来到中原的方式，却仍然选择了怎样使用余下的生命。他无法改变已经发生的战争，却可以让自己所学的佛法不因战争而沉没。

== 四、逍遥园里，佛经是怎样翻译出来的？
<四逍遥园里佛经是怎样翻译出来的>
人们提起鸠摩罗什，常说“他翻译了《金刚经》”。这句话并没有错，却容易使人产生一种误解：仿佛鸠摩罗什独自坐在书桌前，摊开梵文经卷，一字一句写成中文。真实的译经场面更像一所规模庞大的研究院，也像一场持续多年的公开讲学。姚兴为鸠摩罗什组织了由众多僧人参加的译场。僧叡、僧肇、道恒、道标等学僧参与其中。《高僧传》说，当时有八百余人咨询、听受并协助译经。这个数字可能带有古代传记常见的概数意味，但可以确定的是，鸠摩罗什的译经绝不是孤立的个人工作，而是一次集体性的知识工程。

古代经序用一句简练的话描述译场的核心过程：

“手执胡本，口宣秦言。”鸠摩罗什手持西域原本，先诵读经文，再用当时的汉语口头解释。参与译经的僧人记录译文，对词义提出疑问，将新译本与旧译本相互比较。遇到一词多义、句法不明或者教义难点，众人便反复讨论。经序又称其间“交辩文旨”，说明译文并不是一次口授便立即定稿，而是在问答、辩论、记录和修订中逐渐形成。

一次较完整的译经，大致可能经过以下环节：

鸠摩罗什先解释原文的语言和整体意义；熟悉汉语的僧人将其记录下来；义学僧针对经义提出问题；众人比较旧译、核对上下文；负责文字的人调整句式；最后再由鸠摩罗什审定。其中最重要的，并不是把每一个外来词换成一个汉字，而是确定：这句话在整部经中究竟是什么意思？这个词在不同章节是否应保持一致？如果直译会造成误解，怎样调整才能既不背离原意，又让中国读者读得明白？

因此，译经场同时也是讲经场、辩论场和培养佛教学者的学校。鸠摩罗什主持译出的经论数量，历代目录记载并不一致。有的记为三十余部、近三百卷，有的记载更多。《高僧传》概称三百余卷。与其执着于某一个数字，不如看到这些译典涵盖了般若、法华、净土、禅法、戒律与中观论典等多个领域，而且其中许多译本一直流传至今。

== 五、好的翻译，是忠实还是优美？
<五好的翻译是忠实还是优美>
关于鸠摩罗什，人们常说他的翻译“意译为主，文辞优美”。这句话大体不错，却容易被理解为：鸠摩罗什为了文章好看，可以自由删改原文。事实上，鸠摩罗什所追求的并不是脱离原典的文学创作，而是在准确理解经义之后，寻找最适合汉语的表达。他的“达意”，首先建立在通晓佛理之上。只有真正知道原文在说什么，才有可能判断哪些地方应当直译，哪些地方需要调整语序，哪些词应当音译保留，哪些词可以译出意义。

翻译佛经至少面对三重困难。第一重是语言。一个词在原文中可能同时具有多种含义，汉语中却没有完全对应的表达。第二重是思想。译者不仅要知道字面意思，还要知道它在整个佛教教义体系中的位置。若把“空”简单译成“无”，便可能让读者以为佛教否定一切存在；若把“涅槃”理解为死亡，又会失去烦恼止息与解脱的意义。

第三重是文体。印度佛典中有大量偈颂、反复、音韵和修辞，原有的节奏很难完整移入汉语。鸠摩罗什曾感叹，梵文偈颂一经翻译，往往会失去原有声韵，如同“嚼饭与人”：意思也许还能传达，原来的滋味却已经改变。正因为知道翻译必然有所损失，他才格外重视译文的整体神韵。

鸠摩罗什译经的文字通常简洁、流畅而富有节奏，但这种简洁并不只是文学风格，也是一种思想上的取舍。他常常去除不符合汉语习惯的重复，使句子更凝练，同时努力保留教义结构。例如《金刚经》结尾的偈颂：

“一切有为法，如梦幻泡影，如露亦如电，应作如是观。”短短数句，梦、幻、泡、影、露、电六种譬喻依次展开。它没有说世界完全不存在，而是提醒人们：一切由条件聚合而成的现象，都在变化，都不能被当作永恒不变之物执取。译文既保存了般若思想，又形成了汉语诗歌般的节奏，因此能够穿越寺院讲堂，进入诗词、书法和普通人的语言。

好的翻译，不是在“忠实”和“优美”之间任选其一，而是让文字的清楚、准确和可诵读彼此成全。

== 六、《金刚经》：把“空”译成可以实践的智慧
<六金刚经把空译成可以实践的智慧>
鸠摩罗什所译《金刚般若波罗蜜经》，后来成为汉地流传最广的佛经之一。《金刚经》所说的“空”，并不是要求人拒绝现实，也不是让人宣布善恶、责任和生命都没有意义。它所要破除的，是人对固定自我和固定事物的执著。人总以为自己的身份、成就、关系和处境具有某种不变的本质：成功了，便希望永远保持；失去了，便觉得人生从此完全破碎。般若智慧告诉我们，一切现象都是因缘所生。既然依赖条件，就会随着条件变化；既然不断变化，就不应把它抓住当成永恒的“我”和“我的”。

因此，《金刚经》一面说不应执著于相，一面又反复教导菩萨度化众生。正因为没有一个固定不变的“我”，人才可能放下自我中心；正因为众生与世界处在相互依存之中，慈悲才不只是道德命令，而是对缘起事实的回应。鸠摩罗什的译文，把深奥的般若思想化为凝练而有力量的汉语。后来六祖慧能听闻《金刚经》而发心求法，禅宗又反复引用其中关于“无住”的教诲。由此可见，翻译不仅决定一部经书是否易读，也可能影响后来宗派如何理解修行。

一句译文，可能成为另一个时代的入口。

== 七、《法华经》：让“一乘”成为中国佛教的重要理想
<七法华经让一乘成为中国佛教的重要理想>
鸠摩罗什译出的《妙法莲华经》，对中国佛教产生了极为深远的影响。《法华经》面对的是一个重要问题：佛陀为什么说出许多看似不同的教法？声闻、缘觉和菩萨所走的道路是否彼此隔绝？普通人是否也有可能成佛？经中说：

“唯有一乘法，无二亦无三，除佛方便说。”这里的“一乘”，不是说所有修行方法必须变得完全一样，而是说佛陀施设不同教法，最终都以引导众生成佛为目标。众生根机不同，佛陀便采用不同的语言和方法，这就是“方便”。“方便”不是欺骗，也不是为了达到目的可以不择手段。真正的方便必须以智慧观察众生的处境，以慈悲选择对方能够接受的方式，并且始终指向离苦与觉悟。

《法华经》的这一思想，为中国佛教后来面对众多经典、众多法门时提供了一种整合方式：不同教法不必彼此排斥，可以根据对象和阶段发挥作用。后来天台宗以《法华经》为根本经典，智者大师据此建立系统的判教与修行理论。《观世音菩萨普门品》也从《法华经》中单独流传，使观音信仰深入中国社会。

如果没有一部清楚、流畅、适合讲说和诵读的译本，这些思想便很难产生如此广泛的影响。鸠摩罗什翻译的，不只是字句，也是佛教在中国继续生长的可能。

== 八、《维摩诘经》：在家人也能走菩萨道
<八维摩诘经在家人也能走菩萨道>
《维摩诘所说经》是鸠摩罗什译本中极具文学魅力的一部。经中的主人公维摩诘并不是出家僧人，而是一位生活在城市中的在家居士。他有家庭和社会身份，出入市井，却能以智慧和慈悲教化众生。许多大弟子面对他的诘问都难以应对，文殊菩萨则与他展开一场关于“不二法门”的著名对话。

这部经给中国读者留下了一个重要启示：佛法并不只存在于远离人群的山林中，菩萨道也不只是出家人的道路。人在家庭中可以修忍辱，在职业中可以守正命，在关系中可以学习慈悲，在疾病与挫折中可以观察无常。修行并不是逃离生活之后才开始，而是在生活的每一个接触点上学习不被贪、嗔、痴牵引。

《维摩诘经》还以大量机锋、譬喻和戏剧性场面表达般若智慧。它后来深刻影响了中国士大夫文化、文学艺术以及禅宗语言。王维的名与字------名“维”，字“摩诘”------便取自维摩诘。佛法进入中国，不只是增加了一批宗教术语，也改变了中国人谈论疾病、沉默、智慧、出世与入世的方式。

== 九、《中论》：空不是虚无，而是缘起
<九中论空不是虚无而是缘起>
如果说《金刚经》和《法华经》使大乘佛法广泛进入信仰与修行生活，那么鸠摩罗什所译《中论》《百论》《十二门论》，则为中国佛教提供了严密的哲学基础。《中论》由龙树菩萨所造，以缘起为中心，破除人们对一切固定自性的执著。后来中国形成三论学派，便以《中论》《百论》《十二门论》为主要依据。

《中论》中有一首极为重要的偈颂：

“众因缘生法，我说即是无，亦为是假名，亦是中道义。”这里的“无”，应结合全论理解为无自性，而不是说什么都不存在。一个事物既然由众多条件共同形成，就不具有独立、永恒、不依赖其他条件的本体。但它仍然能够在因缘关系中发挥作用，所以又称“假名”。例如，一辆车由车轮、车架、动力系统以及人的命名共同成立。离开这些部分与条件，找不到一个独立存在的“车”；但这并不妨碍人在日常生活中使用它。佛教所说的空，不是否定现象，而是否定现象背后存在一个固定不变的自性。

因此，缘起与空不是两套相反的理论。正因为一切法空无自性，才可能依因缘而生起；正因为事物依因缘而生，才必然没有固定自性。这就是中道：既不把事物执为永恒实有，也不落入一切皆无的虚无主义。鸠摩罗什及其弟子对中观经典的翻译和讲解，使中国佛教学者能够更准确地区分“空”与玄学之“无”。他的弟子僧肇进一步以中国人熟悉的语言阐发般若与中道，写成《肇论》，成为中国佛教思想史上的重要著作。

翻译到了这里，已经不再是文字技术，而是在重新塑造一个文明思考世界的方式。

== 十、鸠摩罗什不是一个人在翻译
<十鸠摩罗什不是一个人在翻译>
鸠摩罗什的成就，不能只归于个人天才。他的译场中有精通汉语文辞的人，有擅长佛教义理的人，有负责记录、校订和比较旧译的人。僧叡善于整理经义与撰写经序；僧肇深研般若和中观，后来成为重要思想家；道生进入长安参学后，又从《法华经》《涅槃经》等思想中发展出众生皆有成佛可能的主张。

一部译经的诞生，是跨语言、跨地域和跨世代的合作。原典来自印度或中亚，译师来自龟兹，译场设在长安，参与者包括西域僧人与汉地学僧，支持者则是后秦政权。此后这些译本又传入朝鲜半岛、日本和越南，成为整个东亚佛教共同的经典语言。因此，鸠摩罗什并不是简单地把印度佛教“搬运”到中国。他与译场僧众共同完成了一次创造性的文化转化：原有教义得到保存，却不再以陌生生硬的面目出现；汉语被赋予新的思想能力，佛教也获得了在中国继续发展的语言身体。

现代研究者仍将鸠摩罗什视为汉译佛典史上最重要的译师之一。他所主持的许多译本，即使后来出现了更完整或在名相上更精密的新译，仍长期用于诵读、讲解和宗派义学之中。

== 十一、鸠摩罗什与玄奘：谁翻译得更好？
<十一鸠摩罗什与玄奘谁翻译得更好>
后人常把鸠摩罗什与唐代玄奘比较。鸠摩罗什的译本通常被称为“旧译”的重要代表，玄奘译本则被称为“新译”。鸠摩罗什重视整体意义与汉语流畅，玄奘则更强调名相对应和原文结构的精确。于是，有人简单地说：鸠摩罗什译得优美，玄奘译得准确。这种说法过于绝对。

首先，两人所依据的原本不一定完全相同。佛经在印度与西域长期传抄，本来就可能存在不同版本。后来译本篇幅较长或用词不同，并不能直接证明早期译者任意删节。其次，两人的翻译目标和时代条件不同。鸠摩罗什面对的是佛教概念尚未完全定型的汉语世界，首要任务是让经义能够被理解、讲说和接受；玄奘生活在佛教义学高度发展的唐代，需要建立更严密统一的术语系统，以支持唯识等复杂理论的研究。

最后，佛经也有不同用途。用于宗派哲学研究时，精确稳定的术语十分重要；用于诵读、讲说和日常修持时，流畅清楚的文字同样不可缺少。两位译师不是简单的高下关系，而是代表了汉译佛典在不同阶段的成熟。鸠摩罗什使佛经能够自然地说汉语，玄奘则使许多佛教名相获得更加系统严密的表达。

他们共同拓宽了汉语能够承载的思想边界。

== 十二、传说中的“不烂之舌”
<十二传说中的不烂之舌>
关于鸠摩罗什，最著名的故事之一是“火焚之后，舌头不坏”。《高僧传》记载，鸠摩罗什临终前对僧众说，自己主持翻译了众多经论，如果所译没有严重错误，希望火化之后舌头不被烧坏。传记随后说，他火化后身体化为灰烬，舌头却没有烧毁。从佛教信仰传统看，这个故事象征着“舌根清净”和译经真实，表达后人对鸠摩罗什的敬仰。

从现代历史研究看，我们无法用这一故事证明某一译本在语言学上绝对无误。古代高僧传记常以神异故事彰显人物德行，这类内容应当放在宗教文学与信仰表达的背景中理解。尊重传统，并不等于必须把所有传说当作可验证的历史事实；保持理性，也不意味着要嘲笑古人的信仰。

比“不烂之舌”更能够经受历史检验的，是他的译本本身。一千六百多年过去，《金刚经》仍被诵读，《法华经》仍被讲说，《维摩诘经》仍启发人们思考出世与入世，《中论》仍帮助读者理解缘起与空。无数人在并不知道鸠摩罗什生平的情况下，仍然通过他的语言接近佛法。

这或许才是“不烂之舌”最深刻的含义：一个人的身体终会消失，但他所说出的真实而有益的语言，可以继续在人间流传。

== 十三、常见误解：佛经翻译是不是只要懂外语？
<十三常见误解佛经翻译是不是只要懂外语>
不是。懂得两种语言，只是译经的起点。佛经译者首先要理解语言，包括词义、语法、文体和历史语境；还要理解佛教教义，知道一个词在经、律、论中的不同用法；还要理解两种文化，预见某种译法可能引起的联想和误解。更重要的是，译者必须对自己的理解保持谨慎。

一个人若只懂语言而不懂佛法，可能译出字面通顺、义理却错误的经文；只懂佛法而汉语表达不佳，译文又可能艰涩难读；只追求优美而随意改变原意，佛经便会变成译者自己的作品。鸠摩罗什译经的成功，来自语言能力、佛学修养、文化理解和集体校勘的结合。翻译也不是透明的搬运。每当译者选择一个词，便同时选择了一种理解。用“觉悟”还是“觉醒”，用“空”还是“无”，用音译保留陌生感，还是用意译帮助理解，都会影响后来读者怎样认识佛教。

所以，佛教进入中国，并不是在某一天越过边境便自动完成。它需要一次又一次讲解，一次又一次核对，一次又一次在“准确”与“可懂”之间寻找平衡。鸠摩罗什最大的贡献，不只是翻译得多，而是让佛法获得了一种能够在中国人的口中诵读、在头脑中思考、在生活中实践的语言。

== 十四、语言，也是佛法东来的道路
<十四语言也是佛法东来的道路>
长安的译场早已消失，逍遥园也只存在于历史记载中。但是，鸠摩罗什留下的声音并没有消失。今天，当一个人翻开《金刚经》，读到世间如梦幻泡影；当一个人在困境中思考“不应执著于相”；当一个普通居士从维摩诘的故事中明白，修行不必离开家庭与社会；当一个学佛者终于知道“空”不是虚无，而是因缘和合、没有固定自性------鸠摩罗什的翻译仍在发挥作用。

佛法从印度来到中国，要经过沙漠、雪山和战争，也要经过词语与词语之间那条更加隐秘的道路。一边是原典所承载的思想，一边是中国人熟悉的语言。译者站在两者之间，既不能丢失来处，也不能拒绝抵达。鸠摩罗什用自己辗转而坎坷的一生，完成了这样的抵达。他没有建立一个帝国，没有统领一支军队，也没有留下宏伟的宫殿。他留下的是一批句子。

然而，有些句子比城池更加长久。长安城一次次毁于战火，又一次次重建；王朝兴亡，宫阙荒废。只有那些经过反复思考、讨论和斟酌的文字，被一代代人抄写、刻印和诵读，穿过了漫长时间。翻译并不是佛教传播之后附带发生的工作。翻译本身，就是佛法东来。

#horizontalrule

=== 本章经典原文
<本章经典原文>
一切有为法，如梦幻泡影，如露亦如电，应作如是观。------鸠摩罗什译《金刚般若波罗蜜经》

=== 本章核心知识
<本章核心知识>
鸠摩罗什：出生于龟兹的西域高僧、佛教学者和译经家，后在长安主持大规模译经。译场：由译师、义学僧、记录者和校订者共同参与的佛经翻译机构，也兼具讲经、讨论与人才培养功能。旧译：玄奘以前汉译佛典的传统称呼，鸠摩罗什是其中最重要的代表之一。新译：主要指唐代玄奘等人所形成的翻译体系，特点是名相严密、对应较为统一。

格义：借用中国固有思想和名词解释佛教概念的方法，在佛教初传时有帮助，也可能造成误解。中观：以缘起、性空和中道为核心的大乘佛教思想，龙树《中论》是其代表论典。

=== 本章主要参考典籍
<本章主要参考典籍>
梁·慧皎：《高僧传》卷二〈鸠摩罗什传〉。梁·僧祐：《出三藏记集》。鸠摩罗什译：《金刚般若波罗蜜经》。鸠摩罗什译：《妙法莲华经》。鸠摩罗什译：《维摩诘所说经》。龙树造、鸠摩罗什译：《中论》。提婆造、鸠摩罗什译：《百论》。龙树造、鸠摩罗什译：《十二门论》。

= 第十三章　玄奘西行
<第十三章-玄奘西行>
#figure([
#box(image("chapters/../images/downloaded/ch13_xuanzang.jpg", width: 65.0%))
], caption: figure.caption(
position: bottom, 
[
西安大雁塔外景及玄奘法师铜像
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


一匹瘦马，一个水囊，一位年轻僧人。前方，是八百余里的沙漠；身后，是他刚刚越过的关塞。四周没有飞鸟，没有走兽，也看不见一株可以辨认方向的草木。白昼狂风卷起黄沙，天地昏暗；入夜之后，气温骤降，远处时常出现若有若无的光影。更不幸的是，玄奘在途中失手打翻了水囊。

在沙漠里，水就是性命。没有向导，没有水源，继续向西几乎等于送死。他一度调转马头，准备返回东面的烽燧。可是走出十余里后，他忽然想起自己出发时所立的誓愿：

#quote(block: true)[
“宁可就西而死，岂归东而生！”
]

于是，他再次拨转马头，向西而去。这句话后来常被转述为“宁可西行而死，不可东归而生”。后者意思相近，但《大唐大慈恩寺三藏法师传》中的原文，正是“宁可就西而死，岂归东而生”。传记记载，玄奘在沙漠中四夜五日滴水未进，几近昏厥，最终才遇到水草，保全性命。无论其中是否包含后世佛教传记常见的神异叙述，这段文字所保存的，首先是一位求法者面对死亡时仍不肯放弃的决心。

许多人是从《西游记》中认识玄奘的。小说里的唐僧骑着白马，有孙悟空、猪八戒和沙和尚保护，一路降妖伏魔，历经九九八十一难，终于到达西天。真实的玄奘没有金箍棒，也没有能够腾云驾雾的徒弟。但他的旅程并不比神话逊色。在某种意义上，甚至更加壮阔。

#horizontalrule

== 一、他为什么一定要去印度？
<一他为什么一定要去印度>
玄奘，俗姓陈，通行说生于公元602年，卒于664年；关于其生年，学界也有公元600年等不同说法。他出生于洛州缑氏，即今天河南洛阳附近。少年时随兄长学习佛法，十三岁出家，二十岁受具足戒。隋末唐初，天下战乱，寺院讲席时聚时散，他先后在洛阳、长安、成都、荆州、相州、赵州等地参访名师，学习《涅槃经》《摄大乘论》《俱舍论》《成实论》等经论。

玄奘并不是因为不懂佛法，才想到印度学习。恰恰相反，他是因为学得太多，才发现问题越来越多。当时，佛教传入中国已经数百年。不同年代、不同地区的译师，依据不同梵本、不同传承翻译经典；同一概念可能有不同译名，同一部经论的不同译本之间，有时也存在差异。各地讲经法师又有各自的师承和解释，彼此之间未必能够完全一致。

玄奘遍访诸师之后，发现各家“各擅宗途，莫知适从”。他并不愿意随便选择一种自己喜欢的说法，更不愿意把疑问压在心里。他希望亲自寻找更完整的梵文原典，向印度高僧请教，并特别希望获得当时中国尚不完备的《瑜伽师地论》。玄奘传记称，他决定“游西方以问所惑”，正说明他的西行，首先源于一种严肃的求真精神。

因此，玄奘西行并不是为了猎奇，也不是为了获得神秘力量。他想解决的是佛法理解上的根本问题：

不同译本为何互有差异？大乘经典应当怎样理解？“空”与“有”是否彼此冲突？众生的认识、烦恼与解脱，究竟怎样发生？这些疑问，在当时的中国很难得到令他完全信服的回答。于是，他决定循着佛法传来的道路，反向前往佛教的故乡。与其说玄奘是去“寻找几本经书”，不如说，他是去寻找一套能够校正、解释和贯通佛教思想的完整知识体系。

#horizontalrule

== 二、没有通关文牒的出发
<二没有通关文牒的出发>
唐朝初年，边境局势尚未稳定，朝廷一度限制百姓私自出境。玄奘曾与同伴申请西行，但没有获得许可。其他人相继放弃，玄奘却没有改变主意。贞观三年，即公元629年前后，他离开长安，向西出发。严格来说，玄奘并不是从长安到印度始终孤身一人。在不同路段，他曾与僧人、商旅、使者同行，也受到沿途国王、官员和佛教徒的帮助。但在越过玉门关、穿越莫贺延碛等危险路段时，他确实曾失去向导，独自骑马前行。传记甚至用“孑然孤游沙漠”来形容当时的处境。

他的路线大致从长安出发，经凉州、瓜州，越过玉门关和莫贺延碛，到达伊吾、高昌；之后继续穿越今天的新疆、中亚地区，经龟兹、凌山、碎叶、飒秣建等地，越过帕米尔高原和兴都库什山脉，最终进入印度。这不是一条已经铺设好驿站和道路的旅游线路。沙漠里没有路标，只能依据前人遗留的骨骸、马粪和远山辨认方向；雪山之上气候骤变，同行者可能冻饿而死；有些地区战乱频仍，有些山道常有盗贼。每进入一个国家，还要面对语言、礼俗、政治关系和宗教派别的差异。

今天的人坐飞机，从西安到印度只需数小时。玄奘走过这段距离，却用了数年。他的脚步所经过的，不只是地理上的沙漠与雪山，也是古代文明之间巨大的语言和知识边界。

#horizontalrule

== 三、高昌王的挽留：供养不是占有
<三高昌王的挽留供养不是占有>
玄奘抵达高昌后，受到高昌王麹文泰的隆重接待。麹文泰敬仰玄奘的学识，希望他留在高昌长期讲经。他提供住所、饮食和种种供养，甚至想以强硬方式挽留。玄奘却坚持继续西行。传记记载，他一度绝食，以表明志向不可改变。高昌王最终被他的决心打动，不仅同意放行，还为他准备衣物、马匹和路费，并写信给沿途各国，请求给予照顾。这些物资和国书，为玄奘继续穿越西域提供了重要帮助。

这段经历体现了玄奘性格中很重要的一面。他并不拒绝帮助，却不会因为优厚的供养改变志向；他尊重国王，却不把权势当作必须服从的真理。佛教所说的“供养”，本来是为了帮助他人闻法、修行和弘法，而不是把受供养者变成自己的私有之物。真正的护法，也不是把高僧留在身边作为荣耀，而是成全他所承担的事业。

麹文泰最终放玄奘西行，正是从“挽留一位高僧”，转变为“帮助一项求法事业”。

#horizontalrule

== 四、那烂陀寺：他不是去拿经，而是去读书
<四那烂陀寺他不是去拿经而是去读书>
经过漫长跋涉，玄奘到达印度。他参礼佛陀诞生、成道、初转法轮和涅槃等圣迹，也在各地寻访不同部派和学派的高僧。但他最重要的学习地点，是摩揭陀国的那烂陀寺。那烂陀寺是当时印度规模宏大的佛教寺院和学术中心。这里不仅教授佛教经、律、论，也研习因明、声明、医学以及印度其他哲学流派。玄奘在这里拜高僧戒贤论师为师，系统学习《瑜伽师地论》以及唯识、中观、因明等学问。

《大唐大慈恩寺三藏法师传》记载，戒贤为玄奘开讲《瑜伽论》，一次讲席历时十五个月，同听者数以千计。玄奘后来又多次学习相关经论，研究不同学派之间的异同。所以，玄奘的“取经”，绝不是到了印度以后，把经书装进行李便返回中国。经书不是商品，买到手里就算拥有。

一部佛典背后，包含语言、术语、师承、注疏和论辩传统。没有老师讲解，不了解相关学派，即使把梵文经本带回中国，也未必能够准确翻译，更难回答中国佛教界长期存在的疑问。玄奘在印度所做的，是一场长期而艰苦的系统学习：

他学习梵文和印度语言；听受不同部派的经论；研究大乘与部派佛教的思想；学习因明，也就是印度传统的逻辑与论辩方法；参访高僧，反复请教疑难；亲自考察佛教遗迹和各地佛教流传情况。复旦大学相关研究指出，玄奘在那烂陀寺学习《瑜伽师地论》、因明及多种经论，并在印度佛教论辩传统中取得很高声望。他不仅接受老师的教导，也会对既有论证提出修正意见。

这正是玄奘不同于普通旅行者的地方。他不仅能吃苦，而且能学习；不仅有信仰，而且有分析能力；不仅尊重传统，也敢于在传统内部提出问题。

#horizontalrule

== 五、“空”与“有”真的互相矛盾吗？
<五空与有真的互相矛盾吗>
玄奘在印度学习期间，接触到佛教内部不同的思想传统。一些学者依据《中论》《百论》等经典，强调诸法无自性，重视“空”的思想；另一些学者依据《瑜伽师地论》等经论，分析心识活动、修行阶位和认识过程，通常被称为瑜伽行派或唯识学派。如果只看字面，似乎一方在说“空”，一方在说“有”，彼此水火不容。

玄奘却不愿意轻易把两者对立起来。传记记载，他认为佛教圣者随不同对象和问题建立教说，各有侧重，未必彼此矛盾；如果后人不能融会贯通，问题可能出在学习者，而不在佛法本身。后来，当那烂陀寺有学者以中观义批评瑜伽行派时，玄奘曾试图从更完整的角度加以会通。

这种态度很值得注意。面对思想差异，人们最容易做的，是迅速站队：一派正确，另一派错误；或者把自己熟悉的说法当作唯一标准。玄奘采取的却是另一条道路：

先弄清每一种说法在回答什么问题；再考察它所依据的经典和语境；最后判断它们究竟是真正矛盾，还是层次和角度不同。这也是佛教所重视的智慧：不是回避分别，而是不被粗糙、僵硬的分别所控制。

#horizontalrule

== 六、唯识到底在说什么？
<六唯识到底在说什么>
玄奘回国后所传译的思想中，最有代表性的便是唯识学。“唯识”两个字，常使现代读者产生误解。有人认为，它是在说“整个世界只是我的想象”，或者“一切都不存在”。这都过于简单。唯识学首先提醒我们：人所经验到的世界，从来不是一个未经加工、原封不动进入心中的世界。

同一句话，有人听见的是善意，有人听见的是讽刺；同一次失败，有人认为人生已经结束，有人却把它看成改变方向的机会；同一个人，在喜欢他的人眼中和讨厌他的人眼中，仿佛成了两个完全不同的人。外在事情固然有其因缘，但我们所感受到的“世界”，总是经过感官、记忆、情绪、习惯和执著的共同作用。

《唯识三十论》说：

#quote(block: true)[
“是诸识转变，分别所分别；由此彼皆无，故一切唯识。”
]

这里并不是说桌椅山河毫无意义，而是说，我们执著为固定不变的“我”和“事物”，离不开识的分别、建构与显现。唯识学将人的认识活动进一步分析为八识：

眼识、耳识、鼻识、舌识、身识，负责对色、声、香、味、触的了别；第六意识进行判断、推理、想象和分别；第七末那识不断执取一个中心化的“我”；第八阿赖耶识则被用来说明业力、习气和生命经验如何相续。这些概念不是为了制造一套玄秘的灵魂结构，而是为了分析：烦恼为什么反复出现？习惯为什么如此顽固？我们为什么总把自己的看法误认为事实本身？

例如，一个人小时候曾经受到公开嘲笑，此后每当需要当众发言，便会紧张、逃避。他明知眼前的人未必会嘲笑自己，身体和情绪却仍然自动作出反应。唯识学会把这种现象理解为过去经验留下的“习气”在适当因缘下再次现行。修行的意义，就是通过戒、定、慧与持续观照，使染污的习气逐渐减弱，使智慧与慈悲的种子不断增长。唯识并不要求人逃离世界，而是要求人看清：我们以为自己正在直接面对世界时，其实也在面对自己长期形成的心识习惯。

因此，唯识的最终目的不是证明一个哲学命题，而是“转依”------转变生命所依止的认识方式，使执著转为智慧，使烦恼转为清净。

#horizontalrule

== 七、名震五印度，却仍然选择回国
<七名震五印度却仍然选择回国>
玄奘在印度学习多年，逐渐获得很高声望。传记记载，他曾在那烂陀寺讲授《摄大乘论》《唯识决择论》等，也参与佛教内部及佛教与其他印度学派之间的论辩。在戒日王主持的曲女城无遮大会等活动中，他受到许多僧侣和国王尊重。有关论辩“无人能破”等记载，带有中古高僧传记常见的赞颂色彩，不宜完全当作现代新闻记录理解；但从多种材料可以确认，玄奘在印度佛教学术界确实获得了相当高的地位。

许多人劝他留在印度。在佛教发源地，他已经拥有名望、师友和安定的学习环境。回到中国，却要面对漫长路途，还要从头开始组织翻译。玄奘仍然决定回国。有人劝他说，印度是佛陀出生之地，圣迹众多，为什么还要返回遥远的中国？玄奘回答：

#quote(block: true)[
“法王立教，义尚流通。”
]

佛陀建立教法，意义正在于使其流传，使尚未理解的人能够理解，而不是让少数已经得到教法的人独自享有。这一回答说明，玄奘的求法从来不只是个人求知。假如只为自己学习，他完全可以留在那烂陀寺；正因为他想到中国还有无数人等待完整的经典和准确的解释，所以必须把所学带回去。

真正的大乘精神，不只是“我终于找到了答案”，而是“怎样让更多人也能够接触答案”。

#horizontalrule

== 八、长安归来：一座城市迎接一个僧人
<八长安归来一座城市迎接一个僧人>
公元645年，玄奘回到长安。他带回大小乘佛典梵本六百五十七部，以及佛像、舍利等物。《大唐大慈恩寺三藏法师传》形容，当时长安道俗出城迎接，街道上人群聚集，几乎形成“倾都罢市”的景象。传记的辞藻固然带有渲染，却反映出玄奘归国在当时社会造成的巨大轰动。

唐太宗接见玄奘，详细询问西域和印度情况，并希望他参与国家政务。玄奘没有接受出仕的安排，而是请求集中精力翻译佛经。此后近二十年，他几乎把全部生命投入译经事业。玄奘的翻译并不是一个人关在房间里逐字改写。唐代译场是一项分工严密的集体工程，设有译主、证义、笔受、缀文、书手等人员：

有人核对梵文原本；有人讨论教义；有人记录口译；有人调整汉语文句；有人校勘和誊写。玄奘是整个译场的核心。他既要精通梵汉语言，又要理解原典背后的教义传统，还要对不同意见作出判断。《大唐大慈恩寺三藏法师传》记载，他在弘福寺开始翻译前，专门列出证义、缀文、笔受、书手等所需人员，请朝廷提供支持。

按通行统计，玄奘及其译场共译出佛典七十五部、一千三百三十五卷，包括《瑜伽师地论》《成唯识论》《大般若经》《大毗婆沙论》《俱舍论》《解深密经》以及流传广泛的《般若波罗蜜多心经》等。后世常把玄奘以前的译经称为“旧译”，将玄奘所开创的翻译体系称为“新译”，足见其在汉传佛教译经史上的分量。

其中，《成唯识论》尤其特殊。它以世亲《唯识三十颂》为基础，综合印度多位论师的解释，以护法一系学说为主要立场，由玄奘组织译成十卷。其弟子窥基又撰写《成唯识论述记》等注疏，逐渐建立中国的法相唯识教学。玄奘带回来的，不只是几百部经书。他带回了一整套新的术语、新的论证方法、新的经典系统和新的佛学视野。

#horizontalrule

== 九、《大唐西域记》：不只是一部旅行日记
<九大唐西域记不只是一部旅行日记>
玄奘归国后，奉唐太宗之命讲述自己在西域和印度的见闻，由弟子辩机整理成《大唐西域记》，全书十二卷。书中记录了玄奘亲自游历的一百一十多个国家和地区，以及从他人处听闻的二十多个国家。内容不仅涉及寺院、僧侣和佛教圣迹，还包括山川道路、疆域距离、气候物产、城市建筑、政治制度、语言文字、衣食习俗和历史传说。

因此，《大唐西域记》不是一本只写“今天走到了哪里”的私人日记。它更像一部七世纪中亚、南亚的综合地理与文化记录。玄奘每到一地，常先说明国土范围、都城规模、土地气候、风俗语言，再叙述当地佛教寺院、僧侣人数、所学部派和重要遗迹。这种相对稳定的记述方式，使《大唐西域记》具有超出宗教传记的史料价值。

近现代以来，考古学家和历史学家曾利用书中的地理记载，考察古代印度城市和佛教遗址。即使其中也包含传闻、神异故事和中古地理观念，它仍然是研究七世纪西域、印度历史以及佛教传播的重要文献。相关研究认为，《大唐西域记》兼具宗教、历史、地理、文学和跨文化记录的多重价值。

如果说玄奘翻译的经论，把印度佛教思想带入中国，那么《大唐西域记》则把一个辽阔、复杂而真实的西域与印度世界，带入了中国人的知识视野。

#horizontalrule

== 十、真实的玄奘与《西游记》的唐僧
<十真实的玄奘与西游记的唐僧>
《西游记》的故事，确实源于玄奘西行求法的历史。但从历史事件到百回本小说，中间经历了数百年的民间传说、说唱文学、取经诗话和戏曲演变。孙行者、猪八戒、沙和尚等形象，是在长期文学创作中逐渐形成的。中国国家博物馆相关研究指出，宋代取经故事已经出现孙行者和深沙神，元代故事又增加猪八戒，最终发展成明代百回本《西游记》。

所以，《西游记》里的唐僧不能简单等同于历史上的玄奘。小说中的唐僧往往显得柔弱、容易受骗，需要孙悟空保护；真实的玄奘则是一位意志坚定、判断力很强的僧人。他能够穿越沙漠和雪山；能够拒绝国王的强行挽留；能够在陌生文明中学习多年；能够用梵语讲学和参与论辩；

能够回国主持规模庞大的翻译工程；也能够面对皇帝，坚持自己不愿出仕、只愿译经的选择。小说中的降妖伏魔，是文学创造。真实玄奘所战胜的，则是饥渴、寒冷、恐惧、语言障碍、知识疑难，以及人在名利和安逸面前最容易生起的退缩之心。神话赋予他九九八十一难。

历史却告诉我们：真正困难的，从来不是打败一只看得见的妖怪，而是在看不见终点的时候，仍然知道自己为什么出发。

#horizontalrule

== 小栏目：为什么称玄奘为“三藏法师”？
<小栏目为什么称玄奘为三藏法师>
“三藏”指佛教的经藏、律藏和论藏。经藏主要保存佛陀及佛弟子的教说；律藏主要记录僧团戒律和生活规范；论藏则对佛法义理进行分析、解释和论证。“三藏法师”原本是一种尊称，指通晓经、律、论三藏，或者能够翻译三藏经典的高僧，并不是玄奘一个人的专属名字。

中国历史上，鸠摩罗什、真谛、不空等译经高僧也可以称为三藏法师。只是由于玄奘西行故事影响极大，后来普通人一提到“三藏法师”，往往首先想到玄奘。

#horizontalrule

== 常见误解：玄奘只是去印度把佛经取回来吗？
<常见误解玄奘只是去印度把佛经取回来吗>
不是。把玄奘的事业概括成“去印度拿了几箱佛经回来”，会忽略最重要的部分。他出发前，已经在中国学习佛法多年；到达印度后，又长期学习语言、经典、注疏、因明和不同学派；回国后，还要组织译场，经过讲解、讨论、记录、润文和校勘，才能使梵文经典变成中国读者可以研习的汉文佛典。

一部经典真正的“传入”，至少包含四个过程：

获得原典；理解原典；准确翻译；建立能够继续讲授和解释它的传承。玄奘的伟大，就在于他几乎完整承担了这四个过程。他不是一名搬运经书的人。他是一位求法者、旅行者、语言学者、佛学思想家、翻译家和教育者。

#horizontalrule

== 玄奘留给现代人的，不只是坚持
<玄奘留给现代人的不只是坚持>
人们谈到玄奘，最常赞叹他的坚持。但坚持本身并不必然高尚。一个人如果方向错误，越坚持，可能离目标越远。玄奘的可贵之处，在于他的坚持建立在三个基础上。第一，是疑问。他并非为了证明自己早已正确，而是因为承认自己仍有不懂之处，才踏上旅程。真正的学习，往往从“我可能还没有完全理解”开始。

第二，是求证。他不满足于听说，也不满足于选择自己喜欢的答案，而是寻找原典、参访名师、比较不同学派。信仰在他那里，并不是拒绝思考，而是支持他把思考进行到底。第三，是利他。他在印度获得声望后仍然回国，因为佛法不应成为个人收藏的知识。他愿意用余生翻译，就是希望后来的人不必重新走完他所走过的全部道路。

玄奘的一生，像一条从长安伸向天竺、又从天竺返回长安的长路。向西时，他带着中国佛教的疑问而去；向东时，他带着印度佛教的经典与智慧归来。沙漠、雪山和国界，没有阻断佛法的流动，反而使两大文明在一个僧人的生命中相遇。《西游记》让我们记住了一个神话中的唐僧。

历史上的玄奘却提醒我们：真正能够穿越漫长黑夜的，不是神通，而是愿力；不是永远没有恐惧，而是在恐惧之中，仍然不忘自己为何出发。在莫贺延碛的黄沙中，他曾短暂转身向东。但最终，他还是拨转马头，重新向西。那一刻，改变的不只是一位僧人的命运。一条连接长安与天竺、连接汉语与梵语、连接中国与印度的佛法之路，也由此继续向前延伸。

#horizontalrule

== 本章经典原文
<本章经典原文-1>
#quote(block: true)[
“宁可就西而死，岂归东而生！”
]

------《大唐大慈恩寺三藏法师传》通行转述：

#quote(block: true)[
宁可西行而死，不可东归而生。
]

这句话并不是鼓励人盲目冒险，而是在说明：当一个人已经审慎确认了真正值得承担的方向，就不能因为暂时的恐惧，轻易背弃初心。

#horizontalrule

== 本章小结
<本章小结>
玄奘西行的直接原因，是中国佛教经典和各家解释之间存在疑难，他希望寻找更完整的梵文原典，特别是系统学习《瑜伽师地论》。他的西行历经沙漠、雪山、盗贼、疾病和政治阻碍，却并非从头到尾完全独行，而是在不同阶段获得沿途僧俗、商旅和各国君主的帮助。玄奘在那烂陀寺等地长期学习佛法、语言和因明。他的“取经”首先是一场系统留学与求法，其次才是把经本带回中国。

归国后，他主持译经近二十年，按通行统计译出七十五部、一千三百三十五卷佛典，开创了影响深远的“新译”体系。《大唐西域记》不仅记录佛教圣迹，也保存了七世纪中亚和印度的地理、政治、文化与社会资料。《西游记》中的唐僧以玄奘为历史源头，却是长期文学演变形成的艺术形象。真实的玄奘，是一位意志坚定的求法者、学者、翻译家和文明交流者。

= 第十四章　鉴真东渡
<第十四章-鉴真东渡>
#figure([
#box(image("chapters/../images/downloaded/ch14_jianzhen.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
日本奈良唐招提寺鉴真大和尚坐像
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


公元753年深秋，扬州江边，夜色已经沉了下来。一位年过花甲、双目失明的老僧，悄然走出自己住了多年的龙兴寺。他没有车马仪仗，也没有公开送行，因为唐朝对于人员出境有严格限制，地方僧俗又担心他渡海遇险，处处设法挽留。江边已有船只等候，他将在这里登船，前往一个从未踏足的遥远国度。

消息还是走漏了。二十四名年轻沙弥哭着追到江边，对他说：

“大和尚今日远赴海东，我们今生恐怕再也见不到您了。临别之前，恳请和尚为我们授戒，让我们与您结下法缘。”老僧没有催促开船，而是在江岸为他们举行了授戒仪式。仪式结束后，他才登船离去。这位老僧就是鉴真。这已经是他第六次尝试东渡日本。此前十余年间，他遭遇过告发、拘押、风暴、沉船和长途漂流；弟子有人病逝，有人退却，他自己也因炎热、疾病和误治而失去了视力。但这一次，他仍然没有回头。

《唐大和上东征传》记载，鉴真第一次答应东渡时，曾说：

#quote(block: true)[
“是为法事也，何惜身命？诸人不去，我即去耳。”
]

意思是：这是为了佛法的事业，何必吝惜自己的身命？别人不去，我便自己去。这句话并不是一时激动的豪言。此后十二年的经历证明，鉴真确实把它变成了自己一生的行动。

#horizontalrule

== 一、日本已经有佛教，为什么还要请鉴真东渡？
<一日本已经有佛教为什么还要请鉴真东渡>
说到鉴真东渡，人们常会产生一种误解：鉴真是不是把佛教第一次带到了日本？并不是。在鉴真到来以前，佛教传入日本已经有近两百年的历史。佛像、佛经、寺院建筑以及僧尼制度，先后由朝鲜半岛和中国传入日本。到了奈良时代，日本已经有法隆寺、兴福寺、东大寺等著名寺院，朝廷也把佛教视为护国安民的重要力量。

问题不在于“有没有佛教”，而在于僧团制度是否完备。佛教不是只有经文和佛像。一个完整的佛教僧团，还需要依照戒律剃度、受戒、安居、诵戒，处理僧团内部的各种事务。尤其是一个人要成为正式的比丘，不能只靠自己在佛前发誓，还须由具备资格的僧团依照律藏规定，举行羯磨和授戒仪式。

按照当时中国佛教通行的制度，正式授予具足戒，一般需要“三师七证”：

- #strong[戒和尚]，负责传授戒法；

- #strong[羯磨阿阇梨]，主持僧团议事和仪式程序；

- #strong[教授阿阇梨]，询问受戒者是否具备受戒资格；

- 另有七位尊证师，共同证明授戒如法完成。

这不是为了把仪式变得繁琐，而是为了说明：出家不是一个人的私人决定，而是正式进入僧团、接受僧团教育和约束的一件大事。当时日本虽然已经有律藏，也有僧尼，但能够按照完整程序主持传戒的高僧不足。《东大寺要录》用一句非常简洁的话概括了日本佛教面临的困境：

#quote(block: true)[
“我国中虽有律本，阙传戒人。”
]

有戒律的经典，却缺少能够依律传戒的人。因此，日本朝廷派遣荣叡、普照等僧人随遣唐使入唐，任务之一就是寻找通晓戒律、具备传戒资格的高僧。他们不是来寻找一个普通的讲经法师，而是希望请回一位能够建立僧团规范的“传戒之师”。这也提醒我们：佛教的传承不能只有书本。

佛经可以抄写，佛像可以雕刻，寺院可以建造；但怎样修行、怎样生活、怎样授戒、怎样形成一个清净和合的僧团，还需要一代代真实的人亲自示范和传授。鉴真东渡所要传递的，正是这种“活着的佛法”。

#horizontalrule

== 二、鉴真是谁？
<二鉴真是谁>
鉴真出生于公元688年，俗姓淳于，是扬州江阳县人。扬州位于长江与大运河交会之地，是唐代重要的商业城市和国际港口。来自波斯、阿拉伯、东南亚和日本的商人与僧侣在这里往来，各地的货物、宗教和文化也在这里交汇。鉴真十四岁时，随父亲到扬州大云寺。他见到佛像，心中深受触动，便请求父亲允许自己出家。此后，他先后在洛阳、长安学习佛法，在实际寺登坛受具足戒，又从道岸、弘景等律师学习戒律。

当时长安和洛阳汇集了全国最优秀的佛教学者。鉴真不仅学习律藏，也广泛研习经、律、论三藏。学成之后，他回到江淮地区讲授戒律，逐渐成为当地最受尊敬的传戒大师之一。《唐大和上东征传》说，鉴真前后讲授大律及其注疏数十遍，度人授戒“略计过四万有余”。这一数字带有高僧传记常见的赞颂色彩，却足以说明：接受日本僧人邀请时，鉴真并不是一位默默无闻、希望到海外寻找机会的普通僧人。

恰恰相反，他已经拥有崇高的声望、众多的弟子和稳定的寺院生活。他没有任何世俗理由必须离开中国。也正因为如此，他决定东渡才格外令人震动。

#horizontalrule

== 三、“山川异域，风月同天”
<三山川异域风月同天>
公元742年，日本僧人荣叡、普照来到扬州大明寺。那一天，鉴真正在为大众讲授戒律。荣叡和普照向他顶礼，说明来意：

佛法虽然已经传到日本，但日本缺少能够如法传戒的高僧，希望鉴真能够东渡，成为日本僧众的导师。鉴真没有立刻回答。他先向自己的弟子们询问：

“在我们这些同修之中，有谁愿意接受这份遥远的邀请，前往日本传法？”众人沉默不语。一位名叫祥彦的弟子解释说，日本路途遥远，海上风浪无常，渡海者百不存一。人身难得，佛法难闻，大家修行尚未成就，所以不敢轻易舍身远行。这种担忧并非怯懦。在没有现代航海技术的时代，从中国渡海前往日本，往往意味着把生命交给风向、海流和一艘木船。遣唐使船遇到风暴、迷失航线乃至全船覆没，并不是罕见的事情。

鉴真听完，却说出了那句后来流传千年的话：

#quote(block: true)[
“是为法事也，何惜身命？诸人不去，我即去耳。”
]

祥彦随即回答：

“如果大和尚去，我也跟随大和尚去。”于是，二十余名僧人表示愿意同行。《唐大和上东征传》还记载，鉴真此前已经听说过日本长屋王向唐朝僧人布施千件袈裟的故事。袈裟边缘绣着四句话：

#quote(block: true)[
“山川异域，风月同天。
]

#quote(block: true)[
寄诸佛子，共结来缘。”
]

山河把人们分隔在不同的国度，同一轮明月、同一阵清风，却照临着彼此。愿把这些袈裟送给佛门弟子，共同结下来日的法缘。这几句话是否完全出自长屋王本人，后世尚有讨论，但它准确表达了当时东亚佛教交流的一种精神：地域可以不同，众生求法向善的心却可以相通。

鉴真认为，日本是一个“佛法兴隆有缘之国”。因此，他的东渡并不是为了扩张领土，也不是为了传播某种民族优越感，而是回应远方求法者的请求，把自己所学的戒律传给需要它的人。

#horizontalrule

== 四、六次东渡：并不是六次都顺利出海
<四六次东渡并不是六次都顺利出海>
后世常用“六次东渡，五次失败”概括鉴真的经历。实际上，这六次尝试的情况各不相同。有的尚未出海，便因内部矛盾和官府干预而中止；有的船只出发后遭遇风暴；有的被地方僧俗告发拦截；最远的一次，则被海风吹到了海南岛。

=== 第一次：事情败露
<第一次事情败露>
鉴真答应东渡后，弟子们开始秘密准备船只、粮食、经卷、佛像和药物。但同行僧人之间发生争执，有人向官府告发，说队伍中藏有海盗，东渡计划因此败露。船只和物资被官府查扣，荣叡等人也受到拘押。第一次尝试尚未真正进入大海，便宣告失败。

=== 风浪与阻拦
<风浪与阻拦>
此后几次，鉴真一行或者因为船只受损，或者因为风暴被迫返航，或者因弟子和地方官员担心他的安危而被强行留下。有一次，船只遭遇恶风，巨浪将船击破。众人登岸时，海水已经没到腰间。那时正值寒冬，风急水冷，粮食和淡水很快耗尽。一行人在饥渴中苦熬数日，才得到当地渔民救助。

又有一次，地方僧众得知鉴真打算离开，担心失去这位德高望重的老师，便向官府报告。鉴真一行被追赶、拦截，送回原来的寺院。从普通人的感情来看，这些挽留并不都是恶意。鉴真的弟子舍不得老师，当地信众也不愿让一位年长高僧冒险渡海。但对鉴真来说，越是受到尊敬，越意味着他必须放下已经拥有的一切。

真正难以跨越的，有时并不是海上的风浪，而是熟悉生活的牵绊。

=== 漂流海南
<漂流海南>
公元748年，鉴真再次出海。这次航行成为六次东渡中最危险的一次。船只在大海中连续漂流，风浪翻涌，海水黑如浓墨，船时而像被推上高山，时而仿佛跌入深谷。船上的人晕眩呕吐，只能不断称念观世音菩萨。淡水很快用尽。众人只能嚼食生米，却因为口渴而难以下咽；饮用海水，又导致腹部胀痛。

《东征传》记载，一行人在海上漂流十四天，最后没有抵达日本，反而被风吹到了遥远的海南岛。此后，他们从海南出发，经过广东、广西、江西、江苏，辗转数千里，才重新回到扬州。这趟失败的航程，前后持续数年。在返回途中，日本僧人荣叡病逝于端州。荣叡为求传戒之师，在中国奔走近二十年，最终未能亲眼看到鉴真抵达日本。

鉴真悲痛万分。不久，他又因长期在炎热地区跋涉而患上眼病。有胡人自称能够医治，诊治之后，鉴真的双眼却彻底失去了光明。他失去了弟子，失去了视力，绕行大半个中国，最后又回到了出发之地。从世俗的角度看，此时已经有足够充分的理由放弃。然而，鉴真并没有认为自己的愿心已经结束。

#horizontalrule

== 五、看不见海的人，再次登上了船
<五看不见海的人再次登上了船>
公元753年，日本遣唐使藤原清河、大伴古麻吕、吉备真备等人准备返回日本。他们早已听说鉴真多次渡海未成，于是前往寺中拜见，希望设法帮助他同行。鉴真的名字原本曾被列入随行名单，但唐玄宗要求日本使节带道士回国，日本朝廷一向不崇奉道教，使节没有接受，因此相关名单也被撤回。加上扬州僧俗严密看守，鉴真仍然难以公开离境。

最后，大伴古麻吕将鉴真和弟子秘密接上自己的船。这时的鉴真已经六十六岁，又双目失明。一个完全看不见海的人，再次登上了远洋船只。与鉴真同行的，不只是几名僧人。《东征传》详细列出了他们携带的物品，其中包括：

- 佛舍利；

- 阿弥陀佛、观世音菩萨、药师佛、弥勒菩萨等佛像；

- 《华严经》《涅槃经》《四分律》等佛典；

- 天台宗的止观、法华玄义等著作；

- 道宣律师的戒律注疏；

- 《大唐西域记》；

- 王羲之、王献之等人的书法；

- 菩提子、香药、器物以及各种工艺品。

这份清单十分重要。它告诉我们，鉴真所乘坐的船，并不是只载着一个人，也不只是载着几箱经书。船上承载的是一整套唐代佛教文化：戒律、教理、造像、书法、仪式、工艺和生活知识。佛教的传播从来不是一个抽象观念单独旅行，而是由具体的人，带着具体的经典、技艺和生活方式，一起跨越山海。

公元753年十一月，船队从苏州黄泗浦起航。途中经过海岛和屋久岛，十二月二十日，鉴真所乘船只抵达日本萨摩国阿多郡。随后，一行人经太宰府、难波，于第二年二月进入平城京。鉴真终于踏上了日本国土。从第一次答应东渡算起，已经过去了十二年。

#horizontalrule

== 六、东大寺授戒：一座戒坛意味着什么？
<六东大寺授戒一座戒坛意味着什么>
鉴真抵达平城京后，被安置在东大寺。日本朝廷派人传达诏令，大意是：

大和尚远渡沧海来到我国，正合朕心。建造东大寺十余年来，朕一直希望设立戒坛，传授戒律，日夜不忘。今后传戒授律之事，全都委任大和尚主持。公元754年四月，东大寺大佛殿前筑起戒坛。圣武太上皇首先登坛受菩萨戒，随后光明皇太后、孝谦天皇等也登坛受戒。此后，鉴真又为四百余名沙弥授戒，并为一批已有声望的日本僧人重新授戒。

后来，东大寺大佛殿西侧建成常设的戒坛院。从此，越来越多日本僧人在这里依照完整仪式受戒。东大寺至今仍把鉴真来日和戒坛院的建立，视为日本正规授戒制度形成的重要开端。

=== 小栏目：戒、律、戒坛分别是什么？
<小栏目戒律戒坛分别是什么>
#strong[戒]，主要是个人自愿接受的行为准则。例如不杀生、不偷盗、不妄语，是在家佛教徒也可以受持的戒。出家僧尼则有更为完整的具足戒。#strong[律]，不仅包括个人应当遵守的戒条，也包括僧团共同生活和处理事务的制度。例如怎样受戒、怎样安居、怎样诵戒、怎样处理争议、怎样照顾病人，都属于律的范围。

#strong[戒坛]，是举行正式授戒仪式的特定场所。它的重要性并不在于建筑是否高大，而在于这里划定了一个清净、庄严的僧团空间。受戒者在僧团见证下承诺遵守戒法，并被正式接纳为僧团成员。因此，鉴真建立戒坛，不只是修建了一处宗教建筑，更是在帮助日本佛教建立一种可以持续传承的人才培养制度。

#horizontalrule

== 七、戒律是不是对人的束缚？
<七戒律是不是对人的束缚>
现代人听到“戒律”，很容易想到禁止、惩罚和压抑。但从佛教的角度说，戒律的目的并不是让人失去自由，而是帮助人摆脱烦恼和欲望的控制。一个人想做什么就立刻去做，看似自由，实际上可能只是被贪欲、愤怒和习惯牵着走。真正的自由，是在欲望出现时，仍然能够看清后果，作出不伤害自己和他人的选择。

《佛遗教经》把戒比喻为通往解脱的根本：

#quote(block: true)[
“戒是正顺解脱之本。”
]

又说：

#quote(block: true)[
“因依此戒，得生诸禅定及灭苦智慧。”
]

戒能够使人的行为安定，行为安定之后，内心才容易安定；内心安定，才可能生起观察自己和世界的智慧。这就是佛教常说的“戒、定、慧”三学：

- 以戒约束身口，使行为清净；

- 由戒生定，使内心安住；

- 由定发慧，看清烦恼和痛苦的根源。

因此，鉴真传到日本的并不是一部冷冰冰的规章，而是一条完整的修行道路。当然，历史上的戒律制度也曾与国家管理结合，僧人资格有时受到朝廷控制。我们不必把古代制度全部理想化。但从佛教本身来看，戒律最根本的意义仍然是自愿止恶行善，而不是外在权力对人的强迫。

#horizontalrule

== 八、唐招提寺：让戒律真正扎根
<八唐招提寺让戒律真正扎根>
在东大寺居住数年后，鉴真希望建立一处专门学习戒律、培养僧才的道场。公元759年，日本朝廷把新田部亲王的旧宅赐给鉴真。鉴真与普照、思托等弟子在这里建立寺院，最初称为“唐律招提”，后来成为唐招提寺。“招提”一词原本与“四方僧”有关，后来逐渐成为寺院的别称。“唐律招提”，可以理解为一座传承唐代戒律、供十方僧众修学的道场。

《唐大和上东征传》记载，鉴真和弟子在这里讲授《四分律》及其注疏。随着师徒相承，日本的律仪“渐渐严整”，戒律之学也从一位外来高僧的个人教导，逐渐转化为能够代代传承的制度。书中用一个非常美的比喻形容这种传承：

#quote(block: true)[
“亦如一灯燃百千灯，冥者皆明，明终不绝。”
]

一盏灯点燃百千盏灯，黑暗之处因此得到光明，而最初的灯火并不会因为分给别人而减少。这正是佛法传播最理想的状态。老师不是让弟子永远依附自己，而是点亮弟子的灯，使弟子也能够照亮后来的人。唐招提寺后来成为日本律宗的重要道场。寺内现存的金堂、讲堂、经藏、宝藏以及鉴真和上坐像，成为奈良时代佛教文化的重要遗产。唐招提寺官方资料记载，该寺由鉴真于759年创建，目的正是为学习戒律者提供修行道场。

#horizontalrule

== 九、闭着双眼的鉴真像
<九闭着双眼的鉴真像>
公元763年，鉴真的弟子忍基梦见讲堂栋梁折断，感到老师即将离世，于是带领弟子为鉴真塑造坐像。同年农历五月初六，鉴真结跏趺坐，面向西方圆寂，世寿七十六岁。今天，唐招提寺仍保存着这尊鉴真和上坐像。坐像中的鉴真身披袈裟，双手安放膝前，眼睛安静地闭着。脸上没有经历苦难后的愤怒，也没有完成伟业后的骄傲，只有一种经历一切之后的沉静。

唐招提寺介绍，这尊像高约八十厘米，采用脱活乾漆工艺制成，是日本现存最早的肖像雕塑之一，也是奈良时代肖像艺术的代表作品。人们站在这尊像前，很容易想到鉴真已经失明的双眼。但真正值得记住的，不是他“看不见”了什么，而是他在双眼失明之后，仍然知道自己应该去往哪里。

有些人眼睛明亮，却一生不知道方向；有些人失去了视力，内心的愿却从未动摇。鉴真的方向，并不是地图上的东方，而是远方众生对佛法的需要。

#horizontalrule

== 十、鉴真带去的，不只有戒律
<十鉴真带去的不只有戒律>
在后世叙述中，鉴真常被称为中日文化交流的使者。有些说法把日本医药、建筑、雕塑、书法等领域的许多发展都归功于鉴真一人，这未免过于简单。奈良时代的日本长期派遣使节和留学生到唐朝，唐代文化的传入是许多僧人、使节、工匠和学者共同努力的结果。但鉴真及其弟子的确是其中极具代表性的一群人。

他们带去大量佛典、佛像、舍利和书迹，也带去了戒坛制度、讲律传统、寺院管理方式和唐代佛教的审美经验。鉴真不是独自一人完成这一切，同行的法进、思托、法载、义静等僧人，以及工匠和在家弟子，都参与了传播和建设。唐招提寺的建筑、佛像和文物，至今仍保留着奈良时代吸收唐代文化后形成的独特风貌。联合国教科文组织在评价古奈良历史遗迹时指出，这些建筑和艺术见证了日本在与中国、朝鲜半岛文化联系中发生的深刻发展。

这说明文化传播从来不是简单复制。日本没有原样照搬唐朝佛教，而是在自己的社会、语言和历史条件中重新理解它。中国佛教传到日本以后，逐渐形成日本的律宗、天台宗、真言宗、净土诸宗与禅宗传统；寺院建筑、佛像风格和僧团制度，也在漫长历史中发生变化。真正有生命力的文化传播，既需要忠实传承，也需要本土创造。

#horizontalrule

== 十一、佛教是怎样从中国走向东亚的？
<十一佛教是怎样从中国走向东亚的>
佛教起源于印度，但它并没有沿着一条单一、笔直的路线传播。从印度出发的佛教，通过陆上丝绸之路和海上航路，传播到中亚、中国、朝鲜半岛、日本、越南以及东南亚各地。不同地区接触佛教的时间、接受的经典和形成的宗派都不完全相同。中国在这一过程中发挥了十分重要的中转和再创造作用。

佛经进入中国后，经过数百年的翻译和解释，逐渐形成了以汉语为载体的庞大佛教典籍。中国僧人又在印度佛教的基础上，建立天台、华严、禅、净土和律宗等具有鲜明中国特点的传统。这些汉译佛经、宗派思想和寺院制度，后来继续向朝鲜半岛、日本和越南传播，由此形成了通常所说的汉传佛教文化圈。

这个文化圈有几个明显特征：

第一，共同使用大量汉译佛典。即使各国的日常语言不同，许多僧人仍以汉文佛典作为学习和交流的共同基础。第二，寺院制度和僧团礼仪相互影响。受戒、讲经、法会、寺院建筑和佛像造型，都能看到中国佛教的深刻影响。第三，交流并不是单向的。日本和朝鲜半岛的僧人来到中国求法，也保存、整理了不少后来在中国散失的佛教典籍。中国僧人前往海外传法，各国僧人又把自己的理解带回中国。佛教在东亚的传播，更像一张不断往来的网络，而不是一条只向一个方向流动的河流。

玄奘的故事，是中国僧人向西求法；鉴真的故事，则是中国僧人向东传法。一位把印度佛法带回长安，一位把已经中国化的佛教带向奈良。他们行走的方向不同，所做的却是同一件事：为了求法与传法，跨越语言、国界和文化的隔阂。

#horizontalrule

== 十二、常见误解：佛教只是从印度传入中国吗？
<十二常见误解佛教只是从印度传入中国吗>
佛教的确起源于印度，中国最初也是佛教的接受者。但历史并没有停在“印度传入中国”这一步。佛教进入中国后，经历了长期的翻译、解释和本土化。中国僧人不仅学习佛教，也重新组织佛教的思想体系，发展出具有中国特色的宗派、修行方法和寺院文化。当这些成果继续传入朝鲜半岛、日本和越南时，中国便从佛教的接受地之一，转变为东亚佛教的重要传播中心。

因此，更准确的说法是：

#quote(block: true)[
佛教从印度出发，在亚洲不同文明之间不断被翻译、理解、实践和再创造。
]

它不是某一个国家永远独占的文化财产，也不是从一个中心复制到各地的固定模板。鉴真东渡所代表的，正是文明之间的接力。印度僧人和中亚僧人曾冒险来到中国；中国僧人又冒险前往日本；日本僧人此后继续来到中国学习。每一代人都是接受者，也是传递者。佛法在这种往来中得以延续。

#horizontalrule

== 十三、“何惜身命”是不是鼓励人不顾生命？
<十三何惜身命是不是鼓励人不顾生命>
鉴真的名言“是为法事也，何惜身命”，很容易被理解成一种不计后果的牺牲精神。但鉴真的行动并不是冲动冒险。每次东渡之前，他都会准备船只、粮食、药物、经卷和同行人员；航行失败后，他也会返回寺院，重新讲经授戒，等待新的机会。他重视生命，也关心弟子，并不是为了证明自己勇敢而轻率赴死。

“不惜身命”真正表达的是：当个人安逸与利益众生的愿心发生冲突时，他不愿因为害怕困难而放弃责任。佛教并不鼓励无意义地伤害自己。佛教戒律以不杀生为根本，也包括爱护自己的身心。菩萨行中的舍身故事，重点不是制造痛苦，而是说明慈悲心能够超越狭隘的自我中心。

因此，鉴真精神不应被简单理解为“不要命”，而应理解为：

- 认清自己所承担的责任；

- 不因一时挫折便放弃长期愿心；

- 在困难中仍然保持理智和准备；

- 愿意为了比个人得失更重要的事情，坚持走下去。

对现代人来说，我们未必需要跨越风暴中的大海，但每个人都会遇到自己的“第五次失败”。真正值得学习的，不是鉴真吃过多少苦，而是他在失败之后，依然没有让挫折决定自己的方向。

#horizontalrule

== 十四、佛法的传播，不靠征服
<十四佛法的传播不靠征服>
鉴真抵达日本时，没有带军队，也没有携带要求别人服从的权力。他带去的是戒律、经典、佛像、书法和一群愿意教学的弟子。他在日本获得尊敬，不是因为强迫别人接受佛法，而是因为有人主动邀请他，而他又用自己的学问、人格和行动回应了这种邀请。佛教在东亚最深远的传播，大多不是依靠战争和征服，而是依靠译经、讲学、求法、造寺和师徒之间的传承。

一位僧人翻译一部经，一位弟子抄写一份注疏，一位工匠建造一座佛殿，一位普通人供养远行者的食物------许多看似微小的行动，最终共同改变了一个地区的文化。这也是鉴真故事最动人的地方。他没有把自己的名字刻在征服的疆界上，却把一盏戒灯留在了海的另一边。《唐大和上东征传》说：

#quote(block: true)[
“一灯燃百千灯，冥者皆明，明终不绝。”
]

佛法之灯点燃另一盏灯，光明并不会因此减少。从扬州大明寺到奈良唐招提寺，从长江边的一次夜航，到延续千年的东亚佛教文化，鉴真所传递的正是这样一束光。

#horizontalrule

== 本章小结
<本章小结-1>
鉴真东渡并不是佛教第一次传入日本。鉴真到来以前，日本已经有佛经、佛像、寺院和僧尼，但缺少能够得到广泛承认的完整传戒制度。鉴真是唐代著名律学高僧。面对日本僧人的请求，他说：“是为法事也，何惜身命？诸人不去，我即去耳。”此后十二年间，他多次遭遇告发、阻拦、风暴和漂流，又经历弟子病逝与双目失明，最终在第六次航行中抵达日本。

鉴真在东大寺设立戒坛、主持授戒，又创建唐招提寺，培养学习戒律的僧人。他带到日本的不只是戒律，还有大量佛典、佛像、书迹、工艺和唐代佛教文化。鉴真的故事说明，佛教传播不是从印度到中国便告结束。中国在接受、翻译和发展佛教之后，又成为佛教走向朝鲜半岛、日本和越南的重要枢纽。佛教文明正是在不断的求法、翻译、传授和本土化中延续下来。

佛教的传播不是一场征服，而是一盏灯点燃另一盏灯。

#horizontalrule

== 本章经典名句
<本章经典名句>
#quote(block: true)[
#strong[是为法事也，何惜身命？诸人不去，我即去耳。]
]

#quote(block: true)[
------《唐大和上东征传》
]

为了佛法与众生的事业，何必只顾惜个人的安逸与得失？别人不去，我便先走出这一步。

#quote(block: true)[
#strong[山川异域，风月同天。寄诸佛子，共结来缘。]
]

#quote(block: true)[
------《唐大和上东征传》所载袈裟题句
]

虽然身处不同国度，却共在同一片天地之中；愿以佛法结缘，使彼此超越地域的阻隔。

#quote(block: true)[
#strong[一灯燃百千灯，冥者皆明，明终不绝。]
]

#quote(block: true)[
------《唐大和上东征传》
]

一盏灯可以点燃百千盏灯，使黑暗之处都得到光明，而光明也因此代代相续，永不断绝。

#horizontalrule

== 主要史料与参考依据
<主要史料与参考依据>
+ 真人元开即淡海三船撰《唐大和上东征传》。该书写成于公元779年，主要依据鉴真随行弟子思托所撰传记，是研究鉴真生平和东渡经历最重要的基本史料。日本文化遗产数据库所藏高山寺本，是现存重要古写本之一。2. 《东大寺要录》，有关日本派遣荣叡、普照入唐迎请传戒师的记载。3. 唐招提寺官方资料，有关鉴真生平、唐招提寺创建及鉴真和上坐像的介绍。4. 东大寺官方资料，有关鉴真授戒与戒坛院建立的记载。5. 联合国教科文组织“古奈良历史遗迹”资料，有关中国、朝鲜半岛文化交流对日本建筑和艺术发展的影响。

#part[第五部：汉地成形——佛教怎样变成中国人的佛教]
= 第十五章　达摩东来
<第十五章-达摩东来>
#figure([
#box(image("chapters/../images/downloaded/ch15_zen.jpg", width: 65.0%))
], caption: figure.caption(
position: bottom, 
[
达摩面壁示意图
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


深山入冬，夜雪无声。一位来自异域的僧人独坐石室，身披旧袈裟，面向冰冷的墙壁，终日沉默。石室之外，一个中国僧人立在雪中，请求大师开示佛法。雪越下越深，渐渐没过他的膝盖。为了表明求法的决心，他甚至挥刀断臂，鲜血染红了白雪。这是中国禅宗历史上最著名的画面之一：达摩面壁，慧可断臂。

在后世的绘画中，达摩常被画成浓眉大眼、满脸虬髯的异域僧人。他不诵经，不讲论，只是面对石壁静坐。慧可则站在一旁，捧着断臂，以生命求取一句安心之法。故事充满传奇色彩，但它所要追问的问题，却与每一个普通人有关：

当内心被忧虑、恐惧、得失和烦恼搅动时，人究竟怎样才能安定下来？文字、道理和知识，为什么有时仍不能解除人的痛苦？禅宗所说的“不立文字”，是不是意味着不读佛经、不学教理，只要闭目静坐就可以成佛？要回答这些问题，我们必须从那位被后世尊为“中国禅宗初祖”的异域僧人说起。

#horizontalrule

== 一、达摩到来以前，中国已经有“禅”
<一达摩到来以前中国已经有禅>
“禅”并不是达摩发明的。“禅”是“禅那”的简称，来自印度语“dhyāna”，大意是通过专注、观察和修习，使散乱的心逐渐安定、明净。佛陀时代的戒、定、慧三学中，“定”便与禅修密切相关。早在达摩来到中国以前，安世高、鸠摩罗什等译经家已经译出许多有关禅定、念处和观心的经典，中国僧人也早已在修习各种禅法。

因此，达摩并不是第一个把坐禅带到中国的人。他真正带来的，是一种鲜明的修行态度：佛法不能只停留在文字解释和概念辨析上，必须回到自己的身心，在当下亲自体会、亲自验证。从历史上看，达摩的生平并不十分清楚。较早提到他的文献，是北魏杨衒之所著的《洛阳伽蓝记》；稍后的昙林序文和唐代道宣《续高僧传》，才逐渐勾勒出一位由西方来到中土、在洛阳一带传授大乘禅法的僧人形象。至于达摩与梁武帝问答、一苇渡江、少林面壁九年、只履西归等故事，大多是在后来的禅宗史书中逐步形成的。因而，我们今天所认识的达摩，一部分属于可以考察的历史人物，一部分属于禅门世代传诵的祖师形象。

这并不意味着所有传说都毫无价值。历史研究关心的是：“事情是否确曾这样发生？”宗教故事还关心另一个问题：“后人为什么要这样讲述？”达摩面壁、慧可断臂，即使包含后世的文学塑造，仍然凝聚了禅宗对修行的理解：真正的佛法，不只是听来的知识，而是一个人用全部生命去面对自己、转化自己的过程。

严格地说，达摩在世时，还没有后来宗派制度意义上的“禅宗”。禅宗经过慧可、僧璨、道信、弘忍等人的传承，到道信、弘忍的“东山法门”时期才逐渐形成规模。达摩被尊为“东土初祖”，是后来禅宗在回溯自身源流时确立的地位。因此，“达摩东来”并不是说一个已经完整成熟的宗派从印度搬到了中国，而是说一颗种子落入了中国文化的土壤，经过数代人的培育，最后长成了具有鲜明中国气质的禅宗。

#horizontalrule

== 二、一个从海上而来的异域僧人
<二一个从海上而来的异域僧人>
依照道宣《续高僧传》的记载，菩提达摩出身南天竺婆罗门种，通达大乘佛法，渡海来到南方，后来北上进入北魏境内，在洛阳、嵩山一带传授禅法。“菩提达摩”是音译。“菩提”意为觉悟，“达摩”意为法，合起来可以理解为“觉法”。后世最流行的故事，说达摩到达南朝以后，曾受到梁武帝接见。梁武帝笃信佛教，一生建寺、写经、供养僧众，于是问达摩：

“朕即位以来，造寺、写经、度僧无数，有何功德？”达摩回答：

“并无功德。”梁武帝不解，又问：

“如何是圣谛第一义？”达摩回答：

“廓然无圣。”梁武帝再问：

“对朕者谁？”达摩说：

“不识。”两人话不投机，达摩便离开南方，渡江北上。这段对话见于后出的禅宗灯录，并不见于较早的达摩史料，不能简单当作确定的历史事实。但它非常生动地表达了禅宗对“功德”的反省：建寺、布施、护持佛法当然是善行，却不能因此产生“我做了多少功德”的骄傲，更不能用外在善行代替内心的觉察。

梁武帝所计算的是“我做了什么”；达摩所追问的却是：“这个不断计算功德的‘我'，究竟是什么？”善行若被贪求名声、福报和自我满足的心所支配，便仍然没有触及烦恼的根本。禅宗并不否定行善，而是要求人在行善时，也看见自己内心的执著。达摩后来被传说为渡过长江，来到嵩山少林寺，在石洞中面壁九年。人们无法理解他的修行，便称他为“壁观婆罗门”。

“婆罗门”说明他来自印度；“壁观”则成为达摩禅法最鲜明的标志。

#horizontalrule

== 三、面壁九年：墙壁究竟意味着什么？
<三面壁九年墙壁究竟意味着什么>
说到达摩，人们首先想到的往往是“面壁九年”。有人把它理解为：达摩真的在山洞中面对墙壁，一坐就是九年。也有人认为，“壁观”不只是身体面对一面墙，更是一种修心的譬喻。达摩禅法的重要文献《二入四行论》中说，修行人应当“舍妄归真，凝住壁观”，使心不再随外境漂动。《中国禅宗史》中，印顺法师将“壁观”解释为凝心、安心、住心的譬喻：心如墙壁，并不是内心变得麻木僵硬，而是不轻易被分别、爱憎和得失所穿透。

一面坚实的墙壁，不会因为有人赞美它就欢喜，也不会因为有人辱骂它就愤怒；不会因为风吹雨打便失去自己的位置。“心如墙壁”，不是让人没有感情，而是让人不再被每一次情绪冲动立即带走。别人说一句好话，我们便心花怒放；说一句难听的话，我们便辗转难眠。工作顺利时，觉得自己无所不能；遇到挫折时，又觉得人生毫无希望。我们的心就像一片轻薄的树叶，外界吹来什么风，便向什么方向飘去。

壁观所训练的，是在情绪与行动之间留出一点空间。愤怒升起时，先看见愤怒，而不是立刻说出伤人的话。焦虑升起时，先知道“此刻有焦虑”，而不是马上认定“我的人生完了”。欲望升起时，先观察它从哪里来、如何变化，而不是立刻跟随它。所以，达摩面壁并不是逃避世界。恰恰相反，它要求一个人不再只盯着外面的世界，而是转身看见：外境之所以能够扰动自己，是因为内心早已有了贪求、排斥和执取。

墙壁没有告诉达摩任何道理。但在长久的沉默中，人可以逐渐听见自己的心。

#horizontalrule

== 四、入道的两扇门：理入与行入
<四入道的两扇门理入与行入>
达摩禅法最重要的概括，是“二入四行”。《二入四行论》开篇说：

#quote(block: true)[
“夫入道多途，要而言之，不出二种：一是理入，二是行入。”
]

入道的方法虽然很多，概括起来，不外乎两个方面：一是从道理上明白，二是在生活中实践。

=== 1. 理入：借助经典，明白宗旨
<理入借助经典明白宗旨>
所谓“理入”，原文首先说的是“藉教悟宗”。“藉教”，就是借助佛陀的教法和经典；“悟宗”，就是由文字所指引，明白文字背后的根本宗旨。这四个字非常重要。它说明达摩禅法并不是反对经典，而是反对把经典只当作知识来积累。经典是一条道路，而不是终点；是一根指向月亮的手指，而不是月亮本身。

一个人可以熟读“诸行无常”，却在失去某件东西时无法接受变化；可以天天讲“无我”，却处处维护自尊；可以解释“缘起性空”，却仍被一句批评困扰数日。这便是只记住了文字，还没有“悟宗”。《二入四行论》说，一切众生虽有迷悟不同，却“同一真性”，只是被客尘妄想覆盖，不能显现。所谓“客尘”，就像暂时落在镜面上的灰尘。灰尘虽然遮蔽镜子，却不是镜子的本质；烦恼虽然覆盖心性，也不是不可改变的命运。

理入，不是相信自己已经成佛，而是深信烦恼并非永恒不变，觉悟具有可能。但仅仅明白这个道理还不够。知道镜子可以擦亮，不等于镜子已经干净；知道心可以安定，也不等于烦恼已经止息。因此，理入之后，还必须有“行入”。

=== 2. 行入：在生活中修四种行
<行入在生活中修四种行>
行入包括四种实践：报冤行、随缘行、无所求行、称法行。这四种修行没有离开日常生活。它们所面对的，正是每个人都会遇到的苦乐、荣辱、得失和欲求。

==== 第一，报冤行：遇到痛苦时，不让怨恨继续制造痛苦
<第一报冤行遇到痛苦时不让怨恨继续制造痛苦>
“报冤”并不是说，一个人遭受不幸时，只能认命，更不是说受欺凌者必须忍受伤害。它所强调的是：当苦难已经发生时，不要让怨恨、报复和自我折磨继续扩大苦难。人遇到挫折，常会不断追问：

“为什么偏偏是我？”“他凭什么这样对我？”“如果当初没有发生那件事就好了。”这些念头看似是在寻找答案，实际上往往是在反复撕开伤口。报冤行提醒人：已经成熟的因缘，必须如实面对。我们可以制止不公，可以保护自己，可以寻求帮助，也可以纠正造成痛苦的原因；但在行动时，不必再用怨恨烧灼自己的心。

接受事实，不等于赞同伤害。不怀怨恨，也不等于放弃原则。真正的忍，不是软弱地忍受一切，而是不让自己的心变成另一个伤害的源头。

==== 第二，随缘行：得到时不狂喜，失去时不崩溃
<第二随缘行得到时不狂喜失去时不崩溃>
世间的荣誉、地位、财富和关系，都由许多条件共同形成。条件聚合时，事物出现；条件变化时，事物也随之改变。今天获得的成功，并不完全属于“我”的能力，其中还有时代、环境、他人帮助和许多偶然因缘。明天遭遇失败，也不意味着自己从此一无是处。随缘不是随便，更不是随波逐流。

它是尽力而为，却不要求世界必须按照自己的愿望运行；珍惜所得，却知道所得不会永远停留；面对失去，也不把一次得失看成对整个人生的最后判决。顺境中不骄慢，逆境中不绝望，这便是“随缘”。

==== 第三，无所求行：做事，但不把幸福押在结果上
<第三无所求行做事但不把幸福押在结果上>
“无所求”并不是没有理想、没有计划、什么都不做。人可以认真工作，可以改善生活，可以追求学问，也可以努力帮助他人。问题不在于有没有目标，而在于是否把内心的安稳完全押在某个结果上。“只有升职，我才有价值。”“只有别人认可我，我才能快乐。”“只要念佛、坐禅，佛就应该保佑我事事顺利。”

这种带着交易心的追求，即使一时得到满足，也会立刻产生新的不安，因为得到之后害怕失去，没有得到时又感到怨恨。无所求行，是认真做应做之事，却不把修行变成与佛菩萨交换利益的条件。努力，但不被结果绑架。发愿，但不以愿望控制世界。

==== 第四，称法行：让行为与佛法相应
<第四称法行让行为与佛法相应>
“称法”，就是与法相称、依照正法而行。既然一切事物都因缘和合，没有一个孤立不变的“我”，那么布施、帮助和善行，就不应成为炫耀自我的工具。帮助别人时，不总想着“是我帮助了你”；受到赞美时，不把功劳牢牢据为己有；付出没有得到回报时，也不立刻后悔。

称法行使禅不再只是静坐时的内心体验，而成为待人接物的方式。若一个人坐禅时十分安静，离开蒲团后却傲慢、自私、易怒，他所修的便只是暂时的安静，还没有真正进入佛法。二入四行所表达的，是一种完整的修行：

以道理指明方向，以实践改变生命；由经典明白佛法，再在日常生活中验证经典。

#horizontalrule

== 五、雪夜求法：慧可为什么要断臂？
<五雪夜求法慧可为什么要断臂>
在达摩的弟子中，最著名的是慧可。据《续高僧传》记载，慧可俗姓姬，早年既读儒家典籍，也通佛教经论。大约四十岁时，他遇见正在嵩洛一带传法的达摩，一见便知其非凡，随从学习六年。达摩后来将四卷本《楞伽经》授予慧可，说汉地修行人依此经而行，可以得到解脱。

《续高僧传》还记载，慧可后来“遭贼斫臂”，被盗贼砍去一臂。他以佛法调伏其心，处理伤口以后，仍如常乞食，没有到处诉说自己的痛苦。然而，稍后的禅宗文献《传法宝纪》提出了另一种说法：慧可并非被盗贼砍断手臂，而是为了向达摩表明求法的诚意，主动断臂。《传法宝纪》甚至特别说，所谓被贼斫臂，是误传。

到了宋代《景德传灯录》，这个故事被描述得更加完整。神光------也就是后来的慧可------听说达摩住在少林，便前往参学。达摩终日面壁，不加开示。寒冬腊月，神光彻夜站立于雪中。天明时，积雪已经没过膝盖。达摩问他：“你久立雪中，求什么？”神光流泪说：“愿和尚慈悲，开甘露门，广度众生。”

达摩告诉他，无上佛道必须经过长久精勤，不是凭轻慢之心便能获得。神光听后，取刀断去左臂，放在达摩面前。达摩见他求法心切，便为他改名“慧可”。从现代历史研究的角度看，“立雪断臂”很可能是后世逐渐定型的祖师传说。但从禅宗自身的叙事来看，断去的并不只是一条手臂，更是求法者的骄傲、自满和犹豫。

慧可早已读过许多书，也懂得许多道理。他缺少的不是知识，而是把全部身心投入修行的决心。当然，今天的读者绝不能模仿断臂这样的行为。佛教以不伤害生命为基本原则，也不鼓励用伤害身体来证明虔诚。故事真正要表达的是“断疑”，而不是“断臂”；是斩断敷衍、退缩和自欺，而不是伤害自己。

修行不要求人轻视身体。它要求人不再轻率地浪费生命。

#horizontalrule

== 六、“把你的心拿来，我替你安”
<六把你的心拿来我替你安>
慧可被达摩接纳后，提出了一个最根本的问题：

“我心未宁，乞师与安。”我的心不能安定，请老师替我安心。达摩没有告诉他一种神秘咒语，也没有列出十种消除焦虑的方法，只说：

“将心来，与汝安。”把你的心拿来，我替你安。慧可沉默良久，回头寻找自己的心。他寻找那个不安的主体，寻找那个被忧虑抓住的固定之物，最后说：

“觅心了不可得。”我寻找这颗心，却找不到一个固定不变的实体。达摩回答：

“我与汝安心竟。”我已经替你把心安好了。这则著名公案见于后出的《景德传灯录》，体现了成熟禅宗惯用的问答方式。它并不是说，人的痛苦都是假的，所以不必理会；也不是说，只要找不到心，焦虑就会自动消失。达摩要求慧可寻找的，是那个被他认定为固定、真实、无法改变的“不安之心”。

仔细观察时，我们会发现，所谓“不安”其实由许多条件组成：脑中反复出现的念头、胸口的紧张、对未来的想象、过去的记忆、对失败的恐惧，以及“我绝不能失败”的执著。这些现象都真实地出现，却没有一个永远不变、独立存在的“不安实体”。念头生起，又会消失；身体感受不断变化；恐惧随着环境和注意力而增减。既然不安由因缘形成，它便也可以随着因缘改变。

“觅心了不可得”，不是把心彻底否定，而是发现：我们平日紧紧抓住的那个“我”，并不像想象中那么固定。看见这一点，心便出现了转动的余地。焦虑仍可能出现，但不必再说“我就是一个焦虑的人”。愤怒仍可能出现，但不必把愤怒当成必须服从的命令。悲伤仍可能出现，却可以被看见、被理解，也会在因缘变化中逐渐改变。

安心不是从此没有任何波动。安心是知道波动并不是心的全部。

#horizontalrule

== 七、“不立文字”是不是不需要经典？
<七不立文字是不是不需要经典>
禅宗最著名的四句话是：

#quote(block: true)[
教外别传，
]

#quote(block: true)[
不立文字，
]

#quote(block: true)[
直指人心，
]

#quote(block: true)[
见性成佛。
]

许多人因此以为，禅宗不需要读经，也不需要学习佛教教理，只要坐在那里等待开悟就可以了。这是一种误解。这四句口号是在禅宗长期发展过程中逐步形成并定型的，不能简单看作达摩本人留下的原话。有关“见性”“不立文字”等观念，经过唐宋禅宗不断阐发，最后才被组合为概括禅宗特色的完整表达。

更重要的是，达摩禅法的重要文本《二入四行论》明明说“藉教悟宗”------要借助教法，明白宗旨。《续高僧传》也记载，达摩曾把四卷本《楞伽经》授予慧可；慧可一系的禅者随身携带此经，以它作为修行心要。早期达摩禅并不是离开经典另立一种神秘宗教，而是在经典教法的基础上，强调亲身实践和内在证悟。

因此，“不立文字”不是“不用文字”，而是“不把佛法仅仅建立在文字上”。药方写得再清楚，也不能代替服药。食谱研究得再透彻，也不能代替吃饭。地图画得再详细，也不能代替亲自走路。佛经告诉我们无常、无我、缘起和慈悲，但只有在自己的生命中观察无常、松动我执、理解缘起、实践慈悲，这些文字才真正变成佛法。

=== “教外别传”是什么意思？
<教外别传是什么意思>
它不是说，在佛陀教法之外，另外秘密传授一套与经典无关的真理。这里的“教外”，更适合理解为：佛法的真实体验，不能被语言和概念完全穷尽。老师可以解释什么是游泳，却不能只靠讲解让学生学会游泳；可以描述蜜糖的滋味，却不能让从未吃过蜜的人仅凭文字真正知道甜味。

佛法的语言能够引导人，却不能代替人的觉察。所谓“别传”，不是另传一种内容，而是强调由心地实践而亲自印证。

=== “直指人心”是什么意思？
<直指人心是什么意思>
人遇到痛苦时，习惯把原因全部归到外面：

只要换一份工作，我就不会烦恼；只要他改变，我就能幸福；只要得到更多财富，我就会安心。禅宗并不否定改善环境的必要，却进一步追问：即使外境改变，这颗不断攀缘、比较和恐惧的心，是否真的改变了？“直指人心”，就是不再绕着外界寻找最后的答案，而是直接观察苦乐怎样在自己的心中形成。

=== “见性成佛”是什么意思？
<见性成佛是什么意思>
“见性”不是看见一个隐藏在身体里的神秘灵魂，也不是发现一个永恒不变的“真我”。它是看见自己的心并非只能被贪嗔痴支配；看见念头、情绪和执著皆由因缘生起，没有固定不变的实体；也看见众生具有觉察、慈悲和智慧的可能。“成佛”在这里首先不是获得一种神奇身份，而是使原本被无明遮蔽的觉悟能力显现出来。

因此，禅门后来也说：

#quote(block: true)[
“不执文字，不离文字，而为道用。”
]

不被文字束缚，也不抛弃文字，而是善用文字来帮助修道。这才是“不立文字”的完整含义。

#horizontalrule

== 八、禅宗不是拒绝知识，而是拒绝“只剩知识”
<八禅宗不是拒绝知识而是拒绝只剩知识>
学习佛法大致会遇到两种偏差。一种是只重文字，不重实践。这样的人可以熟练讲解空性，却不能容忍不同意见；可以讨论慈悲，却对身边人的痛苦漠不关心；可以背诵许多经典，却从不观察自己的贪心和傲慢。另一种是以“不立文字”为借口，拒绝学习。这样的人把自己的直觉当作觉悟，把情绪冲动当作“率真”，把不了解经典说成“不被文字束缚”。没有正见的指引，所谓自由很容易变成任性，所谓见性也可能只是自我想象。

真正的禅，处在两者之间。需要经典，却不被概念困住；需要老师，却不把老师当成偶像；需要坐禅，却不把安静的感受当作终点；重视当下，却不逃避因果和责任；强调自心，却不否定众生的痛苦。“不立文字”不是少读几本书，而是读完以后，愿意回到自己身上。读到“无常”，便观察自己怎样抓住不肯放手。

读到“慈悲”，便看看自己是否愿意理解一个不喜欢的人。读到“无我”，便发现许多争执只是为了维护“我一定是对的”。读到“放下”，便在现实生活中少一次报复，少一次攀比，少一次无止境的索求。文字到了这里，才不再只是文字。

#horizontalrule

== 九、把“壁观”带回现代生活
<九把壁观带回现代生活>
现代人很少有机会进入山洞面壁九年，但每个人都可以在生活中练习片刻的“壁观”。当一件事情突然激怒你时，不必立即回复信息，也不必立刻作出决定。先停下来，安静地呼吸几次，看看身体哪里紧张，脑中正在重复什么念头。然后问自己：

“现在真正发生的是什么？”“这是事实，还是我对事实的解释？”“我正在保护什么？”“如果不被愤怒推着走，我可以怎样处理？”例如，别人没有及时回复消息。事实只是“消息暂时没有回复”。心却可能马上编出许多故事：

“他不尊重我。”“他一定讨厌我。”“所有人最终都会离开我。”壁观不是禁止这些念头出现，而是像看云一样，看见它们出现，也看见它们并不等同于事实。再如，一次工作失败以后，心中出现：

“我什么都做不好。”仔细观察便会发现，一件事情没有成功，被扩大成了对整个人生的判决。若能看见这个过程，我们便可以把它重新还原为：

“这一次没有做好，我需要分析原因，再作调整。”事情没有立刻变好，心却不再被一句绝对化的判断封死。这便是现代生活中的“心如墙壁”。不是把自己变成一堵冷漠的墙，而是让心拥有一点稳定，不被每一阵风吹走。

#horizontalrule

== 十、禅的起点：从寻找答案，到看见提问的人
<十禅的起点从寻找答案到看见提问的人>
达摩东来以后，中国佛教中逐渐生长出一种独特的声音。它不满足于问：

佛经里怎样解释烦恼？而要进一步问：

此刻正在烦恼的是谁？它不满足于问：

怎样才能得到安心？而会追问：

那个不安的心，究竟在哪里？它不满足于积累更多关于觉悟的知识，而要求修行者转过身来，亲自观察自己的念头、欲望、恐惧和执著。这不是否定经典，而是使经典回到生命。不是轻视语言，而是知道语言有它的边界。不是追求神秘体验，而是直面当下这一颗不断生灭、不断攀缘、也能够觉察和转化的心。

达摩留给中国佛教最深刻的影响，或许并不是某一种固定的坐禅姿势，而是一个始终无法由别人代答的问题：

当所有关于佛法的道理都已经听过以后，你是否真正看见了自己的心？后来，达摩所播下的这颗种子，经过慧可、僧璨、道信、弘忍的传承，终于在岭南一个不识字的砍柴人身上开出了一朵震动中国佛教的花。他的名字叫慧能。下一章，我们将走近这位六祖，看看一个没有显赫出身、没有深厚经学背景的普通人，为什么仅仅听到《金刚经》中的一句话，便由此改变了中国禅宗的方向。

#horizontalrule

== 小栏目：禅宗是不是不用读书、不用修行？
<小栏目禅宗是不是不用读书不用修行>
不是。“不立文字”是说佛法不能停留在文字上，不是说佛法不需要文字。达摩禅法讲“藉教悟宗”，达摩又被记载为将《楞伽经》传给慧可，可见早期禅法并未排斥经典。禅宗留下的《六祖坛经》《景德传灯录》《碧岩录》《临济录》等著作数量极多，本身也说明禅宗从未真正离开文字。

禅宗反对的，不是读书，而是把读书误认为修行；不是思考，而是把概念误认为觉悟。经典告诉人道路，修行使人亲自走上道路。没有经典和正见，容易误入歧途；只有经典而没有实践，也只能站在路旁谈论远方。

#horizontalrule

== 本章经典名句
<本章经典名句-1>
#quote(block: true)[
直指人心，见性成佛。
]

这句话并不是要人抛弃一切知识，而是提醒我们：佛法最终必须落实在对自心的认识和转化上。所谓“直指”，是少一些逃避和绕行。所谓“人心”，是当下正在爱憎、取舍、恐惧和觉察的心。所谓“见性”，是看见烦恼并非永恒，看见我执并无固定实体，也看见觉悟和慈悲的可能。

所谓“成佛”，是使这种觉察、智慧与慈悲不断成熟。

#horizontalrule

== 主要依据与延伸阅读
<主要依据与延伸阅读>
+ 唐·道宣：《续高僧传》卷十六〈菩提达摩传〉、〈慧可传〉。其中记载达摩的南天竺出身、壁观禅法、二入四行、慧可从学以及传授四卷《楞伽经》等内容。2. 《菩提达磨大师略辨大乘入道四行观》，即通常所说的《二入四行论》，为认识早期达摩禅法的核心资料。3. 唐·杜朏：《传法宝纪》。其中已有慧可断臂以表诚恳的记载，并对《续高僧传》“遭贼斫臂”之说提出不同意见。4. 宋·道原：《景德传灯录》卷三。达摩面壁、慧可立雪断臂、“将心来与汝安”等故事在此形成了后世最熟悉的叙述。5. 印顺法师：《中国禅宗史》。书中对早期达摩禅、壁观、楞伽禅以及禅宗形成过程作了系统考察。6. 陈平坤：〈慧可所传达摩的安心禅法〉，从《二入四行论》、慧可思想与四卷本《楞伽经》出发，讨论达摩禅法中的安心与缘起思想。

= 
<section>
#figure([
#box(image("chapters/../images/downloaded/ch16_huineng.jpg", width: 60.0%))
], caption: figure.caption(
position: bottom, 
[
《慧能禅师》
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


第十六章　六祖慧能：一个砍柴人怎样改变中国佛教？岭南的山路上，一个年轻人挑着柴，缓缓走进集市。他没有显赫的家世，没有受过完整的经学教育，也没有住进名寺修行。按照后世流传的故事，他靠砍柴、卖柴奉养母亲，只是唐代社会里一个再普通不过的贫苦百姓。

有一天，他送柴到客店门前，忽然听见有人诵经。诵到一句时，他像是被什么击中了，脚步停了下来。那句经文出自《金刚经》：

“应无所住而生其心。”一个念头生起，却不被这个念头捆住；身处万事万物之中，却不把任何一件事执著为永恒不变。这句话后来成为中国禅宗最著名的心法之一，也成为慧能一生故事的起点。这个砍柴人，就是后来被尊为禅宗六祖的慧能。不过，在讲述他的故事之前，需要先作一个说明：古籍多写作“惠能”，今天也常写作“慧能”。本书标题沿用现代读者较熟悉的“慧能”，引用古籍时则保留“惠能”原字。

更重要的是，我们今天熟悉的慧能生平，主要来自《六祖坛经》及后世禅宗史籍。这些记载既保存了早期禅宗的重要思想，也经过历代弟子的整理、增补和传述。因此，本章所讲的许多故事，应当理解为“禅宗传统中的慧能”。它们未必都能被当作现代意义上的历史实录，却真实影响了中国人理解佛法的方式。

一、当佛教走进盛唐慧能生活的时代，大约是公元七世纪后半叶。这时，佛教传入中国已经数百年。鸠摩罗什、真谛、玄奘等译经大师，陆续将大量佛经译成汉文；天台、三论、华严、法相等佛教思想体系也已逐渐成熟。寺院中不仅有诵经、礼佛和坐禅，还有规模宏大的讲经、注疏与义理辩论。

佛教在中国获得了前所未有的发展，但也出现了一个新的问题。经典越来越多，理论越来越精密，普通人却可能越来越不知道：佛法与自己究竟有什么关系？一个不识梵文、没有能力研读浩繁经论的人，能不能学佛？一个没有进入名寺、没有追随高僧多年的人，能不能明白佛法？

觉悟是否只能属于少数博学的僧侣？慧能故事之所以在中国流传千年，正因为它对这些问题给出了极为有力的回答：

觉悟不由出身决定，也不由文字多少决定。无论南方人还是北方人，无论识字还是不识字，无论贵族还是樵夫，皆有觉悟的可能。这并不是说经典和知识没有价值，而是说：经典的目的，是帮助人看见自己的迷执；知识若不能转化为生命中的智慧，仍然只是知识。慧能所象征的，正是佛教从深奥义理进一步走向中国人的日常心灵。

二、一句话唤醒一个人按照《六祖坛经》的叙述，慧能俗姓卢，祖籍范阳，后来随家人迁居岭南新州。父亲早逝，他与母亲生活贫困，靠卖柴维持生计。有一天，他送柴到客店，听见一位客人诵读《金刚经》。慧能听后心有所悟，便询问客人从哪里得到这部经。客人告诉他，湖北黄梅东山寺有一位高僧，名叫弘忍，常劝人诵持《金刚经》。

慧能于是生起求法之心。有人资助银两，使他能够安顿母亲，他便离开岭南，跋涉北上，到黄梅参见五祖弘忍。这个故事最值得注意的，不是它有多么传奇，而是慧能的觉悟从“听经”开始。后人常把禅宗概括成“不立文字”，于是有人误以为禅宗排斥佛经。其实，慧能第一次有所领悟，是听闻《金刚经》；后来在五祖处进一步开悟，依然与《金刚经》有关。《六祖坛经》中也广泛引用和解释《金刚经》《涅槃经》《法华经》《维摩诘经》等经典。

禅宗所反对的，不是文字本身，而是把文字当成觉悟本身。地图可以告诉人道路，却不能代替人走路；药方可以说明药性，却不能代替人服药。佛经也是如此。若只是背诵名句、争论术语，却不观察自己的贪欲、愤怒与执著，那么读得再多，也可能仍在门外。《坛经》用一个生动的比喻说，只在口头谈论般若智慧，却不依智慧而行，就像谈论食物而不能饱腹。

慧能的故事不是“不要读经”，而是提醒我们：读经最终必须回到自己的身心。三、南方人也有佛性慧能来到黄梅后，五祖弘忍问他从哪里来、来做什么。慧能回答，自己从岭南来，只为求作佛。弘忍故意问道：你是岭南人，又是未开化之地的人，怎么能够成佛？慧能回答的大意是：人的身体和地域虽有南北之分，佛性难道也有南北之分吗？

这句话在中国佛教史上极具象征意义。在唐代中原人的眼中，岭南遥远而偏僻，语言、风俗与中原不同。慧能在传统叙事中又是贫穷、少识文字的“獦獠”，处在文化与寺院等级的边缘。但他提出：身体有地域差异，人的觉悟本性却没有高低贵贱。佛性不是某个地区、阶层或知识群体的特权。

这与大乘佛教“一切众生皆有佛性”的思想相呼应。一个人可能暂时被无明和烦恼遮蔽，却不能因此被断定永远没有觉悟的可能。弘忍看出慧能根器不凡，却没有立刻让他进入讲堂，而是让他到碓房舂米。慧能在那里做了八个多月的杂役。这个安排也很有意味。求法不是只靠说几句高深的话。扫地、舂米、挑水、做饭，同样可以是修行。一个人是否真正明白佛法，不仅要看他能说什么，更要看他在劳作、委屈和无人注意时，如何安住自己的心。

四、墙上的两首偈后来，弘忍准备选择传法弟子，命众人各作一首偈，表达自己对心性的领悟。众弟子都认为，上座神秀学问深厚、修行多年，理应继承五祖的法。神秀经过反复思量，在墙上写下一首偈：

身是菩提树，心如明镜台；时时勤拂拭，勿使惹尘埃。这首偈把人的心比作明镜。烦恼和妄念如同镜上的尘埃，修行者应当时时觉察、不断清理，不让贪嗔痴覆盖清净的心。这种修行观并没有错。持戒、禅定、反省和长期熏修，本来就是佛教修行不可缺少的部分。五祖在《坛经》的故事中也让弟子诵持此偈，认为依此修行可以避免堕入恶道。

慧能当时仍在碓房。他听见别人诵念神秀的偈，便请人带自己到墙前，又请一位识字的人代为书写另一首偈。后世最流行的宗宝本《坛经》记为：

菩提本无树，明镜亦非台；本来无一物，何处惹尘埃？这首偈并不是说心中真的什么都不存在，也不是否定善恶、因果和修行。它所破除的是另一种更隐蔽的执著：把“心”想象成一个固定不变的实体，把“清净”当成某件可以占有的东西，把“开悟”当成一个可以抓住的结果。

若执著有一面永恒的镜子需要擦拭，仍然在“我擦镜子”“我得清净”的分别中。慧能之偈要人进一步看见：所谓菩提、明镜、尘埃，都是为了引导众生而建立的比喻，不应再被当作实有。真正的清净，不是紧紧抓住一个“清净的我”，而是连这个执著也放下。不过，不能因此把神秀与慧能简单画成“一个错误、一个正确”。

神秀偈强调修行过程，慧能偈强调不可执著于修行所得；前者提醒人时时观照，后者提醒人不要把观照变成新的自我中心。对尚未觉察烦恼的人来说，“时时勤拂拭”十分必要；对已经执著于“我在修行”“我比别人清净”的人来说，则需要进一步明白“本来无一物”。修行既不能放任尘埃，也不能执著镜子。

【版本小注：流传最广的宗宝本写作“本来无一物”。现存较早的敦煌本则写作“佛性常清净，何处有尘埃”，并另存一偈。两种文字各有侧重：一者突出般若性空，一者突出佛性清净。它们也提醒我们，《六祖坛经》并非一次定稿，而是在长期流传中逐渐形成的经典。】

五、三更受法：“应无所住而生其心”弘忍看到慧能的偈后，担心众人嫉妒加害，表面上用鞋将偈擦去，说慧能也还没有见性。第二天夜里，弘忍来到碓房，以手杖敲碓三下。慧能领会其意，在三更时进入五祖房中。弘忍用袈裟遮住四周，为他讲解《金刚经》。讲到“应无所住而生其心”时，慧能豁然领悟。

什么叫“无所住”？并不是什么都不想，也不是变得像木石一样没有感觉。“住”，是心抓住某件事不肯放下。别人赞美我，我反复回味；别人批评我，我久久怨恨；得到财富，我害怕失去；失去关系，我认定人生从此毫无意义。外境已经过去，心却仍然停留在那里，这就是“有所住”。

“无所住”，不是逃离外境，而是不被外境绑住。那么，既然无所住，为什么还要“生其心”？因为佛教所说的解脱，不是冷漠，也不是对世界毫无反应。无所住之后，仍然要生起慈悲心、智慧心、责任心。该帮助别人时帮助，该承担责任时承担，该判断是非时判断，只是不把自己的名声、得失和情绪牢牢抓住。

无所住，不是没有行动；恰恰因为不再被自我执著牵制，行动才可能更加清明。慧能领悟后感叹，自性本来清净，不随生灭而断绝，具足觉悟的可能，又能随缘显现种种作用。弘忍知道他已经把握了心法，便将衣钵传给他，命他连夜离开黄梅。在传统叙事中，一个没有显赫身份的碓房杂役，越过众多博学僧人，成为禅宗六祖。这并非鼓励人轻视学习，而是用极具冲击力的故事说明：

佛法最终检验的不是身份，而是觉悟；不是背诵了多少，而是能否照见自己的心。六、风动、幡动，还是心动？慧能南归后，据说曾隐居多年。后来，他来到广州法性寺，遇见印宗法师讲《涅槃经》。寺院外有风吹动经幡。两位僧人争论起来，一个说是风在动，一个说是幡在动。慧能在旁说：

不是风动，不是幡动，是仁者心动。这句话后来成为最著名的禅宗公案之一。若从物理现象来说，当然是风吹动了幡。慧能并不是否定客观世界，也不是说只要闭上眼睛，风和幡就不存在。他所指出的，是争论背后的那颗心。两位僧人表面上在讨论风和幡，内心却可能已经落入“我对你错”的执著。外面的幡只动了一阵，心中的胜负、成见和自尊却不断翻腾。真正使人烦恼的，往往不是眼前现象，而是心对现象的攀附。

我们在生活中也常常如此。一封邮件原本只有几行字，心却猜测对方是否轻视自己；一句无心之言，心中可以反复演绎数日；一次工作失误，很快被解释成“我永远不行”；一次意见不同，又被扩大成“他处处针对我”。外境确实发生了，但烦恼往往是在心中被反复加工、放大的。

看见“心动”，不是否认现实责任，而是把注意力从一味指责外境，转回自己的认识、情绪和执著。只有看见心是怎样动的，人才有可能不再被它牵着走。印宗法师听到慧能的话，认为他见解不凡，便请他上座问法，后来为他剃度。慧能由此公开弘法，最终长期居住于曹溪宝林寺。后世因此常用“曹溪”指称慧能一系的禅法。

七、顿悟：不是突然什么都懂了慧能最著名的思想，是“顿悟”。所谓顿悟，是说觉悟并不是把佛性一点一点制造出来。佛性不是今天有百分之一，明天增加到百分之二，修行多年后才终于拼成完整的佛性。从禅宗的立场说，众生觉悟的可能本来具足，只因长期被贪欲、愤怒、偏见和自我执著遮蔽，不能如实看见。

这就像一个人在黑暗的房间里摸索多年。灯一亮，房间不是逐渐出现，而是在刹那间被看见。房间中的桌椅原本就在，只是过去没有看清。但灯亮之后，不等于所有问题都解决了。一个人忽然看见自己的执著，并不代表旧习气立刻全部消失；明白愤怒会伤害自己和别人，也不代表从此再不会发怒；体会无常，也不代表面对失去时不再悲伤。

所以，“顿悟”不能被理解成一次神秘经验之后便无须修行。《坛经》本身不断强调“自悟修行”“心行”“依此修行”。其中所谓“顿”，主要是指对本性的看见不分阶段，而不是否定看见之后持续调伏习气、落实慈悲与智慧。后来的禅宗大德对此有不同表达。圭峰宗密提出“顿悟渐修”：可以顿时明白自己的本性，却仍须在日常生活中渐渐除去长期熏成的习气。这好比一个流浪者忽然知道了回家的方向，但知道方向之后，仍要一步一步走完道路。

慧能所说的“顿”，不是省略功课，而是不把功课误认为佛性本身。悟，是看清方向；修，是沿着方向生活。八、见性：不是发现一个永恒的“我”禅宗常说“明心见性”“见性成佛”。这也很容易被误解。有人把“自性”想象成身体里面隐藏着一个永恒不变的灵魂，仿佛只要通过冥想找到它，就能拥有一个真正的“我”。

这种理解并不符合佛教的无我和缘起思想。《坛经》所说的“自性”，不能被简单理解成一个独立、固定、可以占有的实体。它更多指向心不被妄执遮蔽时所显现的清净、觉照与智慧。它不是与世界隔绝的内在小我，而是在缘起关系中，不再执著自我中心的觉悟可能。因此，“见性”不是发现“我原来最伟大”，而是看见我们平常执著的这个“我”，其实由身体、感受、记忆、欲望、关系和环境等众多因缘暂时组成。

看见这一点，人的心反而会变得柔软。因为不再把自己看成孤立不变的中心，所以能够理解别人也受各自的经历、习惯与痛苦影响；因为知道自己的见解并非绝对，所以愿意倾听；因为知道一切因缘无常，所以更加珍惜当下。真正的见性，不会使人傲慢。一个人若总觉得自己已经开悟，处处轻视别人，恰恰说明“我执”仍然牢固。

九、无念、无相、无住《六祖坛经》以“无念为宗、无相为体、无住为本”概括修行纲要。这三个“无”都不是把世界消灭，也不是把心变成一片空白。第一，无念。无念不是没有念头，而是念头生起时，心不被念头污染和控制。看见美好的事物，可以欣赏，却不一定据为己有；遇到不如意的事情，可以处理，却不必让怨恨持续蔓延；制定未来计划，可以认真准备，却不把尚未发生的结果当成现实反复焦虑。

念头仍然来去，但人能够觉察它，而不必每一次都跟随它。第二，无相。无相不是看不见形象，而是不把暂时的形象当作事物永恒的本质。一个人今天成功，不代表永远成功；一次失败，也不能定义整个人生。职业、财富、年龄、名声、学历，都是因缘形成的“相”，可以发挥现实作用，却不是一个人的全部。

不执著于相，才不会以貌取人，也不会把自己困在某个标签里。第三，无住。无住是不停留在任何经验、观念和成就上。即使是佛法，也不能成为新的执著。有人执著财富，有人执著名声，也有人执著“清净”“修行”“境界”，不断比较谁更有功夫。所执著的对象虽不同，抓取之心却没有改变。

无住不是拒绝一切，而是接触一切、运用一切，却不被一切占有。因此，无念不是痴呆，无相不是虚无，无住不是冷漠。它们共同指向一种清醒而自由的生活：心能认识万事万物，却不被自己的认识束缚；身处复杂世界，却仍保有选择善行的能力。十、定与慧为什么不能分开？

有些人认为，修行应当先把心完全安定下来，等定力足够之后，才会产生智慧。慧能则强调“定慧一体”。定，不只是身体坐着不动；慧，也不只是头脑理解佛理。真正的定，是面对境界时不被贪嗔牵走；真正的慧，是清楚看见因缘、无常和执著。没有智慧的定，可能只是压抑念头；没有安定的慧，也可能只是聪明的辩论。

《坛经》把定与慧比作灯与光：灯亮便有光，光离不开灯。二者名称虽不同，作用却不能割裂。一个人在争吵时忽然觉察到自己的愤怒，这份清楚是慧；没有立刻被愤怒推动，能够停下来，这份稳定是定；接着以合适的方式表达意见，不伤害自己和别人，则是定慧落实于行动。

因此，禅并不限于蒲团上的静坐。慧能并不否定坐禅，却反对把“长时间坐着不动”本身当成觉悟。走路、吃饭、工作、照顾家人、与人交谈，只要能够觉察自己的心，不谄曲、不执著，皆可成为用功之处。佛法不是离开生活以后才出现的另一个世界。十一、佛法就在世间

《坛经》中有一首非常重要的偈：

“佛法在世间，不离世间觉。”觉悟不是逃到一个没有矛盾、没有人际关系、没有责任的地方。如果一个人在清净房间里觉得自己心无烦恼，一回到家庭和工作中便处处发怒，那么他的清净可能只是环境暂时提供的安静。真正的修行，要在事情发生时看见自己的心。家人不理解时，能否不让怨恨立即占据全部内心？

利益受到影响时，能否仍然守住基本的诚实？意见冲突时，能否既不一味退缩，也不以伤害对方来证明自己正确？遭遇失败时，能否承认痛苦，却不把一次失败变成对整个人生的判决？这些不是佛法之外的琐事，正是佛法发生的地方。“佛法在世间”也不意味着顺从一切现实。佛教讲慈悲，也讲智慧；讲忍辱，并不等于纵容伤害；讲无我，并不等于放弃合理权利；讲放下，也不等于逃避责任。

不被嗔恨控制，才能更准确地制止恶行；不被名利束缚，才可能作出更公正的选择；不执著自己的面子，才有勇气承认错误。禅不是把世界关在门外，而是在世界之中，不再被自己的贪嗔痴完全支配。十二、一个砍柴人改变了什么？从严格的历史研究看，慧能被确立为禅宗六祖，并不是仅凭黄梅的一夜传法就立即完成的。

慧能去世后，他的弟子神会在北方积极弘扬“南宗顿教”，批评当时受到朝廷尊崇的北宗禅，主张慧能才是五祖弘忍的正统继承者。经过长期争论与传播，慧能的六祖地位才逐渐得到普遍承认。后来，所谓南宗和北宗的直接传承都发生了变化，但唐宋以后兴起的禅宗各家，大多将自己的法脉追溯到慧能。临济、曹洞、云门、法眼、沩仰等宗派，也都在传统谱系中被视为曹溪禅法的后裔。

因此，真正改变中国佛教的，既是历史上的慧能，也是后来围绕慧能形成的《六祖坛经》、祖师故事和禅宗传统。这种改变至少体现在三个方面。第一，觉悟进一步向普通人开放。慧能被塑造成贫苦、少识文字的岭南樵夫。他的故事告诉人们：佛法不是少数贵族和学者的专利。一个人的社会地位不能决定他的佛性。

第二，佛法进一步回到当下之心。复杂的经论并未被否定，但修行的焦点更直接地落在每个人此刻的起心动念上。烦恼从哪里生起，执著怎样形成，慈悲与智慧如何在当下显现，成为禅宗关注的中心。第三，修行进一步融入日常生活。禅不再只是特定时间的静坐，也不仅是寺院内的仪式。行住坐卧、担水砍柴、待人接物，都可以成为觉察和修行的场所。

这正是慧能形象最强大的地方：他没有把佛法带向更神秘的高处，而是把它带回普通人的脚下。十三、常见误解：顿悟是不是一下子什么都懂了？不是。顿悟不是突然获得所有知识，也不是从此永不烦恼，更不是拥有神通。一个人可以在某一刻深刻看见：自己长期以来的痛苦，原来来自对名声、关系或自我形象的执著。这种看见可能十分迅速，甚至改变人生方向。但长期形成的情绪反应和行为习惯，仍须在一次次境界中观察和调整。

真正的悟，应当在行为中接受检验。是否比过去更少伤害别人？是否更能承认自己的错误？是否面对得失时多了一点从容？是否在别人痛苦时愿意伸手帮助？如果所谓“开悟”只带来傲慢、怪异和对因果责任的轻视，那很可能只是另一种自我想象。《坛经》反复强调“心行”，正是为了防止把顿悟变成一句漂亮口号。

顿悟不是修行的终点，而是从盲目修行走向清醒修行的转折。【小栏目：如何把“无住”带回生活？】第一步，看见。情绪生起时，先承认：“我现在很愤怒”“我正在害怕失去”“我很希望别人认可我。”不要急着责怪自己，也不要立刻跟随情绪行动。第二步，不住。提醒自己：这是一种正在变化的感受，不是永恒事实；这是一个念头，不等于全部的我。让情绪存在，但不继续用想象和判断喂养它。

第三步，生心。无住之后，不是什么都不做，而是问：在当下因缘中，怎样做更有智慧、更少伤害？需要解释便解释，需要拒绝便拒绝，需要道歉便道歉，需要承担便承担。这便是“应无所住而生其心”在现代生活中的一个朴素实践。结语：不在远方的菩提慧能的故事，从一个砍柴人听见诵经开始。

他没有告诉世人，觉悟只能在遥远的圣地获得；也没有告诉人们，必须成为另一个特别的人，才有资格接近佛法。他把问题带回每个人自己：

当赞美来到时，心怎样动？当侮辱来到时，心怎样动？当欲望、恐惧、嫉妒和后悔升起时，我们是否能够看见？看见之后，能不能不被它们完全拖走？所谓明心见性，并不是在心中找到一件神秘宝物，而是在每一次起心动念中，看见执著如何形成，也看见它可以被放下。神秀说，应当时时拂拭心上的尘埃。

慧能进一步追问：是谁在拂拭？什么又是尘埃？这两个问题并不一定互相排斥。一个教我们认真修行，一个教我们连“我在修行”的执著也不要抓住。从黄梅碓房到曹溪法席，从《金刚经》的一句话到流传千年的《六祖坛经》，慧能留给中国佛教最重要的启示，也许正是：

觉悟并不遥远。它不在生活之外，也不只在文字之中。它就在此刻这颗会喜悦、会愤怒、会执著，也能够觉察、放下并重新选择的心里。

= 第十七章　寺庙里的佛教
<第十七章-寺庙里的佛教>
#figure([
#box(image("chapters/../images/downloaded/ch17_foguang.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
五台山佛光寺东大殿外景（唐代建筑，公元857年）
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


清晨，城市还没有完全醒来。山门外的石阶上留着昨夜的雨水，树叶被洗得发亮。几位老人缓缓走上台阶，有人手里捧着鲜花，有人只是空着手。山门以内，钟声从重重殿宇之间传来，低沉而悠长。香炉中升起几缕淡烟，扫地的僧人没有抬头，游客也不由自主地放轻了脚步。

一个第一次走进寺院的人，往往会有许多疑问：

进门时应该先迈哪只脚？佛像那么多，应该拜哪一尊？香是不是烧得越多越灵？佛前供水果，是不是希望佛菩萨“收下礼物”之后保佑自己？钟鼓为什么早晚都要敲？身穿僧衣的人都叫“和尚”吗？不信佛的人，能不能进寺院？这些看似琐碎的问题，背后其实都指向一个更根本的问题：

#strong[寺院究竟是什么地方？]有人把寺院当作旅游景点，有人把它当作祈求好运的许愿场所，也有人把它想象成远离现实世界的清静之地。但从佛教传统来看，寺院首先是一处住持佛法的道场：有人在这里学习经典，有人在这里持戒修行，有人在这里礼佛、禅坐、忏悔、听法，也有人只是在忙乱的人生中，暂时停下脚步，重新看一看自己的内心。

《华严经·净行品》写道：

#quote(block: true)[
“入僧伽蓝，当愿众生：演说种种，无乖诤法。”
]

“僧伽蓝”是梵语“僧伽蓝摩”的略称，原意是僧众共同居住、修行的园林。进入寺院，不只是跨过一道门槛，也意味着暂时离开外界的争竞喧闹，学习一种不争、和合、清净的生活方式。寺院之所以让人安静，不只是因为那里有古树、佛像和钟声，更因为它保存了一套帮助人收摄身心的空间、礼仪与生活秩序。

== 一、从印度精舍到中国寺院
<一从印度精舍到中国寺院>
佛陀在世时，僧团最初没有固定寺院。出家弟子常在林间、树下、山洞或空地修行。后来，频婆娑罗王、给孤独长者等人布施园林，竹林精舍、祇园精舍等固定道场才逐渐出现。这些早期精舍的主要功能，是供僧人居住、听法、禅修和结夏安居。佛陀并没有要求弟子建造宏伟宫殿，也没有把寺院规定为神明接受祭祀的住所。寺院的核心从来不是建筑本身，而是其中有没有清净的僧团、正确的教法和真实的修行。

佛教传入中国以后，寺院的形态逐渐发生变化。早期佛寺常以佛塔为中心，周围建造佛殿、讲堂和回廊。南北朝以后，许多王侯宅第被改建为佛寺，中国传统住宅和宫殿的院落格局由此进入佛教建筑。隋唐以后，山门、天王殿、大雄宝殿、法堂、藏经楼等建筑渐次排列，纵向中轴线越来越清晰，佛寺也逐渐形成我们今天熟悉的汉式格局。

然而，寺院的格局并没有一部适用于所有地方的统一“建筑经”。不同宗派、时代、地域和山川地形，都会影响寺院的安排。有的寺院坐北朝南，有的依山而建；有的以大雄宝殿为中心，有的以观音殿、弥陀殿或禅堂为主要道场；有的规模宏大，有的只是一座小庵。因此，第一次进入一座寺院，不必急着套用固定模式。殿堂上的匾额，往往比导游口中的传说更可靠；寺院的介绍牌和常住僧人的说明，也比网络上流传的“拜佛秘诀”更值得相信。

== 二、穿过山门：从喧闹走向清净
<二穿过山门从喧闹走向清净>
寺院的大门通常称为“山门”。这并不意味着寺院一定建在深山。古代佛寺多择清静之处修建，久而久之，即使城市中的寺院，其正门也沿称山门。有些山门建成三门并列的形式，后世常以佛教的“空、无相、无作”三解脱门解释其象征意义，所以山门也称“三门”。但进入山门，并不是从“凡间”突然进入一个可以改变命运的神秘世界。真正需要跨越的，是心中的那一道门。

在门外，人可能还在想着工作成败、家庭矛盾、利益得失；走进门内，钟声和寂静提醒他：能不能先把这些念头放一放？能不能暂时不与别人比较？能不能让脚步慢下来，让言语少一点，让心清楚一点？这正是寺院礼仪的第一层意义：#strong[通过外在行为，帮助内心完成转变。]

传统礼仪中，有人进入山门时合掌问讯，有人从侧门进入，有人避免踩踏门槛。这些做法主要表达恭敬，并不是决定福祸的神秘规则。不同寺院的实际规定也不完全相同。对于普通参访者而言，衣着整洁、举止安静、遵守指示，远比纠结先迈左脚还是右脚重要。一个人即使不懂复杂仪轨，只要怀着尊重之心走进寺院，也不算失礼。

《法华经》中甚至说：

#quote(block: true)[
“若人散乱心，入于塔庙中，一称南无佛，皆已成佛道。”
]

这句话并不是说，一个人随口念一句佛号，立刻就圆满成佛；它所强调的是，即使最初的心并不专一，只要与佛法结下一点善缘，这颗种子也可能在未来成熟。寺院的大门，因此不是用来拒绝“外行人”的。它是向所有愿意停下来的人敞开的。

== 三、钟楼与鼓楼：寺院也有自己的时间
<三钟楼与鼓楼寺院也有自己的时间>
走过山门，许多寺院两侧可以看到钟楼和鼓楼。现代人听到寺院钟声，常觉得它古雅、空灵，适合营造远离尘世的意境。但在传统僧团中，钟鼓首先是生活秩序的一部分。什么时候起床，什么时候上殿，什么时候用斋，什么时候集众，钟鼓都有相应信号。它们既是法器，也是寺院中的“公共时钟”。北京市文物部门对大觉寺的介绍便指出，寺院诵经、斋粥、升堂和聚众等活动，都要依钟鼓号令进行。

钟声的宗教意义，也由此自然产生。钟一响，所有人都要放下手中私事，回到大众之中。它提醒人：时间正在过去，生命不会停留，修行不可放逸。中国佛教协会在解释寺院钟声时指出，钟既有报时集众的实际功能，也有警醒大众、破除烦恼、增长智慧的象征意义。寺院法器通常依照固定时间和仪轨使用，参访者不应因为好奇而随意敲击。

所以，寺院里的钟并不是满足游客愿望的“幸运钟”。真正值得听见的，不只是铜钟的声音，而是它在问：

#strong[一天又过去了，你是否清醒地生活过？]

== 四、天王殿：威严与欢喜为什么同在？
<四天王殿威严与欢喜为什么同在>
许多汉传佛教寺院进入山门后的第一重大殿，是天王殿。殿内正面常供奉笑容满面、大腹宽怀的弥勒形象，两侧是四大天王，弥勒像背后常见韦驮菩萨或韦驮护法。不同寺院会有差异，但这种配置在汉地非常常见。第一次参观的人也许会觉得奇怪：为什么一边是笑容可掬的弥勒，一边却是威武严肃的天王？

因为佛教所说的慈悲，并不是没有原则；所谓护法，也不是依靠暴力惩罚异己。弥勒的笑容提醒人宽容、欢喜、包容，四大天王和韦驮的威严则象征守护正法、止恶护善。一个真正慈悲的人，并不是对一切行为都纵容；他既要有柔软的心，也要有不随烦恼动摇的力量。中国人后来又把四大天王所持的剑、琵琶、伞和龙等器物，解释为“风调雨顺”的象征。这种解释带有明显的中国民间文化色彩，反映了佛教进入中国以后与社会愿望、艺术想象不断融合的过程。

在佛教教义中，护法神并不是独立于因果之外、可以随意降福降祸的万能神明。他们所“护”的首先是法，是人的善念、正见与修行。若一个人一边祈求护法保佑，一边欺骗伤害他人，便已经背离了“护法”的真正含义。

== 五、大雄宝殿：佛像在向谁说法？
<五大雄宝殿佛像在向谁说法>
继续向前，通常便来到寺院最重要的殿堂------大雄宝殿。“大雄”是对释迦牟尼佛的尊称，赞叹佛陀以智慧和勇气降伏烦恼。大雄宝殿通常是寺院举行早晚课诵、讲经说法和重大法会的重要场所。殿内供奉的佛像并不完全相同。有的供一尊释迦牟尼佛，两侧是迦叶、阿难；有的以文殊、普贤为胁侍；有的供横三世佛或竖三世佛；净土道场可能突出阿弥陀佛、观音菩萨和大势至菩萨；药师道场则可能供奉药师佛。

因此，不能只凭佛像的大小、颜色或手势随意判断身份。最稳妥的办法，是看佛像前的名号、殿堂匾额和寺院说明。

=== 佛像是不是“偶像”？
<佛像是不是偶像>
这是理解寺院佛教的关键问题。佛教徒为什么要塑造佛像、礼拜佛像？首先，佛像是一种纪念。释迦牟尼佛已经入灭，后人无法亲眼见到佛陀，便以雕塑、绘画和造塔等方式纪念他的觉悟、教法与人格。面对佛像，如同面对一位已经远去的老师，使人想起他曾经说过什么、走过怎样的道路。

其次，佛像是一种象征。佛像的安详，象征不被贪嗔痴扰乱的心；垂目内观，象征觉察自己；莲花座象征从烦恼污泥中生起清净智慧；手印与持物，也常用来表达说法、禅定、无畏、慈悲和愿力。再次，佛像是一面镜子。礼拜佛像，不只是赞叹外在的佛，也是在提醒自己：觉悟并不是永远与我无关。佛陀曾经也是在人间修行的人，众生也具有走向觉悟的可能。

但佛教同时警惕人们执著佛像，把有形的形象误认为佛的全部。《金刚经》说：

#quote(block: true)[
“若以色见我，以音声求我，是人行邪道，不能见如来。”
]

意思是，若只在外在形色和声音中寻找佛，就不能真正理解如来。佛像可以帮助人忆念佛、学习佛，却不能代替智慧、慈悲和修行。因此，佛教对佛像的态度既不是简单否定，也不是把佛像当作拥有脾气和欲望的神灵。可以借像表法，却不可执像为佛。

== 六、佛、菩萨、罗汉与护法分别代表什么？
<六佛菩萨罗汉与护法分别代表什么>
进入一座大寺，常会看到许多形象：佛、菩萨、罗汉、祖师以及护法诸天。若不了解它们的意义，很容易误以为寺院供奉的是一套等级复杂的“神仙体系”。事实上，它们所表达的是不同的觉悟境界、修行道路和精神品格。

=== 1. 佛：已经圆满觉悟者
<佛已经圆满觉悟者>
“佛”意为觉者。寺院中的佛像，主要代表圆满的智慧与慈悲。释迦牟尼佛是我们这个世界佛教的创立者；阿弥陀佛象征无量光明与寿命；药师佛的愿力与众生身心病苦相关。诸佛名号和愿力虽有不同，所指向的都是离开无明、圆满觉悟。

=== 2. 菩萨：走在觉悟道路上，并愿帮助众生的人
<菩萨走在觉悟道路上并愿帮助众生的人>
菩萨并不是“比佛低一级的神仙”，而是以成佛为目标、同时不舍众生的修行者。文殊象征智慧，普贤象征实践与行愿，观音象征慈悲，地藏象征深重愿力，大势至象征念佛摄心。面对菩萨像，不只是求菩萨替自己解决问题，更要问：我能否学习他的精神？拜观音之后，能不能少说一句伤人的话？

拜地藏之后，能不能对父母和弱者多一分承担？拜文殊之后，能不能不再固执己见，愿意分辨事实与偏见？

=== 3. 罗汉：佛陀教法的实践者与传承者
<罗汉佛陀教法的实践者与传承者>
罗汉主要指依佛陀教法断除烦恼、证得解脱的圣者。汉地寺院常见十八罗汉或五百罗汉像，其形象有老有少、有喜有怒，姿态各不相同。罗汉不像佛像那样往往具有高度理想化的庄严相貌。他们更接近现实中的人，仿佛提醒参访者：修行者的性格、经历和外貌可以各不相同，解脱之道却向所有人开放。

=== 4. 护法诸天：守护善法与道场秩序
<护法诸天守护善法与道场秩序>
四大天王、韦驮、伽蓝等护法形象，象征守护佛法和修行环境。所谓护法，既包括保护寺院，也包括保护人心中的善念。若一个人能够在诱惑面前守住戒律，在愤怒时不伤害别人，在利益冲突中不欺骗，这同样是在护法。佛像不只是供人观看的艺术品。每一尊形象，都在用无声的方式向人提问。

== 七、礼佛：弯下身体，是为了放下傲慢
<七礼佛弯下身体是为了放下傲慢>
在佛殿中，人们通常双手合掌，向佛像问讯或礼拜。合掌，是把散乱的双手合在一起，也象征把散乱的心收回来。礼拜时，人的额头、双手与双膝接近地面，在佛教中常称“五体投地”。有人觉得礼拜是一种自我贬低，仿佛人在高高在上的神灵面前承认卑微。其实，佛教礼拜的重点不在讨好佛，而在调伏自己。

人最难放下的，往往不是财物，而是“我对”“我重要”“我不能向别人低头”的傲慢。身体愿意弯下去，内心才有机会柔软下来。礼佛也并不意味着把判断权交给佛像。一个人可以在佛前诉说烦恼，但最后仍要依照因果和正见作出选择；可以祈愿身体健康，但仍要规律生活、接受治疗；可以祈愿事业顺利，但仍要勤奋、诚信；可以祈愿家庭和睦，但仍要学习倾听、克制脾气。

佛教的礼拜，是愿心与行动的开始，不是以仪式取代行动。至于礼拜一次还是三次，并不是衡量虔诚的标准。三拜常用来表达礼敬佛、法、僧三宝，也有寺院依自身仪轨安排礼数。普通参访者不熟悉礼仪时，合掌问讯即可，不必紧张地模仿每一个动作。

== 八、烧香：不是向佛菩萨递交礼物
<八烧香不是向佛菩萨递交礼物>
在大众印象中，烧香几乎成了佛教最醒目的标志。有人一进寺院便购买大把香烛，认为香越高、越粗、越多，所求之事越容易实现；有人争烧“头香”，仿佛只有第一个把香插入香炉的人，才能得到更多保佑。这些观念并不符合佛教本义。香最初是古印度常见的供养物，也有清洁环境、表达敬意的作用。佛教后来赋予香更深的象征：真正能够感召人心的，不是木料燃烧产生的气味，而是戒律、禅定、智慧与解脱所散发的“德香”。

《六祖坛经》解释“五分法身香”时，把“戒香”说成：

#quote(block: true)[
“无恶、无嫉妒、无贪嗔、无劫害，名戒香。”
]

换言之，一个人即使点燃了名贵香木，若内心充满嫉妒、贪欲和伤害，便没有真正供上戒香。反过来，即使没有烧香，只要愿意止恶行善、调伏内心，也已经在实践香供的真实意义。汉地寺院中常见一炷香或三炷香。三炷香可用来象征佛、法、僧三宝，也常被解释为戒、定、慧三学，但这属于汉传佛教中形成的象征性礼俗，并不是“多一炷就多一分灵验”的计算规则。

中国佛教协会曾明确指出，“头香”“头钟”并非佛教本身的内容，供养功德不取决于时间先后和物品贵贱，而在于是否具有至诚、恭敬乃至无我利他的发心。烧香因此不是向佛菩萨行贿。佛陀已经断除贪欲，不会因为谁送的香更贵便偏爱谁；菩萨以平等慈悲对待众生，也不会因供品多少决定是否救度。

所谓“心诚”，也不是心里强烈地想要某样东西，而是愿望之中有多少善意、责任和行动。求平安的人，应当先不伤害别人。求财富的人，应当守信用、勤劳并懂得布施。求孩子成才的人，应当给予陪伴和正确教育。求家庭和睦的人，应当从少一些指责开始。香烟终会散去，行为产生的因果却会留下。

== 九、供花、供果、供灯：佛需要这些东西吗？
<九供花供果供灯佛需要这些东西吗>
佛前常见鲜花、水果、净水、灯烛和食物。佛菩萨是否真的需要这些东西？若从物质需要来说，当然不需要。已经觉悟的佛陀，不会因为少了一盘水果而饥饿，也不会因为没有鲜花而不悦。供养首先是在训练布施和感恩。普通人的习惯是把最好的东西留给自己。供养则是有意识地把珍爱之物放到三宝之前，提醒自己：生命中所得到的一切，都不是理所当然。

不同供品也常被赋予象征意义：

花朵美丽却会凋谢，提醒人观照无常；果实象征行为终将结成果报；灯火象征智慧破除无明；净水象征清净、平等与柔和；香象征戒定慧与德行。这些解释不是把供物神秘化，而是借日常物品帮助人忆念佛法。但是，外在供养终究只是起点。《普贤行愿品》说：

#quote(block: true)[
“诸供养中，法供养最。”
]

所谓法供养，包括依照教法修行、利益众生、摄受众生、勤修善根、不舍菩萨事业。因此，给佛前供一束花，不如同时善待身边的人；给寺院点一盏灯，也应当努力减少自己内心的偏见；捐献财物固然可以护持道场，但若能同时诚实工作、照顾家人、帮助困苦者，才是把供养带回生活。

佛教并不反对财物供养。寺院需要修缮殿堂、培养僧才、印经弘法，也可能开展慈善救助。但捐款不是购买“功德额度”，更不能成为与佛菩萨交换利益的筹码。供养真正改变的，不是佛，而是供养者自己。

== 十、法会：不是一场神秘表演
<十法会不是一场神秘表演>
寺院举行法会时，常有梵呗、钟磬、诵经、礼拜、绕佛、持咒和回向等仪式。不了解佛教的人站在殿外，可能只听见整齐而陌生的唱诵，觉得其中充满神秘色彩。“法会”最朴素的意思，是大众因佛法而相会。广义而言，讲经说法、诵经礼佛、斋僧布施和集体共修，都可称为法会。狭义的法会则有特定仪轨，常包括庄严道场、供养三宝、礼佛、忏悔、诵经、绕行、禅观与回向等内容。

法会的作用，首先是帮助人集中身心。一个人在家诵经，容易被电话、家务和杂念打断；在大众共同修行的环境中，钟磬、唱诵和统一动作形成稳定节奏，使散乱的心逐渐安定。其次，法会具有教育功能。诵经不是把不懂的文字念给佛听，而是反复把佛法念给自己听。礼忏也不是请求佛菩萨取消因果，而是承认自己的过失，发愿不再重犯。回向则是把修行的善愿从自己扩大到亲友乃至一切众生。

再者，法会保存了汉传佛教独特的音乐、文学和礼仪传统。梵呗、法器、偈颂与仪轨经过历代祖师整理，既是宗教修行，也是中国文化的一部分。不过，形式越庄严，越要避免忘记内容。若参加完忏悔法会，回家仍旧伤害别人；诵完慈悲经典，仍旧傲慢刻薄；口中回向众生，心里只想着自己得福，那么法会便只剩下声音和动作。

真正的法会，应当在仪式结束后继续。

== 十一、僧人与居士：寺院里不只有“和尚”
<十一僧人与居士寺院里不只有和尚>
很多人把所有出家人都称为“和尚”。严格来说，“和尚”原是对亲教师、依止师的尊称，后来在汉语日常使用中，才逐渐成为男性出家人的泛称。现代进入寺院，对出家人一般尊称“法师”或“师父”即可；女性出家人可以称“比丘尼法师”或直接称“法师”，不宜以轻慢、戏谑的称呼相待。

佛教传统中的僧团，包括比丘和比丘尼。梵语“僧伽”意为和合众，并非单指某一个出家人，而是依戒律共同修学、共同生活的团体。汉译律疏常解释：“僧者，具云僧伽，此翻和合众。”出家人主要承担住持正法、持守戒律、修行、教学和管理道场等责任。但出家并不意味着自动成为圣人。僧人同样处在修行过程中，也会有性格、能力和修学程度的差别。尊重僧宝，是尊重清净僧团和佛法传承，并不等于放弃理性判断，更不意味着任何穿僧衣者所说的话都绝对正确。

与出家众相对的，是在家佛教徒。传统上，男性在家弟子称优婆塞，女性称优婆夷；与比丘、比丘尼合称佛教“四众”。经典中常并列“比丘、比丘尼、优婆塞、优婆夷”，说明佛法的传承并不只是出家人的责任。“居士”也不是出钱供养寺院的人，更不是拥有某种宗教身份便自然高于他人。通常而言，皈依三宝、在家庭和社会生活中学习佛法的人，可称在家居士。法鼓山对居士的解释强调，在家佛教徒生活在现实社会之中，以三皈五戒为方向，在家庭、人际和工作中实践戒定慧与菩萨道。

寺院因此不是由僧人表演、居士围观的场所。僧人住持教法，居士护持道场；僧人可以教授佛法，居士也应当在社会中实践佛法。两者各有生活方式，却共同构成佛教的生命。

== 十二、第一次进寺院，应该怎么做？
<十二第一次进寺院应该怎么做>
第一次进入寺院，不必先背诵一整套复杂规矩。掌握几项基本原则，已经足够表达尊重。

=== 1. 衣着整洁，不过分暴露
<衣着整洁不过分暴露>
寺院是宗教活动和僧众生活的场所。衣着不必昂贵正式，但应当整洁得体。参加禅修、诵经或正式法会时，可事先了解寺院是否有特别要求。

=== 2. 放低声音，放慢脚步
<放低声音放慢脚步>
佛殿、禅堂和法会现场应避免大声谈笑、奔跑追逐或长时间接打电话。静音不是因为佛菩萨怕吵，而是为了不妨碍正在修行的人。

=== 3. 不随意触摸佛像和法器
<不随意触摸佛像和法器>
佛像、经书、钟鼓、木鱼、磬和供具都有特定用途。未经允许，不宜触摸、敲击或移动。

=== 4. 拍照前先看规定
<拍照前先看规定>
有些寺院允许在庭院拍摄，却禁止在佛殿内拍照；有些法会不宜拍摄僧众和参加者。即使允许拍照，也应避免使用闪光灯、挡住礼佛者或把宗教仪式当作猎奇素材。

=== 5. 不烧大把香，不追逐“头香”
<不烧大把香不追逐头香>
遵守寺院的敬香规定即可。有些寺院出于消防和环保考虑不允许自带香烛，有些提倡殿外集中敬香。不上香也完全可以礼佛。

=== 6. 不懂仪轨时，合掌即可
<不懂仪轨时合掌即可>
不必因为怕“拜错”而不敢进入佛殿。合掌、低头、保持安静，便是最简单的恭敬。复杂礼仪可观察大众，或请教寺院义工和法师。

=== 7. 不要把每一尊佛像都当作不同的“办事部门”
<不要把每一尊佛像都当作不同的办事部门>
民间常把佛菩萨分配成求财、求子、求学业、求健康的不同对象。这种理解容易把佛教变成神灵职能表。可以向任何佛菩萨表达愿望，但更重要的是理解其所代表的智慧、慈悲和愿行。礼仪的目的，是培养觉察和尊重。若只记住了脚步、手势和香的数量，却对周围的人粗暴无礼，便失去了礼仪的根本。

== 十三、常见误解：烧香是不是“贿赂”佛菩萨？
<十三常见误解烧香是不是贿赂佛菩萨>
从佛教教义看，烧香不是贿赂。但现实中，人们确实可能带着交易心理烧香：

“我给佛供一炷香，佛要让我生意成功。”“我捐了钱，菩萨就应该保佑全家无灾。”“我连续参加七天法会，这次考试一定要让我通过。”这种心理不是佛教所说的信仰，而是把人间的利益交换投射到佛菩萨身上。贿赂之所以可能，是因为接受者有私欲，可以被利益打动。佛之所以称为佛，正因为已经断除贪欲与偏私。若佛也会因为礼物多少而改变因果，因为香火贵贱而偏爱某些人，他便不再是觉悟者。

佛教所说的感应，也不是取消因果，而是心与法相应。一个人在观音菩萨前发愿学习慈悲，离开寺院后真的减少伤害、帮助他人，这便是与观音相应。一个人在地藏菩萨前忏悔不孝，回家后开始照顾父母、改变言语，这便是与地藏相应。一个人在佛前祈求智慧，之后愿意学习、反省、承认错误，这便是与文殊相应。

相应不是佛菩萨替人完成任务，而是人的心行逐渐接近佛菩萨的心行。佛教并不禁止人祈愿。人在病痛、失业、考试、亲人离世时走进寺院，向佛菩萨倾诉，是很自然的事。问题不在“求”，而在把佛菩萨当成满足欲望的工具。可以求健康，但也愿众生离病苦。可以求事业顺利，但不以损害别人为代价。

可以求家人平安，也愿意帮助陌生的苦难者。当愿望从只顾自己，慢慢扩大到理解别人、利益别人，祈愿便开始具有佛法的方向。

== 十四、经典名句辨析：“一花一世界，一叶一如来”
<十四经典名句辨析一花一世界一叶一如来>
“一花一世界，一叶一如来”常被题写在寺院、茶室和书画作品中，也常被说成出自《华严经》。这句话意境优美，也确实接近华严思想：微小事物与广大世界并非彼此隔绝，一尘一法之中，都可以显现重重无尽的因缘。但从现存通行的汉译佛典看，很难找到“一花一世界，一叶一如来”完全相同的经文。它更像后世根据华严意境凝练而成的佛教文化用语，不宜直接加上引号，称为佛陀在某部经典中的逐字原话。

《华严经·普贤行愿品》中更接近的原文是：

#quote(block: true)[
“一尘中有尘数刹，一一刹有难思佛。”
]

意思是，在一粒微尘之中，可以观见如微尘数的世界；每一个世界中，又有不可思议诸佛说法。这是华严宗重重无尽、圆融无碍境界的诗性表达。普通读者仍然可以使用“一花一世界，一叶一如来”来表达对生命和世界的感悟，但应当知道：它是流行的佛教文化名句，不是可以轻率断定出处的经典直引。

一朵花能够让人看到什么？有人只看到颜色，有人想到花价，有人想到占有，也有人在花开花落之间看见无常，在花朵依赖阳光、泥土、雨水和无数条件而生时，看见缘起。世界并不藏在花瓣里面。世界显现在我们如何观看这一朵花。

== 十五、走出山门：把寺院带回生活
<十五走出山门把寺院带回生活>
那个第一次进入寺院的人，终于走到了藏经楼前。他没有记住每一尊佛像的名字，也没有学会复杂的礼拜仪轨。他只是跟着人群合掌，安静地站了一会儿。离开时，钟声再次响起。山门之外，车辆仍旧拥挤，手机里仍有未回复的信息，工作和家庭的问题也没有因为一次礼佛便自动消失。寺院没有替他改变世界。

但他似乎比来时慢了一点。他开始明白，寺院的安静不是为了让人永远逃离生活，而是让人在重新进入生活之前，看清自己。佛像提醒人觉察；菩萨提醒人慈悲；罗汉提醒人修行可以落实于真实人生；钟声提醒人生命无常；香提醒人修戒、定、慧；礼拜提醒人放下傲慢；供养提醒人学习给予；

法会提醒人不只为自己祈愿；僧团提醒人和合共住；山门则提醒人，每一次回头，都可以是重新开始。真正的寺院，并不只存在于高墙、殿宇和古树之间。当一个人在愤怒升起时愿意停一下，在利益面前守住诚实，在别人受苦时生起关怀，在拥有时懂得布施，在失去时理解无常------佛教便已经从寺院回到了生活。

烧过的香终会熄灭，钟声也会渐渐远去。唯有被唤醒的心，可以继续前行。

= 第十八章　因果、轮回与十善
<第十八章-因果轮回与十善>
#figure([
#box(image("chapters/../images/downloaded/ch18_wheel.jpg", width: 75.0%))
], caption: figure.caption(
position: bottom, 
[
Trongsa dzong壁画中的六道轮回图（Bhavachakra），不丹
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


中国人日常生活中，有许多话听起来并不像佛经，却带着浓厚的佛教色彩。看见有人做了亏心事，人们会说：“善恶到头终有报。”劝人不要欺骗伤害别人，会说：“人在做，天在看。”遭遇一时难以解释的得失，又会想到“因果”“业报”“前世今生”。在清明、中元、盂兰盆等节日里，人们祭奠祖先、超荐亡者；在寺院中，常能看到地藏菩萨像，听到《地藏经》和《盂兰盆经》的诵读声。

这些观念经过漫长的传播，已经与中国原有的祖先崇拜、孝道伦理和善恶报应思想交织在一起，以至于许多人很难分清：哪些是佛教的本义，哪些是中国民间文化的发展，哪些又只是后世为了劝善而形成的通俗说法。例如，有人把因果理解为一套看不见的奖惩制度：做好事，佛菩萨就会赐福；做坏事，冥冥之中便会受到惩罚。也有人把业力当成无法改变的命运，遇到疾病、贫困和不幸，便说：“这都是前世造的业。”甚至有人以因果之名责怪受苦者，仿佛每一个遭遇苦难的人都一定“罪有应得”。

这些理解看似敬畏因果，实际上却可能偏离佛法。佛教所说的因果，并不是一位神明在天上记账，也不是一张简单的善恶兑换表。它首先要回答的，是一个极其朴素而严肃的问题：

#strong[一个人反复作出的选择，会把自己变成怎样的人？]

#horizontalrule

== 一、业不是神秘力量，而是我们的造作
<一业不是神秘力量而是我们的造作>
“业”是梵文“羯磨”的意译，本义是行为、行动和造作。在日常汉语里，我们常把“业”理解成“罪业”或“业障”，仿佛业一定是不好的。其实佛教所说的业有善、有恶，也有不善不恶之分。帮助别人是业，伤害别人是业；诚实说话是业，欺骗也是业；嫉妒、怨恨、慈悲和宽容，同样会在内心形成相应的力量。

佛教通常把人的行为分为三类：

- 身体所作，称为“身业”；

- 语言所说，称为“语业”或“口业”；

- 内心的意图、判断与选择，称为“意业”。

其中，真正使行为具有善恶意义的，是行为背后的动机和意向。一个人无意踩死小虫，与故意以折磨生命为乐，外在结果或许相似，内在性质却并不相同。《阿毗达磨俱舍论》说：“思即是意业，所作谓身语。”意思是，内心的“思”推动身体和语言采取行动，因此意向是业的重要根本。

这并不是说只要“心是好的”，行为造成的后果便可以忽略。佛教判断一件事，既看动机，也看手段和结果。善意需要智慧，否则也可能好心办坏事；错误已经造成，也不能只用一句“我不是故意的”推卸责任。因此，业并不是一种从外面降临到人身上的神秘能量，而是身、口、意不断活动所形成的生命倾向。

一次愤怒，也许只是一时情绪；反复用愤怒解决问题，便逐渐形成暴躁的习惯。一次谎言，可能出于恐惧；不断以谎言保护自己，最终会使人失去信用，也使自己越来越难以面对真实。相反，一个人每一次克制伤害的冲动，每一次选择诚实，每一次体谅他人的处境，也都在塑造自己的性格与未来。

从这个意义上说，所谓业力，就是行为经过反复累积后，对自己、他人和周围世界产生的持续影响。《十善业道经》说：“一切众生心想异故，造业亦异。”不同的心念，引出不同的行为；不同的行为，又使生命呈现出不同的方向。

#horizontalrule

== 二、因果不是“做一件好事，立刻得到一个好结果”
<二因果不是做一件好事立刻得到一个好结果>
佛教讲“因果”，其实常常连着另一个字：缘。一颗种子是因，但种子不一定立刻发芽。它还需要土壤、水分、阳光、温度等条件，这些条件就是缘。因缘具足，果实才会成熟；条件不足，种子可能长期潜伏，也可能枯坏。人的行为也是如此。一个人今天帮助了别人，明天未必马上升职发财；一个人欺骗了别人，也未必立刻遭遇灾祸。因为现实中的每一个结果，往往都是许多原因和条件共同作用的结果。个人习惯、家庭环境、社会制度、他人的选择、身体状况以及偶然事件，都可能参与其中。

因此，因果不能被理解成机械的一对一关系：

#quote(block: true)[
做一件善事，便兑换一件好事；
]

#quote(block: true)[
做一件恶事，便马上遭遇一件坏事。
]

这样的理解过于简单，也容易让信仰变成交易：我布施了多少，就应该得到多少回报；我念了多少佛，灾难就不应该发生。若结果不如预期，便怀疑佛法“不灵”。佛教所说的善果，首先不一定是外在利益，也可能表现为内心的改变。一个常常布施的人，未必因此变得富有，却可能逐渐减轻吝啬与占有；一个愿意宽恕的人，未必立即得到别人道歉，却可能不再被怨恨长久折磨。善行的第一个受益者，往往就是那个正在行善的人。

同样，恶业的果报也不只是未来遭受某种惩罚。一个习惯欺骗的人，即使暂时得利，也会生活在害怕暴露的焦虑中；一个习惯仇恨的人，即使没有受到法律制裁，仇恨本身也已经在灼伤他的内心。佛教经典虽然强调“因业得报”，却并不主张世间一切苦乐全部由过去世的业决定。《杂阿含经论会编》所引阿含教义，明确批评“一切所受皆是宿因所作”的观点，称这种把所有遭遇都归因于宿业的说法“不应道理”。

这点十分重要。一个人生病，可能与遗传、饮食、环境、感染和医疗条件有关；一个人遭遇贫困，可能与教育机会、社会结构和时代环境有关；一个人受到暴力伤害，责任首先在施暴者，而不能用一句“这是受害者的业报”加以搪塞。#strong[相信因果，不等于把一切现实问题都推给前世。]

若因果观使人冷漠，使人面对他人的苦难只会说“他自作自受”，那便不是慈悲的佛法，而是披着佛教语言的无情。

#horizontalrule

== 三、不是天罚，也没有一位神明替人结算
<三不是天罚也没有一位神明替人结算>
在许多宗教传统中，善恶报应由至高神裁决。但佛教并不以一位创造世界、赏善罚恶的神作为因果法则的主宰。《中阿含经·鹦鹉经》中，佛陀说众生“因自行业，因业得报”。生命的差别与自己的行为有关，并不是由某位神灵任意安排。这是一种强调责任的思想。人不能把自己的贪婪归咎于魔鬼，也不能只靠祈求神明便抹去行为的后果。已经伤害了别人，需要道歉、补偿和改正；已经形成的恶习，需要一次次觉察和停止。礼佛、诵经和忏悔可以帮助人反省，但真正的忏悔必须包含“不再重犯”的努力。

印顺法师把佛教的善恶业果概括为“自力创造非他力”。这里的“自力”并不是说一个人可以脱离社会独自决定一切，而是说：自己的思想和行为，不能由别人代替负责。不过，佛教同时又说“无我”。既然没有一个永恒不变的灵魂，那么究竟是谁造业，又是谁受报？《杂阿含经》提出一句很深的话：

#quote(block: true)[
“有业报而无作者，此阴灭已，异阴相续。”
]

它不是否认行为和结果，而是否认在行为背后存在一个永远不变、独立自主的“我”。前一刻的身心消逝，后一刻的身心继续生起；二者不是完全相同，却也不是毫无关系，如河流不断变化，却仍有前后相续。昨天愤怒的“我”与今天后悔的“我”，并不是一个丝毫不变的实体，却有清楚的因果联系。童年时养成的习惯，会影响成年后的选择；前一念滋长的欲望，会推动后一念的行动。

所以佛教的业报观处在两个极端之间：

- 不是说存在一个永恒灵魂，背着业债从一生走向另一生；

- 也不是说人死之后一切断灭，过去行为再无任何意义。

佛教用“缘起相续”解释责任：没有不变的主体，却有前后相连的因果过程。

#horizontalrule

== 四、轮回：不是同一个“我”反复搬家
<四轮回不是同一个我反复搬家>
在汉传佛教中，人们常说六道轮回：天、人、阿修罗、畜生、饿鬼、地狱。按照传统佛教的理解，众生由于无明、欲望和业力，在不同生命形态中不断生死流转。善业成熟，可能趋向较为安乐的生命状态；贪、瞋、痴等恶业增长，则可能趋向痛苦的生命状态。轮回并不是某位神对人的永久判决，而是烦恼与行为不断延续的结果。印顺法师在面向青年的佛教读物中，将一生又一生随善恶业力延续的过程称为轮回，并以六道说明其传统分类。

许多人听到轮回，马上想到一个灵魂离开旧身体，又钻进新身体，好像一个人脱下旧衣服，再换上一件新衣服。这种说法容易理解，却并不完全符合佛教的“无我”思想。佛教否认一个永恒不变的灵魂实体，但承认身心活动的因果相续。可以借用烛火作一个并不完全精确的比喻：一支蜡烛点燃另一支蜡烛，后面的火焰不能说就是前面的火焰，却也不能说与前面的火焰毫无关系。前一火焰成为后一火焰生起的条件，既非完全相同，也非完全不同。

同样，轮回中的生命并不是一个固定自我原封不动地迁移，而是欲望、执著、行为和认识方式不断相续。对现代读者来说，六道也可以帮助观察当下的精神状态：

盛怒之时，内心如在烈火地狱；欲望永远得不到满足，便像饿鬼饥渴不休；只凭本能追逐食色而缺乏反省，近似畜生状态；处处争胜、嫉妒斗争，具有阿修罗的特征；能够守护理性、道德与慈悲，才真正活出“人”的可贵。但这种心理解释只是帮助理解，不能完全取代佛教传统关于生死流转的教义。佛教谈轮回，最终不是为了满足人们对前世身份的好奇，而是为了指出：只要贪、瞋、痴仍在推动生命，痛苦的循环便会以不同形式继续。

因此，比“我前世是谁”更重要的问题是：

#strong[我今天正在培养什么？这样的心念与行为，将把生命带向哪里？]

#horizontalrule

== 五、目连救母：一个人的孝心为什么还不够？
<五目连救母一个人的孝心为什么还不够>
在佛教进入中国之后，因果轮回最深入人心的故事之一，是目连救母。《佛说盂兰盆经》记载，佛弟子大目犍连得到神通后，想报答父母养育之恩。他观察亡母所在之处，发现母亲堕入饿鬼道，饥饿憔悴。目连悲痛不已，便盛饭送给母亲。母亲得到食物，一手遮掩饭钵，唯恐其他饿鬼看见，另一手急忙取食。然而食物还未入口，便化为火炭，无法食用。

目连虽有神通，也救不了母亲，只得向佛陀求助。佛陀告诉他，母亲的业力深重，不能仅凭一人之力解除；应在僧众结夏安居圆满之日，以饮食和生活用品供养十方僧众，借大众清净修行的功德，使现世父母乃至过去父母得到利益。这个故事进入中国后，与孝道传统结合，逐渐形成盂兰盆会等仪式。它最感人的地方，并不只是神通和饿鬼世界，而是目连在成就之后仍然没有忘记母亲。

可是故事还有更深一层意义：目连最初只想把一碗饭直接交给母亲，却没有成功。个人的感情固然真挚，但仅凭占有式的爱和神通式的拯救，并不足以解除深重的苦。佛陀引导他把个人孝心扩大为供养僧团、帮助大众的善行。换句话说，真正的报恩不能只停留在悲伤和怀念，也不能只靠烧纸、祭品或祈求。它应转化为现实中的善行：照顾仍然在世的父母，尊重老人，帮助饥饿贫困者，把亲情化为更广泛的慈悲。

目连救母的故事因而完成了一次转变：

#strong[从“我怎样救我的母亲”，走向“我怎样减少世间众多母亲和众生的苦”。]

#horizontalrule

== 六、地藏菩萨：从救度母亲到救度一切众生
<六地藏菩萨从救度母亲到救度一切众生>
与目连故事相呼应的，是地藏菩萨的愿力。汉传佛教流通的《地藏菩萨本愿经》中，讲述了婆罗门女和光目女救母的故事。她们得知母亲因生前恶业而受苦，便以供养、念佛和发愿等方式为母亲修福。更重要的是，她们没有在母亲得救之后便停止，而是由个人的悲痛生起广大誓愿，希望救度一切受苦众生。

于是，孝心不再只指向一个家庭。看见母亲受苦，便想到其他人的母亲也在受苦；希望自己的亲人离苦，也希望一切众生离苦。这正是大乘佛教把亲情扩展为菩萨愿力的方式。《地藏经》以“恶习结业，善习结果”说明众生随习惯造业、随业流转，也反复强调地藏菩萨以大愿救拔受苦众生。

因此，地藏菩萨并不只是“管理亡者的菩萨”，也不只是出现在葬礼和墓园中的形象。他所象征的，是面对最深重的痛苦仍不放弃任何人的愿力。一个人犯过错误，是否就永远没有希望？地藏信仰给出的回答是：只要仍有觉悟和改变的可能，就不应轻易舍弃。承认业果，是承认行为有后果；发愿救度，则是相信众生不必永远被过去定义。

这里也需要作一点文献说明：《地藏菩萨本愿经》传统题为唐代实叉难陀译，但现代学术界对于其成书过程和译者问题仍有讨论。无论文献来源如何研究，这部经典在汉传佛教孝道、地藏信仰和民间善恶观念中的巨大影响，都是不可忽视的。CBETA也说明，《地藏经》在早期大藏经中的收录情况及传统作译者问题，存在值得研究之处。

#horizontalrule

== 七、五戒：不是神的命令，而是五种保护
<七五戒不是神的命令而是五种保护>
佛教在家弟子最基本的行为准则，是五戒：

一、不杀生；二、不偷盗；三、不邪淫；四、不妄语；五、不饮酒。这五条表面上都以“不”开头，似乎只是禁止。若从积极面理解，它们其实保护了人类生活中五种重要的安全：

不杀生，是保护生命安全；不偷盗，是保护财产与劳动成果；不邪淫，是保护家庭、感情与彼此信任；不妄语，是保护真实与社会信用；不饮酒，是保护清醒、理性与自我控制。五戒不是因为佛陀不允许人做什么，而是因为某些行为会伤害自己和他人。例如，饮酒戒并不是说酒本身具有某种宗教上的污秽，而是因为醉酒容易使人失去觉察，进而破坏其他戒律。《优婆塞五戒相经》用饮酒后失去自制的故事说明，即使平时具有能力和威仪的人，醉后也可能无法控制自己的行为。

戒律也不是一次受持之后便自动变成完人。它更像训练边界：当愤怒升起时，提醒自己不要伤害；当利益诱惑出现时，提醒自己不要侵占；当欲望使人想背叛承诺时，提醒自己尊重关系；当谎言即将出口时，提醒自己承担真实。因此，“戒”不是束缚善良生活的枷锁，而是防止人被冲动和欲望奴役的护栏。

#horizontalrule

== 八、十善：把善恶落实到身体、语言和心念
<八十善把善恶落实到身体语言和心念>
五戒主要是为在家佛教徒建立底线，十善则把行为规范进一步扩展到身、口、意三个方面。

=== 身体方面的三善
<身体方面的三善>
#strong[第一，不杀生。]不仅是不故意夺取生命，也应培养尊重生命、减少伤害的慈悲心。现代生活中的虐待动物、校园欺凌、家庭暴力和战争，同样属于杀害与伤害精神的延伸。#strong[第二，不偷盗。]不拿取别人没有给予的东西。除了明显的盗窃，也包括侵占公物、贪污、诈骗、剽窃成果、盗用数据和利用权力夺取不当利益。

#strong[第三，不邪淫。]不以欲望伤害他人，不破坏他人的家庭和承诺，不利用欺骗、权势或胁迫获得关系。它要求人对亲密关系承担尊重与责任。

=== 语言方面的四善
<语言方面的四善>
#strong[第四，不妄语。]不故意说假话欺骗别人。诚实并不等于不顾场合地伤人，而是既不歪曲事实，也尽量以合适的方式表达真实。#strong[第五，不两舌。]不挑拨离间，不在两边搬弄是非。它的积极面，是帮助双方沟通、化解矛盾。#strong[第六，不恶口。]不以侮辱、羞辱和恶毒语言伤害别人。语言看似没有形体，却可能在人心中留下长久伤痕。

#strong[第七，不绮语。]不说虚浮、无益、诱惑人走向错误的话。绮语并不是禁止幽默和文学，而是提醒人不要用漂亮言辞包装欺骗，也不要为了取悦和流量传播毫无责任的言论。

=== 内心方面的三善
<内心方面的三善>
#strong[第八，不贪欲。]不是要求人没有任何愿望，而是不让占有欲无限膨胀，不把别人的东西、地位和生活都据为己有。积极面是知足、布施和随喜。#strong[第九，不瞋恚。]不是强迫自己永远不能生气，而是不让愤怒发展为伤害和报复。积极面是慈悲、忍耐和理解。#strong[第十，不邪见。]

邪见在这里主要指否定行为责任，认为善恶毫无意义，或者只要没有被发现，做什么都没有关系。正见则是明白行为会形成后果，生命彼此关联，应为自己的选择负责。十善由三种身体行为、四种语言行为和三种内心倾向组成。传统佛教文献将其概括为不杀生、不偷盗、不邪淫，不妄语、不两舌、不恶口、不绮语，以及不贪欲、不瞋恚、不邪见。

《十善业道经》不只要求停止十恶，还分别说明远离伤害、偷盗、妄语和瞋恚等行为所能成就的安稳、信任与和合。它的重点并不是用恐惧威胁人，而是说明一种行为会逐渐营造与之相应的生命世界。

#horizontalrule

== 九、网络时代，更要小心“口业”
<九网络时代更要小心口业>
古代人说一句话，影响的也许只是身边几个人。今天，一个未经证实的消息、一张恶意剪辑的图片、一句侮辱性的评论，几分钟内便可能传播给成千上万人。因此，十善中的四种语言规范，在网络时代尤其重要。转发谣言，可能同时包含妄语与绮语；在两个群体之间煽动仇恨，属于两舌；躲在匿名账号后羞辱攻击别人，属于恶口；为了流量夸大事实、制造恐慌，则可能四者兼具。

有些人认为：“我只是转发，又不是我写的。”但从佛教的业观来看，只要明知内容可能伤害别人，仍然主动帮助传播，便参与了行为后果的形成。每一次点击、评论和转发，都是一种微小的选择。它们可能让谣言扩散，也可能让真实被看见；可能让仇恨升级，也可能使冲突降温。

十善并不是古代社会留下的陈旧道德清单。它提醒现代人：技术改变了语言传播的速度，却没有取消说话者的责任。

#horizontalrule

== 十、因果是不是“好人马上有好报”？
<十因果是不是好人马上有好报>
这是关于佛教因果最常见的误解。现实生活中，我们常常看见好人遭遇不幸，恶人一时得势。如果把因果理解为立即兑现的奖惩，就会产生疑问：因果到底在哪里？佛教的回答不是要求人闭上眼睛，相信坏人迟早必遭雷劈，而是提醒我们：现实结果由复杂因缘共同形成，业果成熟有快有慢，表现形式也不相同。更不能因为一个人正在受苦，就武断地推测他过去一定做过坏事。

一个善良的人可能因疾病、灾害或社会不公而受苦；一个不诚实的人也可能暂时利用制度漏洞获利。这些现象并不意味着行为没有后果，而是说明因果远比人们想象的复杂。因果观真正能确定的，不是“我做一件好事，宇宙必须给我一份奖励”，而是：

- 贪婪会使贪婪增长；

- 仇恨会使仇恨延续；

- 欺骗会侵蚀信任；

- 慈悲会使人更能体会他人的痛苦；

- 诚实会逐渐建立稳定可靠的关系。

外在果报何时以何种方式成熟，凡夫未必能够判断；但每一次行为都在塑造当下的自己，这是任何人都可以观察的因果。

#horizontalrule

== 十一、轮回是不是恐吓人的故事？
<十一轮回是不是恐吓人的故事>
地狱、饿鬼和畜生道的描述，确实具有强烈的警示作用。古代寺院壁画和民间善书，也常用可怕的刑罚场景劝人止恶。但如果佛教只剩下“做坏事便下地狱”的恐吓，它的教化便停留在最表层。佛陀讲轮回，不是为了让人永远活在恐惧中，而是为了让人看见苦如何产生，又如何停止。若贪欲、瞋恨和无明不断延续，人即使没有想到来世，当下也已经被烦恼束缚；若能减少贪瞋痴，培养戒、定、慧，轮回的动力便会逐渐减弱。

恐惧也许能暂时阻止一个人作恶，但真正稳定的善，需要来自理解与慈悲：

我不伤害生命，不只是因为害怕将来受罚，而是因为知道众生都畏惧痛苦；我不欺骗别人，不只是担心报应，而是因为明白信任一旦破坏，自己与他人都会受伤；我愿意布施，不只是为了积累福报，而是因为看见别人的需要。佛教最终要培养的，不是一个害怕惩罚的人，而是一个能够自觉选择善行的人。

#horizontalrule

== 十二、佛教是不是叫人认命？
<十二佛教是不是叫人认命>
恰恰相反，真正理解业力，便会明白命运不是完全固定的。过去的行为已经形成某些条件，这是人无法假装不存在的部分；但现在如何回应，又会形成新的因缘。一个人曾经伤害别人，不能让伤害从未发生，却可以承认错误、停止伤害、补偿对方，并改变今后的行为。一个人从小形成暴躁习惯，不能一夜之间完全改变，却可以在每一次愤怒升起时练习停顿。一个人过去吝啬，也可以从一次小小的分享开始培养布施。

如果一切早已注定，佛陀便没有必要说法，人也没有必要修行。修行之所以可能，正是因为身心是因缘所生、不断变化的。恶习由一次次重复形成，也可以通过新的选择逐渐减弱。业力不是判决书，而更像已经形成的惯性；惯性很强，却并非永远不能改变。圣严法师解释三世因果时强调，未来的情形还要由过去的条件加上现在的努力共同形成；基于当下的善恶与勤惰，厄运可以改变，好运也可能消失。

所以，佛教的因果观不是要人消极地说“这就是我的命”，而是要人意识到：

#strong[过去影响现在，现在也正在创造未来。]

#horizontalrule

== 十三、“欲知前世因”究竟出自哪里？
<十三欲知前世因究竟出自哪里>
汉地佛教中流传着一首非常著名的偈语：

#quote(block: true)[
欲知前世因，今生受者是；
]

#quote(block: true)[
欲知来世果，今生作者是。
]

这几句话简明有力，因此常被直接说成“佛经云”或“佛陀说”。不过，从现有可检索的佛教文献看，这一完整表达更多见于后世汉地佛教著作和劝善文献，并非可以轻易确认的早期佛经原句。例如，明清以来的《启信杂说》等文献已经引用“欲知前世因，今生受者是”，后来的佛教注疏和劝善著作又不断沿用。

因此，在严谨写作中，更适合称它为“汉地佛教广泛流传的劝善偈”，不宜未经说明便标为释迦牟尼佛亲口所说。但文献出处需要辨明，并不表示这首偈毫无价值。它最值得重视的，不是让人猜测自己前世做过什么，而是把注意力拉回当下：无论过去如何，今天的行为正在成为未来的原因。

圣严法师也借这首偈强调，不必沉迷于用神通追查前世，重要的是清楚地把握现在，因为现在正连接着过去与未来。

#horizontalrule

== 十四、从害怕报应，到自净其意
<十四从害怕报应到自净其意>
佛教对善恶修行最简洁的概括，是一首古老偈语：

#quote(block: true)[
诸恶莫作，众善奉行，自净其意，是诸佛教。
]

不做恶事，积极行善，还不算全部；最后还要“自净其意”。因为一个人表面没有伤害别人，内心仍可能充满嫉妒和怨恨；表面行善，也可能只是为了名声和回报。若不观察内心，善行仍可能成为自我炫耀和交换利益的工具。“诸恶莫作”是守住底线；“众善奉行”是主动利益他人；“自净其意”则是看清并减少内心的贪、瞋、痴。

这三层合在一起，才构成完整的佛教善恶观。此偈在汉传佛教诸多论疏和修行著作中被反复引用，被视为佛教实践的总纲。因果使人懂得为行为负责，轮回使人看到烦恼相续的漫长，五戒帮助人守住不伤害的底线，十善则引导身、口、意走向清净。这些教法的目的，不是让人终日担心报应，也不是要求人用前世解释一切，而是让人从每一个当下开始，停止制造新的痛苦。

当我们准备说一句伤人的话时，可以停一下；当我们想占取不属于自己的利益时，可以退一步；当嫉妒和怨恨升起时，可以看见它，而不急着跟随它；当别人陷入困难时，可以少一点评判，多一点帮助。真正的因果，不只写在看不见的来世，也写在今天的面容、语言、习惯和人与人之间的关系里。

每一个念头，都可能成为一颗种子；每一次选择，都在决定它将得到怎样的土壤。我们无法重新选择已经发生的过去，却可以选择现在如何生活。而现在，正是未来最初的因。

#horizontalrule

== 常见误解：三个问题
<常见误解三个问题>
=== 一、因果是不是简单的“好人马上有好报”？
<一因果是不是简单的好人马上有好报>
不是。结果由许多因缘共同形成，业果成熟也有时间和条件差别。善行首先改变的是行善者的心性、习惯与人际关系，外在回报并不一定立即出现。更不能因为某人遭遇不幸，就断言他一定是过去作恶。

=== 二、轮回是不是恐吓人的故事？
<二轮回是不是恐吓人的故事>
传统佛教把轮回视为真实的生死流转，但讲轮回的目的不是制造恐惧，而是说明贪、瞋、痴如何使苦不断延续。六道也能帮助人观察当下不同的精神状态，但这种心理解释不能完全取代传统教义。

=== 三、佛教是不是叫人认命？
<三佛教是不是叫人认命>
不是。业力说明过去行为会形成影响，却不表示未来完全注定。现在的选择仍会加入新的因缘。正因为身心可以改变，忏悔、持戒和修行才有意义。

#horizontalrule

== 本章经典与资料依据
<本章经典与资料依据-1>
+ 《中阿含经》卷四十四《鹦鹉经》，大正藏第1册，第26号。经中以“众生因自行业，因业得报”说明行为责任。2. 《杂阿含经》卷十三第三三五经，大正藏第2册，第99号。提出“有业报而无作者，此阴灭已，异阴相续”。3. 《十善业道经》，大正藏第15册，第600号。说明身、语、意善恶业及十善的修行意义。4. 《阿毗达磨俱舍论》卷十三，大正藏第29册，第1558号。论述思业及身语业。5. 《佛说优婆塞五戒相经》，大正藏第24册，第1476号。解释在家五戒的具体行持。6. 《佛说盂兰盆经》，大正藏第16册，第685号。记载目连救母与供僧报恩故事。7. 《地藏菩萨本愿经》，大正藏第13册，第412号。包含婆罗门女、光目女救母及地藏菩萨发愿救度众生等内容。8. 印顺法师《华雨集（四）》及《杂阿含经论会编》。前者强调善恶业果的自力责任，后者说明佛法不赞同把一切感受简单归为宿业。9. 圣严法师《学佛群疑·如何了解三世因果》。强调把握当下行为，而非沉迷追问前世。10. “欲知前世因，今生受者是；欲知来世果，今生作者是”为汉地后世广泛流传的劝善偈，现有文献依据不足以直接标作早期佛经原句。

#part[第六部：末法与人间——现代人如何重新理解佛教]
= 第十九章　从人生佛教到人间佛教
<第十九章-从人生佛教到人间佛教>
#figure([
#box(image("chapters/../images/downloaded/ch19_taixu.jpg", width: 60.0%))
], caption: figure.caption(
position: bottom, 
[
太虚大师（1890---1947）法相
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


清晨，寺院的山门刚刚打开。有人走进大殿，点一炷香，求家人平安；有人在佛像前久久不语，只想暂时躲开生活中的烦恼；也有人望着殿中的出家人，心里生出一个疑问：

佛教讲放下、出离和涅槃，是不是意味着离开现实，远离社会，什么都不再关心？这个疑问并不是今天才有。二十世纪初的中国，社会剧烈动荡，旧有秩序逐渐瓦解，西方科学、教育与政治思想大量传入。寺院也面临前所未有的压力：有人把佛教看成迷信，有人认为僧人只会经忏度亡，还有人批评佛教只谈来世、不问现实。

就在这样的时代里，一位年轻僧人站了出来。1913年，在敬安和尚追悼会上，太虚大师提出“教理革命、教制革命、教产革命”，希望佛教摆脱积弊，重建僧团教育，恢复大乘佛教自利利他的精神。此后，他创办佛学院、组织佛教团体、出版刊物，并多次阐述一种新的佛教方向------人生佛教。

他并不是要把佛教改造成一种时髦的新思想，而是要重新回答一个古老而现实的问题：

佛法究竟应当怎样活在人间？

#horizontalrule

== 一、“看破红尘”，是不是佛教的全部？
<一看破红尘是不是佛教的全部>
在许多人的印象中，佛教似乎总与“看破红尘”联系在一起。一个人遭遇失恋、破产或者事业挫折，旁人可能会说：“想开一点，不如看破红尘。”影视作品里的出家人，也常常是在遭逢重大变故后，万念俱灰，遁入空门。久而久之，佛教便被描绘成一条逃离人生的道路：现实太苦，所以不再面对；世事太乱，所以退到深山；感情令人受伤，所以不再爱任何人。

但这并不是佛陀教法的本意。佛教所说的“出离”，首先是出离贪、嗔、痴的支配，而不只是离开家庭与社会。一个人即使住在深山之中，心里仍然充满欲望、怨恨和分别，也不能算真正出离；另一个人虽然生活在人群中，却能减少自私，保持清醒，帮助他人，同样可以实践佛法。

所谓“红尘”，真正需要看破的，不是人间本身，而是我们对于人间的错误执著。看破无常，不是厌恶生命，而是知道一切都会改变，因此更懂得珍惜。看破名利，不是拒绝工作，而是不让财富和地位决定自己的全部价值。看破感情中的占有，不是不再关心他人，而是学习以更少控制、更少伤害的方式去爱。

佛教并不是叫人从生活中退场，而是希望人不再被生活中的贪欲、恐惧和愤怒牵着走。

#horizontalrule

== 二、佛教为什么必须面对现代社会？
<二佛教为什么必须面对现代社会>
佛教传入中国以后，经历了两千年的发展。隋唐时期，佛教宗派兴盛，译经、讲学、造像和寺院制度都达到高峰。到了近代，中国社会的政治结构、经济制度和知识体系发生巨大变化，佛教原有的生存方式也受到冲击。当时一些寺院过度依赖经忏和超度维持生计，佛教在民众眼中，逐渐与死亡、鬼神和来世紧密联系。佛教中原本丰富的智慧、伦理、禅修和菩萨行，反而不容易被普通人看见。

与此同时，现代学校、医院、慈善机构和报刊出版逐渐发展起来。人们开始用新的标准追问佛教：

佛教能不能帮助活着的人？佛教能不能回应教育、贫困、战争和社会道德问题？佛教除了超度亡者，还能为现实世界做些什么？这些问题并不意味着佛法已经过时，反而迫使佛教重新发掘自身最根本的精神。佛陀成道以后，并没有永远独坐菩提树下，而是走向鹿野苑，开始四十余年的教化。他接触国王、商人、农夫、妇女、病人和贫穷者，也调解僧团纷争，教导弟子如何处理家庭、财富、友谊和社会关系。

佛陀虽然证悟了超越生死的智慧，却始终在人间行走。因此，近现代佛教所面对的，并不是一个全新的选择，而是一次回归：

回到佛陀在人间说法的本怀，回到大乘佛教悲智双运的菩萨道。

#horizontalrule

== 三、太虚大师：先把“人”做好，再走向佛道
<三太虚大师先把人做好再走向佛道>
太虚大师是近代中国佛教改革最重要的倡导者之一。他所面对的佛教，一方面保存着浩瀚的经论和修行传统，另一方面也积累了制度松弛、教育不足、寺产私有化和过度依赖经忏等问题。因此，太虚提出三方面的改革。第一是教理革命，纠正佛教被鬼神化、消极化的倾向，重新彰显大乘佛教自利利他的精神。

第二是教制革命，改革僧团组织和教育制度，培养真正能够修行、讲学与服务社会的僧才。第三是教产革命，使寺院财产服务于僧团教育、弘法和社会公益，而不成为少数人的私产。太虚认为，其中又以僧制改革和人才培养最为根本。没有具备正见、戒行与现代知识的僧才，再好的制度也难以长期维持。

太虚后来把自己的思想逐渐概括为“人生佛教”。这里的“人生”，并不是追求享乐的人生，也不是把佛教降低为一般的处世哲学，而是强调：成佛的道路，要从现实的人生开始。一个人不能一面幻想成佛，一面忽略最基本的人格。不能口中谈慈悲，却在家庭中刻薄伤人。

不能高谈空性，却没有责任感。不能盼望净土，却任由自己所在的环境变得污浊。因此，太虚特别重视五戒、十善、人格养成、僧伽教育与服务社会。他希望学佛者先成为一个诚实、有责任、能利益他人的人，再由完善人格而深入菩萨行，最终趋向佛果。太虚曾写下一首著名的偈颂：

#quote(block: true)[
仰止唯佛陀，
]

#quote(block: true)[
完就在人格；
]

#quote(block: true)[
人圆佛即成，
]

#quote(block: true)[
是名真现实。
]

后世常把第三句转述为“人成即佛成”。这句话通俗易记，也广为流传；但从原颂看，“人圆佛即成”更能准确表达太虚的意思：并不是普通人格一完成，就等于圆满成佛，而是以佛陀为究竟目标，从人格的净化和圆满起步，逐步修习菩萨道。这首偈的重点，不是把佛降低为普通人，而是把普通人的生命提升到可以不断觉悟、不断圆满的道路上。

“仰止唯佛陀”，说明学佛仍以佛陀的觉悟为最高目标。“完就在人格”，说明佛道不能离开现实的道德实践。“人圆佛即成”，说明成佛不是凭空发生，而是慈悲、智慧、戒行和愿力逐渐圆满的结果。人生佛教的核心，不是“只做人，不成佛”，而是“由人生而进趣佛道”。

#horizontalrule

== 四、入世，不等于沉溺世间
<四入世不等于沉溺世间>
人们常把“入世”与“出世”看成彼此矛盾的两条路。入世，似乎就是追逐功名、财富和权力；出世，则似乎必须抛弃一切现实事务。佛教却不这样理解。佛教所说的“出世”，是超越贪嗔痴和自我中心；所说的“入世”，则是以慈悲心进入众生的现实处境。如果一个人投身社会，却只是为了自己的名声、利益和控制欲，这不一定是菩萨行。

如果一个人内心追求清净，却对他人的痛苦无动于衷，也不是完整的大乘精神。真正的菩萨道，是以出世的智慧做入世的事业。因为知道一切因缘和合，所以不固执己见；因为体会无我，所以不只为自己打算；因为明白无常，所以不拖延行善；因为观见众生皆苦，所以愿意伸手帮助。

太虚强调现实人生，并不是鼓励佛教徒沉迷世俗，而是希望人们带着佛法的智慧进入现实。佛教参与教育，不是为了扩张权势，而是为了启发智慧。佛教从事慈善，不是为了炫耀功德，而是为了减轻具体的痛苦。佛教关心社会，不是为了争夺控制权，而是为了减少暴力、贪婪与仇恨。

因此，人生佛教不是对出世精神的否定，而是把出世精神落实到人间。

#horizontalrule

== 五、印顺法师：“佛在人间”
<五印顺法师佛在人间>
太虚之后，印顺法师进一步发展了“人间佛教”的思想。印顺阅读《阿含经》和各部律藏时，特别注意到早期佛教中真实、朴素而亲切的人间性。他引用《增一阿含经》的话：

#quote(block: true)[
诸佛皆出人间，终不在天上成佛也。
]

这句话并不是否认佛陀的伟大，而是提醒人们：释迦牟尼佛不是一位凭空降临、代替人决定命运的神。他在人间出生，在人间修行，在人间成道，也在人间教化众生。印顺认为，佛教长期发展以后，容易出现两种偏向。一种过度关注鬼与死亡，使佛教仿佛只是处理丧葬、超度和死后归宿的宗教。

另一种过度向往天神、神通和永生，使佛教逐渐被神秘化。为纠正这些偏向，他特别提出“人间”二字。人间不是佛法的障碍，而是修行的道场。人的生命有痛苦，也有反省痛苦的能力；有贪嗔痴，也有发展慈悲与智慧的可能。人既不像极端痛苦中的众生那样难以修行，也不像沉醉于享乐中的天人那样缺少出离心，因此最适合听闻佛法、发菩提心和实践菩萨道。

印顺所说的人间佛教，并不是简单地把佛教变成社会伦理。他更强调一种“人菩萨行”：

修行者仍是有烦恼的普通人，却愿意学习菩萨；不假装自己已经圆满，却从当下能够做到的事情开始；不等待拥有神通以后才度众生，而是在日常生活中学习布施、持戒、忍辱、精进、禅定和智慧。菩萨不是远离人群的神秘形象，而是愿意在众生中不断学习慈悲的人。

#horizontalrule

== 六、人间佛教的经典根据
<六人间佛教的经典根据>
“人生佛教”和“人间佛教”虽然是在近现代受到重视的名称，但它们并不是脱离经典而产生的新宗教。它们的思想根源，可以在早期佛教和大乘经典中找到。《增一阿含经》说：

#quote(block: true)[
诸佛世尊，皆出人间，非由天而得也。
]

这句话说明，佛陀的觉悟发生在人类现实生命之中。《维摩诘所说经》说：

#quote(block: true)[
若菩萨欲得净土，当净其心；随其心净，则佛土净。
]

净土不仅是遥远世界的庄严，也与人的心行有关。一个充满贪婪、欺骗和仇恨的社会，不可能仅靠建筑和财富成为净土；只有人的内心和行为逐渐净化，人与人的关系才可能改善。《六祖坛经》说：

#quote(block: true)[
佛法在世间，不离世间觉；
]

#quote(block: true)[
离世觅菩提，恰如求兔角。
]

觉悟不是在世间之外另找一个地方，而是要在面对工作、家庭、得失和人际关系时，看清自己的执著。佛教流传极广的一首偈颂又说：

#quote(block: true)[
诸恶莫作，众善奉行；
]

#quote(block: true)[
自净其意，是诸佛教。
]

这三句话同时包含三个层面。“诸恶莫作”，是约束伤害他人的行为。“众善奉行”，是主动实践利益众生的善行。“自净其意”，是净化自己的贪嗔痴。如果只讲“自净其意”，却不愿意行善，佛教容易变成只顾个人内心安宁的修行。如果只讲“众善奉行”，却不处理自己的贪欲和我执，行善也可能成为追求名声的工具。

佛法把行为、社会责任与内心净化连在一起，这正是人间佛教的经典基础。

#horizontalrule

== 七、赵朴初：让人间佛教成为现实方向
<七赵朴初让人间佛教成为现实方向>
在中国大陆，赵朴初居士对人间佛教的恢复与推广具有重要作用。二十世纪八十年代，中国佛教逐渐恢复。寺院需要重建，僧才需要培养，经典需要重新整理，佛教与现代社会的关系也需要重新说明。1983年，赵朴初在《中国佛教协会三十年》中提出，在当代中国佛教中，应当提倡人间佛教思想。他把人间佛教的基本内容概括为五戒、十善、四摄、六度等“自利利他的广大行愿”。

这里有两层内容。第一层是五戒、十善。它们帮助人建立基本的道德底线：不杀害、不偷盗、不邪淫、不妄语、不因酒精等使心智昏乱；同时减少贪欲、嗔恨和邪见。第二层是四摄、六度。四摄是布施、爱语、利行、同事，强调怎样与众生相处，怎样用别人能够接受的方式帮助他们。

六度是布施、持戒、忍辱、精进、禅定、般若，代表菩萨由自我净化走向利益众生的完整实践。因此，赵朴初所说的人间佛教，并不只是教人做一个守规矩的好人，而是以五戒十善为基础，进一步实践菩萨道。在赵朴初的推动下，人间佛教不再只是少数思想家的理论，而逐渐成为中国佛教处理自身建设、社会责任与现代转型的重要方向。

佛教由此不再只是寺院内部的修持，也包括文化教育、慈善救济、国际交流、社会伦理与和平事业。但无论事业怎样扩大，根本仍然不能离开戒、定、慧。否则，佛教可能有了许多社会活动，却失去了佛法的内在精神。

#horizontalrule

== 八、圣严法师：从心灵环保到人间净土
<八圣严法师从心灵环保到人间净土>
圣严法师常以“人间净土”说明佛法与现代生活的关系。他所说的人间净土，并不是要用人工方式在地球上复制佛经中种种宝树、楼阁和七宝池，而是从净化人的思想、生活和心灵开始，逐渐改善社会环境与自然环境。圣严法师说：

#quote(block: true)[
只要你的一念心净，此一念间，你便在净土。
]

这并不是说只要心情好，外部问题就不存在。面对战争、贫困、污染和不公，仅仅告诉受苦者“把心放下”，显然是不够的。佛教也不能以“万法唯心”为借口，回避现实责任。圣严法师强调的是：一切改善都必须从人的心念开始。一个制度由人建立，一个家庭由人共同生活，一次伤害往往从一个愤怒或贪婪的念头开始。如果人的内心毫无改变，即使外在条件短暂改善，新的冲突仍可能继续产生。

因此，他提出“心灵环保”。环境污染来自过度消费，过度消费背后是永不满足的欲望。网络暴力来自语言失控，语言失控背后是愤怒和偏见。家庭冲突来自彼此指责，指责背后常常是强烈的自我中心。净化环境，不能只清理垃圾，也要清理贪欲；改善社会，不能只制定规则，也要培养尊重；

建设净土，不能只等待理想世界出现，也要从自己的一念、一句话和一个行为开始。人间净土不是突然完成的宏伟工程，而是无数个人在具体生活中，减少一点伤害，增加一点清净。

#horizontalrule

== 九、星云大师：让佛法走进家家户户
<九星云大师让佛法走进家家户户>
星云大师从教育、文化、慈善和日常生活等方面，广泛实践人间佛教。他用非常通俗的话概括人间佛教：

#quote(block: true)[
佛说的、人要的、净化的、善美的，凡有助于幸福人生增进的教法，都是人间佛教。
]

“佛说的”，说明人间佛教必须以佛法为依据，不能为了迎合社会而随意改变根本教义。“人要的”，说明弘法应当回应人的真实需要，使佛法能够帮助人面对烦恼、家庭、工作和生死。“净化的”，说明佛法的作用不是纵容欲望，而是净化身口意。“善美的”，说明佛教应当为人生和社会带来慈悲、和谐与希望。

星云大师还提倡“给人信心、给人欢喜、给人希望、给人方便”，以及“做好事、说好话、存好心”。这些话看似浅白，却可以与传统佛法一一对应。做好事，是身业的净化；说好话，是口业的净化；存好心，是意业的净化。给人信心，不是盲目安慰，而是帮助别人看见改变的可能。

给人欢喜，不是讨好所有人，而是不以冷漠和傲慢伤害他人。给人希望，不是否认痛苦，而是在痛苦中提供方向。给人方便，不是没有原则，而是懂得根据不同人的处境，以适当方式帮助他。星云大师强调，人间佛教虽然“不舍世间”，修行者仍须保持出离心，以出世的思想从事入世的事业。慈善、教育与文化如果脱离了无我、持戒和般若，也可能变成另一种名利事业。

人间佛教的“人间”，不是纵情世间；它的“佛教”，也不能在热闹事业中被遗忘。

#horizontalrule

== 十、几位近现代大德，所说的是同一件事吗？
<十几位近现代大德所说的是同一件事吗>
太虚、印顺、赵朴初、圣严和星云，都重视佛法在人间的实践，但各自侧重点并不完全相同。太虚面对的是近代中国佛教的制度危机。他以人生佛教为纲领，重视僧团改革、佛教教育和人格建设，希望由人生进趣佛道。印顺更重视佛教思想的辨析。他强调“佛在人间”，反对佛教过度鬼神化和天神化，提倡以人菩萨行为实践核心。

赵朴初面对的是中国大陆佛教的恢复与重建。他把人间佛教落实为五戒、十善、四摄、六度，并推动佛教与现代社会相适应。圣严以“心灵环保”和“人间净土”为特色，强调从个人心念的净化，逐步走向社会和环境的净化。星云则以生活化、文化化和国际化的方式传播人间佛教，使佛法进入家庭、学校、社区和公共文化。

他们不是在创造五种彼此无关的佛教，而是在不同历史环境中，回答同一个问题：

怎样既不失去佛法的解脱精神，又能利益现实中的众生？他们共同反对两种极端。一种极端，是只谈出世，不问人间，把佛教缩小为个人逃避痛苦的方法。另一种极端，是只谈社会服务，不修戒定慧，把佛教变成普通的慈善机构或伦理学说。完整的人间佛教，需要把两者结合起来：

以内心觉悟为根本，以利益众生为实践；以出离心摆脱贪著，以菩提心承担责任；以般若智慧看破执著，以慈悲愿行进入人间。

#horizontalrule

== 十一、常见误解：佛教是不是消极避世？
<十一常见误解佛教是不是消极避世>
=== 1. 佛教讲“苦”，是不是否定人生？
<佛教讲苦是不是否定人生>
佛教说苦，不是说人生毫无价值，而是诚实指出：衰老、疾病、离别、求不得和内心不安，都是生命中无法完全回避的经验。医生指出病情，并不是悲观；真正的悲观，是认为病无可救药。佛陀说明苦，同时也说明苦的原因、苦的止息与通向止息的道路。四圣谛不仅有“苦谛”，也有“灭谛”和“道谛”。

佛教不是停留在“人生很苦”，而是在追问：

苦从哪里来？哪些痛苦可以减少？怎样不再反复制造同样的痛苦？这种面对现实的态度，不是消极，而是清醒。

=== 2. 出家是不是逃避责任？
<出家是不是逃避责任>
有人确实可能因为挫折而产生出家的念头，但真正的出家并不是逃避责任，而是承担另一种更严格的责任。出家人要遵守戒律，接受僧团约束，放弃许多个人享受，并承担修学和住持佛法的责任。离开一种生活，并不自动等于逃避；关键在于离开的动机是什么，离开以后又承担了什么。

同样，在家生活也不必然代表积极入世。一个人虽然有工作、家庭和社会身份，却只关心个人利益，也可能是在逃避更深的生命责任。佛教判断一个人是否真正精进，不只看他住在寺院还是城市，而要看他的贪嗔痴是否减少，慈悲和智慧是否增长。

=== 3. 佛教是不是只关心来世？
<佛教是不是只关心来世>
佛教承认生命与行为具有长远影响，但并不因此忽略今生。五戒首先保护的就是现实生活中的生命、财产、家庭关系、社会信任与心智清醒。十善要求人改善当下的身口意。四摄教人怎样与现实中的他人建立善缘。六度更是在具体处境中修习布施、忍辱和智慧。佛教谈来世，是提醒人不要只顾眼前利益；佛教重视当下，则是因为未来正由当下的行为形成。

真正的因果观，不是把希望全部推给来世，而是对现在的每一个选择负责。

=== 4. 人间佛教是不是只做慈善？
<人间佛教是不是只做慈善>
慈善是人间佛教的重要实践，却不是全部。布施若没有智慧，可能使受助者形成依赖；公益若没有戒律，可能夹杂名利和权力；服务社会若没有禅定与反省，参与者也可能在忙碌中充满烦恼。佛教的特色，不只是帮助外在的贫困，也要认识造成痛苦的贪嗔痴。因此，人间佛教既要“众善奉行”，也要“自净其意”。

=== 5. 人间佛教是不是把佛教世俗化？
<人间佛教是不是把佛教世俗化>
“世俗化”可以有两种完全不同的含义。一种是让深奥佛法能够用现代语言表达，使普通人在现实生活中实践。这是契机，是佛教历来弘传必须进行的工作。另一种是为了迎合欲望，放弃戒律、解脱和成佛的目标，把佛教变成成功学、情绪安慰或商业文化。这便失去了佛法的根本。

人间佛教不是把佛法降低到世俗欲望，而是用佛法提升现实人生。它不是告诉人怎样得到更多名利，而是教人怎样不被名利奴役；不是保证人生永远顺利，而是帮助人在无常中保持清醒；不是鼓励执著现世，而是在现世中修习超越执著的智慧。

#horizontalrule

== 十二、普通人怎样实践人间佛教？
<十二普通人怎样实践人间佛教>
人间佛教不只属于高僧，也不只体现在大型慈善、学校和文化事业中。普通人每天都可以实践。在家庭里，少一句刻薄的话，多一次耐心倾听，是爱语。面对父母年老时，愿意照顾而不只是抱怨，是报恩。教育孩子时，不把自己的焦虑和虚荣强加给他，是慈悲。在工作中，不欺骗客户，不侵占公共利益，是持戒。

同事犯错时，不急于羞辱，而是帮助解决问题，是利行。自己取得成绩时，知道其中包含许多人的帮助，是缘起观。在网络上，不随意传播未经证实的消息，是不妄语。看到不同意见时，不立刻辱骂，是忍辱。使用消费品时，减少浪费，尊重自然环境，是对众生和未来负责。

遭遇挫折时，先观察自己的情绪，不让愤怒马上变成伤人的语言，是正念。这些事情并不神秘，却比谈论玄妙境界更能检验一个人是否真正学佛。人间佛教不是要求每个人都做惊天动地的大事，而是让佛法进入每一个普通选择。一个人少制造一点恐惧，周围就多一分安定；

少制造一点欺骗，社会就多一分信任；少制造一点仇恨，人间就多一分清凉。净土并不一定从远方开始。它可能就从一句不再伤人的话开始。

#horizontalrule

== 小栏目：人生佛教与人间佛教有什么区别？
<小栏目人生佛教与人间佛教有什么区别>
“人生佛教”主要与太虚大师的思想联系在一起，强调从现实人生出发，改善人格，建立人乘善行，并进一步修习菩萨道、趋向成佛。“人间佛教”则在印顺、赵朴初、圣严、星云等人的思想与实践中得到不同发展，更突出佛在人间、修行在人间、净化人间和利益人间。二者并不是互相排斥的两个宗派。

简单来说：

人生佛教强调“从怎样的人生走向佛道”；人间佛教强调“佛法怎样在人间落实”。前者以人生为起点，后者以人间为道场。二者共同反对佛教被片面理解为只重死亡、鬼神和来世，也共同强调佛法不能离开戒定慧、菩提心与解脱目标。

#horizontalrule

== 小栏目：“人成即佛成”是不是说做好人就等于成佛？
<小栏目人成即佛成是不是说做好人就等于成佛>
不是。做好人是学佛的重要基础，却不等于已经成佛。一个诚实、善良、有责任感的人，具备修行所需要的良好人格；但佛陀还圆满了深广的智慧、慈悲、福德和觉悟。太虚原颂作“人圆佛即成”，强调人格、菩萨行与佛果逐步圆满的关系。因此，“人成即佛成”更适合作为通俗的勉励：

学佛不能跳过做人。它不能被理解为：

只要遵守一般社会道德，便已经达到佛陀的觉悟。

#horizontalrule

== 小栏目：人间佛教是不是只适合在家人？
<小栏目人间佛教是不是只适合在家人>
不是。在家人可以在家庭、职业和社会关系中实践五戒、十善、四摄和六度。出家人则要通过持戒、禅修、讲学、教育和弘法，为社会保存并传递佛法。两者承担的方式不同，却都能实践人间佛教。在家人不能因为强调入世，就忽视内心修行；出家人也不能因为重视出世，就远离众生疾苦。

佛教的完整发展，需要出家与在家四众弟子彼此支持。

#horizontalrule

== 十三、人间佛教仍然需要警惕什么？
<十三人间佛教仍然需要警惕什么>
人间佛教回应了现代社会，却也面临新的风险。第一，是把佛教变成励志成功学。佛法可以帮助人平静、专注和改善关系，却不是保证升职、发财、事事如愿的工具。若只宣传“正能量”，却避开苦、无常、无我与生死问题，佛教便会失去深度。第二，是以社会事业代替个人修行。

寺院可以办教育、文化和公益事业，但参与者仍要反省自己的发心。事业越大，越需要戒律、制度与无我精神，否则也可能产生权力、金钱和名声的执著。第三，是为了现代化而随意解释经典。契机不是迎合，创新也不能离开契理。人间佛教首先仍然是佛教，必须以三宝、四圣谛、八正道、缘起、戒定慧和菩萨行为根本。

第四，是只强调人类利益，忽略其他生命。佛教的慈悲对象不只包括人。现代人间佛教还应关心动物、生态环境和未来世代。人间是修行的中心场域，却不是人类可以任意占有的世界。第五，是在忙碌中失去清净。社会参与越多，越需要禅修和独处；言论越多，越需要正语；组织越庞大，越需要谦卑。

真正的人间佛教，不是用忙碌掩盖内心的空虚，而是在清净心中生起承担，在承担中不断照见自己的执著。

#horizontalrule

== 十四、出世与入世，是一条完整的路
<十四出世与入世是一条完整的路>
佛教确实有出世的一面。它要人看见生老病死，认识欲望不能带来究竟满足，最终超越无明和生死轮回。佛教也确实有入世的一面。佛陀成道后没有抛弃众生，菩萨也不因世间污浊而拒绝进入世间。如果没有出世的智慧，入世容易变成新的争夺；如果没有入世的慈悲，出世容易变成个人的冷漠。

佛教最可贵的地方，正是在两者之间保持中道：

看破，却不冷漠；放下，却不放弃责任；出离，却不舍众生；寂静，却仍然行动。太虚大师希望人由完善人格而进趣佛道。印顺法师提醒人们，佛在人间成道。赵朴初把五戒、十善、四摄、六度落实为当代佛教方向。圣严法师从一念心净谈到人间净土。星云大师则努力让佛法走进家家户户。

他们共同说明了一件事：

佛教所要离开的，不是人间，而是使人间充满痛苦的贪、嗔、痴。佛教所要建设的，也不只是外在的繁荣，而是一个更清醒、更慈悲、更少伤害的世界。

#horizontalrule

== 本章小结
<本章小结-2>
近现代中国社会的剧烈变化，使佛教必须重新说明自身与现实人生的关系。太虚大师提出人生佛教，以佛陀为究竟目标，以人格完善为现实起点，并从教理、制度与寺产等方面推动佛教改革。印顺法师进一步强调“佛在人间”，主张以人类为本位，实践真实而平实的人菩萨行。

赵朴初把五戒、十善、四摄、六度等自利利他的广大行愿，确立为当代人间佛教的重要内容。圣严法师以心灵环保和人间净土说明：净化社会，应从净化人的心念和行为开始。星云大师则以生活化、文化化和公益实践，使人间佛教进入普通人的日常生活。人间佛教不是否定出世解脱，也不是把佛教简化为慈善和道德教育。

它所强调的是：

以出世的智慧，做入世的事业；以清净自己的心，改善人与人的关系；以成佛为长远方向，从当下能够做到的善行开始。佛教并不叫人逃离现实。它希望人看清现实以后，仍然愿意温柔而坚定地生活在人间。

#horizontalrule

== 佛教常识：本章关键词
<佛教常识本章关键词>
=== 人生佛教
<人生佛教>
太虚大师倡导的重要思想。强调以现实人生为起点，完善人格，修习五戒十善，并由人乘善行进一步进入菩萨道。

=== 人间佛教
<人间佛教>
近现代汉传佛教的重要发展方向。强调佛法以人为主要教化对象，在现实人间修行并利益众生，同时保持解脱、成佛和菩萨道的宗教目标。

=== 人菩萨行
<人菩萨行>
印顺法师特别重视的菩萨实践方式。修行者以普通人的身份发菩提心，不追求神秘化和速成，在现实生活中逐步实践慈悲与智慧。

=== 心灵环保
<心灵环保>
圣严法师倡导的现代佛教理念。通过减少内心的贪欲、嗔恨、嫉妒和傲慢，改善个人生活、社会关系与自然环境。

=== 人间净土
<人间净土>
不是简单把经典中的净土景象搬到现实世界，而是通过净化身心、改善社会、保护环境，使现实人间逐渐减少痛苦与污染。

=== 四摄
<四摄>
布施、爱语、利行、同事。是菩萨亲近众生、帮助众生的四种方法。

=== 六度
<六度>
布施、持戒、忍辱、精进、禅定、般若。是大乘菩萨道的核心实践。

#horizontalrule

== 本章经典原文选读
<本章经典原文选读>
=== 一、《增一阿含经》
<一增一阿含经>
#quote(block: true)[
诸佛世尊，皆出人间，非由天而得也。
]

大意是：佛陀在人间修行成道，而不是依靠天神身份自然成为佛。它提醒人们重视人身的修行价值。

=== 二、《维摩诘所说经·佛国品》
<二维摩诘所说经佛国品>
#quote(block: true)[
若菩萨欲得净土，当净其心；随其心净，则佛土净。
]

大意是：菩萨要建设清净国土，必须先净化自己的心。内心清净还要表现为清净的行为，由此影响家庭、社会和环境。

=== 三、《六祖坛经》
<三六祖坛经>
#quote(block: true)[
佛法在世间，不离世间觉；
]

#quote(block: true)[
离世觅菩提，恰如求兔角。
]

大意是：觉悟不能离开现实生活。若逃避一切现实处境，另外寻找菩提，就像寻找兔子的角一样不切实际。

=== 四、诸佛通诫偈
<四诸佛通诫偈>
#quote(block: true)[
诸恶莫作，众善奉行；
]

#quote(block: true)[
自净其意，是诸佛教。
]

大意是：停止恶行、积极行善、净化内心，三者共同构成佛教修行的基本方向。

=== 五、太虚大师《即人成佛的真现实论》
<五太虚大师即人成佛的真现实论>
#quote(block: true)[
仰止唯佛陀，完就在人格；
]

#quote(block: true)[
人圆佛即成，是名真现实。
]

大意是：以佛陀为最高理想，从现实人格的完善开始，逐渐圆满菩萨行与佛果。后世常见“完成在人格，人成即佛成”的转述版本。

#horizontalrule

== 主要参考资料
<主要参考资料-1>
+ 太虚：《即人成佛的真现实论》《整理僧伽制度论》《佛教革新方案》《志行之自述》等。

+ 印顺：《佛在人间》《契理契机之人间佛教》《人间佛教要略》等。

+ 赵朴初：《佛教常识答问》《中国佛教协会三十年》。

+ 圣严：《净土在人间》及有关“心灵环保”“人间净土”的相关讲演。

+ 星云：《人间佛教佛陀本怀》《人间佛教当代问题座谈会》及相关讲演。

+ 《增一阿含经》《维摩诘所说经》《六祖坛经》等佛教经典。

= 第二十章　把佛教带回生活
<第二十章-把佛教带回生活>
#figure([
#box(image("chapters/../images/downloaded/ch20_ryoanji.jpg", width: 80.0%))
], caption: figure.caption(
position: bottom, 
[
龙安寺枯山水石庭，日本京都
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#quote(block: true)[
诸恶莫作，众善奉行，自净其意，是诸佛教。
]

== 引子：佛法最终要走进一个人的日常
<引子佛法最终要走进一个人的日常>
清晨，手机闹铃响起。一个普通人睁开眼睛，首先看到的不是窗外的阳光，而是屏幕上不断跳出的消息：工作群里有人催问进度，新闻推送着新的冲突和灾难，朋友晒出了更大的房子、更远的旅行和更成功的人生。还没有起床，他的心已经被拉向许多地方。到了公司，他担心落后，害怕被否定；回到家里，他可能因为一句无心的话与亲人争执；夜深以后，他又想起父母渐老、孩子成长、身体衰退，以及某些再也无法挽回的人和事。

现代人的生活，和两千多年前恒河流域的人当然不同。我们有高楼、网络、飞机和人工智能，佛陀时代的人没有这些。然而，隐藏在烦恼背后的心，却并没有发生根本变化。我们仍然希望喜欢的事物永远不变，希望不喜欢的事物尽快消失；仍然容易把一次失败理解为“我这一生都失败了”，把一句批评理解为“别人完全否定了我”；仍然会因为得到而害怕失去，因为失去而追问为什么偏偏是自己。

时代变了，贪、瞋、痴的表现形式变了，但人面对得失、爱憎、生死时的困惑并没有消失。因此，佛教两千多年的历史，不能只停留在鹿野苑的第一次说法、长安城里的译经院、寺庙中的佛像和藏经楼里的经卷。佛法若不能进入一顿饭、一场争执、一次失败、一段关系和一个普通人的内心，它就仍然只是被陈列的知识。

《六祖坛经》说：

#quote(block: true)[
“佛法在世间，不离世间觉；离世觅菩提，恰如求兔角。”
]

真正的修行，不是等到生活中的问题全部消失以后才开始。恰恰相反，疾病、工作、家庭、衰老、误解和失去，正是我们认识无常、练习慈悲、学习放下和生起智慧的地方。这一章不再讲一位遥远的佛陀、一位西行的高僧或一位传奇祖师。这一章的主人公，就是正在生活中的每一个普通人。

#horizontalrule

== 一、佛法不是让生活消失，而是让人看清生活
<一佛法不是让生活消失而是让人看清生活>
有人以为，佛教追求的是远离人群、远离欲望、远离一切现实事务。仿佛只有住进深山古寺，放下工作和家庭，才算真正修行。但佛陀所教导的八正道，并不只属于禅堂。正见，是在纷乱的信息中辨别事实与情绪；正语，是在愤怒时不以恶言继续伤害；正业，是在利益面前守住不伤害他人的底线；正命，是不以损害众生的方式谋取生活；正念，是知道自己此刻在想什么、说什么、做什么；正定，是不让心永远被外境牵着奔跑。

这些都发生在现实生活之中。佛教并不要求人人出家。出家是一种完整而严格的修行生活，在家人则可以在家庭、职业和社会关系中学习五戒、十善、布施、忍辱和智慧。两者生活方式不同，但都要面对自己的贪、瞋、痴。佛教常用一句极其简洁的话概括全部教法：

#quote(block: true)[
“诸恶莫作，诸善奉行，自净其意，是诸佛教。”
]

这四句话包含了三个层次。第一是“诸恶莫作”：不因为愤怒、贪婪和恐惧，去伤害别人，也不继续伤害自己。第二是“诸善奉行”：佛教不只是不做坏事，还要主动行善。看见别人困难时愿意帮助，在关系中愿意倾听，在职责面前愿意承担，这些都是修行。第三是“自净其意”：外在行为固然重要，但佛教最终还要回到心。一个人即使表面行善，如果内心充满傲慢、嫉妒和对回报的要求，烦恼仍然会继续生长。

因此，佛法不是要求人逃离生活，而是训练我们在生活中少制造一点伤害，多成就一点善意，并逐渐看清自己的心。寺院可以帮助人安静，经典可以帮助人明理，仪式可以提醒人恭敬，但真正检验修行的地方，往往是离开寺院以后：

被误解时，我们怎样说话？利益冲突时，我们怎样选择？亲人衰老时，我们怎样陪伴？事情无法挽回时，我们怎样安顿自己的心？这些问题，才是佛法走入生活之后真正面对的功课。

#horizontalrule

== 二、无常：不是坏消息，而是世界原本的样子
<二无常不是坏消息而是世界原本的样子>
佛教所说的“无常”，常被误解为一种消极的叹息。有人听到无常，想到的是花会凋谢、人会衰老、关系会结束，于是觉得佛教总在提醒人失去和死亡。但无常首先不是一种情绪，也不是一句劝人悲观的话。它只是对现实的观察：凡是由条件聚合而成的事物，都会随着条件变化而变化。

身体会变化，情绪会变化，社会会变化，财富和名声会变化，人与人的关系也会变化。《佛遗教经》说：

#quote(block: true)[
“一切世间动不动法，皆是败坏不安之相。”
]

这里的“败坏”，不是说世界毫无价值，而是说一切有为法都不能永远保持原状。

=== 1. 人为什么会被无常伤害？
<人为什么会被无常伤害>
变化本身未必就是痛苦。真正让人痛苦的，往往是我们要求变化的事物不要变化。孩子长大，本是自然过程，父母却可能因为不愿接受孩子独立而痛苦；一段关系出现变化，本来有许多复杂因缘，我们却坚持对方必须永远按照过去的方式爱自己；身体衰老是生命规律，我们却把每一根白发都看成对自我价值的否定。

我们常常不是败给变化，而是败给“它不应该变化”的执着。无常告诉我们：世界没有违背承诺，因为世界从来没有承诺一切永远不变。

=== 2. 无常也意味着，痛苦不会永远固定
<无常也意味着痛苦不会永远固定>
如果一切都是永恒不变的，那么疾病无法治疗，坏习惯无法改变，失败也永远无法翻身。正因为无常，种子才能发芽，伤口才能愈合，误解才有机会解释，一个曾经暴躁的人也可能学会温和。无常不仅带走我们喜欢的事物，也会带走不喜欢的处境。所以，无常并非只意味着“终将失去”，也意味着“仍有可能”。

佛教的因缘观认为，一件事情不是无缘无故出现的，也不是由单一力量决定的。条件改变，结果就可能改变。承认无常，不是叫人放弃努力，恰恰是提醒人：正因为未来尚未固定，现在的选择才有意义。

=== 3. 看见无常，才能真正珍惜
<看见无常才能真正珍惜>
人常常在失去之后才明白珍惜。父母在身边时，我们嫌他们唠叨；孩子依赖我们时，我们觉得疲惫；身体健康时，我们习惯熬夜和透支；一段平静的生活持续太久，我们便误以为这一切理所当然。无常观不是要人整日想着死亡，而是要人醒来。知道相聚不会永远持续，所以今天的一顿饭值得认真吃；知道父母终会老去，所以一句关心不必等到以后；知道身体并不坚固，所以应当适当休息和照顾；知道自己也会犯错，所以不必永远揪住别人的过失。

真正理解无常的人，不会因此冷漠，反而更懂得珍惜。

=== 4. 面对失去，无常不要求人立刻平静
<面对失去无常不要求人立刻平静>
亲人去世、关系结束、事业受挫时，告诉一个正在悲伤的人“这都是无常”，有时并不是智慧，而是一种缺少体谅的说教。佛教承认爱别离苦，也承认人的悲伤需要时间。理解无常，不等于压抑眼泪，更不是要求自己立刻想通。它只是让我们在悲伤中逐渐明白：失去是生命的一部分，而悲伤也是因缘所生的过程。它会到来，也会变化。

我们可以怀念，可以流泪，可以保存一份深厚的感情，但不必要求已经过去的事情重新变回从前。对逝去的人，真正的放下不是遗忘，而是把“我一定要留住你”，慢慢转化成“谢谢你曾经来过”。

#horizontalrule

== 三、慈悲：不是软弱，而是不再增加痛苦
<三慈悲不是软弱而是不再增加痛苦>
“慈悲”是佛教中最常被提起，也最容易被误解的词语之一。有些人把慈悲理解为性格温和、不与人争；有些人认为慈悲就是无条件答应别人的要求；还有人担心，一个人太慈悲，就会被欺负、被利用。佛教所说的慈悲，比一般意义上的“心软”更深。《大智度论》解释：

#quote(block: true)[
“慈名爱念众生，常求安隐乐事以饶益之；悲名愍念众生受种种身苦、心苦。”
]

“慈”是希望众生得到安乐，“悲”是看见众生的痛苦，并愿意帮助他们离苦。慈悲不是一种软弱的情绪，而是一种面对痛苦的能力。

=== 1. 慈悲首先是看见
<慈悲首先是看见>
许多伤害并不是因为人天生残忍，而是因为没有真正看见别人。父母只看见孩子成绩下降，却没有看见他的恐惧；伴侣只听见对方语气不好，却没有看见他一天积累的疲惫；管理者只看见员工犯错，却没有看见制度中长期存在的问题。慈悲的第一步，是暂时放下“我受到了怎样的冒犯”，看一看对方正在经历什么。

这并不表示对方一定正确，也不表示我们必须接受所有行为。只是当一个人看见得更多，他的反应便不必完全由愤怒支配。

=== 2. 慈悲不等于纵容
<慈悲不等于纵容>
一个人沉迷赌博，家人不断替他还债，这未必是慈悲；孩子犯错，父母因为不忍心而取消所有后果，也未必真正帮助了孩子；面对持续的欺骗和暴力，一味忍耐，甚至可能让伤害继续扩大。慈悲的目标是减少痛苦，而不是维持表面的和气。有时慈悲表现为安慰，有时表现为制止；有时是陪伴，有时是明确地说“不”；有时要给人第二次机会，有时则必须建立边界。

阻止一个人继续伤害别人，也是在阻止他继续造作恶业。从这个意义上说，坚定并不违背慈悲。真正的慈悲必须与智慧相伴。只有情感而没有智慧，可能变成溺爱和纠缠；只有判断而没有慈悲，又可能变成冷酷和傲慢。《维摩诘经》提醒，若慈悲中夹杂强烈的占有、分别和自我要求，就会成为“爱见悲”，久而久之容易疲惫和厌倦。

例如，我们帮助别人，却要求对方必须按照自己的意见生活；付出很多，却期待对方永远感激；一旦对方没有改变，便觉得自己的善意全被辜负。这种帮助表面上是为对方，实际上也夹杂着“事情必须符合我的期待”。有智慧的慈悲，是尽力而为，却承认每个人都有自己的因缘；愿意伸手帮助，却不把自己幻想成能够拯救所有人的人。

=== 3. 慈悲也包括对自己
<慈悲也包括对自己>
有些人对别人宽容，对自己却极其苛刻。一次失误，便反复责骂自己；工作没有达到预期，就认为自己毫无价值；看到别人成功，便觉得自己的生活一无是处。这种持续的自我攻击，并不能让人真正进步。它只会让心越来越疲惫。对自己慈悲，不是为错误找借口，也不是放任懒惰，而是承认：我会受伤，会疲倦，会受限，也会犯错。

我们可以承担责任，但不必把一次错误扩大成对整个人格的否定；可以努力改善，却不必靠羞辱自己获得动力。佛教讲“众生”，自己也在众生之中。一个连自己的痛苦都不敢看见的人，很难长久地理解别人的痛苦。适当休息、寻求帮助、承认能力有限，并不自私。有严重身心困扰时，接受必要的医疗和心理专业支持，也不违背佛法。

慈悲不是要求一个人永远独自承受，而是让痛苦得到如实而恰当的照顾。

#horizontalrule

== 四、放下：不是放弃，而是不再被执着捆绑
<四放下不是放弃而是不再被执着捆绑>
在佛教词语中，“放下”大概是被使用得最广，也最容易被说得轻巧的一个。别人失恋了，我们说：“放下吧。”别人遭受不公，我们说：“不要计较。”别人失去亲人，我们也说：“看开一点。”可是，真正的放下从来不是一句轻飘飘的劝告。

=== 1. 放下的不是责任，而是执着
<放下的不是责任而是执着>
《金刚经》说：

#quote(block: true)[
“应无所住而生其心。”
]

这句话不能只读前半句。“无所住”，是心不被名声、利益、成败、爱憎和固定观念牢牢绑住；“生其心”，则是仍然生起布施心、慈悲心、责任心和菩提心。如果只有“无所住”而没有“生其心”，人可能落入什么都不在乎的冷漠；如果只有“生其心”而处处执着，善行又可能变成新的负担。

真正的放下，是认真做事，但不把自己全部交给结果；真诚爱一个人，但不把爱变成占有；承担应有责任，但不把无法控制的部分也背在身上。《维摩诘经》说，菩萨“虽行于空，而植众德本”。理解空，并不妨碍修善；不执着，反而使人能够更自由、更长久地行动。

=== 2. 放下之前，往往要先提起
<放下之前往往要先提起>
该道歉的没有道歉，却说自己已经放下；该偿还的责任没有承担，却说一切随缘；问题明明可以解决，却用“看破”来掩饰逃避，这些都不是佛教所说的放下。放下之前，常常要先把责任提起来。圣严法师把面对困境的过程概括为：

#quote(block: true)[
“面对它、接受它、处理它、放下它。”
]

这四个步骤有清楚的次序。“面对它”，是不否认事情已经发生。“接受它”，不是认同伤害，也不是向命运投降，而是承认当下事实确实如此。只有承认事实，人才可能采取有效行动。“处理它”，是尽自己的能力解决问题、承担责任、寻求帮助。“放下它”，则是在已经尽力之后，不再让事情在心中一遍又一遍重演。

许多人不是没有处理问题，而是在问题结束以后，仍然每天重新审判自己和别人。事情在外部已经过去，在心里却反复发生。放下，就是不再用今天的生命，一遍又一遍惩罚过去的自己。

=== 3. 放下不等于没有感情
<放下不等于没有感情>
真正放下一段关系，并不表示从此毫无怀念；放下亲人的离世，也不表示抹掉共同生活的记忆。放下不是强迫自己“不准再想”，而是即使想起，也不再被过去完全带走。一个人仍然可以记得，但不必继续纠缠；仍然可以感恩，却不再要求时光倒流；仍然可以悲伤，但也允许自己重新生活。

佛教并不是把人训练成没有情感的石头，而是让情感不再演变成永无止境的执取。

=== 4. 该放下什么？
<该放下什么>
需要放下的，往往不是一件具体事物，而是心中那个僵硬的要求：

“别人必须理解我。”“我不能失败。”“我的孩子必须成为我期待的样子。”“付出了就一定要得到回报。”“过去如果不同，我现在一定会幸福。”这些想法之所以带来巨大痛苦，是因为它们把复杂而变化的世界，变成了一个必须服从自我意愿的世界。放下，不是说我们不能有愿望，而是不把愿望变成命令世界的圣旨。

可以努力争取，但也有能力面对结果；可以珍惜拥有，却明白拥有并非永恒；可以为正义发声，却不让仇恨吞没自己。这才是“提得起，也放得下”。

#horizontalrule

== 五、正念：把散落在各处的心带回来
<五正念把散落在各处的心带回来>
现代社会常常谈论“正念”。有人把它理解成一种放松方法，有人用它提高注意力，也有人以为正念就是让头脑一片空白。佛教所说的正念，并不是不思考，也不是追求某种始终平静的状态。正念是清楚地知道：此刻身上发生了什么，心中生起了什么，我们正在做什么，以及这些身心活动将带来怎样的后果。

《中阿含经·念处经》讲四念处，要求修行者观察身、受、心、法，并说：

#quote(block: true)[
“行则知行，住则知住，坐则知坐，卧则知卧……行住坐卧、眠寤语默，皆正知之。”
]

这不是要人变得迟缓，而是让人从自动反应中醒来。

=== 1. 在情绪与行动之间，留出一点空间
<在情绪与行动之间留出一点空间>
愤怒升起时，普通的反应往往很快。一条令人不快的消息出现，手指立即打出恶言；孩子顶嘴，父母立刻提高音量；在网络上看见不同意见，马上把对方归入某种可憎的群体。正念不是要求愤怒不能出现，而是让我们知道：

“现在，愤怒正在升起。”仅仅这一点觉察，就可能在情绪与行动之间留出一道缝隙。我们可以感觉到呼吸变急、肩膀紧绷、心中不断组织攻击性的语言。然后问自己：我接下来这句话，是在解决问题，还是只想让对方也痛苦？正念不能保证每一次都做出完美选择，但它让人不必永远被第一个冲动控制。

《佛遗教经》说：

#quote(block: true)[
“若失念者，则失诸功德；若念力坚强，虽入五欲贼中，不为所害。”
]

失去正念，人的知识、原则和善意可能在一瞬间被情绪冲走；正念现前，才有可能想起自己真正重视什么。

=== 2. 看见感受，而不是成为感受
<看见感受而不是成为感受>
我们常说：“我很愤怒”“我很焦虑”“我很失败”。这些说法容易让人把暂时的状态等同于整个自己。正念可以帮助我们换一种观察方式：

“心中有愤怒。”“身体正在紧张。”“此刻有一种害怕被否定的感受。”愤怒是正在发生的心理现象，但它不是完整的“我”；焦虑会影响我们，却不是永远不变的身份。一旦感受不再等同于自我，我们就有机会观察它的生起、停留和消退。这就是在日常生活中观察无常。

=== 3. 正念不是永远不走神，而是走神以后知道回来
<正念不是永远不走神而是走神以后知道回来>
许多人开始静坐时，会因为杂念太多而沮丧，认为自己不适合修行。其实，发现自己走神，本身就是正念恢复的一刻。心跑到过去，知道它跑到了过去；心担忧未来，知道它正在构想未来；然后轻轻回到呼吸、身体和眼前正在做的事。修行不是从此没有杂念，而是不再毫无觉察地跟着每一个念头奔跑。

在办公室写一份报告，心却不断想象别人怎样评价自己；陪家人吃饭，眼睛却始终停留在手机上；躺在床上，身体准备休息，心还在重复白天的争执。正念，就是一次又一次把心带回来。回来吃这一口饭，听完眼前这个人说的话，完成手上的这一件事。人的生命其实只发生在当下，但我们的心常常不在这里。

#horizontalrule

== 六、智慧：不是聪明，而是看清因缘
<六智慧不是聪明而是看清因缘>
佛教重视智慧，但佛教所说的智慧并不等于记忆力强、学历高或善于争辩。一个人可以非常聪明，却仍然被嫉妒和傲慢支配；可以懂得许多道理，却在利益面前失去分寸。佛教的智慧，首先是如实地看见因缘。

=== 1. 一件事，不等于我们对它的解释
<一件事不等于我们对它的解释>
领导指出一项错误，这是一个事实。“他一直看不起我”，可能是解释。朋友没有及时回复消息，这是一个事实。“他已经不在乎我了”，可能是解释。一次考试失败，这是一个事实。“我这一生都不会成功”，则是把一次事件扩大成了整个命运。人在痛苦时，常常把事实、感受和想象混在一起。智慧不是没有情绪，而是能够分辨：

真正发生了什么？我现在感受到什么？我又在这件事上增加了怎样的推测？这种分辨，可以让人从情绪编织的世界中退后一步。

=== 2. 没有一件事只由一个原因造成
<没有一件事只由一个原因造成>
佛教讲缘起：

#quote(block: true)[
“此有故彼有，此生故彼生；此无故彼无，此灭故彼灭。”
]

一段关系破裂，往往不只是某一句话造成的；一个人的坏习惯，也可能与成长经历、环境诱因、压力和长期选择有关；一次事业失败，既有个人判断，也有市场、时机和许多不可控制的因素。看见因缘，不是逃避个人责任，而是不把一切简单归结为“都是我不好”或“全是别人害我”。

过度自责和一味责怪别人，看似相反，其实都把复杂因缘压缩成单一结论。智慧使人既承担自己应承担的部分，也承认自己无法控制全部条件。

=== 3. “空”意味着没有固定不变的本质
<空意味着没有固定不变的本质>
佛教说“空”，不是说一切都不存在，而是说一切都依因缘而成立，没有一个永恒、孤立、不变的自性。一个人今天失败，不代表他本质上就是失败者；一个曾经伤害过别人的人，也不意味着他永远没有改变的可能；我们现在拥有的身份、财富和能力，也不是永远牢不可破的。

正因为是空，事物才可以变化。理解空，不会使人否定现实，反而让人不必被现实中暂时的标签完全限定。我们可以承认：“这件事我做错了。”却不必断言：“我是一个永远无可救药的人。”可以承认：“这段关系已经结束。”却不必断言：“从此以后，再也不会有人理解我。”

智慧让人看到，眼前的处境真实存在，却不是全部世界；它有自己的因缘，也会随着因缘继续变化。

=== 4. 智慧最终要落实为选择
<智慧最终要落实为选择>
懂得无常，却依然挥霍时间，不是真懂无常。懂得因果，却仍在愤怒中随意伤人，不是真懂因果。懂得空，却以空为借口逃避责任，也不是真正的般若。智慧不是头脑中保存的概念，而是在关键时刻能够改变选择的力量。当一句恶言到了嘴边，愿意停下来；当利益与原则冲突，愿意守住底线；当别人痛苦时，愿意多看一眼；当事情无法改变时，愿意不再徒然折磨自己。

这些看似平常的选择，正是智慧在生活中的形状。

#horizontalrule

== 七、一个普通人的一天
<七一个普通人的一天>
让我们回到本章开始时的那位普通人。清晨，他看到工作群里的催促，第一反应是烦躁。他本想立刻回复一句带着敌意的话，但注意到自己呼吸急促、手臂绷紧。这是正念。他没有否认愤怒，只是暂时没有让愤怒替自己说话。到了公司，他发现项目确实出现了问题。他不再把批评立即解释为“所有人都在针对我”，而是区分哪些意见有事实依据，哪些只是语气问题。

这是智慧。他承担自己疏忽的部分，也没有把全部责任都揽到自己身上。中午，他接到母亲身体不适的消息。过去，他总以为以后还有很多时间。这一次，他忽然意识到，父母的衰老并不会等待自己忙完所有工作。这是无常给予他的提醒。他没有因此陷入恐慌，而是安排检查，抽出时间陪伴，并说出一些过去觉得不好意思说的话。

傍晚，他与家人发生争执。他仍然觉得委屈，却开始看见，对方的尖锐背后也有长期没有被听见的疲惫。这是慈悲。慈悲没有要求他认同所有指责，但使他不再只想着怎样赢得争论。夜晚，他想起白天的错误，心里仍有不安。他检查需要补救的事项，向相关的人说明情况，做好第二天的计划。

能够处理的，他认真处理。处理之后，他提醒自己，不必在床上再把整个过程审判一百遍。这是放下。他并没有因此成为圣人。第二天，他仍然可能焦虑，仍然可能发怒，仍然会忘记所学的道理。但每一次觉察、每一次减少伤害、每一次从执着中松开一点，都是修行真正发生的地方。

修行不是突然变成一个毫无烦恼的人，而是烦恼生起时，我们越来越能够认出它，不再完全听命于它。

#horizontalrule

== 八、把佛法放进一天
<八把佛法放进一天>
佛法进入生活，不一定要从宏大的计划开始。有时，只需要在一天之中，为自己保留几个清醒的时刻。

=== 清晨：记得无常
<清晨记得无常>
醒来以后，不必急着抓起手机。先感受一次呼吸，知道自己又拥有了新的一天。想一想：今天与家人、同事和陌生人的相遇，都不是理所当然。无常不是催促人焦虑，而是提醒人不要把生命全部推迟到以后。

=== 工作时：记得因果
<工作时记得因果>
发出一封邮件、说出一句话、作出一个决定，都可能成为后续结果的条件。在行动之前问一句：

这件事是否会给自己和别人带来不必要的伤害？因果不只发生在遥远的来世，也发生在下一分钟。恶言之后，关系立即改变；欺骗之后，信任开始损耗；善意之后，环境也可能因此多一分温和。

=== 冲突时：记得正念
<冲突时记得正念>
感到愤怒时，不必立刻要求自己慈悲。先停一下。感受呼吸，观察身体，知道愤怒正在发生。可以暂缓回复，可以离开几分钟，也可以告诉对方：“我现在情绪很强，稍后再谈。”这不是逃避，而是不让事情在失控中变得更坏。

=== 面对他人时：记得慈悲
<面对他人时记得慈悲>
试着问自己：

这个人是否也正在承受某种我没有看见的痛苦？这并不意味着取消原则，而是避免把一个复杂的人简化成“讨厌的人”“没用的人”或“坏人”。慈悲有时是一句话，有时是安静倾听，有时是提供实际帮助，有时则是明确而不带仇恨地拒绝。

=== 面对消费和欲望时：记得知足
<面对消费和欲望时记得知足>
《佛遗教经》说：

#quote(block: true)[
“知足之人，虽卧地上犹为安乐；不知足者，虽处天堂亦不称意。不知足者虽富而贫，知足之人虽贫而富。”
]

知足不是拒绝改善生活，也不是赞美贫困，而是不让欲望永远制造“还不够”的感觉。拥有一件东西以后，欲望很快会寻找下一件；达到一个目标以后，比较又会产生新的不足。知足是知道什么已经足够，也知道生命中有许多重要事物无法用拥有多少来衡量。

=== 夜晚：记得反省，也记得放下
<夜晚记得反省也记得放下>
睡前可以问自己三个问题：

今天，我是否因为贪、瞋、痴伤害了谁？今天，我是否做过一件让别人减少痛苦的事？今天，还有什么是我应当处理，而不是继续逃避的？需要道歉的，准备道歉；需要补救的，安排补救；已经尽力而无法改变的，允许它暂时停下。反省不是自我羞辱。看清过失，是为了不再重复；看见善行，是为了使善心继续增长。完成反省之后，就让今天成为今天，不必把它全部带进明天。

#horizontalrule

== 九、三个常见误解
<九三个常见误解>
=== 误解一：放下是不是放弃？
<误解一放下是不是放弃>
不是。放弃是该做的事情不再做，放下是做了应做的事情以后，不再被结果和执念绑架。面对疾病，接受治疗是提起责任；不能控制所有结果，是学习放下。面对不公，依法争取是提起责任；不让仇恨占据余生，是学习放下。面对关系，真诚沟通是提起责任；承认有些人最终不能同行，是学习放下。

佛教的放下，从来不是消极地什么都不做，而是“尽人事而不执着”。

=== 误解二：慈悲是不是软弱？
<误解二慈悲是不是软弱>
不是。软弱是因为恐惧而不敢行动，慈悲则是看见痛苦以后，选择不以仇恨继续制造痛苦。真正的慈悲需要勇气。它可能要求一个人保护弱者、制止伤害、拒绝不合理的要求，也可能要求我们放下报复的快感，以更有效的方式解决问题。慈悲不是没有力量，而是力量不被瞋恨支配。

=== 误解三：学佛是不是远离现实生活？
<误解三学佛是不是远离现实生活>
不是。佛教所说的出离，首先是出离贪、瞋、痴的控制，而不是逃离一切人群和责任。《六祖坛经》说“佛法在世间，不离世间觉”。家庭、工作和社会并非修行的障碍；真正的障碍，是在其中不断增长的执着、伤害和无明。照顾父母、教育孩子、诚实工作、帮助他人、保护环境、遵守责任，都可以成为佛法的实践。

离开现实去寻找一个完全没有烦恼的地方，往往只是另一种逃避。佛法不是让人离开世界，而是让人不再以同样迷惑的方式活在世界里。

#horizontalrule

== 结语：从鹿野苑、长安城，回到我们此刻的心
<结语从鹿野苑长安城回到我们此刻的心>
两千多年前，佛陀在鹿野苑向五比丘讲说苦、集、灭、道。此后，佛法经过结集、传播和翻译，越过高山与沙漠，进入西域，来到洛阳和长安；又在中国形成禅宗、净土、天台、华严等丰富传统，融入语言、艺术、伦理和普通人的生死观念。我们可以记住许多人物和故事：

悉达多太子走出王宫，看见生老病死；佛陀在菩提树下觉悟缘起；阿难诵出“如是我闻”；鸠摩罗什在长安译经；玄奘越过流沙求法；慧能听闻《金刚经》而悟；太虚大师提出人生佛教，近现代大德继续思考佛法怎样面对新的时代。但所有历史最终都指向同一个问题：

今天的我们，怎样生活？佛教不能替我们决定每一份工作、每一段关系和每一个现实选择，也不会承诺信佛以后人生便不再遭遇疾病、失败和离别。佛法所能给予的，是另一种面对人生的方式。看见无常，所以懂得珍惜，也不再要求世界永远不变。生起慈悲，所以愿意理解痛苦，却不以纵容代替智慧。

学习放下，所以认真承担，又不把自己永远囚禁在成败得失之中。保持正念，所以情绪升起时，不必立即成为情绪的奴隶。增长智慧，所以能够看见因缘，分清事实、感受和执着，在复杂世界里尽量作出减少伤害的选择。一个人也许终其一生都不能完全做到这些。但他可以从一句话开始。

少说一句伤人的话，多听一次别人的困难；少一次无休止的比较，多一次对已有生活的珍惜；少抓住一件已经过去的事情，多做一件当下真正有益的事。佛教并不遥远。它可能就在一个人愤怒时停下的那一秒，就在他愿意道歉的那一刻，就在他面对衰老和死亡时仍然选择温柔，就在他经历失去以后，没有让自己变得更加冷酷。

从鹿野苑到长安城，佛法走过了漫长的道路。而它最后的一段路，是从寺院和经卷走进一个人的心里，再从心里走到他如何说一句话、如何做一件事、如何对待眼前的每一个人。所以，在全书的最后，我们仍然可以回到那句最朴素的教诲：

#quote(block: true)[
诸恶莫作，众善奉行，自净其意，是诸佛教。
]

不增加伤害，努力成就善意，时时照看自己的心。这或许就是一个普通人理解佛教之后，可以开始走出的第一步。

#horizontalrule

== 本章主要经典与资料依据
<本章主要经典与资料依据>
+ 《六祖大师法宝坛经》：“佛法在世间，不离世间觉；离世觅菩提，恰如求兔角。”大正藏第48册，第2008号。2. 《增壹阿含经》：“诸恶莫作，诸善奉行，自净其意，是诸佛教。”大正藏第2册，第125号。3. 《佛垂般涅槃略说教诫经》，即《佛遗教经》，有关正念、知足及“一切世间动不动法，皆是败坏不安之相”等教诲。大正藏第12册，第389号。4. 《中阿含经·念处经》，有关观身、观受、观心、观法以及“行住坐卧……皆正知之”的修习。大正藏第1册，第26号。5. 《金刚般若波罗蜜经》：“应无所住而生其心。”大正藏第8册，第235号。6. 《杂阿含经》，有关缘起法“此有故彼有，此生故彼生；此无故彼无，此灭故彼灭”。大正藏第2册，第99号。7. 《大智度论》卷二十，有关慈、悲、喜、舍四无量心的解释。大正藏第25册，第1509号。8. 《维摩诘所说经》，有关“爱见悲”以及菩萨“虽行于空，而植众德本”的教导。大正藏第14册，第475号。9. 圣严法师《人间世》所说“面对它、接受它、处理它、放下它”，可作为现代人理解承担与放下次序的通俗说明。

= 附录
<附录>
== 附录一：佛教名词速查
<附录一佛教名词速查>
#table(
  columns: (40%, 60%),
  align: (auto,auto,),
  table.header([名词], [简要释义],),
  table.hline(),
  [佛], [觉悟者，已彻底觉悟真理之人],
  [菩萨], [上求佛道、下化众生的修行者],
  [罗汉], [已证得解脱、不再受生死束缚者],
  [三宝], [佛、法、僧],
  [三皈依], [皈依佛、皈依法、皈依僧],
  [五戒], [不杀生、不偷盗、不邪淫、不妄语、不饮酒],
  [十善], [身三（不杀、不盗、不邪行）口四（不妄语、不两舌、不恶口、不绮语）意三（不贪欲、不瞋恚、不邪见）],
  [四圣谛], [苦谛、集谛、灭谛、道谛],
  [八正道], [正见、正思惟、正语、正业、正命、正精进、正念、正定],
  [十二因缘], [无明→行→识→名色→六入→触→受→爱→取→有→生→老死],
  [六度], [布施、持戒、忍辱、精进、禅定、般若],
  [因果], [善因感善果，恶因感恶果，自作自受],
  [业力], [行为（身、口、意）所产生的影响力],
  [轮回], [众生因业力而在六道中流转生死],
  [涅槃], [烦恼止息、生死解脱的状态],
  [空], [一切现象无固定自性，依缘起而存在],
  [禅], [通过静虑、观照达到心性明净的修行],
  [净土], [阿弥陀佛的极乐世界，净化修行的理想境界],
)
== 附录二：适合普通读者进一步阅读的佛教经典
<附录二适合普通读者进一步阅读的佛教经典>
- #strong[《心经》] --- 最简短的般若经典，260字，揭示空性要义
- #strong[《金刚经》] --- 大乘般若教义精髓，"应无所住而生其心"
- #strong[《法华经·观世音菩萨普门品》] --- 观音信仰的核心经文
- #strong[《佛说阿弥陀经》] --- 净土法门入门经典
- #strong[《地藏菩萨本愿经》] --- 孝道与愿力的经典
- #strong[《华严经·普贤行愿品》] --- 普贤十大愿行
- #strong[《六祖坛经》] --- 中国唯一被称为”经”的祖师著作
- #strong[《杂阿含经》] --- 记录佛陀原始教法，贴近早期佛教

// 注入 include-after
