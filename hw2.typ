#import "@preview/rubber-article:0.5.2": article, maketitle
#import "@preview/datify:1.0.1": custom-date-format
#import "@preview/muchpdf:0.1.2": muchpdf


// #show: article.with()
#set par(justify: true)
#set text(lang: "he", font: "David CLM")
#set text(size: 1.1em)
// #show terms.item.where(term: [הגדרה]): set text(fill: color.rgb("#ffa0a0"))
// #show terms.item.where(term: [אבחנה]): set text(fill: color.rgb("#d0ffd0"))
// #show terms.item.where(term: [מסקנה]): set text(fill: color.rgb("#d0d0ff"))
#show: it => if sys.inputs.at("env", default: "fmt") == "dev" {
  set text(size: 2em)
  set page(height: auto, numbering: none, margin: (bottom: 24cm))
  // set text(fill: white)
  // set page(fill: black)
  it
} else {
  set page(background: context muchpdf(read("answersheet.pdf", encoding: none), pages: counter(page).get().at(0) - 1))
  it
}

#import "@preview/diagraph:0.3.7": *

#show raw.where(lang: "dot"): raw-render

#let mtext = text.with(font: "David CLM")
#let pseudocode-list(..args) = {
  import "@preview/lovelace:0.3.1": pseudocode-list
  set text(lang: "en")
  pseudocode-list(..args)
}

// #maketitle(
//   title: "אלגוריתמים - תרגיל בית 1",
//   date: custom-date-format(datetime(day: 12, month: 5, year: 2026), lang: "he"),
//   authors: ("דניאל פ.ח.",),
// )

#import "@preview/fletcher:0.5.8": *

#set page(margin: (x: 2.3cm, top: 4.7cm))

#set enum(numbering: "(א)")

+ #diagram($
	1 edge("d",->, bend: #{-10deg}) edge("d",<-,bend: #10deg) edge("dr",->,bend:#10deg) edge("dr",<-,bend: #(-10deg)) \
	2 edge(->, bend: #10deg) edge(<-, bend: #(-10deg), ) & 3
  $)
  
  זהו מעגל קשיר שכאשר מריצים עליו DFS החל מ-$1$ מקבלים קשת חוצה מ-$3$ ל-$2$ או מ-$2$ ל-$3$ (תלוי בסדר האיברים ברשימת שכנויות).

  קיימת דוגמא נגדית לכן הטענה לא נכונה

+ נריץ DFS מ-$u$, אז $f[u] > f[v] >= d[v] >= d[u] = 0$, לכן אנו ניגשים לצומת $v$ אחרי שהתחלנו לעבור על הצאצאים של $u$ ולפני שסיימנו, לכן $v$ בהכרח צאצא של $u$. אז הטענה נכונה.

#pagebreak()
#pagebreak()
#set page(margin: (y: 3.4cm))

+ נניח בשלילה כי $G$ לא עץ, ידוע כי ל-$G$ קיים עץ DFS לכן הוא קשיר מה שאומר שקיים ב-$G$ מעגל פשוט $v_1 - v_2 - ... - v_n - v_1$, נריץ DFS ו-BFS מ-$v_1$ ונקבל כי בעץ ה-BFS $v_2$ ו-$v_n$ שניהם ילדים של $v_1$, ובעץ ה-BFS $v_2$ ילד של $v_1$ אך $v_n$ לא או להיפך (תלוי בסדר רשימת השכנויות) ולכן $T != T$ שזו סתירה ולכן $G$ עץ. הגדרה שקולה לעץ (כשמדובר בגרף לא קשיר) היא שיש מסלול יחיד בין כל שני קדקודים ולכן BFS ו-DFS שניהם יצרו את $G$ עצמו כי הם בהכרח כללו את כל המסלולים. אז הטענה נכונה

// + #diagram($
//     & 1 edge(->, "dl") edge(->,"d") edge(->, "dr") \
//     2 edge(->) & 3 edge("d", ->) edge(->) & 4 edge(->,"d") \
//     & 5 & 6 edge(->, "l")
//   $)
  
//   הדרך היחידה לקבל עץ בהרצת DFS או BFS היא להתחיל מ-$1$ כיוון שאחרת יהיה יותר מרכיב קשירות אחד.

//   בהרצת DFS מ-$1$ העץ המתקבל יכיל את אחד מהמסלולים הבאים בהסתמך על סדר רשימת השכנויות:
//   - $1 -> 2 -> 3 -> 4 -> 6$
//   - $1 -> 3 -> 4 -> 6$
//   - $1 -> 4 -> 6 -> 5$
  
//   בהרצת BFS בהכרח נקבל ש-$2,3,4$ ילדים של

+ העץ הבא מכוון וחסר מעגלים:

  #diagram($
    & 1 edge(->, "dl") edge(->, "dr") \
    2 edge(->,"rr") && 3
  $)

  נאכל להריץ BFS ו-DFS מ-$1$ כאשר ברשימת השכנויות של $1$, $3$ מופיע לפני $2$ ואז בשני המקרים נקבל את העץ:

  #diagram($
    & 1 edge("dl",->) edge("dr",->) \
    2 && 3
  $)

  שהוא לא העץ המקורי.

  קיימת דוגמא נגדית ולכן הטענה לא נכונה.

+ בעץ בהכרח מתקיים $abs(E) = abs(V) - 1$ ולכן בהכרח ב-$G$ יש יותר קשתות מבכל עץ BFS או DFS שלו, ניקח עץ DFS כלשהו $T_0$, אז כאמור בהכרח יש קשת $(u,v)$ ב-$G$ שאין ב-$T_1$, נוכל להריץ BFS מ-$u$ ב-$G$ ואז בהכרח העץ המתקבל $T_2$ יכיל את הקשת $(u,v)$, אז $T_1 != T_2$. נוכל לסדר את רשימות השכנויות של $G$ כך שבכל צומת הקשתות שמופיעות ב-$T_1$ יופיעו קודם ברשימת השכנויות, אז כשנריץ DFS מכל קדקוד על הגרף נקבל שלכל שני קדקודים האלגוריתם עובר קודם במסלול היחודי שקיים ביניהם בעץ $T_1$ ולכן נוכל לקבל את $T_1$ עצמו ע"י הרצת DFS מ-$u$. אז הטענה נכונה.

#pagebreak()
#pagebreak()

+ ראשית אם יש מסלול המילטון אז קיים מיון טופולוגי ובו $u < v$ אמ"מ $u$ מופיע לפני $v$ במסלול.

  נניח בשלילה כי קיים מיון טופולוגי נוסף של הגרף ששונה מהמיון המתואר לעיל, אז קיימת קשת $(u,v)$ כך ש-$u$ לא מופיע לפני $v$ במסלול ההמילטון, אז קיים תת-מסלול של מסלול ההמילטון שהוא מסלול בין $v$ ל-$u$, וביחד עם הקשת הנתונה נקבל מעגל שעובר ב-$u$ ו-$v$, שזו סתירה לכך שהגרף חסר מעגלים. אז המיון הטופולוגי הוא יחיד.

+ אם המיון הטופולוגי יחיד זה אומר שלכל שני קדקודים $u < v$ מתקיים $(v,u) in.not E$,

  #diagram($
    & 1 edge("dl", ->) edge("dd",->) \
    2 edge("rr",->) && 3 edge("dl",->) \
    & 4
  $)

#pagebreak()
#pagebreak()

+ *תנאי:* אחד מבין $u_0, ..., u_(k-1)$ אב קדמון של $u_k$.

  אם התנאי מתקיים אז בהכרח יש מסלול בין $u_0$ ל-$u_k$ ב-$G'$ ולכן הם באותו רכיב קשירות.

  אם $u_0, u_k$ באותו רכיב קשירות ב-$G'$, כלומר שקיים מסלול ביניהם ב-$G'$, אז בהכרח אחת הקשתות של המסלול תתגלה ב-DFS בזמן ש-$u_0$ עדיין אפור ולכן היא תהיה קשת אחורית