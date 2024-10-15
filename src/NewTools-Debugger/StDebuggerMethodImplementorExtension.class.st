"
I am a debugger extension that helps create a method that raised a debugger with a DNU, allowing to choose some parameters such as the class or trait and the protocol of the new method. 
"
Class {
	#name : 'StDebuggerMethodImplementorExtension',
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
StDebuggerMethodImplementorExtension class >> acceptsPredicate: aStDebuggerContextPredicate [

	^ aStDebuggerContextPredicate isContextDoesNotUnderstand or: [
		  aStDebuggerContextPredicate
			  isContextSubclassResponsibilityException ]
]

{ #category : 'debugger extension' }
StDebuggerMethodImplementorExtension class >> showInDebugger [

	^ showDebuggerExtension ifNil: [ showDebuggerExtension := true ]
]

{ #category : 'presenters' }
StDebuggerMethodImplementorExtension >> addProtocols: protocols [
	| sortedProtocols |

	sortedProtocols := SortedCollection sortBlock: [ :p1 :p2 | p1 name <= p2 name ].
	sortedProtocols addAll: protocols.

	selectedProtocol items: sortedProtocols.
				
	customProtocolCheckBox state 
		ifTrue:[ self selectMatchingProtocol ]
]

{ #category : 'private - actions' }
StDebuggerMethodImplementorExtension >> addProtocolsFrom: aClassOrTrait [ 

	aClassOrTrait ifNil: [ ^ self ].

	self addProtocols: (aClassOrTrait isTrait
		ifTrue: [ aClassOrTrait protocols ]
		ifFalse: [ 
			((aClassOrTrait withAllSuperclasses copyWithoutAll: {Object. ProtoObject}) 
				flatCollect: #protocols) asSet])
]

{ #category : 'debugger extension' }
StDebuggerMethodImplementorExtension >> debuggerExtensionToolName [

	^ 'Create method'
]

{ #category : 'layout' }
StDebuggerMethodImplementorExtension >> defaultLayout [

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

{ #category : 'actions' }
StDebuggerMethodImplementorExtension >> implementMethod [
	| classOrTrait methodImplementor |
	
	classOrTrait := classesAndTraits selectedItem.
	
	methodImplementor := (StDebuggerMethodImplementor forSession: self debugger session).
	methodImplementor targetClassOrTrait: classOrTrait.
	methodImplementor protocol: self protocol.
   methodImplementor implementMissingMethod.

	self debugger selectTopContext
]

{ #category : 'initialization' }
StDebuggerMethodImplementorExtension >> initializePresenters [
	
	description := self newLabel.
	description label: exception description.

	selectedProtocol := self newDropList.
	selectedProtocol 
		display: [ :item | item name ];
		displayIcon: [ :aProtocol | (aProtocol isExtensionProtocol
			ifTrue: [ self iconNamed: #protocolExtension ]
			ifFalse: [ self iconNamed: #protocolPublic ]) ].	
	
	customProtocolTextInput := self newTextInput.
	customProtocolTextInput removeEntryCompletion.
	customProtocolTextInput placeholder: 'Add your protocol here'.
	customProtocolTextInput beNotEditable.
	customProtocolTextInput whenTextChangedDo: [ self selectMatchingProtocol ].
	
	customProtocolCheckBox := self newCheckBox.
	customProtocolCheckBox label: 'New protocol'.
	customProtocolCheckBox whenActivatedDo: [ 
		customProtocolTextInput beEditable. 
		selectedProtocol enabled: false ].
	customProtocolCheckBox whenDeactivatedDo: [ 
		customProtocolTextInput beNotEditable.
		selectedProtocol enabled: true ].
		
	classesAndTraits := self newDropList.
	classesAndTraits 
		display: [ :item | item name ];
		displayIcon: [ :item | self iconNamed: item systemIconName ];
		whenSelectedItemChangedDo: [ :item | self addProtocolsFrom: item ].
			
	createMethodButton := self newButton
		icon: (self iconNamed: #add);
		label: 'Add method';
		action: [ self implementMethod ]
]

{ #category : 'actions' }
StDebuggerMethodImplementorExtension >> protocol [

	^ customProtocolCheckBox state
		  ifTrue: [ customProtocolTextInput text ]
		  ifFalse: [ selectedProtocol selectedItem ]
]

{ #category : 'presenters' }
StDebuggerMethodImplementorExtension >> selectMatchingProtocol [

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
StDebuggerMethodImplementorExtension >> setModelBeforeInitialization: aStDebugger [

	debugger := aStDebugger.
	exception := debugger exception 
]

{ #category : 'initialization' }
StDebuggerMethodImplementorExtension >> updatePresenter [
	| traits receiverClass items |
	
	items := OrderedCollection new.
	traits := OrderedCollection new.
	receiverClass := exception receiver class.
	
	receiverClass withAllSuperclassesDo: [ :aClass |
		traits addAll: aClass allTraits.
		items add: aClass ].

	classesAndTraits items: items
]
