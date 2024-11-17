Class {
	#name : 'StSettingsExporter',
	#superclass : 'Object',
	#instVars : [
		'groupSize',
		'basename'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'export' }
StSettingsExporter >> application [

	^ StPharoApplication current
	
]

{ #category : 'accessing' }
StSettingsExporter >> basename [

	^ basename
]

{ #category : 'accessing' }
StSettingsExporter >> basename: anObject [

	basename := anObject
]

{ #category : 'export' }
StSettingsExporter >> defaultBasename [
	"Answer a <String> with the file where settings will be stored"

	^ self settingsFileReference basename
]

{ #category : 'export' }
StSettingsExporter >> defaultGroupSize [

	^ 50
]

{ #category : 'export' }
StSettingsExporter >> exportAllSettings: actions [
	"Export all settings in files. No more than groupSize settings will be exported to the same file. 
	If there are more than groupSize settings, settings will be exported in multiple files 
	(named aString%d.st, with %d a number increasing from 1 to (actions size / groupSize)."

	| index |
	index := 1.
	actions
		groupsOf: self groupSize
		atATimeDo: [ :setting |
			self exportSettings: setting toFileNamed: (self settingsIndex: index fileNamed: self basename).
			index := index + 1 ].
	self
		exportSettings: (actions last: (actions size rem: self groupSize))
		toFileNamed: (self settingsIndex: index fileNamed: self basename)
]

{ #category : 'export' }
StSettingsExporter >> exportSettings: aCollection toFileNamed: filename [
	StartupPreferencesLoader default addAtStartupInPreferenceVersionFolder: aCollection named: filename
]

{ #category : 'export' }
StSettingsExporter >> exportedFileFullName [
	"Answer a <String> with the file where settings will be stored"

	^ self settingsFileReference fullName
]

{ #category : 'export' }
StSettingsExporter >> groupSize [ 

	^ groupSize
]

{ #category : 'accessing' }
StSettingsExporter >> groupSize: anObject [

	groupSize := anObject
]

{ #category : 'initialization' }
StSettingsExporter >> initialize [ 

	super initialize.
	groupSize := self defaultGroupSize.
	basename := self defaultBasename
]

{ #category : 'export' }
StSettingsExporter >> settingsFileReference [

	^ self settingsTree settingsFileReference
]

{ #category : 'export' }
StSettingsExporter >> settingsIndex: index fileNamed: aString [

	^ aString , index printString , '.st'
]

{ #category : 'export' }
StSettingsExporter >> settingsTree [
	"Answer the receiver's <StSettingsTree>, the settings model"

	^ self application propertyAt: #settingsTree.
]
