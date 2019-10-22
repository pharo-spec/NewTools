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
			taskit: spec;
			sindarin: spec.

		spec
			package: 'NewTools-Core';
			package: 'NewTools-Morphic';
			package: 'NewTools-Gtk';
			"inspector"
			package: 'NewTools-Inspector-Extensions' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-Inspector' with: [ spec requires: #( 'NewTools-Inspector-Extensions') ];
			"playground"
			package: 'NewTools-Playground' with: [ spec requires: #('NewTools-Inspector') ];
			"browser"
			package: 'NewTools-SystemBrowser' with: [ spec requires: #('NewTools-Inspector') ];
			"debugger"
			package: 'Debugger-Commands';
			package: 'NewTools-Debugger' with: [ spec requires: #('NewTools-Inspector' 'Debugger-Commands') ];
			package: 'NewTools-Debugger-Extensions';
			package: 'NewTools-Debugger-Tests' with: [ spec requires: #('NewTools-Debugger') ];
			"extras"
			package: 'HelpCenter' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-FlagBrowser' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-FlagBrowser-Tests' with: [ spec requires: #('NewTools-FlagBrowser') ];
			"package: 'NewTools-FileDialog' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-FileDialog-Tests' with: [ spec requires: #('NewTools-FileDialog') ];"
			package: 'NewTools-Sindarin-Tools' with: [ spec requires: #('NewTools-FlagBrowser-Tests') ].
			
		]
]

{ #category : #dependencies }
BaselineOfNewTools >> sindarin: spec [

	spec 
		baseline: 'Sindarin' 
		with: [ spec repository: 'github://dupriezt/ScriptableDebugger' ]
]

{ #category : #dependencies }
BaselineOfNewTools >> taskit: spec [

	spec 
		baseline: 'TaskIt' 
		with: [ spec repository: 'github://sbragagnolo/taskit' ]
]
