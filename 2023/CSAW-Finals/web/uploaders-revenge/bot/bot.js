const { firefox } = require('playwright')

const SITE = process.env.SITE || 'app'
const FLAG = process.env.FLAG || 'csawctf{test_flag}'

const sleep = async ms => new Promise(resolve => setTimeout(resolve, ms))

let browser = null

const visit = async url => {
	let context = null
	try {
		if (!browser) {
			browser = await firefox.launch({
				headless: true,
				// these are just for hardening, this isn't a pwn challenge
				// you can safely ignore this
				firefoxUserPrefs: {
					"privacy.firstparty.isolate": true,
					"media.peerconnection.enabled": false,
					"toolkit.telemetry.enabled": false,
					"geo.enabled": false,
					"javascript.options.wasm": false,
					"javascript.options.wasm_baselinejit": false,
					"javascript.options.wasm_ionjit": false,
					"javascript.options.asmjs": false,
					"javascript.options.ion": false,
					"javascript.options.baselinejit": false,
					"webgl.disabled": true,
				}
			})
		}

		context = await browser.newContext({
			storageState: {
				cookies: [{
					name: "FLAG",
					value: FLAG,
					domain: SITE,
					path: "/"
				}]
			}
		})

		const page = await context.newPage()
		console.log(`[+] Visiting ${url}`)
		await page.goto(url);
		await sleep(5000);
		await page.close();
		await context.close()
		console.log('[+] Done')
		context = null
	} catch (e) {
		console.log(e)
	} finally {
		if (context) await context.close()
	}
}

module.exports = visit

if (require.main === module) {
	visit(process.argv[2])
}
