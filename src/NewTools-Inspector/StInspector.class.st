Class {
	#name : #StInspector,
	#superclass : #StPresenter,
	#instVars : [
		'views',
		'evaluator',
		'model'
	],
	#classVars : [
		'PreferredExtent'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StInspector class >> defaultSpec [
	<spec: #default>
	
	^ SpecBoxLayout newVertical
		add: #views;
		addLast: #evaluator withConstraints: [ :constraints |
			constraints 
				expand: false;
				fill: false; 
				padding: 0;
				minHeight: 100 ];
		yourself
]

{ #category : #accessing }
StInspector class >> defaultTitle [

	^ 'Inspector'
]

{ #category : #'instance creation' }
StInspector class >> openOn: anObject [

	^ (self on: (StInspectorModel on: anObject)) openWithSpec
]

{ #category : #accessing }
StInspector class >> preferredExtent [
	
	^ PreferredExtent ifNil: [ PreferredExtent := 600@400 ]
]

{ #category : #accessing }
StInspector class >> titleFor: anObject [ 

	^ 'Inspector on {1}' format: { anObject gtDisplayString  }
]

{ #category : #private }
StInspector >> allViews [
	
	^ { self model inspectedObject rawInspection }, self collectViews
]

{ #category : #private }
StInspector >> collectViews [
	
	self flag: #TODO.
	^ #()
]

{ #category : #api }
StInspector >> initialExtent [ 

	^ self class preferredExtent
]

{ #category : #initialization }
StInspector >> initializeWidgets [

	views := self newTabManager.
	evaluator := self newText beForCode.
	
	self title: (self class titleFor: self model inspectedObject).
	views tabs: (self allViews collect: [ :each |
		each owner: self.
		self newTab 
			label: each title;
			presenter: each;
			closeable: false;
			yourself ]).
]

{ #category : #initialization }
StInspector >> initializeWindow: aWindowPresenter [

	aWindowPresenter toolBar: self newToolBar
]

{ #category : #'model access' }
StInspector >> model [ 

	^ model
]

{ #category : #'model access' }
StInspector >> model: anInspectorModel [

	model := anInspectorModel.
	self refresh
]

{ #category : #'private factory' }
StInspector >> newToolBar [

	^ LtToolBarBuilder new 
		owner: self;
		matching: [ :each | each hasGroup: StInspectorCommandGroup uniqueInstance ];
		build
]

{ #category : #private }
StInspector >> refresh [
	"model changed?  
	 update inspector values."
	self flag: #TODO.
]

{ #category : #'model access' }
StInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel

	
]
