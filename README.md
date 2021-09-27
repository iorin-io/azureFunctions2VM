# this is function to start/stop vm

関数アプリにデプロイ&構成にVM4,RG4にアクセスしたいvmを変数として書いておく。

proxies.jsonはこんな感じ

プロキシurl=https://{関数アプリ名}.azurewebsites.net/{start/stop/status}

'''
{
  "$schema": "http://json.schemastore.org/proxies",
  "proxies": {
    "proxy1": {
      "matchCondition": {
          "methods": [ "GET" ,"POST"],
          "route": "/{Action}"
      },
      "backendUri": "https://{関数アプリ名}.azurewebsites.net/api/{function名}",
      "requestOverrides": {
        "backend.request.method":"POST",
        "backend.request.querystring.Action": "{Action}"
    }
    }
  }
}
'''