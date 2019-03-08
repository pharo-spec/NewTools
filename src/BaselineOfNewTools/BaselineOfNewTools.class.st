Class {
	#name : #BaselineOfNewTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewTools
}

{ #category : #baselines }
BaselineOfNewTools >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		self spec: spec.
		self lieutenant: spec.

		spec
			package: 'NewTools' with: [ spec requires: #('Spec') ];
			package: 'HelpCenter' with: [ spec requires: #('NewTools') ];
			package: 'NewTools-Inspector' with: [ spec requires: #('Spec' 'Lieutenant') ];
			package: 'NewTools-Playground' with: [ spec requires: #('NewTools-Inspector') ] ]
]

{ #category : #dependencies }
BaselineOfNewTools >> lieutenant: spec [

	self flag: #TODO. "Using *my* version for now, this needs to be reviewed, and making correct"
	spec 
		baseline: 'Lieutenant' 
		with: [ spec repository: 'github://estebanlm/Lieutenant:try-superlight-version/src' ]
]

{ #category : #dependencies }
BaselineOfNewTools >> spec: spec [

	spec 
		baseline: 'Spec' 
		with: [ spec repository: 'github://pharo-spec/Spec:master/src' ]
]
