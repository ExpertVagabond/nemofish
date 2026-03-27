<template>
  <div class="home-container">
    <!-- Navbar -->
    <nav class="navbar">
      <div class="nav-brand">
        <img src="/icon.png" alt="NemoFish" style="width:28px;height:28px;border-radius:6px;margin-right:8px" />
        NEMOFISH
      </div>
      <div class="nav-links-desktop">
        <span style="background:#76B900;color:#000;padding:3px 8px;font-family:'JetBrains Mono',monospace;font-size:0.65rem;font-weight:700;letter-spacing:1px">NIM</span>
        <a href="https://github.com/ExpertVagabond/nemofish" target="_blank" class="github-link">GitHub ↗</a>
        <button style="background:transparent;color:#76B900;border:1px solid #333;padding:6px 14px;font-family:'JetBrains Mono',monospace;font-size:0.75rem;font-weight:600;cursor:pointer" @click="connectWallet">Connect Wallet</button>
      </div>
      <button class="nav-hamburger" @click="mobileMenuOpen = !mobileMenuOpen">☰</button>
    </nav>
    <div class="nav-mobile-menu" :class="{ open: mobileMenuOpen }">
      <span style="color:#76B900;font-family:'JetBrains Mono',monospace;font-size:0.8rem;font-weight:700">Powered by NVIDIA NIM</span>
      <a href="https://github.com/ExpertVagabond/nemofish" target="_blank" style="color:#888;text-decoration:none;font-size:0.9rem">GitHub ↗</a>
      <button style="background:#76B900;color:#000;border:none;padding:12px;font-family:'JetBrains Mono',monospace;font-weight:700;font-size:0.9rem;cursor:pointer" @click="connectWallet">Connect Wallet</button>
    </div>

    <!-- Hero -->
    <section class="hero-section">
      <img src="/icon.png" alt="NemoFish" class="hero-fish" />
      <h1 class="hero-title">Predict <span class="accent">Anything.</span></h1>
      <p class="hero-subtitle">
        Spawn thousands of AI agents with <strong>NVIDIA NIM 253B</strong> brains into simulated worlds. Feed any document, get a prediction report.
      </p>
      <div class="hero-ctas">
        <button class="btn-primary" @click="scrollToConsole">Try Free — 3 runs</button>
        <button class="btn-secondary" @click="scrollToPricing">$2 / prediction</button>
      </div>
      <div class="hero-note">x402 USDC on Solana · No account needed</div>
    </section>

    <!-- Pipeline -->
    <section class="pipeline-section">
      <div class="section-label">◇ How it works</div>
      <div class="pipeline-grid">
        <div class="pipeline-step" v-for="step in pipelineSteps" :key="step.num">
          <div class="step-number">{{ step.num }}</div>
          <div class="step-name">{{ step.name }}</div>
          <div class="step-detail">{{ step.detail }}</div>
        </div>
      </div>
    </section>

    <!-- Pricing -->
    <section class="pricing-section" ref="pricingRef">
      <div class="section-label">◇ Pricing</div>
      <div class="pricing-grid">
        <div class="price-card">
          <div class="price-tier">Free Tier</div>
          <div class="price-amount">$0</div>
          <div class="price-feature">3 predictions per wallet</div>
          <div class="price-feature">Full 7-step pipeline</div>
          <div class="price-feature">NIM 253B reasoning</div>
          <div class="price-feature">Neo4j knowledge graphs</div>
        </div>
        <div class="price-card pro">
          <div class="price-tier">Per Prediction</div>
          <div class="price-amount">$2</div>
          <div class="price-feature">x402 USDC payment</div>
          <div class="price-feature">Unlimited predictions</div>
          <div class="price-feature">Full report + agent interviews</div>
          <div class="price-feature">API access</div>
        </div>
      </div>
    </section>

    <!-- Metrics -->
    <section style="max-width:800px;margin:0 auto;padding:0 24px 40px">
      <div class="metrics-row">
        <div class="metric-card">
          <div class="metric-value">253B</div>
          <div class="metric-label">NIM parameters</div>
        </div>
        <div class="metric-card">
          <div class="metric-value">1M</div>
          <div class="metric-label">Max agents</div>
        </div>
        <div class="metric-card">
          <div class="metric-value">x402</div>
          <div class="metric-label">Payment protocol</div>
        </div>
      </div>
    </section>

    <!-- Console -->
    <section class="console-section" ref="consoleRef">
      <div class="section-label">◇ Run a prediction</div>
      <div class="console-box">
        <div class="console-header">
          <span>01 / Reality Seeds</span>
          <span>PDF, MD, TXT</span>
        </div>
        <div
          class="upload-zone"
          :class="{ 'has-files': files.length > 0 }"
          @dragover.prevent="handleDragOver"
          @dragleave.prevent="handleDragLeave"
          @drop.prevent="handleDrop"
          @click="triggerFileInput"
        >
          <input ref="fileInput" type="file" multiple accept=".pdf,.md,.txt" @change="handleFileSelect" style="display:none" :disabled="loading" />
          <div v-if="files.length === 0" style="text-align:center">
            <div class="upload-icon">↑</div>
            <div class="upload-title">Drop files here</div>
            <div class="upload-hint">or click to browse</div>
          </div>
          <div v-else class="file-list">
            <div v-for="(file, index) in files" :key="index" class="file-item">
              <span>📄</span>
              <span class="file-name">{{ file.name }}</span>
              <button @click.stop="removeFile(index)" class="remove-btn">×</button>
            </div>
          </div>
        </div>

        <div class="console-divider"><span>Parameters</span></div>

        <div class="console-header" style="margin-top:16px">
          <span>>_ 02 / Prediction Prompt</span>
        </div>
        <textarea v-model="formData.simulationRequirement" class="code-input" placeholder="What do you want to predict? Market movements, hackathon outcomes, competitive dynamics..." rows="4" :disabled="loading"></textarea>
        <div class="model-badge">Engine: NVIDIA NIM 253B + Neo4j</div>

        <button class="start-engine-btn" @click="startSimulation" :disabled="!canSubmit || loading">
          <span v-if="!loading">Run Prediction ($2 USDC)</span>
          <span v-else>Spawning agents...</span>
          <span>→</span>
        </button>
      </div>
    </section>

    <!-- History -->
    <section style="max-width:800px;margin:0 auto;padding:0 24px 60px">
      <HistoryDatabase />
    </section>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import HistoryDatabase from '../components/HistoryDatabase.vue'

const mobileMenuOpen = ref(false)
const consoleRef = ref(null)
const pricingRef = ref(null)

const scrollToConsole = () => consoleRef.value?.scrollIntoView({ behavior: 'smooth' })
const scrollToPricing = () => pricingRef.value?.scrollIntoView({ behavior: 'smooth' })

const pipelineSteps = [
  { num: '01', name: 'Upload', detail: 'Feed any document as a reality seed' },
  { num: '02', name: 'Graph', detail: 'NIM builds a Neo4j knowledge graph' },
  { num: '03', name: 'Swarm', detail: '1000s of agents simulate outcomes' },
  { num: '04', name: 'Report', detail: 'Structured prediction delivered' },
]

// Legacy stub — inline styles removed, CSS classes handle everything now
const s = { _unused: true }
/* old styles removed */
const _s_removed = true
/*
  navBrand: { fontFamily: mono, fontWeight: '800', letterSpacing: '2px', fontSize: '1.2rem' },
  navLinks: { display: 'flex', alignItems: 'center', gap: '16px' },
  nimBadge: { background: '#76B900', color: '#000', padding: '4px 10px', fontFamily: mono, fontSize: '0.7rem', fontWeight: '700', letterSpacing: '1px' },
  githubLink: { color: '#fff', textDecoration: 'none', fontFamily: mono, fontSize: '0.9rem', fontWeight: '500', display: 'flex', alignItems: 'center', gap: '8px' },
  walletBtn: { background: 'transparent', color: '#fff', border: '1px solid #555', padding: '6px 16px', fontFamily: mono, fontSize: '0.8rem', fontWeight: '600', cursor: 'pointer', letterSpacing: '0.5px' },
  mainContent: { maxWidth: '1400px', margin: '0 auto', padding: '60px 40px' },
  heroSection: { display: 'flex', justifyContent: 'space-between', marginBottom: '80px', position: 'relative' },
  heroLeft: { flex: '1', paddingRight: '60px' },
  tagRow: { display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '25px', fontFamily: mono, fontSize: '0.8rem', flexWrap: 'wrap' },
  orangeTag: { background: '#76B900', color: '#000', padding: '4px 10px', fontWeight: '700', letterSpacing: '1px', fontSize: '0.75rem' },
  nimTagSmall: { background: '#1a1a2e', color: '#76B900', padding: '4px 10px', fontFamily: mono, fontWeight: '600', fontSize: '0.7rem', border: '1px solid #76B900' },
  versionText: { color: '#999', fontWeight: '500', letterSpacing: '0.5px' },
  mainTitle: { fontSize: '4.5rem', lineHeight: '1.1', fontWeight: '500', margin: '0 0 40px 0', letterSpacing: '-2px', color: '#000' },
  gradientText: { background: 'linear-gradient(90deg, #000 0%, #76B900 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', display: 'inline-block' },
  heroDesc: { fontSize: '1.05rem', lineHeight: '1.8', color: '#666', maxWidth: '640px', marginBottom: '50px', fontWeight: '400', textAlign: 'justify' },
  heroDescP: { marginBottom: '1.5rem' },
  highlightBold: { color: '#000', fontWeight: '700' },
  highlightOrange: { color: '#76B900', fontWeight: '700', fontFamily: mono },
  highlightCode: { background: 'rgba(0,0,0,0.05)', padding: '2px 6px', borderRadius: '2px', fontFamily: mono, fontSize: '0.9em', color: '#000', fontWeight: '600' },
  sloganText: { fontSize: '1.2rem', fontWeight: '520', color: '#000', letterSpacing: '1px', borderLeft: '3px solid #76B900', paddingLeft: '15px', marginTop: '20px' },
  blinkingCursor: { color: '#76B900', fontWeight: '700' },
  decorationSquare: { width: '16px', height: '16px', background: '#76B900' },
  heroRight: { flex: '0.8', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', alignItems: 'flex-end' },
  logoContainer: { width: '100%', display: 'flex', justifyContent: 'flex-end', paddingRight: '40px' },
  heroLogoPlaceholder: { width: '300px', height: '300px', border: '2px solid #E5E5E5', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: '#FAFAFA' },
  logoText: { fontFamily: mono, fontSize: '6rem', fontWeight: '800', color: '#000', letterSpacing: '-4px', lineHeight: '1' },
  logoSubtext: { fontFamily: mono, fontSize: '1rem', fontWeight: '500', color: '#76B900', letterSpacing: '4px', marginTop: '8px' },
  scrollDownBtn: { width: '40px', height: '40px', border: '1px solid #E5E5E5', background: 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', color: '#76B900', fontSize: '1.2rem' },
  // Pricing section
  pricingSection: { borderTop: '1px solid #E5E5E5', paddingTop: '40px', marginBottom: '60px' },
  pricingHeader: { fontFamily: mono, fontSize: '0.8rem', color: '#999', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '25px' },
  pricingGrid: { display: 'flex', gap: '20px' },
  pricingCard: { flex: '1', border: '1px solid #E5E5E5', padding: '30px' },
  pricingCardPro: { flex: '1', border: '2px solid #76B900', padding: '30px', background: '#FAFFF5' },
  pricingTier: { fontFamily: mono, fontSize: '0.8rem', color: '#999', letterSpacing: '1px', marginBottom: '10px', fontWeight: '600' },
  pricingAmount: { fontFamily: mono, fontSize: '3rem', fontWeight: '800', marginBottom: '20px', color: '#000' },
  pricingDetail: { fontSize: '0.9rem', color: '#666', marginBottom: '8px', paddingLeft: '12px', borderLeft: '2px solid #E5E5E5' },
  // Dashboard
  dashboardSection: { display: 'flex', gap: '60px', borderTop: '1px solid #E5E5E5', paddingTop: '60px', alignItems: 'flex-start' },
  leftPanel: { flex: '0.8', display: 'flex', flexDirection: 'column' },
  panelHeader: { fontFamily: mono, fontSize: '0.8rem', color: '#999', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '20px' },
  statusDot: { color: '#76B900', fontSize: '0.8rem' },
  sectionTitle: { fontSize: '2rem', fontWeight: '520', margin: '0 0 15px 0' },
  sectionDesc: { color: '#666', marginBottom: '25px', lineHeight: '1.6' },
  metricsRow: { display: 'flex', gap: '20px', marginBottom: '15px' },
  metricCard: { border: '1px solid #E5E5E5', padding: '20px 30px', minWidth: '150px' },
  metricValue: { fontFamily: mono, fontSize: '1.8rem', fontWeight: '520', marginBottom: '5px' },
  metricLabel: { fontSize: '0.85rem', color: '#999' },
  stepsContainer: { border: '1px solid #E5E5E5', padding: '30px', position: 'relative' },
  stepsHeader: { fontFamily: mono, fontSize: '0.8rem', color: '#999', marginBottom: '25px', display: 'flex', alignItems: 'center', gap: '8px' },
  diamondIcon: { fontSize: '1.2rem', lineHeight: '1' },
  workflowList: { display: 'flex', flexDirection: 'column', gap: '20px' },
  workflowItem: { display: 'flex', alignItems: 'flex-start', gap: '20px' },
  stepNum: { fontFamily: mono, fontWeight: '700', color: '#000', opacity: '0.3' },
  stepInfo: { flex: '1' },
  stepTitle: { fontWeight: '520', fontSize: '1rem', marginBottom: '4px' },
  stepDesc: { fontSize: '0.85rem', color: '#666' },
  rightPanel: { flex: '1.2', display: 'flex', flexDirection: 'column' },
  consoleBox: { border: '1px solid #CCC', padding: '8px' },
  consoleSection: { padding: '20px' },
  consoleHeader: { display: 'flex', justifyContent: 'space-between', marginBottom: '15px', fontFamily: mono, fontSize: '0.75rem', color: '#666' },
  uploadZone: { border: '1px dashed #CCC', height: '200px', overflowY: 'auto', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', background: '#FAFAFA' },
  uploadPlaceholder: { textAlign: 'center' },
  uploadIcon: { width: '40px', height: '40px', border: '1px solid #DDD', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 15px', color: '#999' },
  uploadTitle: { fontWeight: '500', fontSize: '0.9rem', marginBottom: '5px' },
  uploadHint: { fontFamily: mono, fontSize: '0.75rem', color: '#999' },
  fileList: { width: '100%', padding: '15px', display: 'flex', flexDirection: 'column', gap: '10px' },
  fileItem: { display: 'flex', alignItems: 'center', background: '#fff', padding: '8px 12px', border: '1px solid #EEE', fontFamily: mono, fontSize: '0.85rem' },
  fileName: { flex: '1', margin: '0 10px' },
  removeBtn: { background: 'none', border: 'none', cursor: 'pointer', fontSize: '1.2rem', color: '#999' },
  consoleDivider: { display: 'flex', alignItems: 'center', margin: '10px 0', borderTop: '1px solid #EEE' },
  consoleDividerText: { padding: '0 15px', fontFamily: mono, fontSize: '0.7rem', color: '#BBB', letterSpacing: '1px' },
  inputWrapper: { position: 'relative', border: '1px solid #DDD', background: '#FAFAFA' },
  codeInput: { width: '100%', border: 'none', background: 'transparent', padding: '20px', fontFamily: mono, fontSize: '0.9rem', lineHeight: '1.6', resize: 'vertical', outline: 'none', minHeight: '150px' },
  modelBadge: { position: 'absolute', bottom: '10px', right: '15px', fontFamily: mono, fontSize: '0.7rem', color: '#AAA' },
  btnSection: { padding: '0 20px 20px' },
*/

const router = useRouter()

const formData = ref({ simulationRequirement: '' })
const files = ref([])
const loading = ref(false)
const error = ref('')
const isDragOver = ref(false)
const fileInput = ref(null)

const canSubmit = computed(() => {
  return formData.value.simulationRequirement.trim() !== '' && files.value.length > 0
})

const connectWallet = () => {
  // Placeholder for x402 wallet connection
  alert('Wallet connection coming soon. 3 free predictions available without a wallet.')
}

const triggerFileInput = () => { if (!loading.value) fileInput.value?.click() }
const handleFileSelect = (event) => { addFiles(Array.from(event.target.files)) }
const handleDragOver = (e) => { isDragOver.value = true }
const handleDragLeave = (e) => { isDragOver.value = false }
const handleDrop = (e) => { isDragOver.value = false; addFiles(Array.from(e.dataTransfer.files)) }

const addFiles = (newFiles) => {
  const allowed = ['.pdf', '.md', '.txt']
  const valid = newFiles.filter(f => allowed.some(ext => f.name.toLowerCase().endsWith(ext)))
  files.value = [...files.value, ...valid]
}

const removeFile = (index) => { files.value.splice(index, 1) }

const scrollToBottom = () => { window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' }) }

const startSimulation = () => {
  if (!canSubmit.value || loading.value) return
  import('../store/pendingUpload.js').then(({ setPendingUpload }) => {
    setPendingUpload(files.value, formData.value.simulationRequirement)
    router.push({ name: 'Process', params: { projectId: 'new' } })
  })
}
</script>

<!-- Styles loaded from Home.css via import -->
