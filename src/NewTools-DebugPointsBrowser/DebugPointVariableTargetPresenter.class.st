"
I am a UI element to display all methods, and their source code, affected by a selected debug point which targets a variable
"
Class {
	#name : 'DebugPointVariableTargetPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'target',
		'impactedNodesCache',
		'readCheckbox',
		'writeCheckbox',
		'readWriteCheckbox',
		'toolbar',
		'impactedMethodList',
		'codePresenter'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'initialization' }
DebugPointVariableTargetPresenter >> connectPresenters [

	impactedMethodList transmitDo: [ :methodOrBlock |
		methodOrBlock ifNotNil: [ self updateCodeFromMethod: methodOrBlock ] ].

	"implement radio button activation"
	self setupRadioButtonActivationListeners
]

{ #category : 'layout' }
DebugPointVariableTargetPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom
		  add: (self newBoxLayoutLeftToRight
				   add: readCheckbox expand: false;
				   add: writeCheckbox expand: false)
		  expand: false;
		  add: (self newBoxLayoutLeftToRight
				   add: readWriteCheckbox expand: false;
				   add: toolbar expand: false;
				   yourself)
		  expand: false;
		  add: (self newPanedLayoutTopToBottom
				   add: impactedMethodList;
				   add: codePresenter;
				   positionOfSlider: 30 percent;
				   yourself);
		  yourself
]

{ #category : 'layout' }
DebugPointVariableTargetPresenter >> dialogLayout [

	^ self newBoxLayoutTopToBottom
		  add: (self newBoxLayoutLeftToRight
				   add: readCheckbox expand: false;
				   add: writeCheckbox expand: false;
				   add: readWriteCheckbox expand: false;
				   add: toolbar expand: false;
				   yourself)
		  expand: false;
		  add: (self newPanedLayoutLeftToRight
				   add: impactedMethodList;
				   add: codePresenter;
				   yourself);
		  yourself
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeCode [

	codePresenter := self newCode
		                 beNotEditable;
		                 yourself
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeMethodList [

	impactedMethodList := self newFilteringList
		                      items: {  };
		                      sortingBlock: [ :m1 :m2 |
			                      m1 methodClass name < m2 methodClass name
				                      and: [ m1 method name < m2 method name ] ];
		                      yourself
]

{ #category : 'initialization' }
DebugPointVariableTargetPresenter >> initializePresenters [

	self initializeRadioButtons.
	self initializeMethodList.
	self initializeCode.
	self initializeToolbar
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeRadioButtons [

	self initializeReadRadioButton.
	self initializeWriteRadioButton.
	self initializeReadWriteRadioButton.
	readCheckbox associatedRadioButtons: {
			writeCheckbox.
			readWriteCheckbox }
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeReadRadioButton [

	readCheckbox := self newRadioButton
		                label: 'read only';
		                yourself
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeReadWriteRadioButton [

	readWriteCheckbox := self newRadioButton
		                     label: 'read / write';
		                     yourself
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeToolbar [

	toolbar := self newToolbar
		           add: (self newToolbarButton
				            label: 'Refresh';
				            icon: (self iconNamed: #smallUpdate);
				            help: 'Update method list and code';
				            action: [ self updateMethodList ];
				            yourself);
		           yourself
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> initializeWriteRadioButton [

	writeCheckbox := self newRadioButton
		                 label: 'write only';
		                 yourself
]

{ #category : 'presenter building' }
DebugPointVariableTargetPresenter >> setupRadioButtonActivationListeners [

	readCheckbox whenActivatedDo: [ self target accessStrategy: #read ].
	writeCheckbox whenActivatedDo: [ self target accessStrategy: #write ].
	readWriteCheckbox whenActivatedDo: [
		self target accessStrategy: #all ]
]

{ #category : 'accessing' }
DebugPointVariableTargetPresenter >> target [

	^ target
]

{ #category : 'accessing' }
DebugPointVariableTargetPresenter >> target: aDebugPointInstanceVariableTarget [

	target := aDebugPointInstanceVariableTarget.
	self updatePresenter
]

{ #category : 'updating - presenters' }
DebugPointVariableTargetPresenter >> updateCodeFromMethod: method [

	codePresenter
		text: method sourceCode;
		beForMethod: method.
	impactedNodesCache
		select: [ :node | node methodNode == method ast ]
		thenDo: [ :node |
			codePresenter addTextSegmentDecoration:
				(SpTextPresenterDecorator forHighlight
					 interval: (node start to: node stop + 1);
					 yourself) ]
]

{ #category : 'model updates' }
DebugPointVariableTargetPresenter >> updateImpactedNodesCache [

	impactedNodesCache := self target impactedNodes
]

{ #category : 'updating - presenters' }
DebugPointVariableTargetPresenter >> updateMethodList [

	self updateImpactedNodesCache.
	impactedMethodList items: (impactedNodesCache collect: [ :node |
			 node methodOrBlockNode compiledMethod ]) asIdentitySet
]

{ #category : 'initialization' }
DebugPointVariableTargetPresenter >> updatePresenter [

	self target ifNil: [ ^ self ].
	self updateMethodList.
	self updateRadioButtonsState
]

{ #category : 'updating - presenters' }
DebugPointVariableTargetPresenter >> updateRadioButtonsState [

	readCheckbox state: self target isReadOnly.
	writeCheckbox state: self target isWriteOnly.
	readWriteCheckbox state: self target isReadWrite
]
