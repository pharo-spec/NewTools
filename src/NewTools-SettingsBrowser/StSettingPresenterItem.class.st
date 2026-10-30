"
It represents a wrapper for an individual setting presenter to provide a more customized presentation in the settings browser. Subclasses may override accordingly to the ""type"" of value to set. For example, this class provides a label and a description presenters, but subclasses may also add a Number or Float presenter for the value to set (see `StSettingNumberPresenterItem` for details).

Subclasses may want to override `#value:` to abstract the way the wrapped presenter is configured, so instead of sending `#number:` or `#text:` clients can use directly `#value:`

The wrapped presenter is hold in `setterPresenter` instance variable.

Showing the setting value in the wrapped presenter must not write it back to the setting (see `#withoutUpdatingSettingDo:`): the setter of a setting may have side effects (e.g. the font size resets all the fonts).
"
Class {
	#name : 'StSettingPresenterItem',
	#superclass : 'SpPresenter',
	#instVars : [
		'setterPresenter',
		'model',
		'labeledPresenter',
		'pagePresenter',
		'shouldUpdateSetting'
	],
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'layout' }
StSettingPresenterItem >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: labeledPresenter;
		yourself
]

{ #category : 'setting value' }
StSettingPresenterItem >> hasTarget [
	
	^ self settingReceiver isNotNil
]

{ #category : 'accessing' }
StSettingPresenterItem >> headerStyle [

	^ 'header', (self settingStyle allButFirst: 4) "remove 'item'"
]

{ #category : 'accessing' }
StSettingPresenterItem >> help: aString [ 

	"To update the pop-up help"
	self setterPresenter help: aString.
	"To update the 'documentation' pane"
	"self pagePresenter hovering: aString"
]

{ #category : 'initialization' }
StSettingPresenterItem >> initialize [
	"Set shouldUpdateSetting before super initializes the presenters: they may already show the setting value"

	shouldUpdateSetting := true.
	super initialize
]

{ #category : 'initialization' }
StSettingPresenterItem >> initializePresenters [
	"Set a label and description presenters as baseline for every setting"

	self addStyle: self settingStyle.

	labeledPresenter := (self instantiate: self labeledPresenterClass on: self) 
		label: self model label;
		input: self setterPresenter;
		description: self model description;
		yourself
]

{ #category : 'initialization' }
StSettingPresenterItem >> labeledPresenterClass [

	^ StLabeledSettingPresenter

]

{ #category : 'accessing' }
StSettingPresenterItem >> model [

	^ model
]

{ #category : 'accessing' }
StSettingPresenterItem >> pagePresenter [

	^ pagePresenter
]

{ #category : 'accessing' }
StSettingPresenterItem >> pagePresenter: aPresenter [

	pagePresenter := aPresenter
]

{ #category : 'accessing - model' }
StSettingPresenterItem >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : 'setting value' }
StSettingPresenterItem >> setSelector [

	^ self model setSelector

	
]

{ #category : 'accessing' }
StSettingPresenterItem >> setterPresenter [

	^ setterPresenter
]

{ #category : 'accessing' }
StSettingPresenterItem >> setterPresenter: anObject [

	setterPresenter := anObject
]

{ #category : 'setting value' }
StSettingPresenterItem >> settingReceiver [
	"Answer the object that holds the setting value. It may be inherited from a parent group"

	^ self model settingReceiver
]

{ #category : 'accessing' }
StSettingPresenterItem >> settingStyle [

	^ self subclassResponsibility
]

{ #category : 'testing' }
StSettingPresenterItem >> shouldUpdateSetting [
	"Answer whether a change of my setter presenter must be written to the setting"

	^ shouldUpdateSetting
]

{ #category : 'setting value' }
StSettingPresenterItem >> updateSetting: anObject [

	self settingReceiver perform: self setSelector with: anObject
]

{ #category : 'accessing' }
StSettingPresenterItem >> value: anObject [ 
	"Set the receiver's value to anObject"

	self subclassResponsibility
]

{ #category : 'setting value' }
StSettingPresenterItem >> withoutUpdatingSettingDo: aBlock [
	"Evaluate aBlock without writing to the setting the changes it makes to my setter presenter, e.g. when showing the setting value"

	shouldUpdateSetting := false.
	aBlock ensure: [ shouldUpdateSetting := true ]
]
