Class {
	#name : 'StSettingsChanged',
	#superclass : 'Announcement',
	#instVars : [
		'setting',
		'value'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'accessing' }
StSettingsChanged >> aspect: aThemeSettings value: aColor [ 

	setting := aThemeSettings.
	value := aColor.
]
