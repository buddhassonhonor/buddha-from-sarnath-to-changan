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
  title: [$title$],
  subtitle: [$subtitle$],
  author: "$author$",
  date: "$date$",
  lang: "zh",
  main-color: rgb("#C9A84C"),
  outline-depth: 2,
)

// 注入 header-includes (例如 header.typ)
$for(header-includes)$
$header-includes$
$endfor$

// 注入 include-before (例如 before-body.typ)
$for(include-before)$
$include-before$
$endfor$

// 主体正文
$body$

// 注入 include-after
$for(include-after)$
$include-after$
$endfor$
