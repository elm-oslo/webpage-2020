const ParcelProxyServer = require("parcel-proxy-server");

// configure the proxy server
const server = new ParcelProxyServer({
  entryPoint: "public/index.html",
  parcelOptions: {},
  proxies: {
    "/.netlify/functions": {
      target: "http://localhost:9000",
      pathRewrite: {
        "^/\\.netlify/functions": ""
      }
    }
  }
});

// the underlying parcel bundler is exposed on the server
// and can be used if needed
server.bundler.on("buildEnd", () => {
  console.log("Build completed!");
});

// start up the server
server.listen(1234, () => {
  console.log("Parcel proxy server has started");
});
