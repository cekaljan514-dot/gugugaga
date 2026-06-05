let organigramContainer = null;
let searchInput = null;
let treeRoots = [];
const apiUrl = `${window.location.origin}/api/employees.php`;

async function loadEmployees() {
  try {
    if (window.location.protocol === 'file:') {
      throw new Error('Soubor je otevřený z disku. Otevřete stránku přes webový server (http://localhost/api/employees.php).');
    }

    const response = await fetch(apiUrl, { cache: 'no-store' });
    const contentType = response.headers.get('content-type') || '';
    let responseBody = null;

    if (contentType.includes('application/json')) {
      responseBody = await response.json();
    }

    if (!response.ok) {
      const serverMessage = responseBody?.message || responseBody?.error || 'Organigram momentálně neobsahuje žádné zaměstnance.';
      throw new Error(serverMessage);
    }

    if (responseBody == null) {
      throw new Error('Neplatná nebo prázdná odpověď ze serveru.');
    }

    if (responseBody.status === 'error') {
      throw new Error(responseBody.message || 'Server vrátil chybu.');
    }

    let rawTree = null;
    if (Array.isArray(responseBody)) {
      rawTree = responseBody;
    } else if (responseBody.status === 'success' && responseBody.tree != null) {
      rawTree = responseBody.tree;
    } else if (typeof responseBody === 'object') {
      rawTree = responseBody.tree ?? responseBody.data ?? responseBody;
    }

    if (rawTree == null) {
      const message = responseBody.error || responseBody.message || 'Neplatná nebo neočekávaná odpověď ze serveru.';
      throw new Error(message);
    }

    const rootsArray = Array.isArray(rawTree) ? rawTree : Object.values(rawTree);
    if (rootsArray.length === 0) {
      renderEmptyState();
      return;
    }

    treeRoots = normalizeTree(rootsArray);
    renderOrganigram(treeRoots);
  } catch (error) {
    const userMessage = error instanceof TypeError
      ? 'Server neodpovídá, zkuste to prosím později.'
      : String(error.message);
    renderError(userMessage);
  }
}

function normalizeTree(data) {
  return data.map(normalizeNode);
}

function normalizeNode(item) {
  const childrenRaw = item.children ?? item.childrens ?? item.children_list ?? [];
  let children = [];
  if (Array.isArray(childrenRaw)) {
    children = childrenRaw.map(normalizeNode);
  } else if (childrenRaw && typeof childrenRaw === 'object') {
    children = Object.values(childrenRaw).map(normalizeNode);
  } else {
    children = [];
  }
  return {
    id: item.id ?? item.name ?? Math.random().toString(36).slice(2),
    name: item.name ?? item.label ?? 'Neznámý zaměstnanec',
    title: item.title ?? item.position ?? '',
    children,
    expanded: children.length > 0,
    matchesSearch: true,
    selfMatch: false,
    dom: null
  };
}

function renderOrganigram(nodes) {
  if (!organigramContainer) return;
  if (!Array.isArray(nodes) || nodes.length === 0) {
    renderEmptyState();
    return;
  }

  organigramContainer.innerHTML = '';
  const fragment = document.createDocumentFragment();
  nodes.forEach(node => fragment.appendChild(createNodeElement(node)));
  organigramContainer.appendChild(fragment);
}

function renderMessage(text, textColor, backgroundColor) {
  if (!organigramContainer) return;
  organigramContainer.classList.remove('no-results');
  organigramContainer.innerHTML = '';

  const messageBlock = document.createElement('div');
  messageBlock.style.color = textColor;
  messageBlock.style.background = backgroundColor;
  messageBlock.style.padding = '18px';
  messageBlock.style.border = '1px solid rgba(157, 30, 72, 0.12)';
  messageBlock.style.borderRadius = '12px';
  messageBlock.style.boxShadow = '0 8px 20px rgba(0, 0, 0, 0.08)';
  messageBlock.style.maxWidth = '920px';
  messageBlock.style.margin = '26px auto';
  messageBlock.style.textAlign = 'center';
  messageBlock.style.lineHeight = '1.5';
  messageBlock.textContent = text;

  organigramContainer.appendChild(messageBlock);
}

function renderError(message) {
  renderMessage(message, '#9b2c2c', '#fee2e2');
}

function renderEmptyState() {
  renderMessage('Organigram momentálně neobsahuje žádné zaměstnance.', '#102a43', '#f4f6fb');
}

function createNodeElement(node) {
  const nodeEl = document.createElement('div');
  nodeEl.className = 'org-node';

  const headerEl = document.createElement('div');
  headerEl.className = 'org-node-header';

  const toggleButton = document.createElement('button');
  toggleButton.type = 'button';
  toggleButton.className = 'org-toggle';
  toggleButton.textContent = node.children.length ? (node.expanded ? '−' : '+') : '';
  toggleButton.title = node.children.length ? 'Rozbalit / sbalit' : '';
  if (!node.children.length) {
    toggleButton.classList.add('empty');
  }

  const infoEl = document.createElement('div');
  infoEl.className = 'org-node-info';

  const nameEl = document.createElement('div');
  nameEl.className = 'org-node-name';
  nameEl.textContent = node.name;

  const titleEl = document.createElement('div');
  titleEl.className = 'org-node-title';
  titleEl.textContent = node.title;

  infoEl.append(nameEl, titleEl);
  headerEl.append(toggleButton, infoEl);
  nodeEl.appendChild(headerEl);

  const childrenContainer = document.createElement('div');
  childrenContainer.className = 'org-children';
  nodeEl.appendChild(childrenContainer);

  node.dom = { nodeEl, headerEl, toggleButton, childrenContainer };

  node.children.forEach(child => childrenContainer.appendChild(createNodeElement(child)));

  headerEl.addEventListener('click', () => {
    if (node.children.length) toggleNode(node);
  });

  toggleButton.addEventListener('click', event => {
    event.stopPropagation();
    toggleNode(node);
  });

  updateNodeElement(node);
  return nodeEl;
}

function updateNodeElement(node) {
  if (!node.dom) return;
  const { toggleButton, childrenContainer, headerEl } = node.dom;
  const hasChildren = node.children.length > 0;
  headerEl.classList.toggle('has-children', hasChildren);
  toggleButton.textContent = hasChildren ? (node.expanded ? '−' : '+') : '';
  toggleButton.setAttribute('aria-expanded', String(node.expanded));
  childrenContainer.classList.toggle('collapsed', !node.expanded);
}

function toggleNode(node) {
  node.expanded = !node.expanded;
  updateNodeElement(node);
}

function setSearchMatch(node, query) {
  const normalized = query.trim().toLowerCase();
  if (!normalized) {
    node.matchesSearch = true;
    node.selfMatch = false;
    node.children.forEach(child => setSearchMatch(child, query));
    return true;
  }

  node.selfMatch = node.name.toLowerCase().includes(normalized) || node.title.toLowerCase().includes(normalized);
  const childMatch = node.children.some(child => setSearchMatch(child, query));
  node.matchesSearch = node.selfMatch || childMatch;
  if (childMatch || node.selfMatch) node.expanded = true;
  return node.matchesSearch;
}

function expandPathToNode(node, parent = null) {
  if (!node.dom) return;
  node.expanded = true;
  updateNodeElement(node);
  if (parent) {
    expandPathToNode(parent);
  }
}

function findParent(targetNode, searchInNode = null) {
  if (!searchInNode) {
    for (let root of treeRoots) {
      const parent = findParent(targetNode, root);
      if (parent) return parent;
    }
    return null;
  }
  
  if (searchInNode.children.includes(targetNode)) {
    return searchInNode;
  }
  
  for (let child of searchInNode.children) {
    const parent = findParent(targetNode, child);
    if (parent) return parent;
  }
  
  return null;
}

function expandPathToAllMatches(nodes, query) {
  const normalized = query.trim().toLowerCase();
  if (!normalized) return;
  
  function expandMatchingNodes(node, parents = []) {
    if (node.selfMatch) {
      node.expanded = true;
      if (node.dom) updateNodeElement(node);
      parents.forEach(parent => {
        parent.expanded = true;
        if (parent.dom) updateNodeElement(parent);
      });
    }
    node.children.forEach(child => expandMatchingNodes(child, [...parents, node]));
  }
  
  nodes.forEach(root => expandMatchingNodes(root));
}

function updateVisibility(node, query) {
  if (!node.dom) return;
  node.dom.nodeEl.style.display = node.matchesSearch ? '' : 'none';
  node.dom.headerEl.classList.toggle('search-match', !!query && node.selfMatch);
  node.children.forEach(child => updateVisibility(child, query));
}

function applySearchFilter(query) {
  const hasQuery = query.trim().length > 0;
  const anyMatch = treeRoots.some(root => setSearchMatch(root, query));
  
  // Expand path to all matching nodes
  if (hasQuery) {
    expandPathToAllMatches(treeRoots, query);
  }
  
  treeRoots.forEach(root => updateVisibility(root, query));
  organigramContainer.classList.toggle('no-results', hasQuery && !anyMatch);
}

async function handleLogout() {
  try {
    const response = await fetch('/gugugaga/api/logout.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }
    });
    window.location.href = '/gugugaga/api/logout.php';
  } catch (error) {
    console.error('Logout error:', error);
    window.location.href = '/gugugaga/api/logout.php';
  }
}

document.addEventListener('DOMContentLoaded', () => {
  organigramContainer = document.getElementById('organigram');
  searchInput = document.getElementById('organigramSearch');
  const logoutBtn = document.getElementById('logoutBtn');

  if (searchInput) {
    searchInput.addEventListener('input', () => applySearchFilter(searchInput.value));
  }

  if (logoutBtn) {
    logoutBtn.addEventListener('click', handleLogout);
  }

  if (organigramContainer) {
    loadEmployees();
  }
});
