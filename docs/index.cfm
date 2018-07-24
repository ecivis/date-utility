<cfscript>
	config = {
		"projectTitle": "Date Utility Docs",
		"outputDir": request.outputDir,
		"sourceDir": request.sourceDir,
		"mapping": request.mapping
	};
	docbox 	= new docbox.DocBox(properties=config);
	docbox.generate(source=config.sourceDir, mapping=config.mapping);
</cfscript>
<cfif structKeyExists(url, "debug")>
	<cfdump var="#config#"/>
<cfelse>
	<cflocation url="html/index.html" addtoken="false"/>
</cfif>
