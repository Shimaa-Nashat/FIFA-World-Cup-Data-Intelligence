import React, { useState } from 'react';
import { ArrowUpRight, Menu, X } from 'lucide-react';
import { BASE, ANALYTICS_URL, ERD_URL } from './data/siteMeta.js';

const routeLinks = [
  ['home', 'HOME', BASE],
  ['analytics', 'ANALYTICS', ANALYTICS_URL],
  ['documentation', 'DATA LAB', `${BASE}documentation`],
  ['erd', 'Open interactive ERD', ERD_URL],
];

function activeRoute() {
  const path = window.location.pathname.replace(/\/+$/, '') || '/';
  const base = BASE.replace(/\/+$/, '');
  if (path === base || path === `${base}/index.html` || (!base && path === '/')) return 'home';
  if (path.endsWith('/analytics')) return 'analytics';
  if (path.endsWith('/documentation')) return 'documentation';
  if (path.endsWith('/FIFA_WorldCup_ERD.html')) return 'erd';
  return '';
}

export default function SiteNav() {
  const [open, setOpen] = useState(false);
  const close = () => setOpen(false);
  const active = activeRoute();

  return (
    <header className="site-header">
      <a className="brand" href={`${BASE}#top`} onClick={close}>
        <img src={`${BASE}Logo.png`} alt="FIFA World Cup Data Intelligence logo" className="brand-cup" />
        <span className="brand-fifa">FIFA</span>
        <i className="brand-sep" />
        <span className="brand-text">WORLD CUP DATA INTELLIGENCE<small>FIFA World Cup Analytics</small></span>
      </a>
      <button className="menubtn" type="button" onClick={() => setOpen(!open)} aria-label={open ? 'Close navigation menu' : 'Open navigation menu'} aria-expanded={open} aria-controls="global-navigation">
        {open ? <X /> : <Menu />}
      </button>
      <nav id="global-navigation" className={open ? 'show' : ''} onClick={close} aria-label="Main navigation">
        {routeLinks.map(([id, label, href]) => (
          <a key={id} href={href} className={`${active === id ? 'active ' : ''}${id === 'erd' ? 'navcta nav-erd-cta' : ''}`} aria-current={active === id ? 'page' : undefined}>
            {label}
            {id === 'erd' && <ArrowUpRight size={15} aria-hidden="true" />}
          </a>
        ))}
      </nav>
    </header>
  );
}