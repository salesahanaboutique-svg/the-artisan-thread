// The Artisan Thread - Interactive Application Logic

// 1. Toast Notification System
function showToast(message, type = 'success') {
  let toast = document.getElementById('tat-toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'tat-toast';
    toast.className = 'tat-toast';
    document.body.appendChild(toast);
  }
  toast.className = `tat-toast ${type} show`;
  toast.innerHTML = `<span>✨</span><span>${message}</span>`;

  clearTimeout(window._tatToastTimer);
  window._tatToastTimer = setTimeout(() => {
    toast.classList.remove('show');
  }, 3800);
}

// 2. Modal Management
function openModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
  }
}

function closeModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    modal.classList.remove('active');
    document.body.style.overflow = '';
  }
}

// Close modal when clicking outside
window.addEventListener('click', (e) => {
  if (e.target.classList.contains('tat-modal-overlay')) {
    e.target.classList.remove('active');
    document.body.style.overflow = '';
  }
});

// 3. Customer Portal Actions
function openMeasurementModal() {
  openModal('measurement-modal');
}

function saveMeasurementProfile(e) {
  if (e) e.preventDefault();
  const progressBar = document.getElementById('profile-progress-bar');
  const progressText = document.getElementById('profile-progress-text');
  if (progressBar) progressBar.style.width = '100%';
  if (progressText) progressText.innerText = '13 of 13 measurements saved (Complete)';
  closeModal('measurement-modal');
  showToast('Measurement profile updated and saved to your account!');
}

function openHomeVisitModal() {
  openModal('home-visit-modal');
}

function submitHomeVisit(e) {
  if (e) e.preventDefault();
  const name = document.getElementById('hv-name')?.value || 'Customer';
  const address = document.getElementById('hv-address')?.value || 'Chennai';
  const date = document.getElementById('hv-date')?.value || 'Tomorrow';
  closeModal('home-visit-modal');
  showToast(`Home visit booked for ${name} on ${date}. Our hub stylist will visit your address!`);
}

function selectDesigner(id, title) {
  showToast(`Designer ${id} (${title}) selected for your order! Pattern drafting scheduled.`);
}

// 4. Designer Portal Actions
function openDraftModal(orderId) {
  const titleEl = document.getElementById('draft-order-title');
  if (titleEl) titleEl.innerText = `${orderId} · 3-Dart Classic Blouse Draft`;
  openModal('draft-modal');
}

function approveDraft(orderId) {
  closeModal('draft-modal');
  showToast(`Pattern for ${orderId} approved and transferred to Hub Tailors for cutting!`);
}

function requestMissingMeasurements(orderId) {
  showToast(`Automated measurement request sent to customer for ${orderId} via WhatsApp!`, 'info');
}

function openAddMethodModal() {
  openModal('add-method-modal');
}

function saveNewMethod(e) {
  if (e) e.preventDefault();
  closeModal('add-method-modal');
  showToast('New drafting method submitted for Administrator approval!');
}

// 5. Tailor Portal Actions
function openPatternPrintModal(orderId) {
  const titleEl = document.getElementById('print-order-title');
  if (titleEl) titleEl.innerText = `${orderId} · Cutting Pattern (Scale 1:1)`;
  openModal('pattern-print-modal');
}

function updateTailorJob(orderId, btnEl) {
  const statuses = ['To cut', 'Stitching', 'Quality check', 'Ready to deliver'];
  const colors = ['#FBE4DC', '#E3ECD8', '#F7E8D4', '#F8CBD0'];
  
  let currentPill = btnEl.parentElement.querySelector('.p');
  if (currentPill) {
    let currentText = currentPill.innerText.trim();
    let nextIndex = (statuses.indexOf(currentText) + 1) % statuses.length;
    currentPill.innerText = statuses[nextIndex];
    currentPill.style.background = colors[nextIndex];
    showToast(`Order ${orderId} status advanced to "${statuses[nextIndex]}"!`);
  } else {
    showToast(`Order ${orderId} status updated!`);
  }
}

// 6. Admin & Onboarding Actions
function inviteDesignerFromForm() {
  const nameInput = document.getElementById('designerName');
  const phoneInput = document.getElementById('designerPhone');
  const cityInput = document.getElementById('designerCity');
  const garmentsInput = document.getElementById('designerGarments');

  const name = nameInput ? nameInput.value.trim() : '';
  const phone = phoneInput ? phoneInput.value.trim() : '';

  if (!name || !phone) {
    showToast('Please enter at least the Designer Name and WhatsApp number.', 'info');
    return;
  }

  // Find next uninvited slot (TAT-D009 or TAT-D010)
  const slotList = document.getElementById('designer-slots-container');
  if (slotList) {
    const uninvited = slotList.querySelector('.slot-uninvited');
    if (uninvited) {
      uninvited.classList.remove('slot-uninvited');
      const nameSpan = uninvited.querySelector('.slot-name');
      const statusPill = uninvited.querySelector('.p');
      const actionBtn = uninvited.querySelector('.b');

      if (nameSpan) nameSpan.innerText = name;
      if (statusPill) {
        statusPill.innerText = 'Invited';
        statusPill.style.background = '#FBE4DC';
      }
      if (actionBtn) {
        actionBtn.innerText = 'Remind';
        actionBtn.style.background = '#3E2420';
      }
    }
  }

  // Reset form
  if (nameInput) nameInput.value = '';
  if (phoneInput) phoneInput.value = '';
  if (cityInput) cityInput.value = '';
  if (garmentsInput) garmentsInput.value = '';

  showToast(`Invite sent to ${name} (${phone})! Designer slot allocated.`);
}

function openReviewModal(applicantName, role, status) {
  const nameEl = document.getElementById('review-applicant-name');
  const roleEl = document.getElementById('review-applicant-role');
  if (nameEl) nameEl.innerText = applicantName;
  if (roleEl) roleEl.innerText = `${role} · ${status}`;
  openModal('review-modal');
}

function approveApplicant() {
  closeModal('review-modal');
  showToast('Applicant approved! Credential token and welcome kit sent.');
}
