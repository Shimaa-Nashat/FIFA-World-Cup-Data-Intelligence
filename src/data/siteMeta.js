// Single source of truth shared by the landing page and the analytics page.
export const BASE = import.meta.env.BASE_URL;
export const ERD_URL = `${BASE}erd/FIFA_WorldCup_ERD.html`;
export const ANALYTICS_URL = `${BASE}analytics`;

export const DB_META = {
  tables: 17,
  relationships: 37,
  records: 211808,
  fifaRankings: 71019,
  matches: 1352,
  players: 11364,
  goals: 3945,
  mensTournaments: 23,
  womensTournaments: 8,
};
DB_META.tournaments = DB_META.mensTournaments + DB_META.womensTournaments; // 31

export const DB_SUMMARY = `${DB_META.tables} TABLES　·　${DB_META.relationships} RELATIONSHIPS`;

// [value, label]
export const STATS = [
  [DB_META.tables, 'Tables'],
  [DB_META.records, 'Records'],
  [DB_META.matches, 'Matches'],
  [DB_META.players, 'Players'],
  [DB_META.goals, 'Goals'],
  [DB_META.tournaments, 'Tournaments'],
];

// [title, description]  (icons are attached where they are rendered)
export const SOURCES = [
  ['Historical World Cup Data', 'Core tournament, team, player, match, goal, booking, substitution, stadium, and attendance data.'],
  ['2026 Match Analytics', 'Detailed player, team, passing-network, and match-performance data for the 2026 tournament.'],
  ['FIFA Ranking Data', 'Historical FIFA ranking snapshots and ranking points used for comparative analysis.'],
  ['Official Stadium Data', 'Official 2026 stadium information including stadium location and final capacity data for the 16 venues.'],
  ['2026 Player Data', '2026 player records including team, position, and birth-date information used to complete and validate player data.'],
];

export const fmt = (n) => n.toLocaleString('en-US');
