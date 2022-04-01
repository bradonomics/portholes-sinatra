var fs = require('fs');
var { Readability } = require('@mozilla/readability');
var JSDOM = require('jsdom').JSDOM;

try {
  // `0` is a POSIX standard. It should store your stdin as a string.
  fs.readFile(0, 'utf8', function(err, data) {
    if (err) throw err;
    var doc = new JSDOM(data, { url: process.argv.slice(2) });
    var article = new Readability(doc.window.document).parse();
    console.log(article.content);
  });
} catch (error) {
  console.log(error instanceof TypeError);
}
