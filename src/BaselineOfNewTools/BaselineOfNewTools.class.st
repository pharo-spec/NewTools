Class {
	#name : #BaselineOfNewTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewTools
}

{ #category : #baselines }
BaselineOfNewTools >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
			
		self
			spec: spec;
			commander: spec;
			sindarin: spec.

		spec
			package: 'NewTools-Core' with: [ spec requires: #('Spec2') ];
			package: 'HelpCenter' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-Inspector-Extensions' with: [ spec requires: #('NewTools-Core' 'Commander2') ];
			package: 'NewTools-Inspector' with: [ spec requires: #('Spec2' 'Commander2' 'NewTools-Inspector-Extensions') ];
			package: 'NewTools-Playground' with: [ spec requires: #('NewTools-Inspector') ];
			package: 'NewTools-FlagBrowser' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-FlagBrowser-Tests' with: [ spec requires: #('NewTools-FlagBrowser') ];
			package: 'NewTools-Sindarin-Tools' with: [ spec requires: #('NewTools-FlagBrowser-Tests') ]]
]

{ #category : #baselines }
BaselineOfNewTools >> commander: spec [

	spec baseline: 'Commander2' with: [ spec repository: 'github://pharo-spec/Commander2:v1.2.0/src']
]

{ #category : #dependencies }
BaselineOfNewTools >> sindarin: spec [

	spec 
		baseline: 'Sindarin' 
		with: [ spec repository: 'github://dupriezt/ScriptableDebugger' ]
]

{ #category : #dependencies }
BaselineOfNewTools >> spec: spec [
	"Depends on a specific commit of Spec2 to avoi breaking changes done to styles"
	spec 
		baseline: 'Spec2' 
		with: [ spec repository: 'github://pharo-spec/Spec:d5825e1c86bb351f1dea1fba76cbfbfa76a1369f/src' ]
]
