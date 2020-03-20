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
		do: [ self
				taskit: spec;
				spec: spec;
				sindarin: spec.

			spec
				package: 'NewTools-Core' with: [ spec requires: #('Spec2') ];
				package: 'NewTools-Morphic';
				package: 'NewTools-Gtk';
				"inspector"
					package: 'NewTools-Inspector-Extensions' with: [ spec requires: #('NewTools-Core') ];
				package: 'NewTools-Inspector' with: [ spec requires: #('NewTools-Inspector-Extensions') ];
				"playground"
					package: 'NewTools-Playground' with: [ spec requires: #('NewTools-Inspector') ];
				"browser"
					package: 'NewTools-SystemBrowser' with: [ spec requires: #('NewTools-Inspector') ];
				"debugger"
					package: 'NewTools-Debugger-Commands';
				package: 'NewTools-Debugger-Extensions';
				package: 'NewTools-Debugger' with: [ spec requires: #('NewTools-Inspector' 'NewTools-Debugger-Commands' 'NewTools-Debugger-Extensions') ];
				package: 'NewTools-Debugger-Tests' with: [ spec requires: #('NewTools-Debugger') ];
				"extras"
					package: 'HelpCenter' with: [ spec requires: #('NewTools-Core') ];
				package: 'NewTools-FlagBrowser' with: [ spec requires: #('NewTools-Core') ];
				package: 'NewTools-FlagBrowser-Tests' with: [ spec requires: #('NewTools-FlagBrowser') ];
				"package: 'NewTools-FileDialog' with: [ spec requires: #('NewTools-Core') ];
			package: 'NewTools-FileDialog-Tests' with: [ spec requires: #('NewTools-FileDialog') ];"
					package: 'NewTools-SpTextPresenterDecorators';
				"Object-centric breakpoints"
					package: 'NewTools-ObjectCentricBreakpoints';
				package: 'NewTools-ObjectCentricBreakpointsTests';
				"Sindarin"
					package: 'NewTools-Sindarin-Commands';
				package: 'NewTools-Sindarin-Tools' with: [ spec requires: #('NewTools-Sindarin-Commands' 'Sindarin') ];
				package: 'NewTools-Sindarin-ProcessInspector'
					with: [ "Debugger Selector" ";
			package: 'NewTools-DebuggerSelector' with: [ spec requires: #('NewTools-SpTextPresenterDecorators') ];
			package: 'NewTools-DebuggerSelector';
			package: 'NewTools-DebuggerSelector-Tests' with: [ spec requires: #('NewTools-DebuggerSelector') ]" spec requires: #('NewTools-Sindarin-Commands' 'Sindarin') ] ]
]

{ #category : #dependencies }
BaselineOfNewTools >> sindarin: spec [

	spec 
		baseline: 'Sindarin' 
		with: [ spec repository: 'github://dupriezt/ScriptableDebugger' ]
]

{ #category : #dependencies }
BaselineOfNewTools >> spec: spec [

	spec 
		baseline: 'Spec2'
		with: [ spec repository: 'github://pharo-spec/Spec:master/src' ]
]

{ #category : #dependencies }
BaselineOfNewTools >> taskit: spec [

	spec 
		baseline: 'TaskIt' 
		with: [ spec repository: 'github://sbragagnolo/taskit' ]
]
