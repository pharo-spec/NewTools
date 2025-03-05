"
I'm a presenter showing StObjectTranscriptLogger log elements. 


```
StObjectTranscriptPresenter open
 
StObjectTranscriptPresenter openWithLogger: StObjectTranscripLogger instance
```

To open from another presenter use the following expression

```
(self application toolNamed: #objectTranscript) open
```


You can show/hide the inspector and the inspector can either display the currently selected log entry or the complete list so that we can perform collection operations for complex filters


```
	| cb |
	StObjectTranscriptLogger start.
	cb := self open.
	'Pharo is super nice!' emit.
``` 




"
Class {
	#name : 'StObjectTranscriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'logList',
		'zoom',
		'logger',
		'inspectSelectedItem',
		'showInspector',
		'isOpened'
	],
	#classVars : [
		'ShowInspector'
	],
	#category : 'NewTools-ObjectTranscript',
	#package : 'NewTools-ObjectTranscript'
}

{ #category : 'accessing' }
StObjectTranscriptPresenter class >> defaultPreferredExtent [
	"Answer the desired extent for the receiver when it is first opened on the screen.  "

	^ self showInspector
		ifTrue: [ 550 @ 850 ]
		ifFalse: [ 550 @ 650 ]
]

{ #category : 'accessing' }
StObjectTranscriptPresenter class >> example [
	"StObjectTranscriptLogger start.
	
	
	self example"
	
	| cb |
	StObjectTranscriptLogger start.
	cb := self new.
	cb logger: StObjectTranscriptLogger instance.
	'this is a message only interesting from the logger domain' emit.
	cb open.
	^ cb
]

{ #category : 'accessing' }
StObjectTranscriptPresenter class >> example2 [
	"self example2"
	
	self open. 
	'Hello Pharo is cool,' emit.
	
]

{ #category : 'instance creation' }
StObjectTranscriptPresenter class >> open [ 
	"Make sure that the object transcript logger is on and open a presenter on it."
	<script>
	
	StObjectTranscriptLogger start.
	^ self openWithLogger: StObjectTranscriptLogger instance
]

{ #category : 'instance creation' }
StObjectTranscriptPresenter class >> openWithLogger: aLogger [

	^ self new logger: aLogger; open 

	
]

{ #category : 'registration' }
StObjectTranscriptPresenter class >> registerToolsOn: registry [

	registry register: self as: #objectTranscript

]

{ #category : 'settings' }
StObjectTranscriptPresenter class >> settings: aBuilder [

	<systemsettings>

	(aBuilder setting: #objectTranscript)
		parent: #tools;
		selector: #showInspector;
		default: true;
		label: 'Display the inspector part';
		description: 'The object transcript supports the in place inspector of log entities. This preference enables it by default';
		target: self
]

{ #category : 'settings' }
StObjectTranscriptPresenter class >> showInspector [

	^ ShowInspector
]

{ #category : 'settings' }
StObjectTranscriptPresenter class >> showInspector: aBoolean [

	ShowInspector := aBoolean
]

{ #category : 'registration' }
StObjectTranscriptPresenter class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #Browse)
		parent: #Browse;
		label: 'Object Transcript';
		order: 5;
		iconName: #playground;
		help: 'Tool to be able to see logs in this instance of Pharo.';
		action: [ self open ]
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> addActions [

	logList 
		addActionWith: [ :item | item
			name: 'Toggle inspector entities';
			iconName: #smallHelp;
			action: [ self hideShowInspector ] ];
		addActionWith: [ :item | item
			name: 'Hide/Show inspector';
			iconName: #inspect;
			action: [ self showInspector: showInspector not ] ];
		addActionWith: [ :item | item
			name: 'Flush entities';
			iconName: #delete;
			action: [ self flush ]];
		addActionWith: [ :item | item
			name: 'Start logger';
			iconName: #start;
			action: [ self startLogger ]];
		addActionWith: [ :item | item
			name: 'Stop logger';
			iconName: #stop;
			action: [ self stopLogger ]]
	
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> connectPresenters [
	
	logList whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNotNil: [ :log | 
				"zoom model: log asInspectorModel"
				inspectSelectedItem 
						ifTrue: [ self inspect: log ]
						ifFalse: [ self inspect: logger recordings ]
				]]
	
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> defaultLayout [
	
	^ showInspector 
		ifTrue: [ self withInspectorLayout ]
		ifFalse: [ self withoutInspectorLayout ]
]

{ #category : 'customization' }
StObjectTranscriptPresenter >> defaultShowInspector [

	^ ShowInspector ifNil: [ ShowInspector := true ]
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> flush [

	logger reset.
	self populateItemsFrom: logger
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> hideShowInspector [

	inspectSelectedItem := inspectSelectedItem not.
				inspectSelectedItem 
						ifTrue: [ self inspect: logList selectedItem ]
						ifFalse: [ self inspect: logger recordings ]
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> initialize [

	super initialize. 
	inspectSelectedItem := true.
	showInspector := self defaultShowInspector
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> initializePresenters [

	logList := self instantiate: SpFilteringListPresenter.
	zoom := StInspectorPresenter newApplication: self application. 

	self addActions
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> initializeWindow: aWindowPresenter [


	super initializeWindow: aWindowPresenter.
	aWindowPresenter whenOpenedDo: [ 
			self selectLastItem.
			isOpened := true. ].
	aWindowPresenter whenClosedDo: [ logger removeAsClient: self ]
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> inspect: anObject [
	
	zoom model: anObject asInspectorModel
		
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> isOpened [ 
	
	^ isOpened ifNil: [ isOpened := false ]
]

{ #category : 'accessing' }
StObjectTranscriptPresenter >> logger: aLogger [
	
	aLogger ifNil: [ ^ self ].
	logger := aLogger.
	logger addAsClient: self. 
	self populateItemsFrom: logger
	
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> populateItemsFrom: aLogger [

	| rec |
	rec := aLogger recordings copy.
	logList items: rec.
	rec size > 0 
		ifTrue: [ logList reapplyOrResetFilter.
					logList selectLast. ]
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> refresh [ 
	
	self populateItemsFrom: logger.
	self selectLastItem.
	
	

]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> selectLastItem [ 

	logList 
		selectIndex: logList listPresenter listSize 
		scrollToSelection: true
]

{ #category : 'accessing' }
StObjectTranscriptPresenter >> selectedItem [

	^  logList selectedItem
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> setInspectSingleEntry [

	inspectSelectedItem := true
]

{ #category : 'customization' }
StObjectTranscriptPresenter >> showInspector: aBoolean [

	showInspector := aBoolean.
	self layout: self defaultLayout.
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> startLogger [

	logger start
]

{ #category : 'actions' }
StObjectTranscriptPresenter >> stopLogger [

	logger stop
]

{ #category : 'accessing' }
StObjectTranscriptPresenter >> windowTitle [ 

	^ 'Object Transcript'
]

{ #category : 'customization' }
StObjectTranscriptPresenter >> withInspectorLayout [
	

	^ SpBoxLayout
		newTopToBottom 
			add: logList ;
			add: zoom ;
		yourself
]

{ #category : 'customization' }
StObjectTranscriptPresenter >> withoutInspectorLayout [
	

	^ SpBoxLayout
		newTopToBottom 
			add: logList ;
		yourself
]
