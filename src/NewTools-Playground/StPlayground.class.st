"
Playground is the correspondent of a classic Smalltalk Workspace. The problem with the name Workspace is that it implies that work should be carried out in this space, while this is not a best practice. Playground describes better the intention of providing a place in which we can quickly play with some code.

"
Class {
	#name : #StPlayground,
	#superclass : #StPresenter,
	#instVars : [
		'text',
		'statusBar',
		'bindings'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlayground class >> defaultExtent [

	^ 550 @ 350
]

{ #category : #specs }
StPlayground class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #text;
		yourself
]

{ #category : #accessing }
StPlayground class >> defaultTitle [ 

	^ 'Playground'
]

{ #category : #'instance creation' }
StPlayground class >> open [ 

	^ self new openWithSpec
]

{ #category : #'instance creation' }
StPlayground class >> openContents: aString [
	"Open a new workspace with the given contents. It looks better when aString is code since the style is applied"

	^ self new
		contents: aString;
		openWithSpec
]

{ #category : #'tools registry' }
StPlayground class >> register [
	"Add ourselves to registry. See [Smalltalk tools]" 
	<script>

	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
StPlayground class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 

	registry register: self as: #workspace

]

{ #category : #binding }
StPlayground >> bindingOf: aString [

	(bindings includesKey: aString)
		ifFalse: [ bindings add: (WorkspaceVariable key: aString asSymbol) ].
	^ bindings associationAt: aString
]

{ #category : #binding }
StPlayground >> bindings [
	
	^ bindings
]

{ #category : #'private builder' }
StPlayground >> buildMenu [
	| menuSpec |
	
	menuSpec := (PragmaMenuBuilder 
		pragmaKeyword: WorldState discoveredMenuPragmaKeyword 
		model: self)
		menuSpec.
	^ menuSpec asMenuBarPresenter
	
]

{ #category : #'private builder' }
StPlayground >> buildStatusBar [ 

	^ SpStatusBarPresenter new
]

{ #category : #'private builder' }
StPlayground >> buildToolBar [

	^ self toolbarActions 
		asToolbarPresenterWith: [ :presenter | 
			presenter displayMode: self application toolbarDisplayMode ]
]

{ #category : #accessing }
StPlayground >> contents: aString [

	text text: aString
]

{ #category : #binding }
StPlayground >> doItContext [

	^ nil
]

{ #category : #binding }
StPlayground >> doItReceiver [

	^ nil
]

{ #category : #binding }
StPlayground >> hasBindingOf: aString [

	^ bindings includesKey: aString asSymbol
]

{ #category : #binding }
StPlayground >> hasBindingThatBeginsWith: aString [

	^ self variableBindingNames 
		anySatisfy: [ :each | each beginsWith: aString ]
]

{ #category : #initialization }
StPlayground >> initialize [

	bindings := Dictionary new.
	super initialize
]

{ #category : #initialization }
StPlayground >> initializePresenters [
	
	text := self newCode
		interactionModel: self;
		completionEngine: (SpCodeCompletionEngine new 
			scripting: true;
			doItRequestor: self;
			doItContext: self doItContext;
			completionClass: self selectedClassOrMetaClass;
			yourself);
		yourself
]

{ #category : #initialization }
StPlayground >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		initialExtent: self class defaultExtent;
		windowIcon: self windowIcon;
		toolBar: self buildToolBar;
		statusBar: (statusBar := self buildStatusBar).
	
	self flag: #TODO. "This just has sense if this is the 'main' window"
	"aWindowPresenter menu: self newMenu"
]

{ #category : #accessing }
StPlayground >> selectAll [
	
	^ text selectAll
]

{ #category : #binding }
StPlayground >> selectedClassOrMetaClass [

	^ nil
]

{ #category : #accessing }
StPlayground >> selectedTextOrLine [
	
	^ text selectedTextOrLine
]

{ #category : #accessing }
StPlayground >> setBindings: aDictionary [
	"Sets the Workspace to use the specified dictionary as its namespace"

	bindings := aDictionary
]

{ #category : #'accessing ui' }
StPlayground >> text [
	^ text
]

{ #category : #'accessing ui' }
StPlayground >> text: anObject [
	text := anObject
]

{ #category : #'private builder' }
StPlayground >> toolbarActions [

	^ CmCommandGroup forSpec
		register: (CmCommandGroup forSpec
			register: (StPlaygroundDoItCommand forSpecContext: self);
			register: (StPlaygroundPublishCommand forSpecContext: self);
			register: (StPlaygroundBindingsCommand forSpecContext: self);
			register: (StPlaygroundPagesCommand forSpecContext: self);
			yourself);
		yourself
]

{ #category : #accessing }
StPlayground >> variableBindingNames [
	
	^ bindings keys
]

{ #category : #initialization }
StPlayground >> windowIcon [
	
	^ self application iconNamed: #workspace
]
