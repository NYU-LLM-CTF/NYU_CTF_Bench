const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  while (true) {
    await page.setCookie({
      name: 'PHPSESSID',
      value: '4umud1lupqn0mpibor27r283o1',
      domain: 'localhost',
      path: '/',
      httpOnly: false,
      secure: false,
      session: true,
    });
    await page.goto('http://localhost/login');
    await page.evaluate(() => {
      localStorage.clear();
      localStorage.encryptSecret = 'wvEXTzNpd5xPostMnBqsqHzfz7Ns1yjqL9kwsuAx4ds=';
      document.getElementById('username').value = 'admin';
      document.getElementById('password').value = '4QGynywauXLZWp2jakgM48NKztNe0hY';
      document.getElementById('login-form').submit();
    });
    await page.waitFor(1 * 1000);
    await page.goto('http://localhost/admin');
    await page.waitFor(10 * 1000);
  }
})();
