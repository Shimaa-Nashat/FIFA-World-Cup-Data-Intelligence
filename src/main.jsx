import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import './index.css';

// Cursor glow (styled in index.css via --pointer-x / --pointer-y)
let pointerFrame = 0;
window.addEventListener('pointermove', (event) => {
  if (event.pointerType === 'touch') return;
  cancelAnimationFrame(pointerFrame);
  pointerFrame = requestAnimationFrame(() => {
    const root = document.documentElement;
    root.style.setProperty('--pointer-x', `${event.clientX}px`);
    root.style.setProperty('--pointer-y', `${event.clientY}px`);
    root.style.setProperty('--pointer-visible', '1');
  });
});
document.documentElement.addEventListener('pointerleave', () => {
  document.documentElement.style.setProperty('--pointer-visible', '0');
});

createRoot(document.getElementById('root')).render(<App />);
