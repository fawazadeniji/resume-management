// --- CONFIGURATION ---
#import "@preview/iconic-salmon-fa:1.1.0": *

#let data_file = sys.inputs.at("data", default: "resume.json")
#let data = json("/data/" + data_file)
#let primary_color = rgb("#2E58FF")

#set page(
  margin: (x: 1.5cm, y: 1.5cm),
  paper: "a4",
)

#set text(
  font: ("Noto Sans", "New Computer Modern"),
  size: 10pt,
  fill: rgb("#333333"),
)

// --- HELPERS ---

#let format_date(date_str) = {
  if date_str == "" or date_str == none { return "Present" }
  let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  let parts = date_str.split("-")
  let year = parts.at(0)
  if parts.len() >= 2 {
    let month_idx = int(parts.at(1)) - 1
    months.at(month_idx) + " " + year
  } else {
    year
  }
}

#let social_icon(network) = {
  let n = lower(network)
  if n == "github" { fa-github() }
  else if n == "linkedin" { fa-linkedin() }
  else if n == "twitter" { fa-x-twitter() }
  else if n == "x" { fa-x-twitter() }
  else { fa-globe() }
}

#let section_title(title) = {
  v(12pt)
  block(width: 100%)[
    #set text(fill: primary_color, weight: "bold", size: 1.1em)
    #upper(title)
    #v(-6pt)
    #line(length: 100%, stroke: 0.5pt + primary_color)
  ]
  v(4pt)
}

// --- HEADER SECTION ---

#grid(
  columns: (1fr, auto),
  [
    #text(size: 2.2em, weight: "bold", fill: primary_color)[#data.basics.name] \
    #text(size: 1.2em, weight: "semibold")[#data.basics.label]
  ],
  [
    #set align(right)
    #set text(size: 0.9em)
    #fa-phone() #data.basics.phone \
    #fa-envelope() #data.basics.email \
    #for profile in data.basics.profiles [
      #social_icon(profile.network) #link(profile.url)[#profile.username] #h(8pt)
    ]
  ]
)

#v(8pt)
#data.basics.summary

// --- WORK EXPERIENCE ---

#section_title("Work Experience")
#for job in data.work {
  v(4pt)
  grid(
    columns: (1fr, auto),
    [*#job.position*], [*#format_date(job.startDate) – #format_date(job.endDate)*],
    [_ #job.name _], [_ #job.location _]
  )
  v(1pt)
  for highlight in job.highlights {
    list(highlight, marker: [-], indent: 4pt)
  }
}

// --- PROJECTS ---

#section_title("Projects")
#for project in data.projects {
  grid(
    columns: (1fr, auto),
    [*#project.name*], [*#project.roles.first()*]
  )
  text(size: 0.9em)[#project.description]
  for h in project.highlights {
    list(h, marker: [·], indent: 4pt)
  }
}

// --- EDUCATION ---

#section_title("Education")
#for edu in data.education {
  grid(
    columns: (1fr, auto),
    [*#edu.institution*], [*#format_date(edu.startDate) – #format_date(edu.endDate)*],
    [#edu.area]
  )
}

// --- SKILLS ---

#section_title("Technologies")
#for skill_cat in data.skills {
  grid(
    columns: (100pt, 1fr),
    [*#skill_cat.name*], [#skill_cat.keywords.join(", ")]
  )
  v(2pt)
}