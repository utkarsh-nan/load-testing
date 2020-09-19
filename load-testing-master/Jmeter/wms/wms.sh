#general settings
jmeterBin=../bin
resultsDir=../test-results

#connection settings
host=10.28.11.95
port=8600
wmsUrl=geoserver/GS_Workspace/wms

#global test settings
requestsFile=./wms.csv
imageFormat=image/png
layers=GS_Workspace:bluemarble_4km
projection=EPSG:4326
version=1.1.1

#tests selection
runConfigurable=true
runTimed=false

#configurable and timed test settings
users=100
requestDelay=100 #ms

#configurable test settings
userRequests=100

#timed test settings
runTimeMin=1


### test script stat do not modify ###
#preperations
runTimeSec=$(($runTimeMin * 60))
now=$(date +"%d-%m-%y-%T")
dir="${resultsDir}/wms/${now}"
mkdir -p ${dir}
#test
${jmeterBin}/jmeter -n -t ./wms.jmx -l ${dir}/wms-res.jtl -JtargetHost=${host} -JtargetPort=${port} -Jusers=${users} -JrequestsPerUser=${userRequests} \
        -JtargetPath=${wmsUrl} -JparamFile=${requestsFile} -JrunTimeSec=${runTimeSec} -JrunTimed=${runTimed} -JrunConfigurable=${runConfigurable} \
        -JimageFormat=${imageFormat} -Jlayers=${layers} -Jprojection=${projection} -Jversion=${version} -JrequestDelay=${requestDelay}
#generate reports
${jmeterBin}/JMeterPluginsCMD.sh --generate-png ${dir}/wms-test-rtot.png --generate-csv ${dir}/wms-test-rtot.csv --input-jtl ${dir}/wms-res.jtl --plugin-type ResponseTimesOverTime --width 800 --height 600
${jmeterBin}/JMeterPluginsCMD.sh --generate-csv ${dir}/wms-test-agg.csv --input-jtl ${dir}/wms-res.jtl --plugin-type AggregateReport
