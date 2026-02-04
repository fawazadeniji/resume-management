// ================== CONFIGURATION ==================
#import "@preview/iconic-salmon-fa:1.1.0": *

#let data_file = sys.inputs.at("data", default: "resume.json")
#let data = json("/data/" + data_file)

#let primary_color = rgb("#2E58FF")
#let text_gray = rgb("#333333")
#let light_gray = rgb("#666666")

#set page(
  margin: (x: 1.2cm, y: 1.2cm),
  paper: "a4",
)

#set text(
  font: "Raleway",
  size: 10pt,
  fill: text_gray,
  lang: "en",
)

// ================== HELPERS ==================

#let format_date(date_str) = {
  if date_str == "" or date_str == none { return "Present" }
  let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  let parts = str(date_str).split("-")
  if parts.len() >= 2 {
    months.at(int(parts.at(1)) - 1) + " " + parts.at(0)
  } else {
    date_str
  }
}

#let format_range(start, item) = {
  let end = if type(item) == dictionary {
    item.at("endDate", default: none)
  } else {
    item
  }
  format_date(start) + " — " + format_date(end)
}

#let section_title(title) = {
  v(12pt)
  block(width: 100%)[
    #set text(fill: primary_color, weight: "bold", size: 0.95em)
    #upper(title)
  ]
  v(4pt)
}

// ================== HEADER (FULL WIDTH, ATS SAFE) ==================

#block(width: 100%)[
  #text(size: 2.5em, weight: "bold", fill: primary_color)[#data.basics.name]
  #v(2pt)
  #text(weight: "bold", size: 1.05em)[#data.basics.label]
  #v(6pt)

  #set text(size: 0.9em)
  #data.basics.summary

  #v(8pt)
  #set text(size: 0.9em, fill: light_gray)
  Email: #data.basics.email ·
  Phone: #data.basics.phone ·
  #for profile in data.basics.profiles [
    #profile.network: #profile.url ·
  ]
]

#v(18pt)

// ================== BODY (TWO COLUMNS) ==================

#grid(
  columns: (1fr, 150pt),
  column-gutter: 24pt,

  // ================== MAIN COLUMN ==================
  [
    // -------- WORK EXPERIENCE --------
    #section_title("Work Experience")

    #for job in data.work [
      *#job.position*, _#job.name _ \
      #text(size: 0.85em, fill: light_gray)[
        #format_range(job.startDate, job)
        | #job.location
      ]

      #v(2pt)
      #for h in job.highlights [
        #set text(size: 0.9em)
        #list(h, marker: [•], indent: 4pt, body-indent: 6pt)
      ]
      #v(8pt)
    ]

    // -------- EDUCATION --------
    #section_title("Education")
    #for edu in data.education [
      *#edu.institution* \
      #text(size: 0.85em, fill: light_gray)[
        #edu.studyType in #edu.area
        | #format_range(edu.startDate, edu)
      ]
      #v(6pt)
    ]

    // -------- PROJECTS --------
    #if "projects" in data and data.projects.len() > 0 [
      #section_title("Projects")
      #for project in data.projects [
        *#project.name*
        #if "roles" in project and project.roles.len() > 0 [
          #text(size: 0.85em, fill: light_gray)[#project.roles.first()]
        ]
        #v(2pt)
        #for h in project.highlights [
          #set text(size: 0.9em)
          #list(h, marker: [•], indent: 4pt, body-indent: 6pt)
        ]
        #v(6pt)
      ]
    ]
  ],

  // ================== SIDEBAR (NON-CRITICAL ONLY) ==================
  [
    // -------- SKILLS --------
    #section_title("Technical Skills")
    #for skill_cat in data.skills [
      *#skill_cat.name* \
      #text(size: 0.88em, fill: rgb("#444444"))[
        #skill_cat.keywords.join(", ")
      ]
      #v(6pt)
    ]

    // -------- LANGUAGES --------
    #if "languages" in data [
      #section_title("Languages")
      #for lang in data.languages [
        #lang.language — #text(size: 0.85em, style: "italic")[#lang.fluency] \
      ]
    ]
  ]
)
