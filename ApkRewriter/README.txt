Steps:
1) Get python lxml package:
	pip install lxml
2) Compile the APK
	Run ./extract.sh
3) Generate keystore
	./generate_keystore <keystore_name> <keystore_alias_name>
4) Create a configuration file with the following information and format:

	<config>
		<payload location="/location/of/payload"/>
		<keystore location="/location/of/keystore" storepass="keystore password" keypass="private key password" keystoreAlias="keystore alias"/>
		<apktool location="/location/of/apktool" timeout="600"/>
		<apksigner location="/location/of/apksigner"/>
		<zipalign location="/location/of/zipalign"/>
	</config>

5) Rewrite APK file
	python UiRefApkRewriter.py <apkName> <disassembledApkOutputDirectory> <rewrittenApkOutputDirectory>

	Example:
	$ python UiRefApkRewriter.py test_app.apk /home/benandow/UiRefOutput/DisassembledApks/ /home/benandow/UiRefOutput/RewrittenApks/

6) Rewrite an entire directory of APKs in parallel
	python UiRefApkRewriter.py <apkRootDirectory> <disassembledApkOutputDirectory> <rewrittenApkOutputDirectory>

	Example (assuming /home/benandow/APKS/ contains nested directories of APKs -- e.g., /home/benandow/APKS/FINANCE/test_app.apk)
	$ python UiRefApkRewriter.py /home/benandow/APKS/ /home/benandow/UiRefOutput/DisassembledApks/ /home/benandow/UiRefOutput/RewrittenApks/


7) Rip GUIs from an APK:
	$ python UiRefRenderer.py <adbLocation> <apkNameLocation> <directoryToOutputResults>
