# this is function to start/stop vm

関数アプリにデプロイ&構成にVM4,RG4にアクセスしたいvmを変数として書いておく。

プロキシurl=https://{関数アプリ名}.azurewebsites.net/{start/stop/status}

#### 参照

DEV: Power virtual machines ON or OFF using Azure functions

https://dev.to/pwd9000/power-virtual-machines-on-or-off-using-azure-functions-4k8o

公式Doc: Azure Functions プロキシの操作

https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-proxies#requestOverrides

Functions で仮想マシンの起動停止を行うには：Cloud Steady

https://cloudsteady.jp/post/20796/

#### iorin_ioメモ

Functionsのバージョンが4.xだと、プロキシが機能してくれない

Functions v4.x でプロキシを再度有効にするには、環境変数に`AzureWebJobsFeatureFlags`を追加し、値を`EnableProxies`に設定する。
以上を行った上で、proxies.jsonを正しく記述してあげることで、プロキシ機能を使用することができる。

https://learn.microsoft.com/ja-jp/azure/azure-functions/legacy-proxies#re-enable-proxies-in-functions-v4x