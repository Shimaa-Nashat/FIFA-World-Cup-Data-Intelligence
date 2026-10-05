import React, { useEffect, useState } from "react";
import {
  ArrowDown,
  ArrowRight,
  ArrowUpRight,
  BarChart3,
  ClipboardList,
  CircleDot,
  Database,
  Goal,
  GitBranch,
  Network,
  ScanLine,
  Shield,
  Sparkles,
  Trophy,
  User,
  Users,
} from "lucide-react";
import { IoIosFootball } from "react-icons/io";
import { HiMiniUsers } from "react-icons/hi2";
import SiteNav from "./SiteNav.jsx";
import SiteFooter from "./SiteFooter.jsx";
import AnalyticsPage from "./AnalyticsPage.jsx";
import DataLabPage from "./DataLabPage.jsx";
import useInViewOnce from "./hooks/useInViewOnce.js";
import {
  ANALYTICS_URL,
  DB_META,
  DB_SUMMARY,
  ERD_URL as erd,
  STATS,
  fmt,
} from "./data/siteMeta.js";

const erdIcons = [Trophy, Shield, User, CircleDot, Goal, ClipboardList];
const overviewAreas = [
  [
    "Tournament history",
    "Men's and women's tournament, team, player, match, and event records.",
    Trophy,
  ],
  [
    "2026 match detail",
    "Match and player performance measures for the available 2026 men's dataset.",
    Network,
  ],
  [
    "Rankings and references",
    "FIFA ranking snapshots, federations, confederations, and stadium records.",
    BarChart3,
  ],
];

const steps = [
  ["Raw data", "Multiple World Cup data sources", Database],
  ["Data cleaning", "Standardization and missing-data handling", ScanLine],
  ["Integration", "Historical + 2026 datasets", GitBranch],
  ["SQL Server", "Normalized relational database", Database],
  [
    "SQL analytics",
    "Queries and visual insights from the available data",
    BarChart3,
  ],
  [
    "Visual insights",
    "Findings and visualizations from the project data",
    Sparkles,
  ],
];

// [title, description, icon, href] -> each card opens the matching part of the Analytics page
const features = [
  [
    "Historical Analysis",
    "Explore how scoring has changed across World Cups since 1930.",
    BarChart3,
    `${ANALYTICS_URL}#insight-1`,
  ],
  [
    "2026 Match Analytics",
    "Compare expected goals with actual scoring in the 2026 match data.",
    Network,
    `${ANALYTICS_URL}#insight-2`,
  ],
  [
    "Ranking & Performance",
    "Compare FIFA pre-tournament rankings with team win rates in the 2026 World Cup.",
    Trophy,
    `${ANALYTICS_URL}#insight-3`,
  ],
  [
    "Player Analytics",
    "Explore the player and goal records behind every tournament.",
    Users,
    `${ANALYTICS_URL}#players`,
  ],
];

function Counter({ value, start }) {
  const [n, setN] = useState(0);
  useEffect(() => {
    if (!start) return;
    if (window.matchMedia?.("(prefers-reduced-motion: reduce)").matches) {
      setN(value);
      return;
    }
    let frame;
    const begin = performance.now();
    const step = (now) => {
      const t = Math.min((now - begin) / 1300, 1);
      const ease = 1 - Math.pow(1 - t, 4);
      setN(Math.round(value * ease));
      if (t < 1) frame = requestAnimationFrame(step);
    };
    frame = requestAnimationFrame(step);
    return () => cancelAnimationFrame(frame);
  }, [start, value]);
  return <>{n.toLocaleString("en-US")}</>;
}

const pitchData = [
  {
    id: "tournaments",
    value: fmt(DB_META.mensTournaments),
    label: "Men's World Cups",
    note: `of ${DB_META.tournaments} tournaments`,
    icon: Trophy,
    detail: `${DB_META.mensTournaments} men's and ${DB_META.womensTournaments} women's tournaments are included.`,
  },
  {
    id: "players",
    value: fmt(DB_META.players),
    label: "Players",
    note: "in the database",
    icon: HiMiniUsers,
    detail: "Verified player records in the project database.",
  },
  {
    id: "matches",
    value: fmt(DB_META.matches),
    label: "Matches",
    note: "World Cup matches",
    icon: IoIosFootball,
    detail: "Verified match records in the project database.",
  },
];

function HeroPitch() {
  const [active, setActive] = useState(null);
  return (
    <div className="hero-visual">
      <img
        className="stadium-image"
        src={`${import.meta.env.BASE_URL}worldcup-stadium.png`}
        alt="Isometric football stadium with data arcs and charts"
      />
      <span className="visual-label">
        <i /> WORLD CUP DATA MAP
      </span>
      <div className="pitch-data-cards">
        {pitchData.map((item) => {
          const Icon = item.icon;
          return (
            <button
              type="button"
              key={item.id}
              className={`stat-card ${item.id}${active === item.id ? " active" : ""}`}
              onMouseEnter={() => setActive(item.id)}
              onMouseLeave={() => setActive(null)}
              onFocus={() => setActive(item.id)}
              onBlur={() => setActive(null)}
              onClick={() => setActive(active === item.id ? null : item.id)}
              aria-label={`${item.value} ${item.label}. ${item.detail}`}
            >
              <span className="data-glyph">
                <Icon size={18} />
              </span>
              <span className="data-copy">
                <strong>{item.value}</strong>
                <b>{item.label}</b>
                <small>{active === item.id ? item.detail : item.note}</small>
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}

function Overview() {
  const [statsRef, count] = useInViewOnce(0.2);

  return (
    <>
      <SiteNav />

      <main id="top">
        <section className="hero analytics-reveal home-reveal">
          <HeroPitch />
          <div className="hero-copy">
            <span className="eyebrow">THE GAME, IN DATA</span>
            <h1>
              FIFA WORLD CUP
              <br />
              <em>ANALYTICS</em>
            </h1>
            <h2>
              Exploring the World Cup through data,
              <br /> database design, and analytics.
            </h2>
            <p>
              From historical tournaments to modern match analytics, explore the
              data behind the world's biggest football tournament.
            </p>
            <div className="actions">
              <a className="gold" href={ANALYTICS_URL}>
                Explore analytics <ArrowRight size={16} />
              </a>
              <a
                className="outline"
                href={erd}
                target="_blank"
                rel="noreferrer"
              >
                Explore ERD <ArrowUpRight size={16} />
              </a>
            </div>
            <div className="years">
              1930 <span /> 2026
            </div>
          </div>
          <a className="scroll" href="#overview">
            SCROLL TO EXPLORE <ArrowDown size={14} />
          </a>
        </section>

        <section className="section stats analytics-reveal home-reveal" id="overview" ref={statsRef}>
          <div className="sectiontop">
            <div>
              <span className="eyebrow">THE PROJECT AT A GLANCE</span>
              <h2>
                A game of <em>scale.</em>
              </h2>
            </div>
            <p>
              A connected data foundation spanning the history and modern
              analysis of the FIFA World Cup.
            </p>
          </div>
          <div className="statgrid">
            {STATS.map(([n, l], i) => (
              <article style={{ "--i": i }} key={l}>
                <small>0{i + 1}</small>
                <strong>
                  <Counter value={n} start={count} />
                </strong>
                <b>{l}</b>
                <span>
                  {l === "Tournaments"
                    ? `${DB_META.mensTournaments} men · ${DB_META.womensTournaments} women`
                    : "verified project total"}
                </span>
              </article>
            ))}
          </div>
          <div className="verified">
            ● &nbsp; VERIFIED DATABASE TOTALS{" "}
            <span>SQL SERVER　·　{DB_SUMMARY}</span>
          </div>
        </section>

        <section className="section timeline analytics-reveal home-reveal" id="timeline">
          <div className="timelineSectiontop">
            <div>
              <span className="eyebrow">A LONG VIEW OF THE GAME</span>
              <h2>
                1930–2026.
                <br />
                <em>One connected story.</em>
              </h2>
            </div>
            <div className="genders">
              <span>
                <b>{DB_META.mensTournaments}</b> MEN'S
                <br />
                TOURNAMENTS
              </span>
              <i />
              <span>
                <b>0{DB_META.womensTournaments}</b> WOMEN'S
                <br />
                TOURNAMENTS
              </span>
            </div>
          </div>
          <div className="track">
            <span className="point first" />
            <span className="point last" />
            <b>1930</b>
            <b>2026</b>
            <small>—　96-YEAR HISTORICAL SPAN　—</small>
          </div>
        </section>

        <section className="section analytics-reveal home-reveal" id="sources">
          <div className="sectiontop">
            <div>
              <span className="eyebrow">THE DATA, ACROSS THE MODEL</span>
              <h2>
                Built from <em>the game.</em>
              </h2>
            </div>
            <p>
              Built from multiple datasets and official references, combined
              into one connected analytics foundation.
            </p>
          </div>
          <div className="cards">
            {overviewAreas.map(([t, d, I], i) => (
              <article className="source" key={t}>
                <small>
                  0{i + 1} / SOURCE <I />
                </small>
                <h3>{t}</h3>
                <p>{d}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="section journey analytics-reveal home-reveal">
          <div className="sectiontop">
            <div>
              <span className="eyebrow">FROM SOURCE TO SIGNAL</span>
              <h2>
                A considered <em>data journey.</em>
              </h2>
            </div>
            <p>
              A clear path from source material to analysis-ready information.
            </p>
          </div>
          <div className="steps">
            {steps.map(([t, d, I], i) => (
              <article style={{ "--i": i }} key={t}>
                <I />
                <small>0{i + 1}</small>
                <h3>{t}</h3>
                <p>{d}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="section model analytics-reveal home-reveal" id="model">
          <div>
            <span className="eyebrow">THE FOUNDATION</span>
            <h2>
              Built as a<br />
              <em>relational data model.</em>
            </h2>
            <p>
              Explore the full relational structure, keys, relationships, and
              interactive ERD.
            </p>
            <strong>{DB_SUMMARY}</strong>
            <a href={erd} className="link" target="_blank" rel="noreferrer">
              EXPLORE THE INTERACTIVE ERD <ArrowRight size={16} />
            </a>
          </div>
          <div className="erdpreview">
            <svg viewBox="0 0 500 330" aria-hidden="true">
              <path d="M250 40L100 140M250 40L400 140M100 160L250 250M400 160L250 250M250 265L100 305M250 265L400 305" />
            </svg>
            {[
              "TOURNAMENTS",
              "TEAMS",
              "PLAYERS",
              "MATCHES",
              "GOALS",
              "PLAYER_APPEARANCES",
            ].map((t, i) => (
              <span className={"node n" + i} key={t}>
                <i>
                  {React.createElement(erdIcons[i], {
                    size: 14,
                    strokeWidth: 1.8,
                  })}
                </i>
                {t}
              </span>
            ))}
            <small>SIMPLIFIED DATA MODEL</small>
          </div>
        </section>

        <section className="section analytics-reveal home-reveal" id="analytics">
          <div className="sectiontop">
            <div>
              <span className="eyebrow">FOUR WAYS INTO THE DATA</span>
              <h2>
                Explore the <em>full picture.</em>
              </h2>
            </div>
            <p>
              A starting point for deeper discovery across eras, players, and
              match performance.
            </p>
          </div>
          <div className="cards featurecards">
            {features.map(([t, d, I, href], i) => (
              <a className="feature" key={t} href={href}>
                <div className={"art art" + i}>
                  <I />
                </div>
                <small>
                  0{i + 1} / AREA <ArrowUpRight size={14} />
                </small>
                <h3>{t}</h3>
                <p>{d}</p>
                <b>EXPLORE ↗</b>
              </a>
            ))}
          </div>
        </section>
      </main>
      <SiteFooter />
    </>
  );
}

function App() {
  const path = window.location.pathname.replace(/\/+$/, "");
  const analytics = path.endsWith("/analytics");
  const documentation = path.endsWith("/documentation");

  // Sections are rendered by React, so the browser can't jump to #hash on first load by itself.
  useEffect(() => {
    const id = decodeURIComponent(window.location.hash.slice(1));
    if (!id || id === "top") {
      window.scrollTo(0, 0);
      return;
    }
    const t = setTimeout(
      () => document.getElementById(id)?.scrollIntoView(),
      60,
    );
    return () => clearTimeout(t);
  }, [analytics, documentation]);

  useEffect(() => {
    if (analytics || documentation) return undefined;

    const sections = document.querySelectorAll(".home-reveal");
    if (!sections.length) return undefined;

    const revealAll =
      window.matchMedia?.("(prefers-reduced-motion: reduce)")?.matches ||
      !("IntersectionObserver" in window);
    if (revealAll) {
      sections.forEach((section) => section.classList.add("is-visible"));
      return undefined;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12 },
    );
    sections.forEach((section) => observer.observe(section));
    return () => observer.disconnect();
  }, [analytics, documentation]);

  if (documentation) return <DataLabPage />;
  return analytics ? <AnalyticsPage /> : <Overview />;
}

export default App;
