"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestNewToolsDebuggerTests,
	#superclass : #PackageManifest,
	#category : #'NewTools-Debugger-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestNewToolsDebuggerTests class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'NewTools-Debugger-Tests')) #'2020-02-08T18:37:01.061918+01:00') )
]
