const cheerio = require(`cheerio`);
const fetch = require(`node-fetch`);
const { createHash } = require('crypto');

const url = 'https://www.imdb.com/title/tt0096579/quotes/?item=qt0237571#';
const params = {
  "credentials": "include",
  "headers": {
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0",
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
      "Accept-Language": "en-US,en;q=0.5",
      "Alt-Used": "www.imdb.com",
      "Upgrade-Insecure-Requests": "1",
      "Sec-Fetch-Dest": "document",
      "Sec-Fetch-Mode": "navigate",
      "Sec-Fetch-Site": "cross-site"
  },
  "method": "GET",
  "mode": "cors"
}

const fetchData = async () => {
    try {
      const response = await fetch(url, params);
      
      if (!response.ok) throw new Error(`HTTP error! Status: ${ response.status }`);
      
      return response.text();
    } catch (error) {
      console.error(`Error fetching data:`, error);
  
      return ``;
    }
};

const hashData = (data) => createHash('sha256').update(data).digest('hex');

const parseHtml = async () => {
    try {
        const html = await fetchData();
        const $ = cheerio.load(html);
        const lis = $(`li`);
        const map = {}

        for (const li of lis) {
            const text = $(li).text().trim();

            const isUrkel = text.includes('Steve Urkel: ');
            if (!isUrkel) continue;
            
            const quote = text.split('Steve Urkel: ').pop()
            map[hashData(quote)] = quote
        }
        
        console.log(map)
      } catch (error) { console.error(error); throw error; }
}

(async () => parseHtml())();