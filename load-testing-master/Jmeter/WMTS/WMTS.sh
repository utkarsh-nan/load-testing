#general settings
jmeterBin=../bin
resultsDir=../test-results

#connection settings
host=10.28.11.95
port=8600
wmtsUrl=geoserver/gwc/service/wmts

#test settings
layer=GS_Workspace:bluemarble_4km
version=1.0.0
projection=EPSG:4326
imageFormat=image/png
users=100
tilesPerIteration=100 #setting this to -1 will result in sending only 1 capabilities iteretion and unbound amount of tile requests
capabilitiesPerIteration=1 #setting this to -1 will only test capbilities request. seeting this to 0 will result in errors
runTimeMin=60
delayBetweenTileRequests=100 #ms
delayBetweencapabilitiesRequests=0 #ms


## test script stat do not modify ###
#preperations
runTimeSec=$(($runTimeMin * 60))
now=$(date +"%d-%m-%y-%T")
dir="${resultsDir}/wmts/${now}"
mkdir -p ${dir}
#test
${jmeterBin}/jmeter -n -t ./WMTS.jmx -l ${dir}/wmts-res.jtl -JtargetHost=${host} -JtargetPort=${port} -Jusers=${users} -JtilesPerIteration=${tilesPerIteration} \
        -JrunTimeSec=${runTimeSec} -Jlayer=${layer} -Jversion=${version} -JwmtsUrl=${wmtsUrl} -JdelayBetweenTileRequests=${delayBetweenTileRequests} \
        -Jprojection=${projection} -JimageFormat=${imageFormat} -JcapabilitiesPerIteration=${capabilitiesPerIteration} \
        -JdelayBetweenCapabilitiesRequests=${delayBetweenCapabilitiesRequests}
#generate reports
${jmeterBin}/JMeterPluginsCMD.sh --generate-png ${dir}/wmts-test-rtot.png --generate-csv ${dir}/wmts-test-rtot.csv --input-jtl ${dir}/wmts-res.jtl --plugin-type ResponseTimesOverTime --width 800 --height 600
${jmeterBin}/JMeterPluginsCMD.sh --generate-csv ${dir}/wmts-test-agg.csv --input-jtl ${dir}/wmts-res.jtl --plugin-type AggregateReport
