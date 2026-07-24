// ============================================================
// theme.typ — 东方禅意色彩与字体定义
// 《从鹿野苑到长安城》专属主题
// ============================================================

// ── 色彩系统 ────────────────────────────────────────────────
#let ink       = rgb("#1C1917")   // 禅墨：正文色
#let paper     = rgb("#F5F0E8")   // 宣纸：背景色
#let vermilion = rgb("#8B2523")   // 朱砂：一级标题、章号
#let celadon   = rgb("#6B8E7F")   // 青瓷：装饰线、页眉
#let gold      = rgb("#C9A84C")   // 金箔：引言框边线、部分编号
#let stone     = rgb("#4A6FA5")   // 石青：二级标题
#let mist      = rgb("#E8E0D0")   // 烟霭：淡色分割线
#let charcoal  = rgb("#3D3530")   // 炭灰：次要正文

// ── 字体系统 ────────────────────────────────────────────────
// 优先使用系统已有字体，兜底依次回退
#let font-body = (
  "Noto Serif SC",
  "Source Han Serif SC",
  "SimSun",
  "serif",
)

#let font-heading = (
  "Noto Sans SC",
  "Source Han Sans SC",
  "Microsoft YaHei",
  "sans-serif",
)

#let font-kai = (
  "KaiTi",
  "STKaiti",
  "FangSong",
  "serif",
)

#let font-latin = (
  "EB Garamond",
  "Garamond",
  "Georgia",
  "serif",
)

// ── 版式参数 ────────────────────────────────────────────────
#let page-margin = (
  top: 2.8cm,
  bottom: 2.8cm,
  inside: 3.0cm,
  outside: 2.2cm,
)

#let body-size   = 11pt
#let lead-size   = 1.75em    // 行距（leading）
#let indent-size = 2em       // 首行缩进
