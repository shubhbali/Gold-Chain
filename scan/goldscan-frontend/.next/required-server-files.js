self.__SERVER_FILES_MANIFEST={
  "version": 1,
  "config": {
    "env": {},
    "typescript": {
      "ignoreBuildErrors": false
    },
    "typedRoutes": false,
    "distDir": ".next",
    "cleanDistDir": true,
    "assetPrefix": "",
    "cacheMaxMemorySize": 52428800,
    "configOrigin": "next.config.js",
    "useFileSystemPublicRoutes": true,
    "generateEtags": true,
    "pageExtensions": [
      "tsx",
      "ts",
      "jsx",
      "js"
    ],
    "poweredByHeader": true,
    "compress": true,
    "images": {
      "deviceSizes": [
        640,
        750,
        828,
        1080,
        1200,
        1920,
        2048,
        3840
      ],
      "imageSizes": [
        32,
        48,
        64,
        96,
        128,
        256,
        384
      ],
      "path": "/_next/image",
      "loader": "default",
      "loaderFile": "",
      "domains": [],
      "disableStaticImages": false,
      "minimumCacheTTL": 14400,
      "formats": [
        "image/webp"
      ],
      "maximumRedirects": 3,
      "maximumResponseBody": 50000000,
      "dangerouslyAllowLocalIP": false,
      "dangerouslyAllowSVG": false,
      "contentSecurityPolicy": "script-src 'none'; frame-src 'none'; sandbox;",
      "contentDispositionType": "attachment",
      "localPatterns": [
        {
          "pathname": "**",
          "search": ""
        }
      ],
      "remotePatterns": [],
      "qualities": [
        75
      ],
      "unoptimized": false
    },
    "devIndicators": {
      "position": "bottom-left"
    },
    "onDemandEntries": {
      "maxInactiveAge": 60000,
      "pagesBufferLength": 5
    },
    "basePath": "",
    "sassOptions": {},
    "trailingSlash": false,
    "i18n": null,
    "productionBrowserSourceMaps": false,
    "excludeDefaultMomentLocales": true,
    "reactProductionProfiling": false,
    "reactStrictMode": true,
    "reactMaxHeadersLength": 6000,
    "httpAgentOptions": {
      "keepAlive": true
    },
    "logging": {},
    "compiler": {},
    "expireTime": 31536000,
    "staticPageGenerationTimeout": 60,
    "output": "standalone",
    "modularizeImports": {
      "@mui/icons-material": {
        "transform": "@mui/icons-material/{{member}}"
      },
      "lodash": {
        "transform": "lodash/{{member}}"
      }
    },
    "outputFileTracingRoot": "/srv/repos/gold-chain/scan/goldscan-frontend",
    "cacheComponents": false,
    "cacheLife": {
      "default": {
        "stale": 180,
        "revalidate": 900,
        "expire": 4294967294
      },
      "seconds": {
        "stale": 30,
        "revalidate": 1,
        "expire": 60
      },
      "minutes": {
        "stale": 300,
        "revalidate": 60,
        "expire": 3600
      },
      "hours": {
        "stale": 300,
        "revalidate": 3600,
        "expire": 86400
      },
      "days": {
        "stale": 300,
        "revalidate": 86400,
        "expire": 604800
      },
      "weeks": {
        "stale": 300,
        "revalidate": 604800,
        "expire": 2592000
      },
      "max": {
        "stale": 300,
        "revalidate": 2592000,
        "expire": 31536000
      }
    },
    "cacheHandlers": {},
    "experimental": {
      "useSkewCookie": false,
      "cssChunking": true,
      "multiZoneDraftMode": false,
      "appNavFailHandling": false,
      "prerenderEarlyExit": true,
      "serverMinification": true,
      "linkNoTouchStart": false,
      "caseSensitiveRoutes": false,
      "dynamicOnHover": false,
      "preloadEntriesOnStart": true,
      "clientRouterFilter": true,
      "clientRouterFilterRedirects": false,
      "fetchCacheKeyPrefix": "",
      "proxyPrefetch": "flexible",
      "optimisticClientCache": true,
      "manualClientBasePath": false,
      "cpus": 7,
      "memoryBasedWorkersCount": false,
      "imgOptConcurrency": null,
      "imgOptTimeoutInSeconds": 7,
      "imgOptMaxInputPixels": 268402689,
      "imgOptSequentialRead": null,
      "imgOptSkipMetadata": null,
      "isrFlushToDisk": true,
      "workerThreads": false,
      "optimizeCss": false,
      "nextScriptWorkers": false,
      "scrollRestoration": false,
      "externalDir": false,
      "disableOptimizedLoading": false,
      "gzipSize": true,
      "craCompat": false,
      "esmExternals": true,
      "fullySpecified": false,
      "swcTraceProfiling": false,
      "forceSwcTransforms": false,
      "largePageDataBytes": 128000,
      "typedEnv": false,
      "parallelServerCompiles": false,
      "parallelServerBuildTraces": false,
      "ppr": false,
      "authInterrupts": false,
      "webpackMemoryOptimizations": false,
      "optimizeServerReact": true,
      "viewTransition": false,
      "removeUncaughtErrorAndRejectionListeners": false,
      "validateRSCRequestHeaders": false,
      "staleTimes": {
        "dynamic": 30,
        "static": 180
      },
      "reactDebugChannel": false,
      "serverComponentsHmrCache": true,
      "staticGenerationMaxConcurrency": 8,
      "staticGenerationMinPagesPerWorker": 25,
      "transitionIndicator": false,
      "inlineCss": false,
      "useCache": false,
      "globalNotFound": false,
      "browserDebugInfoInTerminal": false,
      "lockDistDir": true,
      "isolatedDevBuild": true,
      "proxyClientMaxBodySize": 10485760,
      "hideLogsAfterAbort": false,
      "mcpServer": true,
      "turbopackFileSystemCacheForDev": true,
      "turbopackFileSystemCacheForBuild": false,
      "turbopackInferModuleSideEffects": false,
      "optimizePackageImports": [
        "lucide-react",
        "date-fns",
        "lodash-es",
        "ramda",
        "antd",
        "react-bootstrap",
        "ahooks",
        "@ant-design/icons",
        "@headlessui/react",
        "@headlessui-float/react",
        "@heroicons/react/20/solid",
        "@heroicons/react/24/solid",
        "@heroicons/react/24/outline",
        "@visx/visx",
        "@tremor/react",
        "rxjs",
        "@mui/material",
        "@mui/icons-material",
        "recharts",
        "react-use",
        "effect",
        "@effect/schema",
        "@effect/platform",
        "@effect/platform-node",
        "@effect/platform-browser",
        "@effect/platform-bun",
        "@effect/sql",
        "@effect/sql-mssql",
        "@effect/sql-mysql2",
        "@effect/sql-pg",
        "@effect/sql-sqlite-node",
        "@effect/sql-sqlite-bun",
        "@effect/sql-sqlite-wasm",
        "@effect/sql-sqlite-react-native",
        "@effect/rpc",
        "@effect/rpc-http",
        "@effect/typeclass",
        "@effect/experimental",
        "@effect/opentelemetry",
        "@material-ui/core",
        "@material-ui/icons",
        "@tabler/icons-react",
        "mui-core",
        "react-icons/ai",
        "react-icons/bi",
        "react-icons/bs",
        "react-icons/cg",
        "react-icons/ci",
        "react-icons/di",
        "react-icons/fa",
        "react-icons/fa6",
        "react-icons/fc",
        "react-icons/fi",
        "react-icons/gi",
        "react-icons/go",
        "react-icons/gr",
        "react-icons/hi",
        "react-icons/hi2",
        "react-icons/im",
        "react-icons/io",
        "react-icons/io5",
        "react-icons/lia",
        "react-icons/lib",
        "react-icons/lu",
        "react-icons/md",
        "react-icons/pi",
        "react-icons/ri",
        "react-icons/rx",
        "react-icons/si",
        "react-icons/sl",
        "react-icons/tb",
        "react-icons/tfi",
        "react-icons/ti",
        "react-icons/vsc",
        "react-icons/wi"
      ],
      "trustHostHeader": false,
      "isExperimentalCompile": false
    },
    "htmlLimitedBots": "[\\w-]+-Google|Google-[\\w-]+|Chrome-Lighthouse|Slurp|DuckDuckBot|baiduspider|yandex|sogou|bitlybot|tumblr|vkShare|quora link preview|redditbot|ia_archiver|Bingbot|BingPreview|applebot|facebookexternalhit|facebookcatalog|Twitterbot|LinkedInBot|Slackbot|Discordbot|WhatsApp|SkypeUriPreview|Yeti|googleweblight",
    "bundlePagesRouterDependencies": false,
    "configFileName": "next.config.js",
    "transpilePackages": [
      "react-syntax-highlighter"
    ],
    "turbopack": {
      "rules": {
        "*.svg": {
          "loaders": [
            "@svgr/webpack"
          ],
          "as": "*.js"
        }
      },
      "resolveAlias": {
        "fs": {
          "browser": "./nextjs/empty-module.js"
        },
        "net": {
          "browser": "./nextjs/empty-module.js"
        },
        "tls": {
          "browser": "./nextjs/empty-module.js"
        }
      },
      "root": "/srv/repos/gold-chain/scan/goldscan-frontend"
    },
    "serverExternalPackages": [
      "@opentelemetry/sdk-node",
      "@opentelemetry/auto-instrumentations-node",
      "pino-pretty",
      "lokijs",
      "encoding"
    ],
    "outDir": "nextjs",
    "distDirRoot": ".next",
    "_originalRewrites": {
      "beforeFiles": [],
      "afterFiles": [
        {
          "source": "/node-api/proxy/:slug*",
          "destination": "/api/proxy"
        },
        {
          "source": "/node-api/:slug*",
          "destination": "/api/:slug*"
        }
      ],
      "fallback": []
    },
    "_originalRedirects": [
      {
        "source": "/account/tag_address",
        "destination": "/account/tag-address",
        "permanent": false
      },
      {
        "source": "/account/tag_address/new",
        "destination": "/account/tag-address",
        "permanent": false
      },
      {
        "source": "/account/tag_transaction",
        "destination": "/account/tag-address?tab=tx",
        "permanent": false
      },
      {
        "source": "/account/tag_transaction/new",
        "destination": "/account/tag-address?tab=tx",
        "permanent": false
      },
      {
        "source": "/account/watchlist_address/:id/edit",
        "destination": "/account/watchlist",
        "permanent": false
      },
      {
        "source": "/account/watchlist_address/new",
        "destination": "/account/watchlist",
        "permanent": false
      },
      {
        "source": "/account/api_key",
        "destination": "/account/api-key",
        "permanent": false
      },
      {
        "source": "/account/api_key/:id/edit",
        "destination": "/account/api-key",
        "permanent": false
      },
      {
        "source": "/account/api_key/new",
        "destination": "/account/api-key",
        "permanent": false
      },
      {
        "source": "/account/custom_abi",
        "destination": "/account/custom-abi",
        "permanent": false
      },
      {
        "source": "/account/custom_abi/:id/edit",
        "destination": "/account/custom-abi",
        "permanent": false
      },
      {
        "source": "/account/custom_abi/new",
        "destination": "/account/custom-abi",
        "permanent": false
      },
      {
        "source": "/account/public-tags-request",
        "destination": "/public-tags/submit",
        "permanent": false
      },
      {
        "source": "/account/rewards",
        "destination": "/account/merits",
        "permanent": false
      },
      {
        "source": "/pending-transactions",
        "destination": "/txs?tab=pending",
        "permanent": false
      },
      {
        "source": "/tx/:hash/internal-transactions",
        "destination": "/tx/:hash?tab=internal",
        "permanent": false
      },
      {
        "source": "/tx/:hash/logs",
        "destination": "/tx/:hash?tab=logs",
        "permanent": false
      },
      {
        "source": "/tx/:hash/raw-trace",
        "destination": "/tx/:hash?tab=raw_trace",
        "permanent": false
      },
      {
        "source": "/tx/:hash/state",
        "destination": "/tx/:hash?tab=state",
        "permanent": false
      },
      {
        "source": "/tx/:hash/token-transfers",
        "destination": "/tx/:hash?tab=token_transfers",
        "permanent": false
      },
      {
        "source": "/blocks/:height/:path*",
        "destination": "/block/:height/:path*",
        "permanent": false
      },
      {
        "source": "/uncles",
        "destination": "/blocks?tab=uncles",
        "permanent": false
      },
      {
        "source": "/reorgs",
        "destination": "/blocks?tab=reorgs",
        "permanent": false
      },
      {
        "source": "/block/:height/transactions",
        "destination": "/block/:height?tab=txs",
        "permanent": false
      },
      {
        "source": "/block/:height/withdrawals",
        "destination": "/block/:height?tab=withdrawals",
        "permanent": false
      },
      {
        "source": "/address/:hash/transactions",
        "destination": "/address/:hash",
        "permanent": false
      },
      {
        "source": "/address/:hash/token-transfers",
        "destination": "/address/:hash?tab=token_transfers",
        "permanent": false
      },
      {
        "source": "/address/:hash/tokens",
        "destination": "/address/:hash?tab=tokens",
        "permanent": false
      },
      {
        "source": "/address/:hash/internal-transactions",
        "destination": "/address/:hash?tab=internal_txns",
        "permanent": false
      },
      {
        "source": "/address/:hash/coin-balances",
        "destination": "/address/:hash?tab=coin_balance_history",
        "permanent": false
      },
      {
        "source": "/address/:hash/logs",
        "destination": "/address/:hash?tab=logs",
        "permanent": false
      },
      {
        "source": "/address/:hash/validations",
        "destination": "/address/:hash?tab=blocks_validated",
        "permanent": false
      },
      {
        "source": "/address/:hash/contracts",
        "destination": "/address/:hash?tab=contract",
        "permanent": false
      },
      {
        "source": "/address/:hash/read-contract",
        "destination": "/address/:hash?tab=read_contract",
        "permanent": false
      },
      {
        "source": "/address/:hash/read-proxy",
        "destination": "/address/:hash?tab=read_proxy",
        "permanent": false
      },
      {
        "source": "/address/:hash/write-contract",
        "destination": "/address/:hash?tab=write_contract",
        "permanent": false
      },
      {
        "source": "/address/:hash/write-proxy",
        "destination": "/address/:hash?tab=write_proxy",
        "permanent": false
      },
      {
        "source": "/address/:hash/tokens/:token_hash/token-transfers",
        "destination": "/address/:hash?tab=token_transfers&token=:token_hash",
        "permanent": false
      },
      {
        "source": "/address/:hash/contract_verifications/new",
        "destination": "/address/:hash/contract_verification",
        "permanent": false
      },
      {
        "source": "/address/:hash/verify-via-flattened-code/new",
        "destination": "/address/:hash/contract_verification?method=flatten_source_code",
        "permanent": false
      },
      {
        "source": "/address/:hash/verify-via-standard-json-input/new",
        "destination": "/address/:hash/contract_verification?method=standard_input",
        "permanent": false
      },
      {
        "source": "/address/:hash/verify-via-metadata-json/new",
        "destination": "/address/:hash/contract_verification?method=sourcify",
        "permanent": false
      },
      {
        "source": "/address/:hash/verify-via-multi-part-files/new",
        "destination": "/address/:hash/contract_verification?method=multi_part_file",
        "permanent": false
      },
      {
        "source": "/address/:hash/verify-vyper-contract/new",
        "destination": "/address/:hash/contract_verification?method=vyper_contract",
        "permanent": false
      },
      {
        "source": "/bridged-tokens",
        "destination": "/tokens/?tab=bridged",
        "permanent": false
      },
      {
        "source": "/bridged-tokens/:chain_name",
        "destination": "/tokens/?tab=bridged",
        "permanent": false
      },
      {
        "source": "/tokens/:hash/:path*",
        "destination": "/token/:hash/:path*",
        "permanent": false
      },
      {
        "source": "/token/:hash/token-transfers",
        "destination": "/token/:hash/?tab=token_transfers",
        "permanent": false
      },
      {
        "source": "/token/:hash/token-holders",
        "destination": "/token/:hash/?tab=holders",
        "permanent": false
      },
      {
        "source": "/token/:hash/inventory",
        "destination": "/token/:hash/?tab=inventory",
        "permanent": false
      },
      {
        "source": "/token/:hash/instance/:id/token-transfers",
        "destination": "/token/:hash/instance/:id",
        "permanent": false
      },
      {
        "source": "/token/:hash/instance/:id/token-holders",
        "destination": "/token/:hash/instance/:id?tab=holders",
        "permanent": false
      },
      {
        "source": "/token/:hash/instance/:id/metadata",
        "destination": "/token/:hash/instance/:id?tab=metadata",
        "permanent": false
      },
      {
        "source": "/token/:hash/read-contract",
        "destination": "/token/:hash?tab=read_contract",
        "permanent": false
      },
      {
        "source": "/token/:hash/read-proxy",
        "destination": "/token/:hash?tab=read_proxy",
        "permanent": false
      },
      {
        "source": "/token/:hash/write-contract",
        "destination": "/token/:hash?tab=write_contract",
        "permanent": false
      },
      {
        "source": "/token/:hash/write-proxy",
        "destination": "/token/:hash?tab=write_proxy",
        "permanent": false
      },
      {
        "source": "/l2-txn-batches",
        "destination": "/batches",
        "permanent": false
      },
      {
        "source": "/zkevm-l2-txn-batches",
        "destination": "/batches",
        "permanent": false
      },
      {
        "source": "/zkevm-l2-txn-batch/:path*",
        "destination": "/batches/:path*",
        "permanent": false
      },
      {
        "source": "/l2-deposits",
        "destination": "/deposits",
        "permanent": false
      },
      {
        "source": "/l2-withdrawals",
        "destination": "/withdrawals",
        "permanent": false
      },
      {
        "source": "/l2-output-roots",
        "destination": "/output-roots",
        "permanent": false
      },
      {
        "source": "/txsAA",
        "destination": "/ops",
        "permanent": true
      },
      {
        "source": "/txs",
        "has": [
          {
            "type": "query",
            "key": "block"
          }
        ],
        "destination": "/block/:block?tab=txs",
        "permanent": true
      },
      {
        "source": "/txsInternal",
        "has": [
          {
            "type": "query",
            "key": "block"
          }
        ],
        "destination": "/block/:block?tab=internal_txs",
        "permanent": true
      },
      {
        "source": "/txsInternal",
        "destination": "/internal-txs",
        "permanent": true
      },
      {
        "source": "/blocks_forked",
        "destination": "/blocks?tab=reorgs",
        "permanent": true
      },
      {
        "source": "/contractsVerified",
        "destination": "/verified-contracts",
        "permanent": true
      },
      {
        "source": "/verifyContract",
        "has": [
          {
            "type": "query",
            "key": "a"
          }
        ],
        "destination": "/address/:a/contract-verification",
        "permanent": true
      },
      {
        "source": "/verifyContract",
        "destination": "/contract-verification",
        "permanent": true
      },
      {
        "source": "/tokentxns",
        "destination": "/token-transfers",
        "permanent": true
      },
      {
        "source": "/nft/:hash/:id",
        "destination": "/token/:hash/instance/:id",
        "permanent": true
      },
      {
        "source": "/charts",
        "destination": "/stats",
        "permanent": true
      },
      {
        "source": "/nft-latest-mints",
        "destination": "/advanced-filter?transaction_types=ERC-1155%2CERC-721&methods=0xa0712d68&methods_names=mint",
        "permanent": true
      },
      {
        "source": "/nft-transfers",
        "destination": "/advanced-filter?transaction_types=ERC-1155%2CERC-721",
        "permanent": true
      },
      {
        "source": "/name-lookup-search",
        "destination": "/name-domains",
        "permanent": true
      },
      {
        "source": "/txsExit",
        "destination": "/withdrawals",
        "permanent": true
      },
      {
        "source": "/txsEnqueued",
        "destination": "/deposits",
        "permanent": true
      },
      {
        "source": "/cc/txs",
        "destination": "/txs?tab=cctx",
        "permanent": true
      },
      {
        "source": "/graphiql",
        "destination": "/api-docs?tab=graphql_api",
        "permanent": true
      },
      {
        "source": "/name-domains",
        "destination": "/name-services",
        "permanent": true
      },
      {
        "source": "/name-domains/:name",
        "destination": "/name-services/domains/:name",
        "permanent": true
      }
    ]
  },
  "appDir": "/srv/repos/gold-chain/scan/goldscan-frontend",
  "relativeAppDir": "",
  "files": [
    ".next/routes-manifest.json",
    ".next/server/pages-manifest.json",
    ".next/build-manifest.json",
    ".next/prerender-manifest.json",
    ".next/server/functions-config-manifest.json",
    ".next/server/middleware-manifest.json",
    ".next/server/middleware-build-manifest.js",
    ".next/BUILD_ID",
    ".next/server/next-font-manifest.js",
    ".next/server/next-font-manifest.json",
    ".next/required-server-files.json",
    ".next/server/instrumentation.js"
  ],
  "ignore": []
}