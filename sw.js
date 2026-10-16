const CACHE='sppg-peki-v2';
const ASSETS=['./','./index.html','./v2-kerja.html','./manifest.json'];
self.addEventListener('install',e=>{ e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS))); });
self.addEventListener('fetch',e=>{ e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request))); });
