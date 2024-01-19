"
I am an inspector of objects. 
I offer multiple views using a miller list as a navigation. 
One particular feature is that you can use the evaluator tab to enter code, and evaluating it results in opening another pane to the right.

The object finder asks dynamically the object for the actual presentations that are displayed in each pane.

Example:
self openOn: Smalltalk.

Register it as a replacement for inspector:
self registerToolsOn: Smalltalk tools.
"
Class {
	#name : 'StInspector',
	#superclass : 'StInspectorPresenter',
	#category : 'NewTools-Inspector-Deprecated',
	#package : 'NewTools-Inspector',
	#tag : 'Deprecated'
}

{ #category : 'testing' }
StInspector class >> isDeprecated [ 
	
	^ true
]
