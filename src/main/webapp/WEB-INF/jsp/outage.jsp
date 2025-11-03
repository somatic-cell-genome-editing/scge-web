<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/3/2025
  Time: 8:11 AM
  To change this template use File | Settings | File Templates.
--%>

<style>
    .outage-banner {
        background: #fef2f2;
        border-bottom: 3px solid #ef4444;
        padding: 1rem 0;
        position: relative;
        z-index: 1000;
    }

    .outage-banner-content {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 1.5rem;
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .outage-icon {
        flex-shrink: 0;
        width: 2.5rem;
        height: 2.5rem;
        background: #ef4444;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.25rem;
        font-weight: bold;
    }

    .outage-message {
        flex: 1;
    }

    .outage-message strong {
        color: #991b1b;
        font-weight: 700;
        font-size: 1rem;
        display: block;
        margin-bottom: 0.25rem;
    }

    .outage-message p {
        color: #7f1d1d;
        margin: 0;
        font-size: 0.9rem;
        line-height: 1.5;
    }

    .outage-close {
        flex-shrink: 0;
        background: transparent;
        border: none;
        color: #991b1b;
        font-size: 1.5rem;
        cursor: pointer;
        padding: 0.5rem;
        line-height: 1;
        opacity: 0.7;
        transition: opacity 0.2s;
    }

    .outage-close:hover {
        opacity: 1;
    }

    .outage-banner.hidden {
        display: none;
    }

    @media (max-width: 768px) {
        .outage-banner-content {
            flex-direction: column;
            text-align: center;
            gap: 0.75rem;
        }

        .outage-message strong {
            font-size: 0.95rem;
        }

        .outage-message p {
            font-size: 0.85rem;
        }
    }
</style>

<div class="outage-banner" id="outageBanner">
    <div class="outage-banner-content">
        <div class="outage-icon">
            <span>!</span>
        </div>
        <div class="outage-message">
            <strong>Scheduled Maintenance Notice</strong>
            <p>The site will be undergoing scheduled maintenance on Monday 3rd November 2025 from 11:00AM to 2:00PM Central Time (CT). During this time, the site may be temporarily unavailable. We apologize for any inconvenience.</p>
        </div>
        <%--        <button class="outage-close" onclick="dismissOutageBanner()" aria-label="Dismiss message">--%>
        <%--            &times;--%>
        <%--        </button>--%>
    </div>
</div>

<script>
    function dismissOutageBanner() {
        var banner = document.getElementById('outageBanner');
        if (banner) {
            banner.classList.add('hidden');
            // Store dismissal in session storage so it stays dismissed during the session
            sessionStorage.setItem('outageBannerDismissed', 'true');
        }
    }

    // Check if banner was previously dismissed in this session
    if (sessionStorage.getItem('outageBannerDismissed') === 'true') {
        var banner = document.getElementById('outageBanner');
        if (banner) {
            banner.classList.add('hidden');
        }
    }
</script>