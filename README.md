# Java Spring Boot Gradle Project - Hello 
## 確認您專案的 gradle 與 tomcat 的 jdk 版本
1. 範本裡提供的 gradle 是 jdk8 的版本，tomcat是 jdk11的版本
2. 請確認您的版本後，再請更新範本專案內的 Dockerfile 檔案。

## 如何增加Sonarqube掃描(用預設的QualiyGate)
在`app/build.gradle`的檔案內plugins新增`id "org.sonarqube" version "3.1.1"`後pipeline即可運行Sonarqube掃描
1. 確認您專案的 gradle 版本，並將它更新至專案的 Dockerfile
2. 若欲使用SonarQube，則請將下列文字新增至 build.gradle 的檔案裡。
```
plugins {
	id 'org.springframework.boot' version '2.3.3.RELEASE'
	id 'io.spring.dependency-management' version '1.0.8.RELEASE'
	id 'java'
	id "org.sonarqube" version "3.1.1"
}
```
2.1 填入位置可參考下列圖示所示

![](https://i.imgur.com/FZL7uD3.png)

若要設定其他額外的細節也可寫在`app/build.gradle`，例如排除特定資料夾(與程式碼無關的)、指定的QualityGate、Rule等等  
相關可用額外參數說明可參考[sonarscanner-for-gradle](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-gradle/)

### 如何關閉Sonarqube UnitTest
在`SonarScan`內修改特定段落內新增`-x test`即可跳過unit Test，以下為跳過unit Test範例，跳過unit Test後則不會出現覆蓋率
```
echo '========== SonarQube(Gradle) =========='
cd app && chmod -R 777 .
./gradlew -Dsonar.host.url=http://sonarqube-server-service.default:9000\
    -Dsonar.projectKey=${CICD_GIT_REPO_NAME} -Dsonar.projectName=${CICD_GIT_REPO_NAME}\
	-Dsonar.projectVersion=${CICD_GIT_BRANCH}:${CICD_GIT_COMMIT}\
    -Dsonar.log.level=DEBUG -Dsonar.qualitygate.wait=true -Dsonar.qualitygate.timeout=600\
    -Dsonar.login=$SONAR_TOKEN -x test jacocoTestReport sonarqube
```
### jacoco Coverage 參考說明
https://dzone.com/articles/reporting-code-coverage-using-maven-and-jacoco-plu
https://blog.miniasp.com/post/2021/08/11/Spring-Boot-Maven-JaCoCo-Test-Coverage-Report-in-VSCode

## 專案資料夾與檔案格式說明

| 型態 | 名稱 | 說明 | 路徑 |
| --- | --- | --- | --- |
| 檔案 | .rancher-pipeline.yml | :warning: (不可更動)devops系統所需檔案 | 根目錄 |
| 檔案 | README.md | 本說明文件 | 根目錄 |
| 檔案 | Dockerfile | (可調整)devops k8s環境部署檔案 | 根目錄 |
| 檔案 | SonarScan | (可調整)整合SonarQube執行檔案 | 根目錄 |
| 資料夾 | app | 專案主要程式碼 | 根目錄 |
| 資料夾 | iiidevops | :warning: devops系統測試所需檔案 | 根目錄 |
| 檔案 | app.env | (可調整)提供實證環境之環境變數(env)定義檔 | iiidevops |
| 檔案 | app.env.develop | (可調整)提供特定分支(develop)實證環境之環境變數(env)定義檔 | iiidevops |
| 檔案 | pipeline_settings.json | :warning: (不可更動)devops系統測試所需檔案 | iiidevops |
| 資料夾 | bin | :warning: devops系統測試所需執行檔案 | iiidevops |
| 資料夾 | postman | :warning: devops系統整合postman測試所需執行檔案 | iiidevops |
| 檔案 | postman_collection.json | (可調整)devops newman部署測試檔案 | iiidevops/postman |
| 檔案 | postman_environment.json | (可調整)devops newman部署測試檔案 | iiidevops/postman |
| 資料夾 | sideex | :warning: devops系統測整合sideex試所需執行檔案 | iiidevops |
| 檔案 | Global Variables.json | (可調整)devops sideex部署測試檔案 | iiidevops/sideex |
| 檔案 | sideex.json | (可調整)devops sideex部署測試檔案 | iiidevops/sideex |

## iiidevops
* 專案內`.rancher-pipeline.yml`除非已很了解 yml 與 rancher pipeline 的語法, 否則更動後可能會造成 pipeline 無法正常運作
* 目前此範本依照 tomcat 預設服務定義 port:8080，如果需要更改其他 port , 就需要將 `.rancher-pipeline.yml` 內所有 web.port: 定義的 port 號。
* `iiidevops`資料夾內
  * `postman`資料夾內則是devops整合API測試(postman)的自動測試檔案放置目錄，devops系統會以`postman`資料夾內 postman_collection.json 檔案做自動測試
  * `sideex`資料夾內則是devops整合Web測試(sideex)的自動測試檔案放置目錄，devops系統會以`sideex`資料夾內 sideex 匯出的 json 檔案做自動測試
* `Dockerfile`內加上前墜dockerhub，是為使image能透過本地端harbor擔任Image Proxy去抓取出Docker Hub的Images
