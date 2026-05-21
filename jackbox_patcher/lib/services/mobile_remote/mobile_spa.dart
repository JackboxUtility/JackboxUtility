// ignore_for_file: prefer_single_quotes
/// Self-contained mobile web app served to phones on the LAN.
/// Vanilla HTML/CSS/JS — no build step needed.
const String kMobileSpaHtml = r"""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>Jackbox Utility – Remote</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg: #1a1a2e;
    --surface: #16213e;
    --card: #0f3460;
    --accent: #e94560;
    --text: #eaeaea;
    --muted: #888;
    --radius: 10px;
    --gap: 12px;
  }

  body {
    background: var(--bg);
    color: var(--text);
    font-family: system-ui, -apple-system, sans-serif;
    min-height: 100dvh;
  }

  header {
    background: var(--surface);
    padding: 14px 16px;
    display: flex;
    align-items: center;
    gap: 10px;
    position: sticky;
    top: 0;
    z-index: 10;
    box-shadow: 0 2px 8px rgba(0,0,0,.5);
  }

  header h1 { font-size: 1.1rem; flex: 1; }

  #status-dot {
    width: 10px; height: 10px;
    border-radius: 50%;
    background: var(--muted);
    flex-shrink: 0;
    transition: background .3s;
  }
  #status-dot.connected { background: #4caf50; }

  .toolbar {
    padding: 10px 12px;
    background: var(--surface);
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    align-items: center;
  }

  #search {
    flex: 1;
    min-width: 150px;
    padding: 8px 12px;
    border-radius: var(--radius);
    border: 1px solid #333;
    background: #222;
    color: var(--text);
    font-size: 0.95rem;
  }

  .filter-btn {
    padding: 7px 12px;
    border-radius: var(--radius);
    border: 1px solid #444;
    background: #222;
    color: var(--muted);
    font-size: 0.8rem;
    cursor: pointer;
    white-space: nowrap;
    transition: background .15s, color .15s, border-color .15s;
  }
  .filter-btn.active {
    background: var(--accent);
    border-color: var(--accent);
    color: #fff;
  }

  .player-filter {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.85rem;
    color: var(--muted);
  }
  .player-filter input[type=range] {
    width: 90px;
    accent-color: var(--accent);
  }
  .player-filter span { min-width: 18px; color: var(--text); }

  #pack-list {
    padding: 12px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .pack-section h2 {
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: .06em;
    color: var(--muted);
    margin-bottom: 8px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .pack-section h2 img {
    width: 28px;
    height: 28px;
    border-radius: 4px;
    object-fit: cover;
  }

  .game-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: var(--gap);
  }

  .game-card {
    background: var(--card);
    border-radius: var(--radius);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    cursor: pointer;
    transition: transform .15s, box-shadow .15s;
    -webkit-tap-highlight-color: transparent;
  }
  .game-card:active { transform: scale(.97); }

  .game-card .thumb {
    width: 100%;
    aspect-ratio: 16/9;
    object-fit: cover;
    background: #0a1929;
  }

  .game-card .info {
    padding: 8px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .game-card .name {
    font-size: 0.82rem;
    font-weight: 600;
    line-height: 1.3;
  }

  .game-card .players {
    font-size: 0.72rem;
    color: var(--muted);
  }

  .launch-btn {
    margin-top: auto;
    padding: 6px;
    background: var(--accent);
    border: none;
    border-radius: 6px;
    color: #fff;
    font-size: 0.78rem;
    font-weight: 600;
    cursor: pointer;
    width: 100%;
    transition: opacity .15s;
  }
  .launch-btn:active { opacity: 0.7; }

  .empty {
    text-align: center;
    color: var(--muted);
    padding: 40px 20px;
    font-size: 0.9rem;
  }

  .toast {
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%) translateY(100px);
    background: #333;
    color: #fff;
    padding: 10px 20px;
    border-radius: 20px;
    font-size: 0.85rem;
    transition: transform .3s;
    z-index: 100;
    pointer-events: none;
  }
  .toast.show { transform: translateX(-50%) translateY(0); }
</style>
</head>
<body>

<header>
  <div id="status-dot"></div>
  <h1>Jackbox Remote</h1>
</header>

<div class="toolbar">
  <input id="search" type="search" placeholder="Search games…" autocomplete="off">
  <div id="filter-buttons"></div>
  <div class="player-filter">
    <span>👥</span>
    <input id="players-range" type="range" min="1" max="11" step="1" value="1">
    <span id="players-label">any</span>
  </div>
</div>

<div id="pack-list"></div>
<div class="toast" id="toast"></div>

<script>
// ── state ──────────────────────────────────────────────────────────────────
let packs = [];
let state = {
  search: '',
  filters: [],     // [{filterType,activated,selected}]
  intFilters: [
    {type:'minPlayers', activated:false, selected:1},
    {type:'maxPlaytime', activated:false, selected:30}
  ]
};
let ws = null;
let reconnectTimer = null;

// ── WebSocket ──────────────────────────────────────────────────────────────
function connect() {
  const url = 'ws://' + location.host + '/ws';
  ws = new WebSocket(url);

  ws.onopen = () => {
    document.getElementById('status-dot').classList.add('connected');
    fetchGames();
  };

  ws.onclose = () => {
    document.getElementById('status-dot').classList.remove('connected');
    clearTimeout(reconnectTimer);
    reconnectTimer = setTimeout(connect, 3000);
  };

  ws.onmessage = (evt) => {
    try {
      const msg = JSON.parse(evt.data);
      if (msg.type === 'state') {
        applyStateFromDesktop(msg);
      } else if (msg.type === 'game_list') {
        packs = msg.packs || [];
        renderGames();
      }
    } catch(e) {}
  };
}

function sendWs(obj) {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify(obj));
  }
}

// ── data ───────────────────────────────────────────────────────────────────
async function fetchGames() {
  try {
    const r = await fetch('/api/games');
    const data = await r.json();
    packs = data.packs || [];
    if (data.state) applyStateFromDesktop(data.state);
    renderGames();
    renderFilters();
  } catch(e) {
    document.getElementById('pack-list').innerHTML =
      '<p class="empty">Could not load games. Is the app running?</p>';
  }
}

function launchGame(gameId, gameName) {
  sendWs({type:'launch', gameId});
  showToast('Launching ' + gameName + '…');
}

// ── state sync ─────────────────────────────────────────────────────────────
function pushState() {
  sendWs({type:'state_update', ...state});
}

function applyStateFromDesktop(msg) {
  if (msg.search !== undefined) {
    state.search = msg.search;
    document.getElementById('search').value = msg.search;
  }
  if (msg.filters) {
    state.filters = msg.filters;
  }
  if (msg.intFilters) {
    state.intFilters = msg.intFilters;
    const mp = state.intFilters.find(f => f.type === 'minPlayers');
    if (mp) {
      const range = document.getElementById('players-range');
      range.value = mp.activated ? mp.selected : 1;
      updatePlayersLabel();
    }
  }
  renderFilters();
  renderGames();
}

// ── render ─────────────────────────────────────────────────────────────────
function renderFilters() {
  const container = document.getElementById('filter-buttons');
  container.innerHTML = '';
  state.filters.forEach(f => {
    const btn = document.createElement('button');
    btn.className = 'filter-btn' + (f.activated ? ' active' : '');
    btn.textContent = labelFor(f);
    btn.onclick = () => {
      f.activated = !f.activated;
      renderFilters();
      renderGames();
      pushState();
    };
    container.appendChild(btn);
  });
}

function labelFor(f) {
  const labels = {
    FAMILY_FRIENDLY: '👨‍👩‍👧 Family',
    AUDIENCE: '👥 Audience',
    STREAM_FRIENDLY: '📺 Stream',
    MODERATION: '🛡 Moderation',
    SUBTITLES: '💬 Subtitles',
    TRANSLATION: '🌐 Translated',
  };
  return labels[f.filterType] || f.filterType;
}

function gameMatchesFilters(game) {
  const search = state.search.toLowerCase();
  if (search && !game.name.toLowerCase().includes(search)) return false;

  const mp = state.intFilters.find(f => f.type === 'minPlayers');
  if (mp && mp.activated) {
    if (!game.players) return false;
    if (game.players.max < mp.selected || game.players.min > mp.selected) return false;
  }
  return true;
}

function renderGames() {
  const list = document.getElementById('pack-list');
  list.innerHTML = '';
  let anyVisible = false;

  packs.forEach(pack => {
    if (!pack.owned) return;
    const games = (pack.games || []).filter(gameMatchesFilters);
    if (!games.length) return;
    anyVisible = true;

    const section = document.createElement('div');
    section.className = 'pack-section';

    const heading = document.createElement('h2');
    if (pack.icon) {
      const ico = document.createElement('img');
      ico.src = pack.icon;
      ico.alt = '';
      heading.appendChild(ico);
    }
    heading.appendChild(document.createTextNode(pack.name));
    section.appendChild(heading);

    const grid = document.createElement('div');
    grid.className = 'game-grid';

    games.forEach(game => {
      const card = document.createElement('div');
      card.className = 'game-card';

      const thumb = document.createElement('img');
      thumb.className = 'thumb';
      thumb.src = game.thumbnail || '';
      thumb.alt = game.name;
      thumb.loading = 'lazy';

      const info = document.createElement('div');
      info.className = 'info';

      const name = document.createElement('div');
      name.className = 'name';
      name.textContent = game.name;

      const players = document.createElement('div');
      players.className = 'players';
      if (game.players) {
        players.textContent = game.players.min + '–' + game.players.max + ' players';
      }

      const btn = document.createElement('button');
      btn.className = 'launch-btn';
      btn.textContent = '▶ Launch';
      btn.onclick = (e) => { e.stopPropagation(); launchGame(game.id, game.name); };

      info.appendChild(name);
      info.appendChild(players);
      info.appendChild(btn);
      card.appendChild(thumb);
      card.appendChild(info);
      grid.appendChild(card);
    });

    section.appendChild(grid);
    list.appendChild(section);
  });

  if (!anyVisible) {
    list.innerHTML = '<p class="empty">No games match your filters.</p>';
  }
}

// ── UI events ──────────────────────────────────────────────────────────────
document.getElementById('search').addEventListener('input', e => {
  state.search = e.target.value;
  renderGames();
  pushState();
});

function updatePlayersLabel() {
  const range = document.getElementById('players-range');
  const label = document.getElementById('players-label');
  const val = parseInt(range.value, 10);
  label.textContent = val <= 1 ? 'any' : val + '+';
  const mp = state.intFilters.find(f => f.type === 'minPlayers');
  if (mp) {
    mp.activated = val > 1;
    mp.selected = val;
  }
}

document.getElementById('players-range').addEventListener('input', () => {
  updatePlayersLabel();
  renderGames();
  pushState();
});

// ── toast ──────────────────────────────────────────────────────────────────
let toastTimer = null;
function showToast(msg) {
  const el = document.getElementById('toast');
  el.textContent = msg;
  el.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('show'), 2200);
}

// ── boot ───────────────────────────────────────────────────────────────────
connect();
</script>
</body>
</html>
""";
