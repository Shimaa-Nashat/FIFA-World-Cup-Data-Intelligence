import React, { useEffect,useState  } from "react";
import useInViewOnce from "./hooks/useInViewOnce.js";
import {
  Activity,
  AlertTriangle,
  ArrowRight,
  ArrowUpRight,
  BarChart3,
  StickyNoteCheck,
   DatabaseSearch,
  DatabaseCheck,
  DatabaseX,
  BookOpen,
  Check,
  Database,
  Download,
  FileCode2,
  GitBranch,
  Trophy,
  Users,
} from "lucide-react";
import SiteNav from "./SiteNav.jsx";
import SiteFooter from "./SiteFooter.jsx";
import {
  ANALYTICS_URL,
  BASE,
  DB_META,
  ERD_URL,
  SOURCES,
  fmt,
} from "./data/siteMeta.js";

const DATA_ZIP = `${BASE}Fifa%20worldcup%20data.zip`;
const sourceIcons = [Trophy, BarChart3, Activity, Database, Users];
const sqlStages = [
  {
    number: "01",
    title: "Create database",
    file: "01_create_database.sql",
    description:
      "Create the relational database structure, tables, keys, and constraints.",
  },
  {
    number: "02",
    title: "Load data",
    file: "02_bulk_insert_all.sql",
    description:
      "Load the original CSV datasets into SQL Server in proper relationship order.",
  },
  {
    number: "03",
    title: "Clean data",
    file: "03_update_missing_data.sql",
    description:
      "Complete and update missing data where reliable source information is available.",
  },
  {
    number: "04",
    title: "Analytics",
    file: "04_analytical_queries.sql",
    description:
      "Run 32 analytical queries and create one reusable team-performance view.",
  },
];

const notebooks = [
  [
    DatabaseSearch,
    "01",
    "Data analysis",
    "01_data_analysis.ipynb",
    "Inspect source tables, missing values, duplicates, data types, unique values, and descriptive statistics.",
  ],
  [
    DatabaseX,
    "02",
    "Data cleaning",
    "02_data_cleaning.ipynb",
    "Remove empty and duplicate records, clean fields, standardize dates, and export cleaned datasets.",
  ],
  [
    DatabaseCheck,
    "03",
    "Data validation",
    "03_data_validation.ipynb",
    "Check keys, relationships, match integrity, scores, dates, attendance, and duplicate rows.",
  ],
  [
    Database,
    "04",
    "SQL → Python analysis",
    "04_sql_to_python_analysis.ipynb",
    "Connect to SQL Server and run analytical queries and visualizations from Python.",
  ],
];

const validations = [
  ["Primary keys", "PASS"],
  ["Foreign keys", "PASS"],
  ["Match integrity", "PASS"],
  ["Score integrity", "PASS"],
  ["Duplicate check", "PASS"],
  ["Date validation", "PASS"],
  ["Attendance / capacity", "WARN"],
];

const insights = [
  [
    "01",
    "Goals through the years",
    "Historical men's World Cup scoring from 1930–2026.",
    "insight-1",
    BarChart3,
  ],
  [
    "02",
    "Expected vs actual",
    "2026 match xG compared with actual goals.",
    "insight-2",
    Activity,
  ],
  [
    "03",
    "Ranking vs performance",
    "FIFA pre-tournament ranking compared with 2026 team win rates.",
    "insight-3",
    Trophy,
  ],
  [
    "04",
    "Players and goals",
    "Appearances, goals, and player records across tournaments.",
    "players",
    Users,
  ],
];

const runSteps = [
  [
    "01",
    "Download",
    "Get the source data, SQL scripts, notebooks, and project files.",
  ],
  ["02", "Database", "Set up SQL Server and create the project database."],
  ["03", "SQL", "Run the four SQL scripts in order and load the datasets."],
  [
    "04",
    "Python",
    "Open the notebooks in Jupyter and configure the required input paths and SQL connection.",
  ],
  [
    "05",
    "Web app",
    "Install the Node dependencies, then run the frontend with npm run dev.",
  ],
];

const resources = [
  [
    FileCode2,
    "SQL scripts",
    "Download the complete four-file SQL workflow",
    `${BASE}sql/FIFA_World_Cup_SQL_Scripts.zip`,
    "download",
  ],
  [
    StickyNoteCheck,
    "Python notebooks",
    "Four analysis, cleaning, validation, and SQL notebooks",
    `${BASE}python/FIFA_World_Cup_Python_Scripts.zip`,
    "download",
  ],
  [
    BookOpen,
    "Project documentation",
    "Methodology, workflows, data checks, and run instructions",
    `${BASE}FIFA_World_Cup_Documentation.pdf`,
    "download",
  ],
  [
    GitBranch,
    "Database / ERD",
    "Interactive relational data model",
    ERD_URL,
    "link",
  ],
  [Database, "Source data", "Original project datasets", DATA_ZIP, "download"],
];

function DownloadLink({ href, children, className = "" }) {
  return (
    <a className={`lab-download-action ${className}`} href={href} download>
      {children} <Download size={15} aria-hidden="true" />
    </a>
  );
}

function MetricCount({ value, start }) {
  const target = Number(value.replaceAll(",", ""));
  const [count, setCount] = useState(0);
  useEffect(() => {
    if (!start) return undefined;
    let frame;
    const begin = performance.now();
    const tick = (now) => {
      const progress = Math.min((now - begin) / 1050, 1);
      setCount(Math.round(target * (1 - (1 - progress) ** 4)));
      if (progress < 1) frame = requestAnimationFrame(tick);
    };
    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
  }, [start, target]);
  return count.toLocaleString("en-US");
}

// Section heading: eyebrow + two-line title, with an optional aside (paragraph or link) beside it.
function LabHeading({ eyebrow, title, accent, className = "", children }) {
  return (
    <div className={`lab-heading-v2 ${className}`.trim()}>
      <div>
        <span className="lab-eyebrow">{eyebrow}</span>
        <h2>
          {title}
          <br />
          <em>{accent}</em>
        </h2>
      </div>
      {children}
    </div>
  );
}

function DataLabPage() {
  const [ref, visible] = useInViewOnce(0.25);
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) =>
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        }),
      { threshold: 0.12 },
    );
    document
      .querySelectorAll(".data-lab-page .analytics-reveal")
      .forEach((node) => observer.observe(node));
    return () => observer.disconnect();
  }, []);

  return (
    <div className="data-lab-page">
      <SiteNav />
      <main id="top">
        <section className="lab-hero-v2">
          <div className="lab-shell lab-hero-v2-grid">
            <div className="lab-hero-v2-copy">
              <span className="lab-eyebrow">
                <i /> WORLD CUP DATA, CONNECTED
              </span>
              <h1>
                DATA LAB
                <span>
                  From Data to <em>Insight.</em>
                </span>
              </h1>
              <p>
                One connected view of the tournaments, teams, players, matches,
                and analytical workflows behind the FIFA World Cup.
              </p>
              <div className="lab-hero-v2-actions">
                <DownloadLink className="lab-button lab-button-teal" href={`${BASE}FIFA_World_Cup_Documentation.pdf`}>
                  Download Documentation
                </DownloadLink>
                <a className="lab-button lab-button-light" href={ERD_URL}>
                  Explore ERD <ArrowUpRight size={16} />
                </a>
              </div>
            </div>
            <div className="lab-hero-v2-art">
              <span className="lab-art-index">
                DATA SYSTEM <b>· 1930–2026</b>
              </span>
            </div>
            <span className="lab-metrics-label">
              THE GAME, IN DATA <i /> PROJECT AT A GLANCE
            </span>
            <div className="lab-metrics" aria-label="Project totals">
              {[
                [fmt(DB_META.tables), "Tables"],
                [fmt(DB_META.relationships), "Relationships"],
                [fmt(DB_META.records), "Records"],
                [fmt(DB_META.matches), "Matches"],
                [String(DB_META.tournaments), "Tournaments"],
              ].map(([value, label], index) => (
                <div className={`lab-metric-${index + 1}`} key={label} ref={ref}>
                  <MetricCount value={value} start={visible} />
                  <span>{label}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section className="lab-sources-v2 source-lab-heading-v2 analytics-reveal" id="sources">
          <div className="lab-shell">
            <LabHeading
              eyebrow="01 / DATA SOURCES"
              title="The data behind"
              accent="the analysis."
            >
              <DownloadLink href={DATA_ZIP}>Download data ZIP</DownloadLink>
            </LabHeading>
            <div className="lab-source-grid">
              {SOURCES.map(([title, description], index) => {
                const Icon = sourceIcons[index] || Database;
                return (
                  <article className="lab-source-card" key={title}>
                    <div className="lab-card-left">
                      <span className="lab-source-icon">
                        <Icon size={19} />
                      </span>
                      <div>
                        <h3>{title}</h3>
                        <p>{description}</p>
                      </div>
                    </div>
                    <div className="lab-card-right">
                      <small>0{index + 1} / SOURCE</small>
                    </div>
                  </article>
                );
              })}
            </div>
          </div>
        </section>

        <section className="lab-pipeline-v2 analytics-reveal" id="sql">
          <div className="lab-shell">
            <LabHeading
              eyebrow="02 / SQL"
              title="Building the database"
              accent="from structure to analysis."
              className="lab-heading-dark"
            >
              <p>
                SQL Server was used to build the database, load source data,
                clean and validate records, and create the analytical queries
                that feed the analytics.
              </p>
            </LabHeading>
            <div className="lab-pipeline-track">
              {sqlStages.map((stage, index) => (
                <React.Fragment key={stage.file}>
                  <article className="lab-pipeline-card">
                    <div className="lab-pipeline-card-head">
                      <span>{stage.number}</span>
                      <FileCode2 size={19} />
                    </div>
                    <h3>{stage.title}</h3>
                    <p className="lab-stage-description">{stage.description}</p>
                    <DownloadLink
                      className="lab-stage-download"
                      href={`${BASE}sql/${stage.file}`}
                    >
                      Download script
                    </DownloadLink>
                  </article>
                  {index < sqlStages.length - 1 && (
                    <ArrowRight
                      className="lab-pipeline-arrow"
                      size={18}
                      aria-hidden="true"
                    />
                  )}
                </React.Fragment>
              ))}
            </div>
            <div className="lab-sql-workflow">
              <span>SQL WORKFLOW</span>
              <b>DATABASE SCHEMA</b>
              <ArrowRight size={14} />
              <b>CSV IMPORT</b>
              <ArrowRight size={14} />
              <b>DATA VALIDATION</b>
              <ArrowRight size={14} />
              <b>ANALYTICAL QUERIES</b>
              <ArrowRight size={14} />
              <b>ANALYTICS DASHBOARD</b>
            </div>
          </div>
        </section>

        <section className="lab-python-v2 analytics-reveal" id="python">
          <div className="lab-shell">
            <LabHeading
              eyebrow="03 / PYTHON"
              title="Analysis"
              accent="beyond the database."
            >
              <p>
                Python notebooks explore, clean, validate, analyze, and
                visualize the datasets and database outputs.
              </p>
            </LabHeading>
            <ol className="lab-python-flow">
              <li>DATA LOADING</li>
              <ArrowRight />
              <li>EDA</li>
              <ArrowRight />
              <li>DATA VALIDATION</li>
              <ArrowRight />
              <li>STATISTICAL ANALYSIS</li>
              <ArrowRight />
              <li>VISUALIZATION</li>
            </ol>
            <div className="lab-notebook-grid">
              {notebooks.map(([Icon, number, title, file, description]) => (
                <article className="lab-notebook-card" key={file}>
                  <span className="lab-notebook-number">
                    {number} / NOTEBOOK
                  </span>
                  <Icon size={20} />
                  <h3>{title}</h3>
                  <p>{description}</p>
                  <DownloadLink href={`${BASE}python/${file}`}>
                    Download notebook
                  </DownloadLink>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section className="lab-validation-v2 analytics-reveal" id="validation">
          <div className="lab-shell">
            <LabHeading
              eyebrow="04 / DATA VALIDATION"
              title="Trust the data."
              accent="Validate before analysis."
            />
            <p className="lab-validation-intro">
              Validation confirms database keys, relationships, match integrity,
              scores, dates, and duplicate records. The report covers 13 cleaned
              CSV tables and 69,309 records.
            </p>
            <div className="lab-validation-grid">
              {validations.map(([name, status]) => {
                const Icon = status === "WARN" ? AlertTriangle : Check;
                return (
                  <article
                    className={`lab-validation-card ${status.toLowerCase()}`}
                    key={name}
                  >
                    <Icon size={19} />
                    <span>{name}</span>
                    <b>{status}</b>
                  </article>
                );
              })}
            </div>
            <p className="lab-validation-warning">
              <AlertTriangle size={16} />{" "}
              <strong>99 attendance/capacity warnings</strong> flagged for
              review. They remain warnings in the validation report.
            </p>
            <DownloadLink
              className="lab-validation-download"
              href={`${BASE}validation/validation_report.csv`}
            >
              Download validation report
            </DownloadLink>
          </div>
        </section>

        <section className="lab-erd-v2 analytics-reveal" id="database">
          <div className="lab-shell lab-erd-v2-grid">
            <div className="lab-erd-v2-copy">
              <span className="lab-eyebrow">05 / THE DATABASE</span>
              <h2>
                The connected
                <br />
                <em>World Cup model.</em>
              </h2>
              <p>
                Follow the relationships linking tournaments, teams, players,
                matches, goals, rankings, and stadiums.
              </p>
              <div className="lab-erd-stats">
                <span>
                  <b>{DB_META.tables}</b> Tables
                </span>
                <i />
                <span>
                  <b>{DB_META.relationships}</b> Relationships
                </span>
                <i />
                <span>
                  <b>{fmt(DB_META.records)}</b> Records
                </span>
              </div>
            </div>
            <div className="lab-erd-preview">
              <div className="lab-erd-preview-bar">
                <span>
                  <i /> ERD PREVIEW
                </span>
              </div>
              <iframe
                src={ERD_URL}
                title="Interactive FIFA World Cup ERD preview"
                loading="lazy"
              />
              <div className="lab-erd-preview-caption">
                <a href={ERD_URL}>
                  Explore interactive ERD <ArrowUpRight size={15} />
                </a>
              </div>
            </div>
          </div>
        </section>

        <section className="lab-analytics-v2 analytics-reveal" id="analytics">
          <div className="lab-shell">
            <LabHeading
              eyebrow="06 / ANALYTICS"
              title="From data"
              accent="to insight."
            >
              <p>
                Explore the visualizations already available in the project
                analytics.
              </p>
            </LabHeading>
            <div className="lab-insight-grid">
              {insights.map(([number, title, description, anchor, Icon]) => (
                <a
                  className="lab-insight-card"
                  href={`${ANALYTICS_URL}#${anchor}`}
                  key={anchor}
                >
                  <div>
                    <span>{number} / INSIGHT</span>
                    <Icon size={20} />
                  </div>
                  <h3>{title}</h3>
                  <p>{description}</p>
                  <b>
                    VIEW ANALYSIS <ArrowUpRight size={14} />
                  </b>
                </a>
              ))}
            </div>
          </div>
        </section>

        <section className="lab-run-v2 analytics-reveal" id="how-to-run">
          <div className="lab-shell">
            <LabHeading
              eyebrow="07 / HOW TO RUN"
              title="Run the"
              accent="project."
            >
              <p>
                From the source files to the analytics experience, follow these
                five steps.
              </p>
            </LabHeading>
            <ol className="lab-run-steps">
              {runSteps.map(([number, title, detail]) => (
                <li key={number}>
                  <span>{number}</span>
                  <div>
                    <h3>{title}</h3>
                    <p>{detail}</p>
                  </div>
                  <ArrowRight size={17} />
                </li>
              ))}
            </ol>
          </div>
        </section>

        <section className="lab-resources-v2 analytics-reveal" id="resources">
          <div className="lab-shell lab-resources-row">
            <div>
              <span className="lab-eyebrow">08 / PROJECT RESOURCES</span>
              <h2>
                Everything
                <br />
                <em>in one place.</em>
              </h2>
            </div>
            <div className="lab-resource-stack">
              {resources.map(([Icon, title, description, href, kind]) => (
                <a
                  key={title}
                  href={href}
                  download={kind === "download" || undefined}
                >
                  <Icon />
                  <span>
                    <b>{title}</b>
                    <small>{description}</small>
                  </span>
                  {kind === "download" ? (
                    <Download size={16} />
                  ) : (
                    <ArrowUpRight size={16} />
                  )}
                </a>
              ))}
            </div>
          </div>
        </section>
      </main>
      <SiteFooter />
    </div>
  );
}

export default DataLabPage;
