$ErrorActionPreference = "Stop"

# Helper to inject portal switcher
function Get-PortalSwitcher($activePage) {
    $pages = @(
        @{ name = "Landing"; file = "index.html" },
        @{ name = "Customer"; file = "Customer.html" },
        @{ name = "Designer"; file = "Designer.html" },
        @{ name = "Tailor"; file = "Tailor.html" },
        @{ name = "Admin"; file = "Admin.html" },
        @{ name = "Onboarding"; file = "Onboarding.html" }
    )
    
    $links = @()
    foreach ($p in $pages) {
        $isActive = $p.file -eq $activePage
        $bg = if ($isActive) { "background:#B24560;color:#fff;font-weight:700;" } else { "color:#FCF2E9;" }
        $links += "<a href='$($p.file)' style='text-decoration:none;padding:5px 12px;border-radius:999px;font-size:13px;transition:all 0.2s;$bg'>$($p.name)</a>"
    }
    $linksHtml = $links -join "<span style='color:#CAA067;opacity:0.5'>•</span>"

    return @"
<!-- The Artisan Thread Portal Quick Switcher Bar -->
<div id="tat-portal-bar" style="position:fixed;bottom:18px;right:18px;z-index:999999;background:#3E2420;color:#FCF2E9;border-radius:999px;box-shadow:0 10px 35px rgba(0,0,0,0.35);padding:8px 16px;display:flex;align-items:center;gap:10px;font-family:'Jost',system-ui,sans-serif;font-size:13px;border:1.5px solid #CAA067;backdrop-filter:blur(10px)">
  <span style="font-weight:600;color:#E6CFA3;display:flex;align-items:center;gap:7px;">
    <span style="width:9px;height:9px;border-radius:50%;background:#48bb78;display:inline-block;box-shadow:0 0 8px #48bb78"></span>
    Portals:
  </span>
  $linksHtml
</div>
"@
}

# 1. BUILD index.html from Main.dc.html
$mainContent = Get-Content -Raw -Encoding UTF8 "Main.dc.html"
$mainContent = $mainContent -replace '\{\{accent\}\}', '#B24560'
$mainContent = $mainContent -replace '\s*<script src="\./_runtime/[^"]+"></script>', ''
$mainContent = $mainContent -replace '<x-dc>', ''
$mainContent = $mainContent -replace '</x-dc>', ''
$mainContent = $mainContent -replace '<helmet>', ''
$mainContent = $mainContent -replace '</helmet>', ''
$mainContent = $mainContent -replace '(?s)<script type="text/x-dc".*?</script>', ''

# Enhance Login section in index.html with interactive role portal cards
$roleCards = @'
<section id="login" style="margin:0 3% 72px;padding:64px 5%;border-radius:36px;background:#B24560;color:#fff;text-align:center;outline:2px dashed rgba(255,255,255,.65);outline-offset:-16px">
<h2 class="hd" style="margin:0 0 10px;font-size:clamp(36px,5vw,62px);line-height:1.05;font-weight:700">Need a garment that fits? Choose your portal.</h2>
<p class="sc" style="margin:0 0 20px;font-size:50px;line-height:1.1">Where Fabric Becomes Art</p>
<p style="margin:0 auto 36px;font-size:18px;max-width:640px">Select your role to access your personal workspace, measurement profiles, pattern drafts, or tailor jobs.</p>
<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:20px;max-width:1100px;margin:0 auto;text-align:left">
  <a href="Customer.html" style="background:#fff;color:#3E2420;border-radius:20px;padding:24px;display:block;text-decoration:none;box-shadow:0 8px 24px rgba(0,0,0,0.15);transition:transform 0.2s" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='none'">
    <span class="pill" style="background:#F8CBD0;color:#7A3B3F;margin-bottom:12px">Customer</span>
    <h3 class="hd" style="margin:0 0 8px;font-size:24px">Customer Portal</h3>
    <p style="margin:0 0 16px;font-size:14px;color:#6B4A42">Save your 13 measurements once, track order ORD-1042, and select or match custom designers.</p>
    <span style="font-weight:600;font-size:14px;color:#B24560">Enter Customer Home &rarr;</span>
  </a>
  <a href="Designer.html" style="background:#fff;color:#3E2420;border-radius:20px;padding:24px;display:block;text-decoration:none;box-shadow:0 8px 24px rgba(0,0,0,0.15);transition:transform 0.2s" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='none'">
    <span class="pill" style="background:#E3ECD8;color:#3E2420;margin-bottom:12px">Designer · TAT-D001</span>
    <h3 class="hd" style="margin:0 0 8px;font-size:24px">Designer Studio</h3>
    <p style="margin:0 0 16px;font-size:14px;color:#6B4A42">Review orders to draft, publish 3-dart blouse or kurta methods, and calculate scale formulas.</p>
    <span style="font-weight:600;font-size:14px;color:#B24560">Open Studio &rarr;</span>
  </a>
  <a href="Tailor.html" style="background:#fff;color:#3E2420;border-radius:20px;padding:24px;display:block;text-decoration:none;box-shadow:0 8px 24px rgba(0,0,0,0.15);transition:transform 0.2s" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='none'">
    <span class="pill" style="background:#FBE4DC;color:#3E2420;margin-bottom:12px">Hub Tailor</span>
    <h3 class="hd" style="margin:0 0 8px;font-size:24px">Tailor Workshop</h3>
    <p style="margin:0 0 16px;font-size:14px;color:#6B4A42">Stitch garments from ready-to-cut scale patterns, print pattern sheets, and track job rates.</p>
    <span style="font-weight:600;font-size:14px;color:#B24560">View Cutting & Stitching Jobs &rarr;</span>
  </a>
  <a href="Admin.html" style="background:#fff;color:#3E2420;border-radius:20px;padding:24px;display:block;text-decoration:none;box-shadow:0 8px 24px rgba(0,0,0,0.15);transition:transform 0.2s" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='none'">
    <span class="pill" style="background:#3E2420;color:#FCF2E9;margin-bottom:12px">Admin</span>
    <h3 class="hd" style="margin:0 0 8px;font-size:24px">Admin Overview</h3>
    <p style="margin:0 0 16px;font-size:14px;color:#6B4A42">Manage designer onboarding queue, approve drafting methods, and enforce one-role rules.</p>
    <span style="font-weight:600;font-size:14px;color:#B24560">Open Admin Dashboard &rarr;</span>
  </a>
</div>
</section>
'@

$mainContent = $mainContent -replace '(?s)<section id="login".*?</section>', $roleCards

# Update button links
$mainContent = $mainContent -replace 'href="#login" class="btn" style="background:#B24560;color:#fff">Log in to start</a>', 'href="#login" class="btn" style="background:#B24560;color:#fff">Choose Portal to Start</a>'
$mainContent = $mainContent -replace 'href="#designers" class="btn" style="border:1.5px solid #3E2420">Join as a designer</a>', 'href="Onboarding.html" class="btn" style="border:1.5px solid #3E2420">Join as a designer</a>'
$mainContent = $mainContent -replace 'href="#login" class="btn" style="background:#B24560;color:#fff">Give it a try</a>', 'href="Customer.html" class="btn" style="background:#B24560;color:#fff">Give it a try</a>'
$mainContent = $mainContent -replace 'href="#login" class="btn" style="background:#B24560;color:#fff">Apply as a designer</a>', 'href="Onboarding.html" class="btn" style="background:#B24560;color:#fff">Apply as a designer</a>'
$mainContent = $mainContent -replace 'href="#login" class="btn" style="background:#B24560;color:#fff">Apply as a tailor</a>', 'href="Tailor.html" class="btn" style="background:#B24560;color:#fff">Apply as a tailor</a>'

# Add portal switcher before </body>
$switcherHtml = Get-PortalSwitcher "index.html"
$mainContent = $mainContent -replace '</body>', "$switcherHtml`n</body>"

[System.IO.File]::WriteAllText("$PSScriptRoot\index.html", $mainContent, [System.Text.Encoding]::UTF8)
Write-Host "Created index.html"

# 2. Helper to clean other dc.html files
function Convert-DcHtml($sourceFile, $targetFile) {
    $content = Get-Content -Raw -Encoding UTF8 $sourceFile
    $content = $content -replace '\s*<script src="\./_runtime/[^"]+"></script>', ''
    $content = $content -replace '<x-dc>', ''
    $content = $content -replace '</x-dc>', ''
    $content = $content -replace '<helmet>', ''
    $content = $content -replace '</helmet>', ''
    $content = $content -replace '(?s)<script type="text/x-dc".*?</script>', ''
    
    # Fix Home links to point to index.html
    $content = $content -replace '<a href="#">Home</a>', '<a href="index.html">Home</a>'
    $content = $content -replace '<a href="#">Overview</a>', '<a href="Admin.html">Overview</a>'
    $content = $content -replace '<a href="#">Onboarding</a>', '<a href="Onboarding.html">Onboarding</a>'
    $content = $content -replace '<a href="#"><strong>Onboarding</strong></a>', '<a href="Onboarding.html"><strong>Onboarding</strong></a>'
    $content = $content -replace '<a href="#">Methods</a>', '<a href="Designer.html">Methods</a>'
    $content = $content -replace '<a href="#">Orders</a>', '<a href="Customer.html">Orders</a>'

    # Make brand logo link to index.html
    $content = $content -replace '<span class="sc" style="font-size:36px;color:#7A3B3F">The Artisan Thread</span>', '<a href="index.html" class="sc" style="font-size:36px;color:#7A3B3F;text-decoration:none">The Artisan Thread</a>'

    $sw = Get-PortalSwitcher $targetFile
    $content = $content -replace '</body>', "$sw`n</body>"

    [System.IO.File]::WriteAllText("$PSScriptRoot\$targetFile", $content, [System.Text.Encoding]::UTF8)
    Write-Host "Created $targetFile"
}

Convert-DcHtml "Customer.dc.html" "Customer.html"
Convert-DcHtml "Designer.dc.html" "Designer.html"
Convert-DcHtml "Tailor.dc.html" "Tailor.html"
Convert-DcHtml "Admin.dc.html" "Admin.html"
Convert-DcHtml "Onboarding.dc.html" "Onboarding.html"

Write-Host "All portal files converted successfully!"
