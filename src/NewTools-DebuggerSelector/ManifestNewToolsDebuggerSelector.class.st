"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestNewToolsDebuggerSelector,
	#superclass : #PackageManifest,
	#category : #'NewTools-DebuggerSelector-Manifest'
}

{ #category : #'code-critics' }
ManifestNewToolsDebuggerSelector class >> ruleReAllAnyNoneSatisfyRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#DebuggerSelector #lookupDebuggerAndOpen:debuggerLevel:notification: #false)) #'2020-03-30T17:17:38.949496+02:00') )
]

{ #category : #'code-critics' }
ManifestNewToolsDebuggerSelector class >> ruleReDetectContainsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#DebuggerSelector)) #'2020-03-30T17:17:34.964612+02:00') )
]
