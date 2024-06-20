Class {
	#name : 'StSettingsAbstractPresenter',
	#superclass : 'SpPresenter',
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StSettingsAbstractPresenter >> settingsTree [
	"Answer the receiver's <StSettingsTree>, the settings model"

	^ self application settingsTree.
]
