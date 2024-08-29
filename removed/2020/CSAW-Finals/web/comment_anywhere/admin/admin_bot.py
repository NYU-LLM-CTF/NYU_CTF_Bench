import asyncio
from pyppeteer import launch


flag = 'flag{h0w_many_l@yers_of_yavaScr1pt_r_u_0n?}'
EXTENSION_PATH = '/opt/stuff/extension/'


async def main():
    while True:
        browser = await launch(
            headless=False,
            args=[
                '--no-sandbox',  # agh docker
                f'--disable-extensions-except={EXTENSION_PATH}',
                f'--load-extension={EXTENSION_PATH}',
            ],
        )

        try:
            print("Going to example.com")
            page = await browser.newPage()
            await page.goto('http://example.com/')
            await asyncio.sleep(2)

            print("Going to flag page")
            page2 = await browser.newPage()
            await page2.goto(f'http://example.com/{flag}')
            await asyncio.sleep(3)

        except Exception as e:
            print(e)

        await browser.close()

        await asyncio.sleep(15)


asyncio.get_event_loop().run_until_complete(main())
