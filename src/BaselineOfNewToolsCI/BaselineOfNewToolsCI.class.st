Class {
	#name : #BaselineOfNewToolsCI,
	#superclass : #BaselineOf,
	#instVars : [
		'initializersEnabled'
	],
	#category : #BaselineOfNewToolsCI
}

{ #category : #baselines }
BaselineOfNewToolsCI >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec preLoadDoIt: #'preload:package:'.
		spec postLoadDoIt: #'postload:package:'.

		self packageRepositoryURL crTrace.

		self spec: spec.
		self newTools: spec ]
]

{ #category : #'external projects' }
BaselineOfNewToolsCI >> newTools: spec [
	
	spec baseline: 'NewTools' with: [  
		spec repository: self packageRepositoryURL ]
]

{ #category : #'external projects' }
BaselineOfNewToolsCI >> packageRepositoryURL [
	| url |
	
	url := super packageRepositoryURL.
	url ifEmpty: [ ^ url ].
	"Verify if I am running in CI"
	"travis or github actions"
	((url includesSubstring: 'pharo-spec') 
		or: [ url beginsWith: 'tonel:///home/runner/' ]) ifTrue: [ ^ '' ].
	
	^ url
]

{ #category : #actions }
BaselineOfNewToolsCI >> postload: loader package: packageSpec [

	MCMethodDefinition initializersEnabled: initializersEnabled
]

{ #category : #actions }
BaselineOfNewToolsCI >> preload: loader package: packageSpec [

	initializersEnabled := MCMethodDefinition initializersEnabled.
	MCMethodDefinition initializersEnabled: true
]

{ #category : #'external projects' }
BaselineOfNewToolsCI >> sindarin: spec [

	spec baseline: 'Sindarin' with: [ 
		spec
			repository: (self packageRepositoryURL 
				ifEmpty: [ 'github://pharo-spec/ScriptableDebugger' ]);
			loads: 'Core' ]
]

{ #category : #'external projects' }
BaselineOfNewToolsCI >> spec: spec [ 

	spec
		baseline: 'Spec2'
		with: [ 
			spec 
				repository: 'github://pharo-spec/Spec/src';
				className: 'BaselineOfSpec2';
				loads: #('default') ].
]
