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
  set text(fill: white)
  set page(fill: black)
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

#set page(margin: (x: 2.3cm, top: 4.7cm))

