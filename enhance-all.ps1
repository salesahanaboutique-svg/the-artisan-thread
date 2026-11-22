$ErrorActionPreference = "Stop"

# 1. Update index.html
$index = Get-Content -Raw -Encoding UTF8 "index.html"

# Add styles.css link in head
if ($index -notmatch 'styles\.css') {
    $index = $index -replace '</head>', '<link rel="stylesheet" href="styles.css">`n</head>'
}

# Update header Login button to trigger role modal
$index = $index -replace '<a href="#login" class="btn" style="background:#3E2420;color:#FCF2E9;padding:10px 24px">Log in</a>', '<button type="button" class="btn" onclick="openModal(''role-modal'')" style="background:#3E2420;color:#FCF2E9;padding:10px 24px;border:none">Log in</button>'

# Add Role Modal to index.html
$roleModalHtml = @'
<!-- Role Selection Modal -->
<div id="role-modal" class="tat-modal-overlay">
  <div class="tat-modal" style="max-width:540px">
    <button class="tat-modal-close" onclick="closeModal('role-modal')">&times;</button>
    <p class="sc" style="font-size:36px;color:#B24560;margin:0 0 4px">Welcome to The Artisan Thread</p>
    <h2 class="hd" style="font-size:32px;margin:0 0 14px">Select Your Workspace</h2>
    <p style="color:#6B4A42;margin:0 0 24px;font-size:15px">Choose your role to open your personal portal:</p>
    <div style="display:flex;flex-direction:column;gap:14px">
      <a href="Customer.html" class="b" style="display:flex;align-items:center;justify-content:space-between;padding:16px 22px;text-decoration:none;background:#fff;color:#3E2420;border:1.5px solid #E6CFA3;border-radius:18px">
        <div><strong style="font-size:17px;display:block">👤 Customer Portal</strong><span style="font-size:13px;color:#6B4A42">Measurements, designer matching & order tracking</span></div>
        <span style="color:#B24560;font-weight:700;font-size:18px">&rarr;</span>
      </a>
      <a href="Designer.html" class="b" style="display:flex;align-items:center;justify-content:space-between;padding:16px 22px;text-decoration:none;background:#fff;color:#3E2420;border:1.5px solid #E6CFA3;border-radius:18px">
        <div><strong style="font-size:17px;display:block">✂️ Designer Studio</strong><span style="font-size:13px;color:#6B4A42">Drafting queue, scale formulas & published methods</span></div>
        <span style="color:#B24560;font-weight:700;font-size:18px">&rarr;</span>
      </a>
      <a href="Tailor.html" class="b" style="display:flex;align-items:center;justify-content:space-between;padding:16px 22px;text-decoration:none;background:#fff;color:#3E2420;border:1.5px solid #E6CFA3;border-radius:18px">
        <div><strong style="font-size:17px;display:block">🧵 Hub Tailor Workshop</strong><span style="font-size:13px;color:#6B4A42">Cutting jobs, stitching tasks & 1:1 scale printable patterns</span></div>
        <span style="color:#B24560;font-weight:700;font-size:18px">&rarr;</span>
      </a>
      <a href="Admin.html" class="b" style="display:flex;align-items:center;justify-content:space-between;padding:16px 22px;text-decoration:none;background:#fff;color:#3E2420;border:1.5px solid #E6CFA3;border-radius:18px">
        <div><strong style="font-size:17px;display:block">⚙️ Studio Administration</strong><span style="font-size:13px;color:#6B4A42">Onboarding queue, method approvals & master charts</span></div>
        <span style="color:#B24560;font-weight:700;font-size:18px">&rarr;</span>
      </a>
    </div>
  </div>
</div>
'@

if ($index -notmatch 'id="role-modal"') {
    $index = $index -replace '</body>', "$roleModalHtml`n<script src='app.js'></script>`n</body>"
}
[System.IO.File]::WriteAllText("$PSScriptRoot\index.html", $index, [System.Text.Encoding]::UTF8)
Write-Host "Updated index.html"

# 2. Update Customer.html
$cust = Get-Content -Raw -Encoding UTF8 "Customer.html"
if ($cust -notmatch 'styles\.css') {
    $cust = $cust -replace '</head>', '<link rel="stylesheet" href="styles.css">`n</head>'
}
$cust = $cust -replace '<div style="width:70%;height:100%;background:#B24560"></div>', '<div id="profile-progress-bar" style="width:70%;height:100%;background:#B24560;transition:width 0.4s ease"></div>'
$cust = $cust -replace '<p style="margin:8px 0 16px;font-size:14px">9 of 13 measurements saved</p>', '<p id="profile-progress-text" style="margin:8px 0 16px;font-size:14px">9 of 13 measurements saved</p>'
$cust = $cust -replace '<a class="b" href="#">Continue measuring</a>', '<button type="button" class="b" onclick="openMeasurementModal()" style="border:none">Continue measuring</button>'
$cust = $cust -replace '<a class="b" href="#" style="background:#3E2420">Book a home visit</a>', '<button type="button" class="b" onclick="openHomeVisitModal()" style="background:#3E2420;border:none">Book a home visit</button>'
$cust = $cust -replace '<a class="b" href="#" style="margin-top:12px">Choose</a>', '<button type="button" class="b" onclick="selectDesigner(''TAT-D001'', ''3-dart blouse'')\" style="margin-top:12px;border:none">Choose</button>'
$cust = $cust -replace '<a class="b" href="#" style="margin-top:12px;background:#3E2420">Match me</a>', '<button type="button" class="b" onclick="selectDesigner(''TAT-Auto'', ''Curated Match'')\" style="margin-top:12px;background:#3E2420;border:none">Match me</button>'

$custModals = @'
<!-- Customer Measurement Modal -->
<div id="measurement-modal" class="tat-modal-overlay">
  <div class="tat-modal">
    <button class="tat-modal-close" onclick="closeModal('measurement-modal')">&times;</button>
    <p class="sc" style="font-size:34px;color:#B24560;margin:0">Measurement Profile</p>
    <h2 class="hd" style="font-size:30px;margin:0 0 12px">Your 13 Tailoring Dimensions</h2>
    <p style="font-size:14px;color:#6B4A42;margin:0 0 20px">Measurements are saved permanently so any designer can draft exact patterns without re-measuring.</p>
    <form onsubmit="saveMeasurementProfile(event)">
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px">
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Shoulder (in)</label><input type="text" class="f" value="14.5" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Upper Chest (in)</label><input type="text" class="f" value="36.0" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Middle Chest (in)</label><input type="text" class="f" value="37.5" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Waist (in)</label><input type="text" class="f" value="29.0" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Armhole (in)</label><input type="text" class="f" value="16.5" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Front Length (in)</label><input type="text" class="f" value="14.0" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Dart Apex (in)</label><input type="text" class="f" value="9.5" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Front Neck (in)</label><input type="text" class="f" value="6.5" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Back Neck (in)</label><input type="text" class="f" value="7.5" style="width:100%;box-sizing:border-box"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Sleeve Length (in)</label><input type="text" class="f" placeholder="e.g. 10.5" value="10.5" style="width:100%;box-sizing:border-box;border-color:#B24560"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Bicep (in)</label><input type="text" class="f" placeholder="e.g. 12.0" value="12.0" style="width:100%;box-sizing:border-box;border-color:#B24560"></div>
        <div><label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Wrist (in)</label><input type="text" class="f" placeholder="e.g. 6.5" value="6.5" style="width:100%;box-sizing:border-box;border-color:#B24560"></div>
      </div>
      <div style="display:flex;justify-content:flex-end;gap:12px">
        <button type="button" class="b" onclick="closeModal('measurement-modal')" style="background:#EDE6DA;color:#3E2420;border:none">Cancel</button>
        <button type="submit" class="b" style="border:none">Save Profile</button>
      </div>
    </form>
  </div>
</div>

<!-- Home Visit Booking Modal -->
<div id="home-visit-modal" class="tat-modal-overlay">
  <div class="tat-modal" style="max-width:480px">
    <button class="tat-modal-close" onclick="closeModal('home-visit-modal')">&times;</button>
    <p class="sc" style="font-size:34px;color:#B24560;margin:0">Doorstep Tailoring</p>
    <h2 class="hd" style="font-size:30px;margin:0 0 12px">Book a Home Visit</h2>
    <p style="font-size:14px;color:#6B4A42;margin:0 0 20px">We visit your home in Chennai, take professional measurements, and collect your fabric.</p>
    <form onsubmit="submitHomeVisit(event)">
      <label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Your Name</label>
      <input type="text" id="hv-name" class="f" placeholder="Full Name" required style="width:100%;box-sizing:border-box">
      <label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Address / Area</label>
      <input type="text" id="hv-address" class="f" placeholder="e.g. Anna Nagar, Chennai" required style="width:100%;box-sizing:border-box">
      <label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Preferred Date</label>
      <input type="date" id="hv-date" class="f" required style="width:100%;box-sizing:border-box">
      <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:16px">
        <button type="button" class="b" onclick="closeModal('home-visit-modal')" style="background:#EDE6DA;color:#3E2420;border:none">Cancel</button>
        <button type="submit" class="b" style="border:none">Confirm Booking</button>
      </div>
    </form>
  </div>
</div>
'@
if ($cust -notmatch 'id="measurement-modal"') {
    $cust = $cust -replace '</body>', "$custModals`n<script src='app.js'></script>`n</body>"
}
[System.IO.File]::WriteAllText("$PSScriptRoot\Customer.html", $cust, [System.Text.Encoding]::UTF8)
Write-Host "Updated Customer.html"

# 3. Update Designer.html
$des = Get-Content -Raw -Encoding UTF8 "Designer.html"
if ($des -notmatch 'styles\.css') {
    $des = $des -replace '</head>', '<link rel="stylesheet" href="styles.css">`n</head>'
}
$des = $des -replace '<a class="b" href="#">Open draft</a>', '<button type="button" class="b" onclick="openDraftModal(''ORD-1042'')\" style="border:none">Open draft</button>'
$des = $des -replace '<a class="b" href="#" style="background:#3E2420">Request</a>', '<button type="button" class="b" onclick="requestMissingMeasurements(''ORD-1045'')\" style="background:#3E2420;border:none">Request</button>'
$des = $des -replace '<a class="b" href="#" style="background:#3E2420">\+ Add method</a>', '<button type="button" class="b" onclick="openAddMethodModal()" style="background:#3E2420;border:none">+ Add method</button>'

$desModals = @'
<!-- Designer Draft Modal -->
<div id="draft-modal" class="tat-modal-overlay">
  <div class="tat-modal" style="max-width:620px">
    <button class="tat-modal-close" onclick="closeModal('draft-modal')">&times;</button>
    <p class="sc" style="font-size:34px;color:#B24560;margin:0">Pattern Studio Engine</p>
    <h2 id="draft-order-title" class="hd" style="font-size:28px;margin:0 0 12px">ORD-1042 · 3-Dart Classic Blouse Draft</h2>
    <p style="font-size:14px;color:#6B4A42;margin:0 0 16px">Step-by-step formula execution on customer measurements (Bust: 37.5 in, Waist: 29.0 in):</p>
    <div style="background:#fff;border:1.5px solid #E6CFA3;border-radius:16px;padding:16px;font-size:13.5px;margin-bottom:20px;line-height:1.7">
      <div><strong>Step 1 (Upper Chest Width):</strong> Bust / 4 + 1.5 in ease = <span style="color:#B24560;font-weight:700">10.875 in</span></div>
      <div><strong>Step 2 (Waist Band Width):</strong> Waist / 4 + 1.0 in dart allowance = <span style="color:#B24560;font-weight:700">8.25 in</span></div>
      <div><strong>Step 3 (Armhole Depth Curve):</strong> Bust / 6 + 1.0 in = <span style="color:#B24560;font-weight:700">7.25 in</span></div>
      <div><strong>Step 4 (Dart Apex Point):</strong> Down from shoulder 9.5 in, out 3.75 in from center fold</div>
      <div><strong>Step 5 (Side Dart & Armhole Dart):</strong> Formed at 45&deg; with 0.75 in intake</div>
    </div>
    <div style="display:flex;justify-content:flex-end;gap:12px">
      <button type="button" class="b" onclick="closeModal('draft-modal')" style="background:#EDE6DA;color:#3E2420;border:none">Close</button>
      <button type="button" class="b" onclick="approveDraft('ORD-1042')" style="border:none">Approve & Send to Tailor Hub</button>
    </div>
  </div>
</div>

<!-- Add Method Modal -->
<div id="add-method-modal" class="tat-modal-overlay">
  <div class="tat-modal" style="max-width:500px">
    <button class="tat-modal-close" onclick="closeModal('add-method-modal')">&times;</button>
    <p class="sc" style="font-size:34px;color:#B24560;margin:0">Publish Craft</p>
    <h2 class="hd" style="font-size:28px;margin:0 0 12px">Add Drafting Method</h2>
    <form onsubmit="saveNewMethod(event)">
      <label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Garment Name</label>
      <input type="text" class="f" placeholder="e.g. Princess Cut Blouse, A-Line Kurta" required style="width:100%;box-sizing:border-box">
      <label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px">Standard Sizing Category</label>
      <select class="f" style="width:100%;box-sizing:border-box">
        <option>Women - Classic Ethnic</option>
        <option>Women - Contemporary</option>
        <option>Men - Kurta & Shirts</option>
        <option>Kids - Festive</option>
      </select>
      <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:16px">
        <button type="button" class="b" onclick="closeModal('add-method-modal')" style="background:#EDE6DA;color:#3E2420;border:none">Cancel</button>
        <button type="submit" class="b" style="border:none">Submit Method</button>
      </div>
    </form>
  </div>
</div>
'@
if ($des -notmatch 'id="draft-modal"') {
    $des = $des -replace '</body>', "$desModals`n<script src='app.js'></script>`n</body>"
}
[System.IO.File]::WriteAllText("$PSScriptRoot\Designer.html", $des, [System.Text.Encoding]::UTF8)
Write-Host "Updated Designer.html"

# 4. Update Tailor.html
$tai = Get-Content -Raw -Encoding UTF8 "Tailor.html"
if ($tai -notmatch 'styles\.css') {
    $tai = $tai -replace '</head>', '<link rel="stylesheet" href="styles.css">`n</head>'
}
$tai = $tai -replace '<a class="b" href="#">Open pattern</a>', '<button type="button" class="b" onclick="openPatternPrintModal(''ORD-1038'')\" style="border:none">Open pattern</button>'
$tai = $tai -replace '<a class="b" href="#" style="background:#3E2420">Update</a>', '<button type="button" class="b" onclick="updateTailorJob(''ORD-1036'', this)\" style="background:#3E2420;border:none">Update</button>'

$taiModals = @'
<!-- Printable Pattern Sheet Modal -->
<div id="pattern-print-modal" class="tat-modal-overlay">
  <div class="tat-modal" style="max-width:650px">
    <button class="tat-modal-close" onclick="closeModal('pattern-print-modal')">&times;</button>
    <p class="sc" style="font-size:34px;color:#B24560;margin:0">Cutting Workshop</p>
    <h2 id="print-order-title" class="hd" style="font-size:28px;margin:0 0 12px">ORD-1038 · Cutting Pattern (Scale 1:1)</h2>
    <div class="pattern-print-area" style="background:#fff;border:2px dashed #CAA067;border-radius:18px;padding:24px;margin-bottom:20px;text-align:center">
      <div style="display:inline-block;border:2px solid #3E2420;width:96px;height:96px;line-height:96px;font-size:12px;font-weight:700;margin-bottom:14px;background:#FEFAF6">
        1 INCH &times; 1 INCH<br>SCALE CHECK
      </div>
      <p style="font-size:13px;color:#6B4A42;margin:0 0 12px">Measure with ruler before cutting. Scale check must measure exactly 1.00 inch.</p>
      <div style="display:flex;justify-content:center;gap:12px;font-size:13px;font-weight:600">
        <span class="p" style="background:#E3ECD8">Front Bodice (2 pcs)</span>
        <span class="p" style="background:#FBE4DC">Back Bodice (1 pc)</span>
        <span class="p" style="background:#F7E8D4">Sleeve Left & Right</span>
      </div>
    </div>
    <div style="display:flex;justify-content:flex-end;gap:12px">
      <button type="button" class="b" onclick="closeModal('pattern-print-modal')" style="background:#EDE6DA;color:#3E2420;border:none">Close</button>
      <button type="button" class="b" onclick="window.print()" style="border:none">🖨️ Print Pattern Sheet</button>
    </div>
  </div>
</div>
'@
if ($tai -notmatch 'id="pattern-print-modal"') {
    $tai = $tai -replace '</body>', "$taiModals`n<script src='app.js'></script>`n</body>"
}
[System.IO.File]::WriteAllText("$PSScriptRoot\Tailor.html", $tai, [System.Text.Encoding]::UTF8)
Write-Host "Updated Tailor.html"

# 5. Update Admin.html
$adm = Get-Content -Raw -Encoding UTF8 "Admin.html"
if ($adm -notmatch 'styles\.css') {
    $adm = $adm -replace '</head>', '<link rel="stylesheet" href="styles.css">`n</head>'
}
$adm = $adm -replace '<a class="b" href="#">\+ Invite designer</a>', '<a class="b" href="Onboarding.html">+ Invite designer</a>'
$adm = $adm -replace '<a class="b" href="#" style="background:#3E2420">\+ Invite tailor</a>', '<button type="button" class="b" onclick="openReviewModal(''Karthik S.'', ''Tailor Application'', ''Pending Review'')\" style="background:#3E2420;border:none">+ Invite tailor</button>'
$adm = $adm -replace '<a class="b" href="#" style="background:#CFE0BE;color:#3E2420">\+ Add customer</a>', '<a class="b" href="Customer.html" style="background:#CFE0BE;color:#3E2420">+ Add customer</a>'
$adm = $adm -replace '<a class="b" href="#">Review</a>', '<button type="button" class="b" onclick="openReviewModal(''Meena R.'', ''Designer Application'', ''Identity Verified'')\" style="border:none">Review</button>'

$admModals = @'
<!-- Admin Review Modal -->
<div id="review-modal" class="tat-modal-overlay">
  <div class="tat-modal" style="max-width:500px">
    <button class="tat-modal-close" onclick="closeModal('review-modal')">&times;</button>
    <p class="sc" style="font-size:34px;color:#B24560;margin:0">Studio Administration</p>
    <h2 id="review-applicant-name" class="hd" style="font-size:28px;margin:0 0 4px">Meena R.</h2>
    <span id="review-applicant-role" class="p" style="background:#E3ECD8;margin-bottom:16px">Designer · Identity Unique</span>
    <div style="background:#fff;border:1.5px solid #E6CFA3;border-radius:16px;padding:16px;margin:16px 0;font-size:14px;line-height:1.6">
      <div><strong>Govt ID:</strong> Verified via DigiLocker</div>
      <div><strong>Role Check:</strong> Clean (Not registered as tailor)</div>
      <div><strong>Garments:</strong> 3-Dart Blouses, Salwar Sets</div>
      <div><strong>City:</strong> Chennai (T. Nagar)</div>
    </div>
    <div style="display:flex;justify-content:flex-end;gap:12px">
      <button type="button" class="b" onclick="closeModal('review-modal')" style="background:#EDE6DA;color:#3E2420;border:none">Reject</button>
      <button type="button" class="b" onclick="approveApplicant()" style="border:none">Approve & Issue ID</button>
    </div>
  </div>
</div>
'@
if ($adm -notmatch 'id="review-modal"') {
    $adm = $adm -replace '</body>', "$admModals`n<script src='app.js'></script>`n</body>"
}
[System.IO.File]::WriteAllText("$PSScriptRoot\Admin.html", $adm, [System.Text.Encoding]::UTF8)
Write-Host "Updated Admin.html"

# 6. Update Onboarding.html
$onb = Get-Content -Raw -Encoding UTF8 "Onboarding.html"
if ($onb -notmatch 'styles\.css') {
    $onb = $onb -replace '</head>', '<link rel="stylesheet" href="styles.css">`n</head>'
}
# Replace form placeholders with real interactive inputs
$formOld = @'
<div class="f">Full name</div>
<div class="f">WhatsApp number</div>
<div class="f">City</div>
<div class="f">Garments they draft (blouse, kurta, salwar...)</div>
<a class="b" href="#">Add and send invite</a>
'@

$formNew = @'
<form onsubmit="event.preventDefault(); inviteDesignerFromForm();">
  <input type="text" id="designerName" class="f" placeholder="Full name (e.g. Ananya Rao)" required style="width:100%;box-sizing:border-box">
  <input type="tel" id="designerPhone" class="f" placeholder="WhatsApp number (e.g. +91 98765 43210)" required style="width:100%;box-sizing:border-box">
  <input type="text" id="designerCity" class="f" placeholder="City (e.g. Chennai)" style="width:100%;box-sizing:border-box">
  <input type="text" id="designerGarments" class="f" placeholder="Garments (blouse, kurta, salwar...)" style="width:100%;box-sizing:border-box">
  <button type="submit" class="b" style="border:none">Add and send invite</button>
</form>
'@
$onb = $onb -replace [regex]::Escape($formOld), $formNew

# Wrap slots in a container with identifiable items
$onb = $onb -replace '<div class="r"><strong>TAT-D009</strong><span>Name pending</span><span class="p" style="background:#EDE6DA">Not invited</span><a class="b" href="#">Invite</a></div>', '<div class="r slot-uninvited"><strong>TAT-D009</strong><span class="slot-name">Name pending</span><span class="p" style="background:#EDE6DA">Not invited</span><button type="button" class="b" onclick="inviteDesignerFromForm()" style="border:none">Invite</button></div>'
$onb = $onb -replace '<div class="r" style="border:0"><strong>TAT-D010</strong><span>Name pending</span><span class="p" style="background:#EDE6DA">Not invited</span><a class="b" href="#">Invite</a></div>', '<div class="r slot-uninvited" style="border:0"><strong>TAT-D010</strong><span class="slot-name">Name pending</span><span class="p" style="background:#EDE6DA">Not invited</span><button type="button" class="b" onclick="inviteDesignerFromForm()" style="border:none">Invite</button></div>'

if ($onb -notmatch 'app\.js') {
    $onb = $onb -replace '</body>', "<script src='app.js'></script>`n</body>"
}
[System.IO.File]::WriteAllText("$PSScriptRoot\Onboarding.html", $onb, [System.Text.Encoding]::UTF8)
Write-Host "Updated Onboarding.html"

Write-Host "All files successfully enhanced!"
