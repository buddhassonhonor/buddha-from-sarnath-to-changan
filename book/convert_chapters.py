# -*- coding: utf-8 -*-
"""convert_chapters.py — Convert 0.md-20.md to Quarto .qmd files"""

import os, re

SOURCE = r"d:\宗教大观\Budda"
BOOK   = r"d:\宗教大观\Budda\book"
CHAPS  = os.path.join(BOOK, "chapters")

chapters = {
    1:  ("ch01", "第一章　一个王子为什么离开王宫？"),
    2:  ("ch02", "第二章　菩提树下，佛陀看见了什么？"),
    3:  ("ch03", "第三章　鹿野苑初转法轮"),
    4:  ("ch04", "第四章　三宝、皈依与僧团"),
    5:  ("ch05", "第五章　佛陀最后的旅程"),
    6:  ("ch06", "第六章　如是我闻：佛经是怎么来的？"),
    7:  ("ch07", "第七章　阿育王与佛塔"),
    8:  ("ch08", "第八章　正法、像法与末法"),
    9:  ("ch09", "第九章　大乘佛教为什么兴起？"),
    10: ("ch10", "第十章　阿弥陀佛与净土法门"),
    11: ("ch11", "第十一章　白马驮经：佛教初入中国"),
    12: ("ch12", "第十二章　鸠摩罗什：翻译如何改变佛教？"),
    13: ("ch13", "第十三章　玄奘西行"),
    14: ("ch14", "第十四章　鉴真东渡"),
    15: ("ch15", "第十五章　达摩东来：禅宗的不立文字"),
    16: ("ch16", "第十六章　六祖慧能"),
    17: ("ch17", "第十七章　寺庙里的佛教"),
    18: ("ch18", "第十八章　因果、轮回与十善"),
    19: ("ch19", "第十九章　从人生佛教到人间佛教"),
    20: ("ch20", "第二十章　把佛教带回生活"),
}

# ── index.qmd (from 0.md) ───────────────────────────────────
with open(os.path.join(SOURCE, "0.md"), encoding="utf-8-sig") as f:
    body0 = f.read().strip()
# Remove leading h1 if present
body0 = re.sub(r'^#\s+.+\n', '', body0, count=1).lstrip()

index_content = f"""---
title: "前言：为什么今天还要读懂佛教？"
---

{body0}
"""
with open(os.path.join(BOOK, "index.qmd"), "w", encoding="utf-8") as f:
    f.write(index_content)
print("✓ index.qmd")

# ── chapter .qmd files ──────────────────────────────────────
for num, (fname, title) in chapters.items():
    src = os.path.join(SOURCE, f"{num}.md")
    dst = os.path.join(CHAPS, f"{fname}.qmd")
    with open(src, encoding="utf-8-sig") as f:
        body = f.read().strip()
    # Remove the leading h1 title line (already in YAML)
    body = re.sub(r'^#\s+.+\n', '', body, count=1).lstrip()
    qmd = f"""---
title: "{title}"
---

{body}
"""
    with open(dst, "w", encoding="utf-8") as f:
        f.write(qmd)
    print(f"✓ {fname}.qmd")

# ── appendix.qmd ────────────────────────────────────────────
appendix = """---
title: "附录"
---

## 附录一：佛教名词速查

| 名词 | 简要释义 |
|------|---------|
| 佛 | 觉悟者，已彻底觉悟真理之人 |
| 菩萨 | 上求佛道、下化众生的修行者 |
| 罗汉 | 已证得解脱、不再受生死束缚者 |
| 三宝 | 佛、法、僧 |
| 三皈依 | 皈依佛、皈依法、皈依僧 |
| 五戒 | 不杀生、不偷盗、不邪淫、不妄语、不饮酒 |
| 十善 | 身三（不杀、不盗、不邪行）口四（不妄语、不两舌、不恶口、不绮语）意三（不贪欲、不瞋恚、不邪见） |
| 四圣谛 | 苦谛、集谛、灭谛、道谛 |
| 八正道 | 正见、正思惟、正语、正业、正命、正精进、正念、正定 |
| 十二因缘 | 无明→行→识→名色→六入→触→受→爱→取→有→生→老死 |
| 六度 | 布施、持戒、忍辱、精进、禅定、般若 |
| 因果 | 善因感善果，恶因感恶果，自作自受 |
| 业力 | 行为（身、口、意）所产生的影响力 |
| 轮回 | 众生因业力而在六道中流转生死 |
| 涅槃 | 烦恼止息、生死解脱的状态 |
| 空 | 一切现象无固定自性，依缘起而存在 |
| 禅 | 通过静虑、观照达到心性明净的修行 |
| 净土 | 阿弥陀佛的极乐世界，净化修行的理想境界 |

## 附录二：适合普通读者进一步阅读的佛教经典

- **《心经》** — 最简短的般若经典，260字，揭示空性要义
- **《金刚经》** — 大乘般若教义精髓，"应无所住而生其心"
- **《法华经·观世音菩萨普门品》** — 观音信仰的核心经文
- **《佛说阿弥陀经》** — 净土法门入门经典
- **《地藏菩萨本愿经》** — 孝道与愿力的经典
- **《华严经·普贤行愿品》** — 普贤十大愿行
- **《六祖坛经》** — 中国唯一被称为"经"的祖师著作
- **《杂阿含经》** — 记录佛陀原始教法，贴近早期佛教
"""
with open(os.path.join(CHAPS, "appendix.qmd"), "w", encoding="utf-8") as f:
    f.write(appendix)
print("✓ appendix.qmd")
print("\n全部完成！共生成 23 个 .qmd 文件。")

# ── Auto-apply images ────────────────────────────────────────
try:
    import sys
    sys.path.append(BOOK)
    import download_and_insert_images
    download_and_insert_images.main()
except Exception as e:
    print(f"⚠ Could not auto-apply images: {e}")

