/**
 * @setupMethod setup
 * @singleton
 */
component accessors="true" {

	/**
	 * @inject coldmvc
	 */
	property pluginManager;

	property javaLoader;

	public void function setup() {

		variables.javaLoader.add(getDirectoryFromPath(getCurrentTemplatePath()) & "../../lib/lesscss-engine-1.0.22.jar");

		variables.lessEngine = javaLoader.create("com.asual.lesscss.LessEngine").init();

	}

	/**
	 * @events applicationStart
	 */
	public void function generateFiles() {

		var directories = pluginManager.getPluginPaths();
		var i = "";
		var directory = "";

		arrayAppend(directories, expandPath("/public/css/"));

		for (directory in directories) {

			var files = directoryList(directory, true, "query", "*.less");

			for (i = 1; i <= files.recordCount; i++) {

				var source = files.directory[i] & "/" & files.name[i];
				var destination = files.directory[i] & "/" & replaceNoCase(files.name[i], ".less", ".css");
				var content = fileRead(source);

				fileWrite(destination, variables.lessEngine.compile(content));

			}

		}

	}

}