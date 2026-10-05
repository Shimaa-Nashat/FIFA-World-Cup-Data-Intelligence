import { DB_META, STATS, fmt } from './siteMeta.js';

export const analyticsMetrics = STATS.map(([value, label]) => [fmt(value), label.toUpperCase()]);

export const goalsTrendData = [
  { year: 1930, average: 3.888888 }, { year: 1934, average: 4.117647 },
  { year: 1938, average: 4.666666 }, { year: 1950, average: 4.000000 },
  { year: 1954, average: 5.384615 }, { year: 1958, average: 3.600000 },
  { year: 1962, average: 2.781250 }, { year: 1966, average: 2.781250 },
  { year: 1970, average: 2.968750 }, { year: 1974, average: 2.552631 },
  { year: 1978, average: 2.684210 }, { year: 1982, average: 2.807692 },
  { year: 1986, average: 2.538461 }, { year: 1990, average: 2.211538 },
  { year: 1994, average: 2.711538 }, { year: 1998, average: 2.671875 },
  { year: 2002, average: 2.515625 }, { year: 2006, average: 2.296875 },
  { year: 2010, average: 2.265625 }, { year: 2014, average: 2.671875 },
  { year: 2018, average: 2.640625 }, { year: 2022, average: 2.687500 },
  { year: 2026, average: 2.961538 },
];

export const xgResultData = [
  { result: 'Win', matches: 84, xg: 1.846666, actual: 2.583333, difference: 0.736667 },
  { result: 'Draw', matches: 40, xg: 1.159750, actual: 0.900000, difference: -0.259750 },
  { result: 'Lose', matches: 84, xg: 0.761666, actual: 0.654761, difference: -0.106905 },
];

const rows2026 = [
  ['Argentina',1,1877.27,8,7,87.50], ['Spain',2,1874.71,8,7,87.50],
  ['France',3,1870.70,8,6,75.00], ['England',4,1828.02,8,6,75.00],
  ['Portugal',5,1767.85,5,2,40.00], ['Brazil',6,1765.86,5,3,60.00],
  ['Morocco',7,1755.10,6,4,66.67], ['Netherlands',8,1753.57,4,2,50.00],
  ['Belgium',9,1742.24,6,3,50.00], ['Germany',10,1735.77,4,2,50.00],
  ['Croatia',11,1714.87,4,2,50.00], ['Colombia',13,1698.35,5,3,60.00],
  ['Mexico',14,1687.48,5,4,80.00], ['Senegal',15,1684.07,4,1,25.00],
  ['Uruguay',16,1673.07,3,0,0.00], ['United States',17,1671.23,5,3,60.00],
  ['Japan',18,1661.58,4,1,25.00], ['Switzerland',19,1650.06,6,4,66.67],
  ['Iran',20,1619.58,3,0,0.00], ['Turkey',22,1605.73,3,1,33.33],
  ['Ecuador',23,1598.52,4,1,25.00], ['Austria',24,1597.40,4,1,25.00],
  ['South Korea',25,1591.63,3,1,33.33], ['Australia',27,1579.34,4,1,25.00],
  ['Algeria',28,1571.03,4,1,25.00], ['Egypt',29,1562.37,5,2,40.00],
  ['Canada',30,1559.48,5,2,40.00], ['Norway',31,1557.44,6,4,66.67],
  ['Ivory Coast',33,1540.87,4,2,50.00], ['Panama',34,1539.16,3,0,0.00],
  ['Sweden',38,1509.79,4,1,25.00], ['Czech Republic',40,1505.74,3,0,0.00],
  ['Paraguay',41,1505.35,5,2,40.00], ['Scotland',42,1503.34,3,1,33.33],
  ['Tunisia',45,1476.41,3,0,0.00], ['Congo DR',46,1474.43,4,1,25.00],
  ['Uzbekistan',50,1458.73,3,0,0.00], ['Qatar',56,1450.31,3,0,0.00],
  ['Iraq',57,1446.28,3,0,0.00], ['South Africa',60,1428.38,4,1,25.00],
  ['Saudi Arabia',61,1423.88,3,0,0.00], ['Jordan',63,1387.74,3,0,0.00],
  ['Bosnia and Herzegovina',64,1387.22,4,1,25.00], ['Cabo Verde',67,1371.11,4,0,0.00],
  ['Ghana',73,1346.88,4,1,25.00], ['Curaçao',82,1294.77,3,0,0.00],
  ['Haiti',83,1293.10,3,0,0.00], ['New Zealand',85,1275.58,3,0,0.00],
].map(([team, rank, fifaPoints, matches, wins, winRate]) => ({
  tournament: 2026, team, rank, fifaPoints, matches, wins, winRate, rankingDate: '2026-06-11',
}));

// The supplied material contains 48 team rows from the 2026 Q31 result.
export const rankingPerformanceData = { 2026: rows2026 };

// Player Analytics: only figures derived from the verified database totals.
// Fill `topScorers` with real query results ([{ player, team, goals }]) to show the ranking table.
export const playerHighlights = [
  [fmt(DB_META.players), 'PLAYERS', 'player records in the database'],
  [fmt(DB_META.goals), 'GOALS', 'goals recorded across all tournaments'],
  [fmt(DB_META.matches), 'MATCHES', 'matches those goals were scored in'],
  [(DB_META.goals / DB_META.matches).toFixed(2), 'GOALS / MATCH', 'across every tournament in the database'],
];
export const topScorers = [];
