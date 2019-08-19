Class {
	#name : #StSystemBrowser,
	#superclass : #StPresenter,
	#instVars : [
		'model',
		'inspectionPanel',
		'codePanel',
		'packagesPanel',
		'classesPanel',
		'instanceSidePanel',
		'classSidePanel',
		'codeText',
		'commentText',
		'sourcePage',
		'variablesPanel',
		'statusBar',
		'selectedPackage',
		'selectedClass',
		'selectedMethod'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #specs }
StSystemBrowser class >> defaultSpec [

	^ SpPanedLayout newVertical
		add: (SpPanedLayout newHorizontal
			add: (SpPanedLayout newHorizontal
				add: #packagesPanel;
				add: #classesPanel;
				yourself);
			add: #inspectionPanel;
			yourself);
		add: #codePanel;
		yourself
]

{ #category : #opening }
StSystemBrowser class >> open [
	<script>

	^ self openOn: ClyNavigationEnvironment currentImage
]

{ #category : #opening }
StSystemBrowser class >> openOn: anEnvironment [

	^ (self on: anEnvironment) openWithSpec
]

{ #category : #accessing }
StSystemBrowser class >> preferredExtent [

	^ 900@650
]

{ #category : #'private selecting' }
StSystemBrowser >> basicSelectClass:  aClassModel [
		
	selectedClass := aClassModel
]

{ #category : #'private selecting' }
StSystemBrowser >> basicSelectMethod:  aMethodModel [
		
	selectedMethod := aMethodModel
]

{ #category : #'private selecting' }
StSystemBrowser >> basicSelectPackage: aPackageModel [
		
	selectedPackage := aPackageModel
]

{ #category : #initialization }
StSystemBrowser >> buildStatusBar [

	^ SpStatusBarPresenter new
]

{ #category : #initialization }
StSystemBrowser >> buildToolBar [

	^ CmCommandGroup forSpec
		register: (StInspectorBrowseCommand forSpecContext: self);
		register: (StInspectorHelpCommand forSpecContext: self);
		asToolbarPresenterWith: [ :presenter | presenter beIcons ]
]

{ #category : #initialization }
StSystemBrowser >> connectPresenters [

	packagesPanel transmitTo: classesPanel transform: #classes.
	packagesPanel transmitDo: [ :selection | self selectPackage: selection ].
	
	classesPanel transmitTo: instanceSidePanel transform: #instanceProtocols.
	classesPanel transmitTo: classSidePanel transform: #classProtocols.		
	"classesPanel transmitTo: variablesPanel transform: #variables."		
	classesPanel transmitDo: [ :selection | self selectClass: selection ].
	
	instanceSidePanel transmitDo: [ :selection | self selectMethod: selection ].
	classSidePanel transmitDo: [ :selection | self selectMethod: selection ].
	variablesPanel transmitDo: [ :selection | self selectMethod: selection ].
]

{ #category : #initialization }
StSystemBrowser >> initializePresenters [
	
	packagesPanel := self instantiate: StSBPackagesPanel on: self model.
	classesPanel := self instantiate: StSBClassesPanel on: self model.
	
	instanceSidePanel := self instantiate: StSBProtocolInspectionPanel on: self model.
	classSidePanel := self instantiate: StSBProtocolInspectionPanel on: self model.
	variablesPanel := self instantiate: StSBVariableInspectionPanel on: self model.
	inspectionPanel := self newNotebook 
		addPage: (self newPage: 'Instance' provider: instanceSidePanel);
		addPage: (self newPage: 'Class' provider: classSidePanel); 
		addPage: (self newPage: 'Variables' provider: (SpLabelPresenter new label: 'TODO'));
		yourself.
		
	codePanel := self newNotebook
]

{ #category : #initialization }
StSystemBrowser >> initializeWidgets [

	self initializePresenters.	
	self connectPresenters
]

{ #category : #initialization }
StSystemBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: self preferredExtent;
		toolBar: self buildToolBar;
		statusBar: (statusBar := self buildStatusBar)
]

{ #category : #'accessing model' }
StSystemBrowser >> model [ 

	^ model
]

{ #category : #'private factory' }
StSystemBrowser >> newClassTemplateForPackage: aPackageModel [

	^ self newCode
		text: aPackageModel classTemplate;
		yourself
]

{ #category : #'private factory' }
StSystemBrowser >> newCommentFor: aModel [

	^ self newCode
		withoutSyntaxHighlight;
		text: aModel comment;
		yourself
		
]

{ #category : #'private factory' }
StSystemBrowser >> newDefinitionFor: aModel [

	^ self newCode
		text: aModel definition;
		behavior: aModel behavior;
		yourself
]

{ #category : #'private factory' }
StSystemBrowser >> newMethodTemplateForClass: aClassModel [

	^ self newCode
		text: self class sourceCodeTemplate;
		yourself
]

{ #category : #'private factory' }
StSystemBrowser >> newPage: aString provider: aBlock [
	
	^ self newNotebookPage
		title: aString;
		presenterProvider: aBlock;
		yourself
]

{ #category : #'private selecting' }
StSystemBrowser >> selectClass: aClassModel [

	self basicSelectClass: aClassModel.
	self window title: 'Class: ', aClassModel name.
	codePanel 
		removeAll;
		addPage: (self 
			newPage: 'Comment' 
			provider: [ self newCommentFor: self selectedClass ]);
		addPage: (self 
			newPage: selectedClass name
			provider: [ self newDefinitionFor: self selectedClass ]);
		addPage: (self 
			newPage: 'New method' 
			provider: [ self newMethodTemplateForClass: self selectedClass ]);
		selectPageIndex: 2
]

{ #category : #'private selecting' }
StSystemBrowser >> selectMethod: aMethodModel [

	self basicSelectMethod: aMethodModel.
	self window title: aMethodModel name.
	codePanel 
		removeAll;
		addPage: (self 
			newPage: 'Comment' 
			provider: [ self newCommentFor: self selectedClass ]);
		addPage: (self 
			newPage: self selectedClass name
			provider: [ self newDefinitionFor: self selectedClass ]);
		addPage: (self 
			newPage: self selectedMethod name
			provider: [ self newDefinitionFor: self selectedMethod ]);
		selectPageIndex: 3
]

{ #category : #'private selecting' }
StSystemBrowser >> selectPackage: aPackage [

	self basicSelectPackage: aPackage.
	self window title: 'Package: ', aPackage name.
	codePanel 
		removeAll;
		addPage: (self 
			newPage: 'Comment' 
			provider: [ self newCommentFor: self selectedPackage ]);
		addPage: (self 
			newPage: 'New class' 
			provider: [ self newClassTemplateForPackage: self selectedPackage ])
]

{ #category : #accessing }
StSystemBrowser >> selectedClass [

	^ selectedClass
]

{ #category : #accessing }
StSystemBrowser >> selectedMethod [
		
	^ selectedMethod
]

{ #category : #accessing }
StSystemBrowser >> selectedPackage [

	^ selectedPackage
]

{ #category : #'accessing model' }
StSystemBrowser >> setModelBeforeInitialization: aNavigationEnvironment [

	model := StSBEnvironmentModel newEnvironment: aNavigationEnvironment	
]
