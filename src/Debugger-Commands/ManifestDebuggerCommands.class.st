"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestDebuggerCommands,
	#superclass : #PackageManifest,
	#category : #'Debugger-Commands-Manifest'
}

{ #category : #'code-critics' }
ManifestDebuggerCommands class >> ruleRBClassNameInSelectorRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'DebugCommand class' #preDebugCommandsForDebugger: #true)) #'2019-07-23T15:30:12.510854+02:00') )
]
