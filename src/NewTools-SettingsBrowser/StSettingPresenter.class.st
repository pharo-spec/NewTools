"
This is an abstract class which provides a model and a title for subclasses, along with basic initializers.

Each of the subclasses will be instantiated with a model, represented by an instance of `StSettingNode`.
Subclasses are presenters ""types"" for specific setting nodes, for instance, nodes for final settings, sections for setting containers.


"
Class {
	#name : 'StSettingPresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'title',
		'settingNode'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'instance creation' }
StSettingPresenter class >> with: aPragmaSetting [ 
	^ self subclassResponsibility
]

{ #category : 'initialization' }
StSettingPresenter >> initializePresenters [

	title := self newLabel label: settingNode label. 
]

{ #category : 'printing' }
StSettingPresenter >> printOn: aStream [

	super printOn: aStream.
	aStream 
		<< ' [';
		<< self title asString;
		<< ']'
]

{ #category : 'initialization' }
StSettingPresenter >> sectionTitle [

	^ title
]

{ #category : 'initialization' }
StSettingPresenter >> sectionTitleStyle: aString [

	self sectionTitle addStyle: aString
]

{ #category : 'accessing - model' }
StSettingPresenter >> setModelBeforeInitialization: aModel [

	settingNode := aModel

]

{ #category : 'accessing' }
StSettingPresenter >> updateHelp: aString [ 

	self owner owner owner
		updateSetting: settingNode declaration label 
		helpText: aString.
]
