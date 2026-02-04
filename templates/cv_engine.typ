// --- CONFIGURATION ---
#import "@preview/iconic-salmon-fa:1.1.0": *

#let data_file = sys.inputs.at("data", default: "resume.json")
#let data = json("/data/" + data_file)
#let primary_color = rgb("#2E58FF")

#set page(
  margin: (x: 1.2cm, y: 1.2cm),
  paper: "a4",
)

#set text(
  font: ("Raleway"),
  size: 10pt,
  fill: rgb("#333333"),
  lang: "en",
)

// --- HELPERS ---

#let format_date(date_str) = {
  if date_str == "" or date_str == none { return "PRESENT" }
  let months = ("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")
  
  // Handle Year-Month or just Year
  let parts = str(date_str).split("-")
  if parts.len() >= 2 {
    let year = parts.at(0)
    let month_idx = int(parts.at(1)) - 1
    months.at(month_idx) + " " + year
  } else {
    upper(date_str)
  }
}

#let social_icon(network) = {
  let n = lower(network)
  if n == "github" { fa-github() }
  else if n == "linkedin" { fa-linkedin() }
  else if n == "twitter" or n == "x" { fa-x-twitter() }
  else { fa-globe() }
}

#let section_title(title) = {
  v(14pt, weak: true)
  block(width: 100%)[
    #set text(fill: primary_color, weight: "bold", size: 1.1em)
    #upper(title)
  ]
  v(4pt)
}

// --- HEADER SECTION ---

#grid(
  columns: (1fr, 150pt),
  gutter: 25pt,
  [
    // --- LEFT SIDE: NAME & SUMMARY ---
    #text(size: 2.6em, weight: "bold", fill: primary_color)[#data.basics.name] \
    #v(2pt)
    #text(weight: "bold", size: 1.05em)[#data.basics.label] \
    #v(4pt)
    #set text(size: 0.9em, weight: "regular")
    #data.basics.summary
  ],
  [
    // --- RIGHT SIDE: CONTACT INFO ---
    #set align(left + bottom)
    #set text(size: 0.95em)
    #v(10pt)
    #link("mailto:" + data.basics.email)[#fa-envelope() #data.basics.email] #h(4pt) \
    #fa-phone() #data.basics.phone #h(4pt) \
    #for profile in data.basics.profiles [
      #link(profile.url)[#social_icon(profile.network) #profile.username] #h(4pt) \
    ]
  ]
)

#v(20pt)

// --- MAIN BODY (TWO COLUMNS) ---

#grid(
  columns: (1fr, 150pt),
  column-gutter: 25pt,
  [
    // --- LEFT COLUMN: EXPERIENCE ---
    #section_title("Work Experience")
    #for job in data.work {
      v(6pt, weak: true)
      grid(
        columns: (1fr, auto),
        [_#job.name _], [*#job.position*],
        "", "",
        [_#job.location _], [#text(size: 0.85em, weight: "light")[#upper(format_date(job.startDate)) - #upper(format_date(job.endDate))]]
      )
      v(2pt)
      for highlight in job.highlights {
        set text(size: 0.9em)
        list(highlight, marker: [•], indent: 4pt, body-indent: 6pt)
      }
      v(8pt)
    }

    // --- LEFT COLUMN: EDUCATION ---
    #section_title("Education")
    #for edu in data.education [
      #v(4pt, weak: true)
      #grid(
        columns: (1fr, auto),
        [*#edu.institution*], [*#format_date(edu.startDate) - #format_date(edu.endDate)*],
        "", "",
        [_#edu.area (#edu.studyType)_], []
      )
      #v(8pt)
    ]

    // --- LEFT COLUMN: PROJECTS ---
    #section_title("Projects")
    #for project in data.projects {
      v(4pt, weak: true)
      grid(
        columns: (1fr, auto),
        [*#project.name*], [*#project.roles.first()*]
      )
      v(2pt)
      for h in project.highlights {
        set text(size: 0.9em)
        list(h, marker: [•], indent: 4pt, body-indent: 6pt)
      }
    }
  ],
  [
    // --- RIGHT COLUMN: SIDEBAR ---
    #section_title("Technical Skills")
    #for skill_cat in data.skills [
      #v(6pt, weak: true)
      *#skill_cat.name* \
      #v(2pt)
      #text(size: 0.88em, fill: rgb("#444444"))[#skill_cat.keywords.join(", ")]
      #v(6pt)
    ]

    #if "languages" in data [
      #section_title("Languages")
      #for lang in data.languages [
        #v(4pt)
        #grid(
        columns: (1fr, auto),
        [*#lang.language*], [#text(size: 0.85em, style: "italic")[#lang.fluency]]
        )
        #v(-8pt)
      ]
    ]
  ]
)