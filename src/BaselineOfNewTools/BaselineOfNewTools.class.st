Class {
	#name : 'BaselineOfNewTools',
	#superclass : 'BaselineOf',
	#instVars : [
		'initializersEnabled'
	],
	#category : 'BaselineOfNewTools',
	#package : 'BaselineOfNewTools'
}

{ #category : 'baselines' }
BaselineOfNewTools >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec preLoadDoIt: #preload:package:.
		spec postLoadDoIt: #postload:package:.

		self sindarin: spec.
		self chest: spec.

		spec
			package: 'NewTools-Core';
			package: 'NewTools-Morphic';
			package: 'NewTools-Gtk';
			"Basic tools (inherited from Spec)"
			package: 'NewTools-MethodBrowsers';
			package: 'NewTools-KeymapBrowser';
			"inspector"
			package: 'NewTools-Inspector' with: [ spec requires: #( 'NewTools-Inspector-Extensions' ) ];
			package: 'NewTools-Inspector-Extensions' with: [ spec requires: #( 'NewTools-Core' ) ];
			package: 'NewTools-Inspector-Tests' with: [ spec requires: #( 'NewTools-Inspector' ) ];
			"debugger"
			package: 'NewTools-Debugger' with: [ spec requires: #( 'NewTools-Inspector' 'NewTools-Debugger-Commands' 'NewTools-Debugger-Extensions' 'NewTools-SpTextPresenterDecorators' ) ];
			package: 'NewTools-Debugger-Commands';
			package: 'NewTools-Debugger-Extensions';
			package: 'NewTools-Debugger-Tests' with: [ spec requires: #( 'NewTools-Debugger' ) ];
			"playground"
			package: 'NewTools-Playground' with: [ spec requires: #( 'NewTools-Inspector' ) ];
			package: 'NewTools-Playground-Tests' with: [ spec requires: #( 'NewTools-Playground' ) ];
			"browser"
			package: 'NewTools-SystemBrowser' with: [ spec requires: #( 'NewTools-Inspector' ) ];
			"system reporter"
			package: 'NewTools-SystemReporter' with: [ spec requires: #( 'NewTools-Core' ) ];
			"spotter"
			package: 'NewTools-Spotter-Processors';
			package: 'NewTools-Spotter' with: [ spec requires: #( 'NewTools-Core' 'NewTools-Spotter-Processors' ) ];
			package: 'NewTools-Spotter-Extensions' with: [ spec requires: #( 'NewTools-Spotter' ) ];
			package: 'NewTools-Spotter-Processors-Tests' with: [ spec requires: #( 'NewTools-Spotter-Processors' ) ];
			package: 'NewTools-Spotter-Tests' with: [ spec requires: #( 'NewTools-Spotter' ) ];
			package: 'NewTools-Morphic-Spotter' with: [ spec requires: #( 'NewTools-Morphic' ) ];
			"extras"
			package: 'HelpCenter' with: [ spec requires: #( 'NewTools-Core' ) ];
			package: 'NewTools-FlagBrowser' with: [ spec requires: #( 'NewTools-Core' ) ];
			package: 'NewTools-FlagBrowser-Tests' with: [ spec requires: #( 'NewTools-FlagBrowser' ) ];
			package: 'NewTools-FileBrowser' with: [ spec requires: #( 'NewTools-Core' ) ];
			package: 'NewTools-FileBrowser-Tests' with: [ spec requires: #( 'NewTools-FileBrowser' ) ];
			package: 'NewTools-FontChooser' with: [ spec requires: #( 'NewTools-Core' ) ];
			package: 'NewTools-FontChooser-Tests' with: [ spec requires: #( 'NewTools-FontChooser' ) ];
			package: 'NewTools-SpTextPresenterDecorators';
			package: 'NewTools-Debugger-Breakpoints-Tools' with: [ spec requires: #( 'NewTools-Inspector' ) ];
			package: 'NewTools-ProjectLoader';
			package: 'NewTools-ProjectLoader-Microdown';
			"Object-centric breakpoints"
			package: 'NewTools-ObjectCentricBreakpoints';
			"Sindarin"
			package: 'NewTools-Sindarin-Commands';
			package: 'NewTools-Sindarin-Commands-Tests' with: [ spec requires: #( 'NewTools-Sindarin-Commands' 'Sindarin' ) ];
			package: 'NewTools-Sindarin-Tools' with: [ spec requires: #( 'NewTools-Sindarin-Commands' 'Sindarin' ) ];
			"package: 'NewTools-Sindarin-ProcessInspector' with: [ spec requires: #('NewTools-Sindarin-Commands' 'Sindarin') ];""Debugger Selector"
			package: 'NewTools-DebuggerSelector' with: [ spec requires: #( 'NewTools-SpTextPresenterDecorators' ) ];
			package: 'NewTools-DebuggerSelector-Tests' with: [ spec requires: #( 'NewTools-DebuggerSelector' ) ];
			"CritiqueBrowser"
			package: 'NewTools-CodeCritiques';
			package: 'NewTools-CodeCritiques-Tests';
			"Fuel"
			package: 'NewTools-Debugger-Fuel';
			package: 'NewTools-Debugger-Fuel-Tests' with: [ spec requires: #( 'NewTools-Debugger-Fuel' ) ];
			package: 'NewTools-Fuel';
     			"Rewriter Tools"
			package: 'NewTools-RewriterTools-Backend';
			package: 'NewTools-RewriterTools' with: [ spec requires: #('NewTools-RewriterTools-Backend') ];
			package: 'NewTools-RewriterTools-Backend-Tests' with: [ spec requires: #('NewTools-RewriterTools-Backend') ];
			package: 'NewTools-RewriterTools-Tests' with: [ spec requires: #('NewTools-RewriterTools') ].

		spec
			group: 'Core' with: #( 'NewTools-Core' 'NewTools-Morphic' );
			group: 'Playground' with: #( 'Core' 'NewTools-Playground' 'NewTools-Playground-Tests' );
			group: 'Inspector' with: #( 'Core' 'NewTools-Inspector' 'NewTools-Inspector-Tests' );
			group: 'Debugger' with: #( 
					 	'Core' 
					 	'Inspector' 
					 	'NewTools-Debugger-Commands'
				    		'NewTools-Debugger-Extensions' 
					 	'NewTools-Debugger'
				    		'NewTools-ObjectCentricBreakpoints'
				    		'NewTools-Sindarin-Tools' 
					 	'NewTools-Sindarin-Commands'
				    		'NewTools-Sindarin-Commands-Tests'
				    		'NewTools-Debugger-Breakpoints-Tools'
				    		'NewTools-Debugger-Tests' 
					 	'NewTools-Debugger-Fuel'
				    		'NewTools-Debugger-Fuel-Tests' 
					 	'NewTools-Fuel' );
			group: 'Spotter' with: #( 
						'NewTools-Morphic-Spotter' 
						'NewTools-Spotter-Processors'
				   		'NewTools-Spotter' 
						'NewTools-Spotter-Extensions'
				   		'NewTools-Spotter-Tests' 
						'NewTools-Spotter-Processors-Tests' );
			group: 'SystemReporter' with: #( 'Core' 'NewTools-SystemReporter' );
			group: 'Methods' with: #( 'Core' 'NewTools-MethodBrowsers' );
			"Not in the image for the moment, we need a pass on them"
			group: 'KeymapBrowser' with: #( 'Core' 'NewTools-KeymapBrowser' );
			group: 'CritiqueBrowser' with: #( 'NewTools-CodeCritiques' 'NewTools-CodeCritiques-Tests' );
			group: 'FontChooser' with: #( 'Core' 'NewTools-FontChooser' 'NewTools-FontChooser-Tests' );
			group: 'FlagBrowser' with: #( 
						'Core' 
						'NewTools-FlagBrowser' 
						'NewTools-FlagBrowser-Tests' );
			group: #development with: #( 'default' 
						'NewTools-DebuggerSelector'
				   		'NewTools-DebuggerSelector-Tests' );
			group: #FileBrowser with: #( 
						'NewTools-FileBrowser' 
						'NewTools-FileBrowser-Tests' );
      			group: #RewriterTools with: #(
				    		'NewTools-RewriterTools-Backend'
				    		'NewTools-RewriterTools'
				    		'NewTools-RewriterTools-Backend-Tests'
				    		'NewTools-RewriterTools-Tests' );
			group: 'default' with: #( 
						'Playground' 
						'Inspector' 
						'CritiqueBrowser' 
						'Debugger'
				   		'SystemReporter' 
						'FontChooser' 
						'Methods'
				   		'Spotter'
            					'RewriterTools') ]
]

{ #category : 'external projects' }
BaselineOfNewTools >> chest: spec [

	spec baseline: 'Chest' with: [ 
		spec
			repository: (self packageRepositoryURL ifEmpty: [ 
						 'github://pharo-spec/Chest:v0.4.1' ]);
			loads: 'default' ]
]

{ #category : 'external projects' }
BaselineOfNewTools >> packageRepositoryURL [
	| url |
	
	url := super packageRepositoryURL.
	url ifEmpty: [ ^ url ].
	"Verify if I am running in CI"
	"travis or github actions"
	((url includesSubstring: 'pharo-spec') 
		or: [ url beginsWith: 'tonel:///home/runner/' ]) ifTrue: [ ^ '' ].
	
	^ url
]

{ #category : 'actions' }
BaselineOfNewTools >> postload: loader package: packageSpec [

	MCMethodDefinition initializersEnabled: initializersEnabled
]

{ #category : 'actions' }
BaselineOfNewTools >> preload: loader package: packageSpec [

	initializersEnabled := MCMethodDefinition initializersEnabled.
	MCMethodDefinition initializersEnabled: true
]

{ #category : 'external projects' }
BaselineOfNewTools >> sindarin: spec [

	spec baseline: 'Sindarin' with: [ 
		spec
			repository: (self packageRepositoryURL 
				ifEmpty: [ 'github://pharo-spec/ScriptableDebugger:Pharo12/src' ]);
			loads: 'default' ]
]
