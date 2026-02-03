// --- CONFIGURATION ---
// Data file can be specified via CLI: typst compile --input data=resume-frontend.json ...
// Defaults to resume.json if not specified
#let data_file = sys.inputs.at("data", default: "resume.json")
#let data = json("../data/" + data_file)
#let primary_color = rgb("#2E58FF")

#set page(
  margin: (x: 1.5cm, y: 1.5cm),
  paper: "a4",
)

#set text(
  font: "Noto Sans",
  size: 10pt,
  fill: rgb("#333333"),
)

// --- HELPERS ---

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
    #data.basics.email \
    #data.basics.phone \
    #for profile in data.basics.profiles [
      #link(profile.url)[#profile.network: #profile.username] #h(4pt)
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
    [*#job.position*], [*#job.startDate – #job.endDate*],
    [_ #job.company _], [_ #job.location _]
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
    [*#project.name*], [*#project.role*]
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
    [*#edu.institution*], [*#edu.startDate – #edu.endDate*],
    [#edu.area], [#edu.location]
  )
}

// --- SKILLS ---

#section_title("Technologies")
#for skill_cat in data.skills {
  grid(
    columns: (100pt, 1fr),
    [*#skill_cat.category*], [#skill_cat.keywords.join(", ")]
  )
  v(2pt)
}