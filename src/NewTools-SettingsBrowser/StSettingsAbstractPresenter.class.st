Class {
	#name : 'StSettingsAbstractPresenter',
	#superclass : 'SpPresenter',
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'callbacks' }
StSettingsAbstractPresenter >> newNodePresenterFrom: aSettingNode level: anInteger [

	| nodePresenter |
	
	nodePresenter := self
		                 instantiate: aSettingNode presenterClass
		                 on: aSettingNode.
	nodePresenter sectionTitleStyle: self sectionTitleString , anInteger asString.
	^ nodePresenter
]

{ #category : 'callbacks' }
StSettingsAbstractPresenter >> sectionTitleString [

	^ 'sectionTitleL'
]

{ #category : 'accessing' }
StSettingsAbstractPresenter >> settingsTree [
	"Answer the receiver's <StSettingsTree>, the settings model"

	^ self application settingsTree.
]
