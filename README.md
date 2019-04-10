# aws-parameter-store-helpers
Powershell commands to improve maintainability AWS Parameter Store for A/B deployment

Examples to use:
1. To copy parameters (saving type String/SecureString) from one prefix to another prefix:
```
.\CopyParameters.ps1 -sourcePrefixPath /test-prefix-a/ -targetPrefixPath /test-prefix-b/
```

2. To delete parameters by prefix:
```
.\DeleteParameters.ps1 -sourcePrefixPath /test-prefix-a/
```