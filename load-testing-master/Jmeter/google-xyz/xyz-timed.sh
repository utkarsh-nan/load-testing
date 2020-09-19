#general settings
jmeterBin=../bin
resultsDir=../test-results

#connection settings
host=10.28.11.95
port=8600

#test settings
layer=1000
version=3
users=100
userRequests=100
runTimeMin=1
publishDb=imagery_test
delayBetweenRequests=100 #ms

## test script stat do not modify ###
#preperations
runTimeSec=$(($runTimeMin * 60))
now=$(date +"%d-%m-%y-%T")
dir="${resultsDir}/xyz/${now}"
mkdir -p ${dir}
#test
${jmeterBin}/jmeter -n -t ./xyz-timed.jmx -l ${dir}/xyz-res.jtl -JtargetHost=${host} -JtargetPort=${port} -Jusers=${users} -JrequestsPerUser=${userRequests} \
        -JrunTimeSec=${runTimeSec} -Jlayer=${layer} -Jversion=${version} -JpublishDb=${publishDb} -JdelayBetweemRequestsMs=${delayBetweenRequests}
#generate reports
${jmeterBin}/JMeterPluginsCMD.sh --generate-png ${dir}/xyz-test-rtot.png --generate-csv ${dir}/xyz-test-rtot.csv --input-jtl ${dir}/xyz-res.jtl --plugin-type ResponseTimesOverTime --width 800 --height 600
${jmeterBin}/JMeterPluginsCMD.sh --generate-csv ${dir}/xyz-test-agg.csv --input-jtl ${dir}/xyz-res.jtl --plugin-type AggregateReport
