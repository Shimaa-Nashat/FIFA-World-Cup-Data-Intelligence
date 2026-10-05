import React from 'react';
import { ANALYTICS_URL, BASE, ERD_URL } from './data/siteMeta.js';

const projectLinks = [
  ['SQL', `${BASE}documentation#sql`],
  ['Python notebooks', `${BASE}documentation#python`],
  ['Database / ERD', ERD_URL],
  ['Data Sources', `${BASE}documentation#sources`],
  ['Documentation', `${BASE}documentation#resources`],
];

export default function SiteFooter() {
  return (
    <footer className="site-footer">
      <div className="site-footer-main">
        <div className="site-footer-brand">
          <span className="site-footer-title">WORLD CUP<br /><em>DATA INTELLIGENCE</em></span>
          <p>Exploring FIFA World Cup history through data, database design, and analytics.</p>
        </div>
        <div className="site-footer-column">
          <span className="site-footer-label">NAVIGATION</span>
          <a href={BASE}>HOME</a>
          <a href={ANALYTICS_URL}>ANALYTICS</a>
          <a href={`${BASE}documentation`}>DATA LAB</a>
        </div>
        <div className="site-footer-column">
          <span className="site-footer-label">PROJECT</span>
          {projectLinks.map(([label, href]) => <a key={label} href={href}>{label.toUpperCase()}</a>)}
        </div>
      </div>
      <div className="site-footer-meta">SQL SERVER <i /> RELATIONAL DATA <i /> ANALYTICS</div>
      <div className="site-footer-bottom">
        <span>&copy; {new Date().getFullYear()} World Cup Data Intelligence</span>
        <span>DATA · DATABASE · ANALYTICS</span>
      </div>
    </footer>
  );
}
