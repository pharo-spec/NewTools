Class {
	#name : #BaselineOfNewToolsCI,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewToolsCI
}

{ #category : #baselines }
BaselineOfNewToolsCI >> baseline: spec [
	<baseline>

	spec for: #common do: [
		self spec: spec.
		self newTools: spec.
		
		spec group: 'default' with: #('Spec2' 'NewTools') ]
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
	((url includesSubstring: 'NewTools') 
		or: [ url beginsWith: 'tonel:///home/runner/' ]) ifTrue: [ ^ '' ].
	
	^ url
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
				repository: 'github://pharo-spec/Spec';
				loads: #('default') ].
]
