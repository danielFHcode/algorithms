#import "@preview/rubber-article:0.5.2": article, maketitle
#import "@preview/datify:1.0.1": custom-date-format

#show: article.with()
#set text(lang: "he", font: "David CLM")
// #show terms.item.where(term: [הגדרה]): set text(fill: color.rgb("#ffa0a0"))
// #show terms.item.where(term: [אבחנה]): set text(fill: color.rgb("#d0ffd0"))
// #show terms.item.where(term: [מסקנה]): set text(fill: color.rgb("#d0d0ff"))

#show: it => if sys.inputs.at("env", default: "fmt") == "dev" {
  set text(size: 2em)
  set page(height: auto, numbering: none, margin: (bottom: 24cm))
  set text(fill: white)
  set line(stroke: (paint: white))
  set page(fill: black)
  it
} else { it }

#import "@preview/fletcher:0.5.8": *

#let mtext = text.with(font: "David CLM")
#let pseudocode-list(..args) = {
  import "@preview/lovelace:0.3.1": pseudocode-list
  set text(lang: "en")
  pseudocode-list(..args)
}

#maketitle(
  title: "אלגוריתמים",
  date: custom-date-format(datetime(day: 17, month: 5, year: 2026), lang: "he"),
  authors: ("דניאל פ.ח.",),
)

= מרחקים קלים ביותר בין כל הזוגות

דיקסטרה מכל קדקוד - עובד רק עם משקלים אי-שליליים.
$O(abs(V)^2 log abs(V) + abs(V)abs(E))$.

אם יש משקלים שליליים, BF מכל קדקוד. $O(abs(V)^2 abs(E))$.

\

רעיון אחר: נרצה מטריצה של מרחקים ומטריצה לקידוד מק"בים.

- $D_(i j)$ - המרחק בין $v_i$ ל-$v_j$
- $P_(i j)$ - צומת אחד לפני אחרון במק"ב" מ-$v_i$ ל-$v_j$ (האחד לפני $v_j$)

נסמן $V={v_1,...,v_n}$, $abs(V)=n$. 2 המטריצות $n times n$.

כאשר מתעניינים בכל הזוגות, נשתמש במטריצת השכנויות $W$ עם שינוי קל:

$
  W_(i j) = cases(
    0 &#h(1em) i = j,
    w(i,j) &#h(1em) (i,j) in E,
    infinity &#h(1em) mtext("אחרת")
  )
$

במהלך צעד ביניים $D_(i j)^((k))$ הינו המשקל של מק"ב מ-$v_i$ ל-$v_j$ עם לכל היותר $k$ קשתות.

נשים לב כי $W_(i j) = D^((1))_(i j)$ וגם $D_(i j) = D_(i j)^((n-1))$.

נבצע עדכון ע"י $D_(i j)^((m+1)) = min_(k){D_(i k)^((m)) + W_(k j)}$.

$
  O(abs(V)^4)
$

מעגלים שליליים: אם יש ערך שלילי על האלכסון של $D$, כלומר $D_(i i)^((n)) < 0$.

עדכון $D^((m+1))$ מתוך $D^((m))$ ו-$W$ הוא כמו כפל מטריצות עם חיבור במקום כפל ומינימום במקום חיבור, ב"כפל זה":

$
  D^((n)) = W^n
$

ניתן לחסוך ע"י iterated squaring, מתקיים:

$
  D_(i j)^((2m)) = min_(k){D_(i k)^((m)) + D_(k j)^((m))}
$

נקבל $O(abs(V)^3 log abs(V))$.

== האלגוריתם של Floyd Warshal

במקום לעדכן מסלולים לפי רמות הקשתות באיטרציה ה-$k$ נרשה רק מסלולים מגובה $k$, כלומר כאלה שcצמתים הפנימיים שלהם משתתפים רק ${v_1,v_2,...,v_k}$.

$
  v_i arrow.squiggly.long^mtext(k "גובה") v_(k+1) arrow.squiggly.long^mtext(k "גובה") v_j
$

המסלול הכי טוב בין $v_i$ ל-$v_j$ מגובה $k+1$ הוא או:
- מסלול מגובה $k$, ואז כבר מצאנו אותו
- מסלול מגובה $k+1$, כלומר שרשרוק של מסלול מגובה $k$ בין $v_i$ ל-$v_(k+1)$ ומסלול מגובה $k$ בין $v_(k+1)$ ל-$v_j$.

$
  delta_(0)(i,j) = W_(i j) = cases(
    0 &#h(1em) i = j,
    w(i,j) &#h(1em) (i,j) in E,
    infinity &#h(1em) mtext("אחרת")
  ) \
  delta_(k+1)(i,j) = min_(k){delta_(k)(i,j), delta_(k)(i,k+1)+delta_(k)(k+1,j)}
$

כל עדכון מלא של המטריצה עולה $O(abs(V)^2)$ במקום $O(abs(V)^3)$. נעשה $abs(V)$ איטרציות, סה"כ $O(abs(V)^3)$.

== ג'ונסון

רעיון: לשנות את המשלים כך שיהיו אי-שליליים, אבל לשמר את הסדר בין מסלולים עם אותם צמתי קצה.

/ טענה: תהא $h: V -> abs(R)$ פונקציה כלשהי. נגדיר פונקציית משקל חדשה:
  $
    w^*(u,v) = w(u,v) + h(u) - h(v)
  $
  אז:
  $
    w^* mtext("הוא מק\"ב לפי") <==> w mtext("מסלול הוא מק\"ב לפי")
  $

  / הוכחה: עבור מסלול $u=v_0->...->v_k=v$, המשקל לפי $w$ הוא:
    $
      sum_(i=1)^k w(v_(i-1),v_i)
    $
    המשקל לפי $w^*$:
    $
      sum_(i=1)^k w^*(v_(i-1),v_i)
      =& sum_(i=1)^k (w(v_(i-1),v_i) + h(v_(i-1))-h(v_i)) \
      =& (sum_(i=1)^k w(v_(i-1),v_i)) + h(u)-h(v) \
    $
    כלומר שכל המסלולים בין $u$ ל-$v$ שינו את המשקל שלהם בדיוק ב-$h(u)-h(v)$ ולכן הטענה נכונה.

/ מטרה: למצוא $h$ כך ש-$forall (u,v) in E, w^*(u,v) >= 0$, כלומר $forall (u,v) in E, w(u,v) + h(u) - h(v) >= 0$ כלומר $forall (u, v) in E, h(v) <= h(u) + w(u,v)$ - נראה מוכר? זהו אי שוויון המשולש! אז נרצה ש-$h$ תהיה פונקציית מרחק כלשהי.

נוסיף קודקוד חדש $s$ שמחובר לכל הצמתים עם קשת במשקל $0$. נחשב בעזרת BF את $delta(s,v)$ לכל צומת, נגדיר:

$
  h(v) := delta(s,v)
$

עכשיו $w^*(u,v) = w(u,v) + h(u)-h(v) >= 0$ ונריץ דיסקטרה מכל קדקוד.

$
  O(abs(V)abs(E) + abs(V)^2 log abs(V)abs(E)) = O(abs(V)^2 log abs(V)abs(E))
$

= עוד

/ הגדרה: סגור טרנזיטיבית של גרף זהו גרף על אותם קודקודים ויש קשת $(u,v)$ רק אם בגרף המקורי של מסלול מ-$u$ ל-$v$.

/ שאלה: רוצים לדעת אם יש מסלול (לוו דווקא פשוט) באורך בדיוק $m$ בין כל זוג קודקודים (אין משקלים).
