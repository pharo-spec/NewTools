"
I test that the inspector prints the values of its nodes once, instead of once for each time the table showing them is drawn.

## Responsibility:

- Check that `StInspectorNode>>stringValue` prints its value once and keeps the result.
- Check that a node shows a new display string once its cached one is reset.
- Check that the raw view and the inspector do not print the inspected object again on each redraw.

## Collaborators:

- `StInspectorNode` and its subclasses: the nodes whose `stringValue` is checked.
- `StRawInspectionPresenter`: the table of nodes, which resets the strings of the nodes it keeps (`updateNodesFromScope:to:`, used by the debugger).
- `StInspectorPresenter`: opened on an object to count the prints of a whole inspector.

## Internal Representation

- printCounterClass: a class built in a private environment for each test, whose instances count how many times they are printed (`printCount`) and print their `label`.
"
Class {
	#name : 'StInspectorNodeStringValueTest',
	#superclass : 'TestCase',
	#instVars : [
		'printCounterClass'
	],
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'helpers' }
StInspectorNodeStringValueTest >> buildPrintCounterClass [
	"Answer a class, built in a private environment so that it leaves no trace in the image, whose instances count how many times they are printed."

	| environment class |
	environment := SystemEnvironment new.
	environment codeChangeAnnouncer: Announcer new.
	environment at: #FixedLayout put: FixedLayout.
	class := (Object << #StPrintCounterForTest)
		         slots: { #printCount. #label };
		         environment: environment;
		         build.
	#( 'printCount

	^ printCount ifNil: [ 0 ]' 'label: aString

	label := aString' 'printOn: aStream

	printCount := self printCount + 1.
	aStream nextPutAll: label' ) do: [ :source |
		class
			compile: source
			classified: #fixture
			withStamp: nil
			logSource: false ].
	^ class
]

{ #category : 'helpers' }
StInspectorNodeStringValueTest >> newPrintCounterLabelled: aString [

	^ printCounterClass new
		  label: aString;
		  yourself
]

{ #category : 'running' }
StInspectorNodeStringValueTest >> setUp [

	super setUp.
	printCounterClass := self buildPrintCounterClass
]

{ #category : 'tests' }
StInspectorNodeStringValueTest >> testOpeningAnInspectorDoesNotPrintTheObjectOnEachRedraw [
	"The window title, the header and the row of the raw view print the inspected object; the many redraws of the table while the window is laid out must not print it again."

	| object window |
	object := self newPrintCounterLabelled: 'first'.
	window := (StInspectorPresenter onObject: object) open.
	[
		self waitUntilUIRedrawed.
		"use perform: since object is instance of an anonymous class with methods defined in strings.
		It defeats the static rule checker"
		self assert: (object perform: #printCount) <= 3 ] ensure: [ window close ]
]

{ #category : 'tests' }
StInspectorNodeStringValueTest >> testResetStringValueShowsTheNewDisplayString [

	| object node |
	object := self newPrintCounterLabelled: 'first'.
	node := StInspectorSelfNode hostObject: object.
	node stringValue.
	object label: 'second'.
	node resetStringValue.
	self assert: node stringValue equals: 'second'
]

{ #category : 'tests' }
StInspectorNodeStringValueTest >> testStringValueAnswersTheDisplayStringOfTheValue [

	| node |
	node := StInspectorSelfNode hostObject: (self newPrintCounterLabelled: 'first').
	self assert: node stringValue equals: 'first'
]

{ #category : 'tests' }
StInspectorNodeStringValueTest >> testStringValuePrintsTheValueOnce [
	"The table of the inspector asks for the string of a node each time it draws its cells: the value must not be printed again each time."

	| object node |
	object := self newPrintCounterLabelled: 'first'.
	node := StInspectorSelfNode hostObject: object.
	node stringValue.
	node stringValue.
		"use perform: since object is instance of an anonymous class with methods defined in strings.
		It defeats the static rule checker"
	self assert: (object perform: #printCount) equals: 1
]

{ #category : 'tests' }
StInspectorNodeStringValueTest >> testUpdateNodesFromScopeShowsTheNewValuesOfTheKeptNodes [
	"The debugger keeps the nodes of the raw view while stepping in the same context, so they must show the new values of the variables."

	| object raw selfNode |
	object := self newPrintCounterLabelled: 'first'.
	raw := StRawInspectionPresenter on: (StInspectorModel on: object).
	selfNode := raw attributeTable roots first.
	selfNode stringValue.
	object label: 'second'.
	raw updateNodesFromScope: #(  ) to: #(  ).
	self assert: raw attributeTable roots first stringValue equals: 'second'
]

{ #category : 'helpers' }
StInspectorNodeStringValueTest >> waitUntilUIRedrawed [

	SpMorphicBackendForTest new waitUntilUIRedrawed
]
