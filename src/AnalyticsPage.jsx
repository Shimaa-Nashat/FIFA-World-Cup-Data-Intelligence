import React, { useEffect, useState } from "react";
import { ArrowDown, ArrowUpRight } from "lucide-react";
import SiteNav from "./SiteNav.jsx";
import SiteFooter from "./SiteFooter.jsx";
import useInViewOnce from "./hooks/useInViewOnce.js";
import { ERD_URL } from "./data/siteMeta.js";
import {
  analyticsMetrics,
  goalsTrendData,
  playerHighlights,
  rankingPerformanceData,
  topScorers,
  xgResultData,
} from "./data/analyticsData.js";

function useReveal() {
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
      .querySelectorAll(".analytics-reveal")
      .forEach((node) => observer.observe(node));
    return () => observer.disconnect();
  }, []);
}

function AnalyticsHero() {
  return (
    <section className="analytics-hero" id="top">
      <div className="analytics-hero-copy">
        <span className="analytics-eyebrow hero-eyebrow">
          <span>WORLD CUP DATA INTELLIGENCE</span>
          <span className="eyebrow-accent">
            <i />
            ANALYTICS
          </span>
        </span>
        <h1>
          THE GAME,
          <br />
          <em>IN DATA.</em>
        </h1>
        <h2>FIFA WORLD CUP ANALYTICS</h2>
        <p>
          Exploring World Cup history, match performance, and team rankings
          through a connected relational database.
        </p>
        <div className="analytics-actions">
          <a className="analytics-primary" href="#insights">
            Explore insights <ArrowDown size={16} aria-hidden="true" />
          </a>
          <a
            className="analytics-secondary"
            href={ERD_URL}
            target="_blank"
            rel="noreferrer"
          >
            Explore ERD <ArrowUpRight size={16} aria-hidden="true" />
          </a>
        </div>
      </div>
      <div className="analytics-hero-art" aria-hidden="true">
        <div className="hero-orbit orbit-one" />
        <div className="hero-orbit orbit-two" />
        <div className="hero-pitch">
          <i />
          <b />
          <span />
        </div>
        <div className="hero-data-point point-one" />
        <div className="hero-data-point point-two" />
        <div className="hero-data-point point-three" />
        <div className="hero-sparkline">
          <i />
          <i />
          <i />
          <i />
          <i />
          <i />
          <i />
        </div>
        <span className="hero-art-caption">
          1930 <i /> 2026
        </span>
      </div>
      <a className="analytics-scroll" href="#metrics">
        SCROLL TO EXPLORE <ArrowDown size={14} aria-hidden="true" />
      </a>
    </section>
  );
}

function AnalyticsMetrics() {
  const [ref, visible] = useInViewOnce(0.25);
  return (
    <section className="analytics-metrics" id="metrics" ref={ref}>
      <div className="analytics-metrics-intro">
        <span className="analytics-eyebrow">THE DATASET</span>
        <p>
          A connected relational database covering FIFA World Cup data from 1930–2026.
        </p>
      </div>
      <div className="metric-row">
        {analyticsMetrics.map(([value, label], index) => (
          <div className="metric-item" key={label}>
            <small>0{index + 1}</small>
            <strong>
              <MetricCount value={value} start={visible} />
            </strong>
            <span>{label}</span>
          </div>
        ))}
      </div>
    </section>
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

function InsightHeading({ number, eyebrow, title, description }) {
  return (
    <div className="insight-heading">
      <span className="insight-number">{number}</span>
      <div>
        <span className="analytics-eyebrow">{eyebrow}</span>
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

function GoalsTrendChart() {
  const [hover, setHover] = useState(null);
  const W = 860,
    H = 370,
    left = 52,
    right = 20,
    top = 24,
    bottom = 54;
  const minYear = 1930,
    maxYear = 2026,
    minY = 2,
    maxY = 5.8;
  const x = (year) =>
    left + ((year - minYear) / (maxYear - minYear)) * (W - left - right);
  const y = (value) =>
    top + ((maxY - value) / (maxY - minY)) * (H - top - bottom);
  const path = goalsTrendData
    .map((d, i) => `${i ? "L" : "M"} ${x(d.year)} ${y(d.average)}`)
    .join(" ");
  const ticks = [2, 3, 4, 5];
  return (
    <div className="chart-frame goals-chart">
      <div className="chart-legend">
        <span>
          <i /> Average Goals per Match
        </span>
        <span className="legend-2026">
          <i /> 2026 dataset value:{" "}
          {goalsTrendData[goalsTrendData.length - 1].average.toFixed(2)}
        </span>
      </div>
      <div className="svg-chart-scroll">
        <svg
          viewBox={`0 0 ${W} ${H}`}
          role="img"
          aria-label="Line chart of average goals per match at each men's World Cup from 1930 to 2026"
        >
          {ticks.map((tick) => (
            <g key={tick}>
              <line
                x1={left}
                x2={W - right}
                y1={y(tick)}
                y2={y(tick)}
                className="chart-grid"
              />
              <text
                x={left - 12}
                y={y(tick) + 4}
                textAnchor="end"
                className="axis-label"
              >
                {tick.toFixed(1)}
              </text>
            </g>
          ))}
          <text
            x="13"
            y="18"
            className="axis-title"
            transform="rotate(-90 13 18)"
          >
            AVG GOALS / MATCH
          </text>
          {[1930, 1950, 1970, 1990, 2010, 2026].map((year) => (
            <text
              key={year}
              x={x(year)}
              y={H - 18}
              textAnchor="middle"
              className="axis-label"
            >
              {year}
            </text>
          ))}
          <line
            x1={x(2026)}
            x2={x(2026)}
            y1={top}
            y2={H - bottom}
            className="year-marker"
          />
          <text
            x={x(2026) - 10}
            y={y(goalsTrendData[goalsTrendData.length - 1].average) - 18}
            textAnchor="end"
            className="point-caption"
          >
            <tspan className="pc-year">2026</tspan>
            <tspan className="pc-val" dx="8">
              {goalsTrendData[goalsTrendData.length - 1].average.toFixed(2)}
            </tspan>
            <tspan className="pc-unit" dx="6">
              goals / match
            </tspan>
          </text>
          <path d={path} className="goals-line" />
          {goalsTrendData.map((point) => (
            <circle
              key={point.year}
              cx={x(point.year)}
              cy={y(point.average)}
              r={point.year === 2026 ? 9 : 4}
              className={
                point.year === 2026
                  ? "chart-point point-highlight"
                  : "chart-point"
              }
              onMouseEnter={() => setHover(point)}
              onMouseLeave={() => setHover(null)}
              onFocus={() => setHover(point)}
              onBlur={() => setHover(null)}
              tabIndex="0"
            />
          ))}
          {hover && (
            <g className="chart-hover-label" pointerEvents="none">
              <rect
                x={Math.min(x(hover.year) + 10, W - 164)}
                y={Math.max(8, y(hover.average) - 42)}
                width="150"
                height="34"
                rx="5"
              />
              <text
                x={Math.min(x(hover.year) + 20, W - 154)}
                y={Math.max(30, y(hover.average) - 20)}
              >
                {hover.year} · {hover.average.toFixed(2)} goals / match
              </text>
            </g>
          )}
        </svg>
      </div>
      <div className="axis-footnote">TOURNAMENT YEAR</div>
    </div>
  );
}

function XGComparisonChart() {
  const [hover, setHover] = useState(null);
  const max = 3,
    left = 52,
    width = 720,
    baseline = 220,
    chartTop = 30,
    scale = (baseline - chartTop) / max;
  return (
    <div className="chart-frame xg-chart">
      <div className="chart-legend">
        <span>
          <i className="legend-xg" /> Average xG
        </span>
        <span>
          <i className="legend-actual" /> Average actual goals
        </span>
      </div>
      <div className="svg-chart-scroll">
        <svg
          viewBox="0 0 820 285"
          role="img"
          aria-label="Grouped bar chart comparing average expected and actual goals for wins, draws, and losses"
        >
          {[0, 1, 2, 3].map((t) => (
            <g key={t}>
              <line
                x1={left}
                x2={790}
                y1={baseline - t * scale}
                y2={baseline - t * scale}
                className="chart-grid"
              />
              <text
                x={left - 12}
                y={baseline - t * scale + 4}
                textAnchor="end"
                className="axis-label"
              >
                {t}
              </text>
            </g>
          ))}
          {xgResultData.map((item, index) => {
            const cx = 190 + index * 230,
              bw = 44,
              x1 = cx - 50,
              x2 = cx + 6;
            return (
              <g
                key={item.result}
                onMouseEnter={() => setHover(item)}
                onMouseLeave={() => setHover(null)}
                className="bar-group"
                tabIndex="0"
                onFocus={() => setHover(item)}
                onBlur={() => setHover(null)}
              >
                <rect
                  x={x1}
                  y={baseline - item.xg * scale}
                  width={bw}
                  height={item.xg * scale}
                  rx="3"
                  className="bar-xg"
                />
                <rect
                  x={x2}
                  y={baseline - item.actual * scale}
                  width={bw}
                  height={item.actual * scale}
                  rx="3"
                  className="bar-actual"
                />
                <text
                  x={cx}
                  y={baseline + 25}
                  textAnchor="middle"
                  className="axis-label result-label"
                >
                  {item.result.toUpperCase()}
                </text>
                <text
                  x={x1 + bw / 2}
                  y={baseline - item.xg * scale - 9}
                  textAnchor="middle"
                  className="bar-value"
                >
                  {item.xg.toFixed(2)}
                </text>
                <text
                  x={x2 + bw / 2}
                  y={baseline - item.actual * scale - 9}
                  textAnchor="middle"
                  className="bar-value"
                >
                  {item.actual.toFixed(2)}
                </text>
              </g>
            );
          })}
          {hover && (
            <g className="chart-hover-label" pointerEvents="none">
              <rect x="566" y="8" width="235" height="63" rx="6" />
              <text x="580" y="27">
                {hover.result} · {hover.matches} matches
              </text>
              <text x="580" y="44">
                xG {hover.xg.toFixed(2)} · Actual {hover.actual.toFixed(2)}
              </text>
              <text x="580" y="61">
                Difference {hover.difference >= 0 ? "+" : ""}
                {hover.difference.toFixed(2)}
              </text>
            </g>
          )}
        </svg>
      </div>
      <div className="xg-result-strip">
        {xgResultData.map((item) => (
          <div
            key={item.result}
            className={`xg-card xg-${item.result.toLowerCase()}`}
          >
            <div className="xg-card-head">
              <strong>{item.result.toUpperCase()}</strong>
              <small>{item.matches} MATCHES</small>
            </div>
            <dl>
              <div>
                <dt>xG</dt>
                <dd>{item.xg.toFixed(2)}</dd>
              </div>
              <div>
                <dt>ACTUAL</dt>
                <dd>{item.actual.toFixed(2)}</dd>
              </div>
              <div
                className={`xg-diff ${item.difference >= 0 ? "pos" : "neg"}`}
              >
                <dt>ACTUAL − xG</dt>
                <dd>
                  {item.difference >= 0 ? "+" : "−"}
                  {Math.abs(item.difference).toFixed(2)}
                </dd>
              </div>
            </dl>
          </div>
        ))}
      </div>
    </div>
  );
}

function RankingPerformanceChart() {
  const [hover, setHover] = useState(null);
  const dataset = rankingPerformanceData[2026] || [];
  const W = 820,
    H = 410,
    left = 64,
    right = 30,
    top = 26,
    bottom = 58;
  const maxRank = Math.max(
    10,
    Math.ceil(Math.max(...dataset.map((point) => point.rank), 1) / 10) * 10,
  );
  const rankTicks = [...new Set([1, 20, 40, 60, 80, maxRank])].filter(
    (rank) => rank <= maxRank,
  );
  const x = (rank) => left + ((rank - 1) / (maxRank - 1)) * (W - left - right),
    y = (rate) => top + ((100 - rate) / 100) * (H - top - bottom);
  const rates = [0, 25, 50, 75, 100];
  return (
    <div className="chart-frame ranking-chart">
      <div className="ranking-toolbar">
        <strong>2026 DATASET</strong>
        <span>
          {dataset.length} {dataset.length === 1 ? "team" : "teams"} in view
        </span>
      </div>
      <div className="svg-chart-scroll">
        <svg
          viewBox={`0 0 ${W} ${H}`}
          role="img"
          aria-label="Scatter plot of FIFA rank and tournament win rate for the 2026 World Cup"
        >
          {rates.map((tick) => (
            <g key={`y${tick}`}>
              <line
                x1={left}
                x2={W - right}
                y1={y(tick)}
                y2={y(tick)}
                className="chart-grid"
              />
              <text
                x={left - 12}
                y={y(tick) + 4}
                textAnchor="end"
                className="axis-label"
              >
                {tick}%
              </text>
            </g>
          ))}
          {rankTicks.map((tick) => (
            <g key={`x${tick}`}>
              <line
                x1={x(tick)}
                x2={x(tick)}
                y1={top}
                y2={H - bottom}
                className="chart-grid vertical"
              />
              <text
                x={x(tick)}
                y={H - 29}
                textAnchor="middle"
                className="axis-label"
              >
                {tick}
              </text>
            </g>
          ))}
          <text x={W / 2} y={H - 5} textAnchor="middle" className="axis-title">
            FIFA RANK · 1 IS STRONGEST
          </text>
          <text
            x="15"
            y="16"
            className="axis-title"
            transform="rotate(-90 15 16)"
          >
            TOURNAMENT WIN RATE
          </text>
          {dataset.map((point) => (
            <circle
              key={`${point.tournament}-${point.team}`}
              cx={x(point.rank)}
              cy={y(point.winRate)}
              r={hover?.team === point.team ? 11 : 8}
              className="ranking-point"
              onMouseEnter={() => setHover(point)}
              onMouseLeave={() => setHover(null)}
              onFocus={() => setHover(point)}
              onBlur={() => setHover(null)}
              tabIndex="0"
            />
          ))}
          {hover &&
            (() => {
              const tx = Math.min(x(hover.rank) + 12, W - 176),
                ty = Math.max(8, y(hover.winRate) - 112),
                lx = tx + 13;
              const rate = `${+hover.winRate.toFixed(2)}%`;
              return (
                <g
                  className="chart-hover-label ranking-tooltip"
                  pointerEvents="none"
                >
                  <rect x={tx} y={ty} width="164" height="104" rx="6" />
                  <text x={lx} y={ty + 22} className="tip-title">
                    {hover.team}
                  </text>
                  <text x={lx} y={ty + 42}>
                    FIFA Rank: {hover.rank}
                  </text>
                  <text x={lx} y={ty + 58}>
                    Matches: {hover.matches}
                  </text>
                  <text x={lx} y={ty + 74}>
                    Wins: {hover.wins}
                  </text>
                  <text x={lx} y={ty + 90}>
                    Win Rate: {rate}
                  </text>
                </g>
              );
            })()}
        </svg>
      </div>
      <p className="chart-note">
        FIFA rank represents the FIFA ranking dated June 11, 2026. Win rate
        represents tournament match performance in the 2026 dataset.
      </p>
      {dataset.length === 0 && (
        <div className="empty-dataset">
          <span>NO RECORDS FOR THIS SELECTION</span>
          <p>
            Ranking and performance records are available for the 2026
            tournament only.
          </p>
        </div>
      )}
    </div>
  );
}

function PlayerAnalytics() {
  return (
    <>
      <div className="player-stats">
        {playerHighlights.map(([value, label, note]) => (
          <div key={label}>
            <small>{label}</small>
            <strong>{value}</strong>
            <span>{note}</span>
          </div>
        ))}
      </div>
      {topScorers.length > 0 && (
        <ol className="scorer-list">
          {topScorers.map((p, i) => (
            <li key={p.player}>
              <span>{String(i + 1).padStart(2, "0")}</span>
              <b>{p.player}</b>
              <em>{p.team}</em>
              <strong>{p.goals}</strong>
            </li>
          ))}
        </ol>
      )}
      <p className="editorial-conclusion">
        The database links every player record to its matches and goals, which
        is what makes player-level questions — scorers, appearances, careers
        across tournaments — answerable with a single query.
      </p>
    </>
  );
}

function InsightSection({
  id,
  number,
  eyebrow,
  title,
  description,
  children,
  className = "",
}) {
  return (
    <section
      id={id}
      className={`insight-section analytics-reveal ${className}`}
    >
      <InsightHeading
        number={number}
        eyebrow={eyebrow}
        title={title}
        description={description}
      />
      {children}
    </section>
  );
}

function AnalyticsPage() {
  useReveal();
  return (
    <div className="analytics-page">
      <SiteNav />
      <main>
        <AnalyticsHero />
        <AnalyticsMetrics />
        <section className="analytics-intro" id="insights">
          <span className="analytics-eyebrow">ANALYTICS</span>
          <h2>
            FOUR WAYS TO READ
            <br />
            <em>THE WORLD CUP</em>
          </h2>
          <p>
            From long-term scoring trends to modern match performance, FIFA
            rankings, and player records, the data reveals different layers of
            the tournament story.
          </p>
        </section>
        <div className="analytics-stories">
          <InsightSection
            id="insight-1"
            number="01"
            eyebrow="HISTORICAL ANALYSIS"
            title="GOALS THROUGH THE YEARS"
            description="Average goals per match across men's FIFA World Cup tournaments from 1930 to 2026."
          >
            <div className="insight-layout">
              <GoalsTrendChart />
              <aside className="insight-aside">
                <div className="high-low">
                  <div>
                    <small>HISTORICAL HIGH</small>
                    <strong>5.38</strong>
                    <span>1954 · goals / match</span>
                  </div>
                  <div>
                    <small>HISTORICAL LOW</small>
                    <strong>2.21</strong>
                    <span>1990 · goals / match</span>
                  </div>
                  <div>
                    <small>2026</small>
                    <strong>2.96</strong>
                    <span>goals / match</span>
                  </div>
                </div>
                <p>
                  Scoring peaked at 5.38 goals per match in 1954 and reached its
                  lowest point at 2.21 in 1990. The 2026 dataset records 2.96
                  goals per match.
                </p>
              </aside>
            </div>
          </InsightSection>
          <InsightSection
            id="insight-2"
            number="02"
            eyebrow="2026 MATCH ANALYTICS"
            title="EXPECTED VS ACTUAL"
            description="Comparing expected goals with actual scoring across wins, draws, and losses in the 2026 match-performance dataset."
            className="insight-tinted"
          >
            <XGComparisonChart />
            <p className="editorial-conclusion">
              Winning teams in the 2026 match-performance data averaged 2.58
              actual goals against 1.85 expected goals. Draws and losses
              remained below their average expected-goal values.
            </p>
            <small className="descriptive-note">
              <em>
                Descriptive comparison — not a causal or predictive analysis.
              </em>
            </small>
          </InsightSection>
          <InsightSection
            id="insight-3"
            number="03"
            eyebrow="RANKING & TOURNAMENT PERFORMANCE"
            title="RANKING VS PERFORMANCE"
            description="Comparing FIFA pre-tournament rankings with team win rates in the 2026 World Cup."
          >
            <RankingPerformanceChart />
          </InsightSection>
          <InsightSection
            id="players"
            number="04"
            eyebrow="PLAYER ANALYTICS"
            title="PLAYERS AND GOALS"
            description="The player and goal records behind every tournament in the database."
          >
            <PlayerAnalytics />
          </InsightSection>
        </div>
        <section className="analytics-summary analytics-reveal">
          <span className="analytics-eyebrow">CROSS-INSIGHT SUMMARY</span>
          <h2>
            WHAT THE DATA <em>SHOWS</em>
          </h2>
          <div className="summary-statements">
            {[
              [
                "01",
                "SCORING",
                "World Cup scoring rates have changed considerably across tournament history.",
              ],
              [
                "02",
                "MATCH PERFORMANCE",
                "Winning teams recorded higher actual goals than their average expected-goal values in the 2026 match-performance data.",
              ],
              [
                "03",
                "RANKING",
                "FIFA pre-tournament rankings and tournament win rates provide two different views of team performance.",
              ],
            ].map(([n, k, t]) => (
              <article key={n}>
                <small>{n}</small>
                <h3>{k}</h3>
                <p>{t}</p>
              </article>
            ))}
          </div>
        </section>
      </main>
      <SiteFooter />
    </div>
  );
}

export default AnalyticsPage;