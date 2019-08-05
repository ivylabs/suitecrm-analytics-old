#/bin/sh

echo ""
echo " We are about to install SuiteCRM Analytics"
echo " Make sure you have configured the install.properties correctly"
echo ""
echo " *** IMPORTANT! *** Running this setup will discard any previous installations!"
echo ""

WORKING_DIR=$(pwd);

read -r -p " Have you configured install.properties? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	echo ""
	echo " Installing..."
	echo ""

	if [ ! -d install/installation-files ]; then

		echo " Downloading Installation Files"

        	mkdir install/installation-files

		wget --progress=dot:giga https://downloads.sourceforge.net/project/pentaho/Pentaho%208.2/server/pentaho-server-ce-8.2.0.0-342.zip -O install/installation-files/suitecrm-server.zip
	
		# For local testing ONLY
		#wget --progress=dot:giga http://localhost:8000/pentaho-server-ce-8.0.0.0-28.zip -O install/installation-files/suitecrm-server.zip

		# Pentaho 8.2

		#wget --progress=dot:giga http://localhost:8000/pentaho-server-ce-8.2.0.0-342.zip -O install/installation-files/suitecrm-server.zip

	fi

	 if [ ! -d suitecrm-analytics/tomcat ]; then

		echo " Extracting files.."
		echo ""

	        unzip install/installation-files/suitecrm-server.zip -d install/installation-files/ | awk 'BEGIN {ORS=" "} {if(NR%100==0)print "."}'

		mkdir suitecrm-analytics

		mv install/installation-files/pentaho-server/* suitecrm-analytics/
		mv suitecrm-analytics/tomcat/webapps/pentaho/ suitecrm-analytics/tomcat/webapps/suitecrmanalytics/
		#cp -Rf install/mysql-connector-java-5.1.47.jar suitecrm-analytics/tomcat/lib/

		cp -Rf install/suitecrm-analytics/* suitecrm-analytics/

		echo ""

        fi

	file="./install.properties"

	if [ -f "$file" ]
	then

		while IFS='=' read -r key value
		do
			key=$(echo $key | tr '.' '_')
			eval ${key}=\${value}
		done < "$file"

		#cp -Rf install/suitecrm-data-integration/{.[!.],}* suitecrm-data-integration/configuration

		#sed -i 's|@@SOLUTION_ROOT_DIR@@|'${WORKING_DIR}'|' suitecrm-data-integration/configuration/config
		#sed -i 's|@@JVM_SIZE@@|'${JVM_SIZE}'|' suitecrm-data-integration/configuration/config

		# JNDI Configuration

		sed -i 's|@@SUITECRM_ANALYTICS_HOST@@|'${SUITECRM_ANALYTICS_HOST}'|'  suitecrm-analytics/tomcat/webapps/suitecrmanalytics/META-INF/context.xml
		sed -i 's|@@SUITECRM_ANALYTICS_PORT@@|'${SUITECRM_ANALYTICS_PORT}'|'  suitecrm-analytics/tomcat/webapps/suitecrmanalytics/META-INF/context.xml
		sed -i 's|@@SUITECRM_ANALYTICS_DATABASE@@|'${SUITECRM_ANALYTICS_DATABASE}'|'  suitecrm-analytics/tomcat/webapps/suitecrmanalytics/META-INF/context.xml
		sed -i 's|@@SUITECRM_ANALYTICS_USERNAME@@|'${SUITECRM_ANALYTICS_USERNAME}'|'  suitecrm-analytics/tomcat/webapps/suitecrmanalytics/META-INF/context.xml
		sed -i 's|@@SUITECRM_ANALYTICS_PASSWORD@@|'${SUITECRM_ANALYTICS_PASSWORD}'|'  suitecrm-analytics/tomcat/webapps/suitecrmanalytics/META-INF/context.xml

		

		sed -i 's|@@SUITECRM_ANALYTICS_WEBAPP_PORT@@|'${SUITECRM_ANALYTICS_WEBAPP_PORT}'|'  suitecrm-analytics/tomcat/conf/server.xml
		sed -i 's|@@SUITECRM_ANALYTICS_WEBAPP_PORT@@|'${SUITECRM_ANALYTICS_WEBAPP_PORT}'|'  suitecrm-analytics/pentaho-solutions/system/server.properties

		sed -i 's|@@SUITECRM_ANALYTICS_WEBAPP_PORT@@|'${SUITECRM_ANALYTICS_WEBAPP_PORT}'|'  suitecrm-analytics/upload-solution.sh


		#sed -i 's|@@ETL_ROOT_DIR@@|'${WORKING_DIR}/suitecrm-data-integration/solution'|'  suitecrm-data-integration/configuration/.kettle/kettle.properties

		# Run ETL scripts to check DB connections and create DDL
		
		echo ""
		read -r -p " Would you like to remove the installation files? This will save disk space. [y/N] " response
		if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
		then
			rm -Rf install/installation-files/
		fi

		echo ""
                echo "-------------------------------------------------------------"
                echo ""
                echo " Installation is complete!"
                echo ""
                echo "-------------------------------------------------------------"		

		

	else
		echo "$file not found."
	fi

	
else
	echo " Exiting!"
	echo ""
	exit

fi



