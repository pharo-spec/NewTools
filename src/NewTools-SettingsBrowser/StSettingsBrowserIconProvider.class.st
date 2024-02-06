"
Provides icons for the Settings Browser. Icons that are requested but not found will be redirected to the superclass (currently the default Pharo icon provider).

It is used by `StSettingsApplication`.

"
Class {
	#name : 'StSettingsBrowserIconProvider',
	#superclass : 'SpPharoThemeIconProvider',
	#category : 'NewTools-SettingsBrowser-IconProvider',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'IconProvider'
}

{ #category : 'accessing' }
StSettingsBrowserIconProvider >> iconNamed: aName ifAbsent: aBlock [
	"Answer a <Form> representing an icon named aName. Execute aBlock if not found"
	
	(aName isNil or: [ (StSettingIcons respondsTo: aName) not ])
		ifTrue: [ ^ aBlock value ].

	 ^ StSettingIcons perform: aName
]
