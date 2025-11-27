"
I am a debugger extension that helps create a method that raised a debugger with a DNU, allowing to choose some parameters such as the class or trait and the protocol of the new method. 
"
Class {
	#name : 'StDebuggerMethodImplementorPresenter',
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
StDebuggerMethodImplementorPresenter class >> acceptsPredicate: aStDebuggerContextPredicate [

	^ aStDebuggerContextPredicate isContextDoesNotUnderstand or: [
		  aStDebuggerContextPredicate
			  isContextSubclassResponsibilityException ]
]

{ #category : 'debugger extension' }
StDebuggerMethodImplementorPresenter class >> showInDebugger [

	^ showDebuggerExtension ifNil: [ showDebuggerExtension := true ]
]

{ #category : 'presenters' }
StDebuggerMethodImplementorPresenter >> addProtocols: protocols [
	| sortedProtocols |

	sortedProtocols := SortedCollection sortBlock: [ :p1 :p2 | p1 name <= p2 name ].
	sortedProtocols addAll: protocols.

	selectedProtocol items: sortedProtocols.
				
	customProtocolCheckBox state 
		ifTrue:[ self selectMatchingProtocol ]
]

{ #category : 'private - actions' }
StDebuggerMethodImplementorPresenter >> addProtocolsFrom: aClassOrTrait [

	| allProtocolsWithDuplicates |
	aClassOrTrait ifNil: [ ^ self ].

	allProtocolsWithDuplicates := Dictionary new.
	
	(aClassOrTrait isTrait
		 ifTrue: [ aClassOrTrait protocols ]
		 ifFalse: [
			((aClassOrTrait withAllSuperclasses copyWithoutAll: ({
						  Object.
						  ProtoObject.
						  Class.
						  Behavior.
						  ClassDescription.
						  Object class.
						  ProtoObject class } copyWithout: aClassOrTrait)) flatCollect: #protocols) asSet .
						
					 ]) do: [ :protocol |
		allProtocolsWithDuplicates at: protocol name put: protocol ].
	self addProtocols: allProtocolsWithDuplicates values
]

{ #category : 'debugger extension' }
StDebuggerMethodImplementorPresenter >> debuggerExtensionToolName [

	^ 'Create method'
]

{ #category : 'layout' }
StDebuggerMethodImplementorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Problem' expand: false fill: false padding: 5; 
		  add: description height: (2 * self class toolbarHeight);
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
StDebuggerMethodImplementorPresenter >> implementMethod [
	| classOrTrait methodImplementor |
	
	classOrTrait := classesAndTraits selectedItem.
	
	methodImplementor := (StDebuggerMethodImplementor forSession: self debugger session).
	methodImplementor targetClassOrTrait: classOrTrait.
	methodImplementor protocol: self protocol.
   methodImplementor implementMissingMethod.

	self debugger selectTopContext
]

{ #category : 'initialization' }
StDebuggerMethodImplementorPresenter >> initializePresenters [
	
	description := self newText.
	description beWrapWord.
	description beNotEditable.
	description text: exception description.

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
		label: 'Create method';
		action: [ self implementMethod ]
]

{ #category : 'actions' }
StDebuggerMethodImplementorPresenter >> protocol [

	^ customProtocolCheckBox state
		  ifTrue: [ customProtocolTextInput text ]
		  ifFalse: [ selectedProtocol selectedItem ]
]

{ #category : 'presenters' }
StDebuggerMethodImplementorPresenter >> selectMatchingProtocol [

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
StDebuggerMethodImplementorPresenter >> setModelBeforeInitialization: aStDebugger [

	debugger := aStDebugger.
	exception := debugger exception 
]

{ #category : 'initialization' }
StDebuggerMethodImplementorPresenter >> updatePresenter [
	| traits receiverClass items |
	
	items := OrderedCollection new.
	traits := OrderedCollection new.
	receiverClass := exception receiver class.
	
	receiverClass withAllSuperclassesDo: [ :aClass |
		traits addAll: aClass allTraits.
		items add: aClass ].
	items addAll: traits.
	classesAndTraits items: items
]
