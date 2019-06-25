"
Playground is the correspondent of a classic Smalltalk Workspace. The problem with the name Workspace is that it implies that work should be carried out in this space, while this is not a best practice. Playground describes better the intention of providing a place in which we can quickly play with some code.

The model behind a Playground instance is a PlaygroundModel object.

!!Use cases
The Playground can be used in two ways

# As a place to construct and try out code snippets.
# as an entry point into an inspection process.

In both cases, the ability of diving into objects to the right is an important feature.

"
Class {
	#name : #StPlayground,
	#superclass : #StPresenter,
	#instVars : [
		'text',
		'statusBar'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlayground class >> defaultExtent [

	^ 600 @ 400
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

	^ CmCommandGroup forSpec
		register: (CmCommandGroup forSpec
			register: (StPlaygroundDoItCommand forSpecContext: self);
			register: (StPlaygroundPublishCommand forSpecContext: self);
			register: (StPlaygroundBindingsCommand forSpecContext: self);
			register: (StPlaygroundPagesCommand forSpecContext: self);
			yourself);
		register: (CmCommandGroup forSpec
			register: (StPlaygroundDoItCommand forSpecContext: self);
			yourself);
		asToolBarPresenterWith: [ :presenter | 
			self flag: #TODO. "This comes from a configuration"
			presenter beIcons ]
]

{ #category : #api }
StPlayground >> initialExtent [ 

	^ self class defaultExtent
]

{ #category : #initialization }
StPlayground >> initialize [
	super initialize.
	self title: self class defaultTitle
]

{ #category : #initialization }
StPlayground >> initializeWidgets [
	
	text := self newCode.
	self focusOrder add: text
]

{ #category : #initialization }
StPlayground >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		toolBar: self buildToolBar;
		statusBar: (statusBar := self buildStatusBar).
	
	self flag: #TODO. "This just has sense if this is the 'main' window"
	"aWindowPresenter menu: self newMenu"
]

{ #category : #'accessing ui' }
StPlayground >> text [
	^ text
]

{ #category : #'accessing ui' }
StPlayground >> text: anObject [
	text := anObject
]
