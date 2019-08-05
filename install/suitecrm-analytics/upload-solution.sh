uploadsolution(){
	echo ""
	echo " Starting SuiteCRM Analytics!"
	until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:@@SUITECRM_ANALYTICS_WEBAPP_PORT@@); do
		sleep 5
	done

	./import-export.sh --import --url=http://127.0.0.1:@@SUITECRM_ANALYTICS_WEBAPP_PORT@@/suitecrmanalytics --username=admin --password=password --charset=UTF-8 --path="/public" --file-path="pentaho-solutions/system/SuiteCRMAnalytics/solution-repository/SuiteCRM Analytics.zip" --overwrite=true --permission=true --retainOwnership=true

	./import-export.sh --restore --url=http://127.0.0.1:@@SUITECRM_ANALYTICS_WEBAPP_PORT@@/suitecrmanalytics --username=admin --password=password --file-path="pentaho-solutions/system/SuiteCRMAnalytics/solution-repository/datasources.zip" --overwrite=true --logfile=/tmp/logfile.log

	echo ""
	echo " The Server has started. You can access the User Console by opening a browser and navigating to http://localhost:@@SUITECRM_ANALYTICS_WEBAPP_PORT@@/suitecrmanalytics."

	rm "upload-solution.sh"
}

uploadsolution
