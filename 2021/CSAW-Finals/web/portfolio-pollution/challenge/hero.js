import puppeteer from 'puppeteer';

const browserOptions = {
    headless: true,
    args: [
        '--disable-background-networking',
        '--disable-default-apps',
        '--disable-extensions',
        '--disable-gpu',
        '--disable-sync',
        '--disable-translate',
        '--hide-scrollbars',
        '--metrics-recording-only',
        '--mute-audio',
        '--no-first-run',
        '--no-sandbox',
        '--safebrowsing-disable-auto-update'
    ]
};

async function emergencyAlert() {
    const browser = await puppeteer.launch(browserOptions);
    const page = await browser.newPage();

    await page.setCookie({
        'name': 'flag',
        'value': 'flag{w0w_y0u_23411y_w3n7_83y0nd_p1u5_u1724_f02_7h15_0n3}',
        'url': 'http://localhost:8080'
    });

    const url = 'http://localhost:8080/handle-emergency';
    const pageOptions = {waitUntil: 'networkidle2'};

    await page.goto(url, pageOptions);

    await browser.close();
};

export { emergencyAlert };
