Class {
	#name : 'StSettingsAbstracPresenter',
	#superclass : 'SpPresenter',
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StSettingsAbstracPresenter >> settingsTree [
	"Answer the receiver's <StSettingsTree>, the settings model"

	^ self application settingsTree.
]
