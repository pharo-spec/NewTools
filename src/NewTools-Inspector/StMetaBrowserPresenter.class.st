"
A special inspection that shows a simplified browser. 
This inspection allow the user to operate with the class of the instance.

Also, this inspection allows the user to place instance breakpoints (breakpoints that will act when the method where the breakpoint is) is called for the instance being inspected.
"
Class {
	#name : 'StMetaBrowserPresenter',
	#superclass : 'StInspectionPresenter',
	#instVars : [
		'classes',
		'methods',
		'source'
	],
	#category : 'NewTools-Inspector-View',
	#package : 'NewTools-Inspector',
	#tag : 'View'
}

{ #category : 'commands' }
StMetaBrowserPresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup
		register: ((CmCommandGroup named: 'classes') asSpecGroup
			beDisplayedAsGroup;
			register: (StInspectorBrowseSelectedCommand forSpecContext: presenter);
			yourself);
		register: ((CmCommandGroup named: 'methods') asSpecGroup
			beDisplayedAsGroup;
			register: (StInspectorInspectSelectedCommand forSpecContext: presenter);
			register: (StInspectorBrowseSelectedCommand forSpecContext: presenter);
			yourself)
]

{ #category : 'layout' }
StMetaBrowserPresenter class >> defaultLayout [
	
	^ SpPanedLayout newTopToBottom
		add: (SpPanedLayout newLeftToRight
			add: #classes;
			add: #methods;
			yourself);
		add: #source;
		yourself
]

{ #category : 'initialization' }
StMetaBrowserPresenter >> classListActions [
	
	^ self rootCommandsGroup / 'classes'
]

{ #category : 'private - actions' }
StMetaBrowserPresenter >> compile: aString [
	| compiledSelector cursorPosition |

	cursorPosition := source cursorPositionIndex.

	compiledSelector := self selectedMethod methodClass
		compile: aString
		classified: 	self selectedMethod protocol.
	
	self updateMethods: self selectedClass.
	methods items 
		detect: [ :each | each selector = compiledSelector ]
		ifFound: [ :aMethod | 
			methods selectItem: aMethod.
			source cursorPositionIndex: cursorPosition ]
]

{ #category : 'initialization' }
StMetaBrowserPresenter >> connectPresenters [ 

	classes
		transmitTo: methods
		transform: [ :aClass | self methodsOf: aClass ]
		postTransmission: [ :destination | 
			methods unfilteredItems: destination items.
			methods filterInputPresenter clearContent.
			destination selectIndex: 1 ].

	methods transmitDo: [ :aMethod |
		self selectedMethod
			ifNotNil: [ : s | 	self updateSourceWith: aMethod ]
			ifNil: [ 
				source 
					beForObject: self model;
					text: String empty ] ]
]

{ #category : 'initialization' }
StMetaBrowserPresenter >> initializePresenters [

	| classHierarchy |
	classHierarchy := self model class withAllSuperclasses reversed.

	classes := self newTreeTable
		           addColumn:
			           (SpStringTableColumn
				            title: 'Class hierarchy'
				            evaluated: #name);
		           roots: { classHierarchy first };
		           children: [ :aClass |
			           classHierarchy select: [ :subclass |
					           subclass superclass == aClass ] ];
		           actions: self classListActions;
		           yourself.
	methods := (self instantiate: SpFilteringListPresenter)
		           display: [ :each | each selector ];
		           actions: self methodListActions;
		           yourself.

	source := self newCode
					lineNumbers: StPharoSettings codeShowLineNumbers;
			 		beForScripting;
					whenSubmitDo: [ :aString | self compile: aString ];
					whenResetDo: [ self updateSourceWith: self selectedMethod ];
					yourself.

	classes
		selectPath: (Array new: classHierarchy size withAll: 1)
		scrollToSelection: true
]

{ #category : 'initialization' }
StMetaBrowserPresenter >> methodListActions [

	^ self rootCommandsGroup / 'methods'
]

{ #category : 'private' }
StMetaBrowserPresenter >> methodsOf: aClass [

	aClass ifNil: [ ^ #() ].
	^ aClass methods sorted: #selector ascending

]

{ #category : 'backstops' }
StMetaBrowserPresenter >> selectedClass [

	^ classes selection selectedItem
]

{ #category : 'accessing' }
StMetaBrowserPresenter >> selectedMethod [

	^ methods selectedItem
]

{ #category : 'accessing' }
StMetaBrowserPresenter >> selectedObject [

	^ self selectedMethod ifNil: [ self selectedClass  ]
]

{ #category : 'private - updating' }
StMetaBrowserPresenter >> updateMethods: aClass [
	
	methods items: (aClass
		ifNotNil: [ aClass methods sorted: #selector ascending ]
		ifNil: [ #() ])
	
]

{ #category : 'private - updating' }
StMetaBrowserPresenter >> updateSourceWith: method [

	source userActionDuring: [
		method
			ifNotNil: [ 
				source text: method sourceCode; beForMethod: method  ]
			ifNil: [ 
				source text: ''; clearInteractionModel ] ]
]
