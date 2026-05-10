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
  // set text(fill: white)
  // set page(fill: black)
  it
} else { it }

#import "@preview/diagraph:0.3.7": *

#show raw.where(lang: "dot"): raw-render

#let mtext = text.with(font: "David CLM")
#let pseudocode-list(..args) = {
  import "@preview/lovelace:0.3.1": pseudocode-list
  set text(lang: "en")
  pseudocode-list(..args)
}

#maketitle(
  title: "אלגוריתמים",
  date: custom-date-format(datetime(day: 10, month: 5, year: 2026), lang: "he"),
  authors: ("דניאל פ.ח.",),
)

= מסלולים קצרים ביותר מנקודה אחת (Single Source Shortest Paths)

$B = (V,E)$. יש משקל על הקשתות $w : E -> RR$ (שימו לב כי המשקל יכול להיות שלילי). משקל של מסלול = סכום משקלי הקשתות לאורכו. מתעניינים במסלולים קלים ביותר (מקבי"ם).

#figure(
  ```dot
  digraph {
    rankdir=LR;
    a -> b [label=1];
    a -> b [style=invis] [label=" "]; // תודה לעידו פרלמן
    b -> a [label=-2];
  }
  ```,
  alt: "גרף ובו שני קדקודים a ו-b, יש קשת עם משקל 1 בין a ל-b וקשת עם משקל -2 בין b ל-a",
  supplement: "גרף",
  caption: [המרחק המינימלי מ-$a$ לעצמו הינו $-infinity$],
)

נקודה חשובה: נרצה שהאלגוריתמים שלנו יזהו ויעצרו אם יש מעגל שלילי. בהינתן שאין, כל המקבי"ם הם פשוטים (יש להם גרסה פשוטה).

- לא ניתן להוסיף משקלה קבוע לכל המשקלים שכן מסלולים שונים הם באורכים שונים (בשונה מעפ"מ).

- אם $w$ היא הפונקציה הקבועה 1, משקל המסלול = אורך המסלול ו-BFS פותר את הבעיה בזמן $O(abs(V) + abs(E))$.

- סימון $delta(s, v)$ - משקל מסלול קל ביותר מ-$s$ ל-$v$.
  $delta(s, v)=infinity$ אם $v$ לא נגיש מ-$s$. $delta(s, v) = -infinity$ אם יש מעגל שלילי "בדרך" מ-$s$ ל-$v$.

/ תכונות\::
  - אי שוויון המשולש $delta(s, v) <= delta(s, u) + w(u,v)$

  - תת מסלול של מק"ב אף הוא מסלול קל ביותר.

  - אם $(u,v)$ קשת אחרונה במק"ב מ-$s$ ל-$v$ אזי $w(u,v) + delta(s, u) = delta(s, v)$.

== רעיון כללי
נחזיק לכל קדקוד שני ערכים:

/ $d[v]$: \- המשקל של מק"ב שמצאנו עד כה מ-$s$ ל-$v$ (מאתחל ל-$infinity$).

/ $pi[v]$: \- הקודקוד  הקודם ל-$v$ במסלול שמשקלו $d[v]$.

== פעולה בודקת:

#pseudocode-list[
  - $#[*Relax*];(u,v)$:
    - *if* $d[u] + w(u,v) < d[v]$:
      - $d[v] = d[u] + w(u,v)$
      - $pi[v] = u$
]

#figure(
  ```dot
  digraph {
    rankdir=LR;
    rank=same { u v };
    s -> u [label=1];
    s -> v [label=3];
    u -> v [label=-3] [dir=back];
    u -> w [label=1];
  }
  ```,
  supplement: [גרף],
)

/ אבחנות\::
  - $d[v] >= delta(s, v)$ לכל $v$ לכל אורך האלגוריתם.
  - ברגע ש-$d[v] =delta(s, v)$
    לכל $v$,
    ברור שלא ניתן לבצע עוד
    Relax
    משפר שכן זה בהכרח יקטין לכן
    $d[v]$
    כלשהו בסתירה.
  - בדומה ל-BFS, מצביעי $pi$ במידה והמרחקים חושבו ייצגו מק"ב בהיפוך כיוון.

#figure(
  ```dot
  digraph {
    rankdir=LR;
    rank=source {s};
    rank=same {a c};
    rank=same {b d};
    s -> a [label=10];
    s -> c [label=5];
    a -> c [label=3];
    a -> c [label=2] [dir=back];
    b -> d [label=6];
    b -> d [label=4] [dir=back];
    c -> d [label=2];
    a -> b [label=1];
    d -> s [label=7];
  }
  ```,
  supplement: [גרף],
)

// ```dot
// digraph {
//   A0 -> A1 -> A2 -> A3 -> A4 -> A5 -> A6 -> A7;
// 	B0 -> B1 -> B2 -> B3 -> B4 -> B5 -> B6 -> B7;
// 	C0 -> C1 -> C2 -> C3 -> C4 -> C5 -> C6 -> C7;
// 	D0 -> D1 -> D2 -> D3 -> D4 -> D5 -> D6 -> D7;
// 	E0 -> E1 -> E2 -> E3 -> E4 -> E5 -> E6 -> E7;
// 	F0 -> F1 -> F2 -> F3 -> F4 -> F5 -> F6 -> F7;
// 	G0 -> G1 -> G2 -> G3 -> G4 -> G5 -> G6 -> G7;
// 	H0 -> H1 -> H2 -> H3 -> H4 -> H5 -> H6 -> H7;

// 	rank=same { A0 -> B0 -> C0 -> D0 -> E0 -> F0 -> G0 -> H0 };
// 	rank=same { A1 -> B1 -> C1 -> D1 -> E1 -> F1 -> G1 -> H1 };
// 	rank=same { A2 -> B2 -> C2 -> D2 -> E2 -> F2 -> G2 -> H2 };
// 	rank=same { A3 -> B3 -> C3 -> D3 -> E3 -> F3 -> G3 -> H3 };
// 	rank=same { A4 -> B4 -> C4 -> D4 -> E4 -> F4 -> G4 -> H4 };
// 	rank=same { A5 -> B5 -> C5 -> D5 -> E5 -> F5 -> G5 -> H5 };
// 	rank=same { A6 -> B6 -> C6 -> D6 -> E6 -> F6 -> G6 -> H6 };
// 	rank=same { A7 -> B7 -> C7 -> D7 -> E7 -> F7 -> G7 -> H7 };
// }
// ```

נתחיל במקרה של גרף מכוון חסר מעגלים (DAG). יש לגרף מיון טופולוגי. קודקודים שלפני $s$ במיון לא מעניינים. נעבור על הקודקודים לפי סדר המיון האופולוגי. לכל קודקוד, נבצע Relax על  כל הקשתות שלו. בסוף הריצה $d[v] = delta(s, v)$ לכל $v in V$.

/ סיבוכיות: $O(abs(E) + abs(V))$
/ נכונות: באינדוקציה על הסדר במיון הטופולוגי. נראה שכאשר מגיעים לקדקוד $i$, מתקיים $d[v_i] = delta(s, v_i)$: נניח בה"כ ש-$s=v_0$. עבור $i=0$ הטענה מתקיימת $d[s]=0=delta(s, s)$. נניח נכונות עד $i-1$ ונוכיח עבור $i$. בהכרח $k < i$ ולכן $d[k]=delta(s, k)$ בזמן טיפול ב-$v_k$. בזמן ביצוע $"Relax"(v_k,v_i)$ נקבל $delta(s, v_i) <<= d[v_i] <= d[v_k] + w(v_k,v_i) = delta(s, v_k) + w(v_k,v_j) =delta(s, v_i)$.
  כלומר $delta[v_i] = delta(s, , v_i)$.

== המקרה הכללי

אסטרטגיה של Ford - נבצע Relax עד שלא ניתן יותר.

_הערה -_ אם יש מעגל שלילי, זה לא יעצור.

_שאלה -_ כמה Relaxים משפרים נוכל לבצע לכל היותר?

גרף עם $n+1$ קדקודים ו-$2n$ קשתות. המשקל $d[v]$ יכול לקבל $2^n$ ערכים שונים! יכולים לצוות מונה בינארי מ-$2^(n+1)$ עד $0$ ובכל עדכון לבצע לפחות Relax אחד.

== Bellman-Ford

נקבע סדר כלשהו של הקשתות. נעבור עליהן $abs(V)-1$ פעמים, לבצע Relax על כל אחת.


נעבור שוב על הקשתות, אם יש Relax משפר $arrow.l.double$ יש מעגל שלילי.

/ סיבוכיות: $O(abs(E) dot abs(V))$
/ נכונות: אם אין מעגלים שליליים, אחרי $abs(V)-1$ איטרציות $d[v]=delta(s, v)$ לכל $v$. נוכיח באינדוקציה על האיטרציות שאחרי $i$ איטרציות כל קודקוד עם מק"ב באורך $i >=$ מקיים $d[v] = delta(s, v)$:

  אחרי 0 איטרציות מתקיים $d[s]=0=delta(s, s)$ (אין מעגל שלילי).

  נניח עד $i-1$ ונראה עבור $i$. יהא $v$ קדקוד שאורך מינמלי של מק"ב שלו הוא $i$. נניח $u$ קדקוד לפני $v$ במק"ב באורך זה. אורך מינמלי של מק"ב של $u$ הוא $i-1$ ולכן אחרי $i-1$ איטרציות מתקיים $d[u]=d(s,u)$. באטרציה ה-$i$ נבצע $"Relax"(u,v)$ ונקבל:

  $
    delta(s, v) <= d[v] <= d[u] + w(u,v) = delta(s, u) + w(u,v) = delta(s, v)
  $

  וסיימנו.

== זיהוי מעגלים שליליים

נניח שהאלגו' לא שיפר באיטרציה ה-$abs(V)$. יהא $v_0,...,v_k$ מעגל ($v_k = v_0$). באיטרציה ה-$abs(V)$ כל ה-Relaxים לא שיפרו כלומר $forall 1 <= i <= k, d[v_i] <= d[v_(i-1)] + w(v_(i-1),v_i)$. נסרוק את אי השוויונות האלה:

$
  sum_(i=1)^k d[v_i] <= sum_(i=1)^(k-1) d[v_i] + sum_(i=1)^(k-1) w(v_(i-1), v_i) \
  => 0 < sum_(i=1)^k w(v_(i-1), v_i)
$

כלומר משקל המעגל אי-שלילי.

נניח שהיה שיפור באיטרציה ה-$abs(V)$, נרצה לטעון שיש מעגל שלילי. אם לא היו מעגלים עבר אחרי $abs(V)-1$ איטרציות התקיים $d[v]=delta(s, v)$ לכל $v$. מצד שני, האלגוריתם כן הצליח לבצע Relax משופר, נניח על הקשת $(u,v)$. נשתמש בא"ש המשולש $d[u] = w(u,v) = delta(s, u) + w(u,v) >= delta(s, v) = d[v]$ ולכן שוב Relax אינו יכול לשפר.

#block(line(length: 100%), inset: .5em)

במקרה שבו אין משקלים שליליים, ניתן לבצע משהו יעיל יותר. האלגוריתם של Dijkstra עובר על הצמתים לפי סדר משקל עולה מ-$s$, ומבצע Realax על כל הקשתות. נעזרים בתור עדיפויות על מנת לבחור את הצומת הבא כל פעם.

/ סיבוכיות\::
  / decresase key -: $O(abs(E))$
  / הוספה לתור -: $O(abs(V))$
  / delete min -: $O(abs(V))$
  / תלוי מימוש\::
    / ערימת fibonnaci -: $O(abs(V) dot log abs(V) + abs(E))$
    / ערימה רגילה -: $O((abs(V) + abs(E)) log abs(V))$
    / מערך -: $O(abs(V)^2+abs(E))$

== Bidirectional Dijkstra

במקרה שרוצים מסלול קל ביותר מ-$s$ ל-$t$ ספציפי.

אם נחפש מ-$s$ (במקביל) אחורה מ-$t$ (עם קשתות הפוכות), נוכל לעיתים לחסוך בזמן החיפוש. בדוגמא של grid דו מימדי זה יחסוך פי 2. בכל צעד נוציא מאחד התורים, לפי אצל מי מהם יש מפתח קטן ביותר.

/ טענה\:: ברגע שיש קודקוד שיצא מהתור גם מ-$s$ וגם אל $t$, בהכרח כבר גילינו מק"ב מ-$s$ ל-$t$, לא דווקא כזה שעובר בקודקוד זה.

  _אינטואיציה:_ בעזרת אי-שוויון המשולש נוכל לטעון שעבור כל מסלול קל יותר, כבר גילינו דרך $s$ או $t$ את כל הקודקודים שלו ולכן אם נחפש  קודקוד עבורו סכום המרחקים מינמלי, נמצא את הדרוש.

== אלגוריתם נוסף נקרא $A^*$

#text(fill: red)[\~ עמית מחק את הלוח (אבל זה בסדר כי זה לא בחומר) \~]
