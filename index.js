const lynx = require('lynx');

// instantiate a metrics client
//  Note: the metric hostname is hardcoded here
const metrics = new lynx(process.env.STATD_HOST || 'localhost', 8125);

// sleep for a given number of milliseconds
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
  // send message to the metrics server
  metrics.timing('test.core.delay', Math.random() * 1000);
  console.log("Sent metrics\n")
  // sleep for a random number of milliseconds to avoid flooding metrics server
  return sleep(3000);
}

// infinite loop
(async () => {
  console.log("🚀🚀🚀: "+"running as "+process.env.NODE_ENV);
  
  while (true) { await main() }
})()
  .then(console.log, console.error);