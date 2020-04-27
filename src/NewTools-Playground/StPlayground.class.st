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
	#classVars : [
		'PreferredExtent'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlayground class >> defaultExtent [

	^ 600@400
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

{ #category : #private }
StPlayground class >> preferredExtent [

	^ PreferredExtent ifNil: [ PreferredExtent := self class defaultExtent ]
]

{ #category : #private }
StPlayground class >> preferredExtent: aPoint [

	PreferredExtent := aPoint
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
StPlayground >> addBinding: aBinding [

	bindings add: aBinding
]

{ #category : #binding }
StPlayground >> bindingOf: aString [

	(self bindings includesKey: aString)
		ifFalse: [ self addBinding: (WorkspaceVariable key: aString asSymbol) ].
	^ self bindings associationAt: aString
]

{ #category : #binding }
StPlayground >> bindings [
	"Combining shared bindings and local bindings needs to be done like this because the 
	 #add: method of Dictionary stores the whole association (which in this case is a 
	 WorkspaceVariable and we need that. #at:put: cannot be used because it will create 
	 an Association and want to keep the WorkspaceVariable."
	| joinedBindings |
	
	"just a small optimisation"
	self application sharedBindings ifEmpty: [ ^ bindings ].
	
	joinedBindings := self application sharedBindings copy.
	bindings associations 
		do: [ :each | joinedBindings add: each ].
	^ joinedBindings
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

	^ self bindings includesKey: aString asSymbol
]

{ #category : #binding }
StPlayground >> hasBindingThatBeginsWith: aString [

	^ self variableBindingNames 
		anySatisfy: [ :each | each beginsWith: aString ]
]

{ #category : #initialization }
StPlayground >> initialize [

	self setBindings: Dictionary new.
	super initialize
]

{ #category : #initialization }
StPlayground >> initializePresenters [
	
	text := self newCode
		contextMenu: [ self menuActions asMenuPresenter ];
		contextKeyBindings: self menuActions asKMCategory;
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
		initialExtent: self class preferredExtent;
		windowIcon: self windowIcon;
		toolBar: self buildToolBar;
		statusBar: (statusBar := self buildStatusBar);
		whenResizingDo: [ :ann | self class preferredExtent: ann newSize ];
		whenOpenedDo: [ text takeKeyboardFocus ]

]

{ #category : #private }
StPlayground >> menuActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: ((CmCommandGroup named: 'Playground') asSpecGroup
			"beDisplayedAsGroup;"
			register: (StPlaygroundPublishCommand forSpecContext: self);
			register: (StPlaygroundBindingsCommand forSpecContext: self);
			register: (StPlaygroundPagesCommand forSpecContext: self);
			yourself);
		yourself	
]

{ #category : #binding }
StPlayground >> removeBinding: aBinding [
 
	bindings removeKey: aBinding key
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
	
	^ self bindings keys
]

{ #category : #initialization }
StPlayground >> windowIcon [
	
	^ self application iconNamed: #workspace
]
