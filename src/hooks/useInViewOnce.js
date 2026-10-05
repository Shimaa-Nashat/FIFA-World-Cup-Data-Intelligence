import { useEffect, useRef, useState } from "react";

// Returns [ref, seen]: `seen` flips to true the first time the element enters the viewport.
export default function useInViewOnce(threshold) {
  const ref = useRef(null);
  const [seen, setSeen] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setSeen(true);
          observer.disconnect();
        }
      },
      { threshold },
    );
    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, [threshold]);

  return [ref, seen];
}
