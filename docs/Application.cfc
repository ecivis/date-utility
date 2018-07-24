component {

    this.name = "DateUtilityDocs";

    this.docsRoot = replace(getDirectoryFromPath(getCurrentTemplatePath()), "\", "/", "all");
    this.moduleRoot = reReplaceNoCase(this.docsRoot, "(.*)/docs/?", "\1/");
    this.mappings = {
        "/docbox": this.docsRoot & "docbox",
        "/modules/date-utility/models": this.moduleRoot & "models"
    };

    public boolean function onRequestStart (string targetPage) {
        request.outputDir = this.docsRoot & "html/";
        request.sourceDir = this.moduleRoot & "models";
        request.mapping = "modules.date-utility.models";
        if (directoryExists(request.outputDir)) {
            directoryDelete(request.outputDir, true);
        }
        directoryCreate(request.outputDir);

        return true;
    }

}