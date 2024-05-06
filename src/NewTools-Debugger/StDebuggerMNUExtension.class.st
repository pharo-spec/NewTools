"
I am a debugger extension that helps create a method that raised a debugger with a DNU, allowing to choose some parameters such as the class or trait and the protocol of the new method. 
"
Class {
	#name : 'StDebuggerMNUExtension',
	#superclass : 'SpPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'exception',
		'description',
		'classesAndTraits',
		'selectedProtocol',
		'createMethodButton',
		'customProtocolCheckBox',
		'customProtocolTextInput'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'testing' }
StDebuggerMNUExtension class >> acceptsPredicate: aStDebuggerContextPredicate [

	^ aStDebuggerContextPredicate isContextDoesNotUnderstand or: [
		  aStDebuggerContextPredicate
			  isContextSubclassResponsibilityException ]
]

{ #category : 'debugger extension' }
StDebuggerMNUExtension class >> showInDebugger [

	^ showDebuggerExtension ifNil: [ showDebuggerExtension := true ]
]

{ #category : 'actions' }
StDebuggerMNUExtension >> addMethod [

	| classOrTrait |
	classOrTrait := classesAndTraits selectedItem.

	self debugger
		createMissingMethodFor: exception message
		inClass: classOrTrait
		underProtocol: self protocol
]

{ #category : 'presenters' }
StDebuggerMNUExtension >> addProtocols: protocols [
	|sortedProtocols|
	sortedProtocols := SortedCollection sortBlock: [ :p1 :p2|p1 name <= p2 name].
	sortedProtocols addAll: protocols.
	selectedProtocol emptyList.
	sortedProtocols do: [ :p |
		selectedProtocol
			addItemLabeled: p
			do: [  ]
			icon: (p isExtensionProtocol
					 ifTrue: [ self iconNamed: #protocolExtension ]
					 ifFalse: [ self iconNamed: #protocolPublic ]) ].
				
	customProtocolCheckBox state ifTrue:[self selectMatchingProtocol]
]

{ #category : 'debugger extension' }
StDebuggerMNUExtension >> debuggerExtensionToolName [

	^ 'Create method'
]

{ #category : 'layout' }
StDebuggerMNUExtension >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: description height: self class toolbarHeight;
		  add: 'Class or Trait' expand: false fill: false padding: 5; 
		  add: (SpBoxLayout newLeftToRight
				   add: classesAndTraits expand: true fill: true padding: 5;
				   yourself) height: (self class toolbarHeight);
		  add: 'Protocol' expand: false fill: false padding: 5; 
		  add: (SpBoxLayout newLeftToRight
				   add: selectedProtocol expand: true fill: true padding: 5;
				   yourself) height: (self class toolbarHeight);
		 add: SpBoxLayout newLeftToRight height: 5;
		 add: (SpPanedLayout newLeftToRight 
					positionOfSlider: 30 percent; 	
					add: customProtocolCheckBox;	   
					add: customProtocolTextInput ;
				   yourself) height: (self class toolbarHeight);
		add: SpBoxLayout newLeftToRight height: 10;		
		add: (SpPanedLayout newLeftToRight
					positionOfSlider:  60 percent;
					add: SpBoxLayout newLeftToRight;
				   add: createMethodButton;
				   yourself) height: (self class toolbarHeight);					
		  yourself
]

{ #category : 'initialization' }
StDebuggerMNUExtension >> initializePresenters [

	| receiverClass traits |
	description := self newLabel.
	description label: exception description.

	selectedProtocol := self newDropList.
	selectedProtocol display: [ :p| p name ].	
	
	customProtocolTextInput := self newTextInput.
	customProtocolTextInput removeEntryCompletion.
	customProtocolTextInput placeholder: 'Add your protocol here'.
	customProtocolTextInput beNotEditable.
	customProtocolTextInput whenTextChangedDo: [self selectMatchingProtocol].
	
	customProtocolCheckBox := self newCheckBox.
	customProtocolCheckBox label: 'New protocol'.
	customProtocolCheckBox whenActivatedDo: 
		[ customProtocolTextInput beEditable. 
		selectedProtocol enabled: false].
	customProtocolCheckBox whenDeactivatedDo: 
		[ customProtocolTextInput beNotEditable.
		selectedProtocol enabled: true ].
	
	traits := OrderedCollection new.
	receiverClass := exception receiver class.
	classesAndTraits := self newDropList.
	receiverClass withAllSuperclassesDo: [ :c |
		traits addAll: c allTraits.
		classesAndTraits
			addItemLabeled: c
			do: [ self addProtocols: (c protocols)   ]
			icon: (self iconNamed: #class) ].
	traits do: [ :t |
		classesAndTraits
			addItemLabeled: t
			do: [ self addProtocols: (t protocols)    ]
			icon: (self iconNamed: #trait) ].		
			
	createMethodButton := self newButton
		icon: (self iconNamed: #add);
		label: 'Add method';
		action: [ self addMethod ]

	




]

{ #category : 'actions' }
StDebuggerMNUExtension >> protocol [

	^ customProtocolCheckBox state
		  ifTrue: [ customProtocolTextInput text ]
		  ifFalse: [ selectedProtocol selectedItem ]
]

{ #category : 'presenters' }
StDebuggerMNUExtension >> selectMatchingProtocol [

	| stringToMatch matchingProtocols |
	stringToMatch := String streamContents: [ :s |
		                 s << customProtocolTextInput text.
		                 s << '*' ].
	matchingProtocols := selectedProtocol items select: [ :e |
		                     stringToMatch match: e name ].
	matchingProtocols ifEmpty: [ ^ self ].
	selectedProtocol selectItem: matchingProtocols first
]

{ #category : 'accessing - model' }
StDebuggerMNUExtension >> setModelBeforeInitialization: aStDebugger [

	debugger := aStDebugger.
	exception := debugger exception 
]
