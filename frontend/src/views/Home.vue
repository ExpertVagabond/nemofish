<template>
  <div class="home-container">
    <!-- Top Navigation Bar -->
    <nav class="navbar" :style="s.navbar">
      <div class="nav-brand" :style="s.navBrand"><img src="/favicon.png" alt="NemoFish" :style="{ width: '32px', height: '32px', borderRadius: '6px', marginRight: '8px', verticalAlign: 'middle' }" />NEMOFISH</div>
      <div class="nav-links" :style="s.navLinks">
        <span :style="s.nimBadge">NVIDIA NIM</span>
        <a href="https://github.com/ExpertVagabond/nemofish" target="_blank" class="github-link" :style="s.githubLink">
          GitHub <span>↗</span>
        </a>
        <button :style="s.walletBtn" @click="connectWallet">Connect Wallet</button>
      </div>
    </nav>

    <div class="main-content" :style="s.mainContent">
      <!-- Hero Section -->
      <section class="hero-section" :style="s.heroSection">
        <div class="hero-left" :style="s.heroLeft">
          <div class="tag-row" :style="s.tagRow">
            <span class="orange-tag" :style="s.orangeTag">Swarm Intelligence Prediction Engine</span>
            <span :style="s.nimTagSmall">Powered by NVIDIA NIM</span>
            <span class="version-text" :style="s.versionText">/ v1.0</span>
          </div>

          <h1 class="main-title" :style="s.mainTitle">
            Spawn Thousands of<br>
            <span class="gradient-text" :style="s.gradientText">AI Agents That Predict</span>
          </h1>

          <div class="hero-desc" :style="s.heroDesc">
            <p :style="s.heroDescP">
              <span :style="s.highlightBold">NemoFish</span> spawns thousands of AI agents with <span :style="s.highlightOrange">NIM 253B brains</span> into simulated worlds. Predict market movements, hackathon outcomes, content performance, and competitive dynamics from any document.
            </p>
            <p class="slogan-text" :style="s.sloganText">
              $2 per prediction via x402 USDC. 3 free runs to start<span :style="s.blinkingCursor">_</span>
            </p>
          </div>

          <div class="decoration-square" :style="s.decorationSquare"></div>
        </div>

        <div class="hero-right" :style="s.heroRight">
          <div class="logo-container" :style="s.logoContainer">
            <div :style="s.heroLogoPlaceholder">
              <img src="/favicon.png" alt="NemoFish" :style="{ width: '200px', height: '200px', borderRadius: '24px', objectFit: 'cover' }" />
              <div :style="s.logoSubtext">NemoFish</div>
            </div>
          </div>
          <button :style="s.scrollDownBtn" @click="scrollToBottom">↓</button>
        </div>
      </section>

      <!-- Pricing Section -->
      <section :style="s.pricingSection">
        <div :style="s.pricingHeader">
          <span :style="s.diamondIcon">◇</span> Pricing
        </div>
        <div class="pricing-cards" :style="s.pricingGrid">
          <div :style="s.pricingCard">
            <div :style="s.pricingTier">Free Tier</div>
            <div :style="s.pricingAmount">$0</div>
            <div :style="s.pricingDetail">3 predictions per wallet</div>
            <div :style="s.pricingDetail">Full 7-step pipeline</div>
            <div :style="s.pricingDetail">NIM 253B reasoning</div>
          </div>
          <div :style="s.pricingCardPro">
            <div :style="s.pricingTier">Per Prediction</div>
            <div :style="s.pricingAmount">$2</div>
            <div :style="s.pricingDetail">x402 USDC payment</div>
            <div :style="s.pricingDetail">Unlimited predictions</div>
            <div :style="s.pricingDetail">Neo4j knowledge graphs</div>
          </div>
        </div>
      </section>

      <!-- Dashboard: Two-Column Layout -->
      <section class="dashboard-section" :style="s.dashboardSection">
        <!-- Left Column: Status & Steps -->
        <div class="left-panel" :style="s.leftPanel">
          <div class="panel-header" :style="s.panelHeader">
            <span :style="s.statusDot">■</span> System Status
          </div>

          <h2 class="section-title" :style="s.sectionTitle">Ready</h2>
          <p class="section-desc" :style="s.sectionDesc">
            NIM-powered prediction engine on standby. Upload unstructured data to initialize a swarm simulation.
          </p>

          <div class="metrics-row" :style="s.metricsRow">
            <div class="metric-card" :style="s.metricCard">
              <div class="metric-value" :style="s.metricValue">253B</div>
              <div class="metric-label" :style="s.metricLabel">NVIDIA NIM parameters</div>
            </div>
            <div class="metric-card" :style="s.metricCard">
              <div class="metric-value" :style="s.metricValue">x402</div>
              <div class="metric-label" :style="s.metricLabel">USDC payment protocol</div>
            </div>
          </div>

          <div class="steps-container" :style="s.stepsContainer">
            <div class="steps-header" :style="s.stepsHeader">
               <span :style="s.diamondIcon">◇</span> Prediction Pipeline
            </div>
            <div :style="s.workflowList">
              <div v-for="(step, i) in steps" :key="i" :style="s.workflowItem">
                <span :style="s.stepNum">{{ step.num }}</span>
                <div :style="s.stepInfo">
                  <div :style="s.stepTitle">{{ step.title }}</div>
                  <div :style="s.stepDesc">{{ step.desc }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Column: Interactive Console -->
        <div class="right-panel" :style="s.rightPanel">
          <div class="console-box" :style="s.consoleBox">
            <div :style="s.consoleSection">
              <div class="console-header" :style="s.consoleHeader">
                <span>01 / Reality Seeds</span>
                <span>Supported: PDF, MD, TXT</span>
              </div>
              <div
                :style="s.uploadZone"
                @dragover.prevent="handleDragOver"
                @dragleave.prevent="handleDragLeave"
                @drop.prevent="handleDrop"
                @click="triggerFileInput"
              >
                <input ref="fileInput" type="file" multiple accept=".pdf,.md,.txt" @change="handleFileSelect" style="display: none" :disabled="loading" />
                <div v-if="files.length === 0" :style="s.uploadPlaceholder">
                  <div :style="s.uploadIcon">↑</div>
                  <div :style="s.uploadTitle">Drag & drop files here</div>
                  <div :style="s.uploadHint">or click to browse</div>
                </div>
                <div v-else :style="s.fileList">
                  <div v-for="(file, index) in files" :key="index" :style="s.fileItem">
                    <span>📄</span>
                    <span :style="s.fileName">{{ file.name }}</span>
                    <button @click.stop="removeFile(index)" :style="s.removeBtn">×</button>
                  </div>
                </div>
              </div>
            </div>

            <div :style="s.consoleDivider"><span :style="s.consoleDividerText">Parameters</span></div>

            <div :style="s.consoleSection">
              <div class="console-header" :style="s.consoleHeader">
                <span>>_ 02 / Prediction Prompt</span>
              </div>
              <div :style="s.inputWrapper">
                <textarea v-model="formData.simulationRequirement" :style="s.codeInput" placeholder="// What do you want to predict? Market movements, hackathon outcomes, content performance..." rows="6" :disabled="loading"></textarea>
                <div :style="s.modelBadge">Engine: NVIDIA NIM + Neo4j</div>
              </div>
            </div>

            <div :style="s.btnSection">
              <button :style="s.startEngineBtn" @click="startSimulation" :disabled="!canSubmit || loading">
                <span v-if="!loading">Run Prediction ($2 USDC)</span>
                <span v-else>Initializing Swarm...</span>
                <span>→</span>
              </button>
            </div>
          </div>
        </div>
      </section>

      <HistoryDatabase />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { useRouter } from 'vue-router'
import HistoryDatabase from '../components/HistoryDatabase.vue'

const mono = 'JetBrains Mono, monospace'
const sans = 'Space Grotesk, Noto Sans SC, system-ui, sans-serif'

const s = reactive({
  navbar: { height: '60px', background: '#000', color: '#fff', display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0 40px' },
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
  startEngineBtn: { width: '100%', background: '#000', color: '#fff', border: 'none', padding: '20px', fontFamily: mono, fontWeight: '700', fontSize: '1.1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', cursor: 'pointer', letterSpacing: '1px' },
})

const steps = [
  { num: '01', title: 'Upload', desc: 'Upload documents (press releases, financial reports, market data) as reality seeds' },
  { num: '02', title: 'Ontology', desc: 'NIM 253B extracts entities, relationships, and dynamics into a structured ontology' },
  { num: '03', title: 'Graph Build', desc: 'Build a Neo4j knowledge graph with GraphRAG-powered entity relationships' },
  { num: '04', title: 'Swarm Sim', desc: 'Spawn hundreds of AI agents with unique personas that simulate reactions and predictions' },
  { num: '05', title: 'Report', desc: 'ReportAgent analyzes simulation results and delivers a structured prediction report' },
]

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
