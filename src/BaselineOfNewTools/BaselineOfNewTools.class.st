Class {
	#name : #BaselineOfNewTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewTools
}

{ #category : #baselines }
BaselineOfNewTools >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			
			self
				spec: spec;
				lieutenant: spec.

			spec
				package: 'NewTools-Core' with: [ spec requires: #('Spec2') ];
				package: 'HelpCenter' with: [ spec requires: #('NewTools-Core') ];
				package: 'NewTools-Inspector-Extensions' with: [ spec requires: #('NewTools-Core' 'Lieutenant') ];
				package: 'NewTools-Inspector' with: [ spec requires: #('Spec2' 'Lieutenant' 'NewTools-Inspector-Extensions') ];
				package: 'NewTools-Playground' with: [ spec requires: #('NewTools-Inspector') ];
				package: 'NewTools-FlagBrowser' with: [ spec requires: #('NewTools-Core') ];
				package: 'NewTools-FlagBrowser-Tests' with: [ spec requires: #('NewTools-FlagBrowser') ] ]
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
		baseline: 'Spec2' 
		with: [ spec repository: 'github://pharo-spec/Spec/src' ]
]
