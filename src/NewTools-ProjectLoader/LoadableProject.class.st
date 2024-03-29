"
I represent the metadata of a loadable project.
These projects are selected by the Pharo contributors and the selected versions are guarantee to work with the current image.

This projects holds the metadata to show to the users, to recover the readme from the GitHub project and to load it using metacello.
"
Class {
	#name : 'LoadableProject',
	#superclass : 'Object',
	#instVars : [
		'name',
		'repository',
		'version',
		'group',
		'baselineName',
		'description',
		'summary'
	],
	#category : 'NewTools-ProjectLoader',
	#package : 'NewTools-ProjectLoader'
}

{ #category : 'instance creation' }
LoadableProject class >> allProjects [ 
	
	^ { 	self new
				name: 'Microdown';
				baselineName: 'Microdown';
				repository: 'pillar-markup/Microdown';
				version: 'v1.0.4';
				group: #default;
				yourself. 
			self new 
				name: 'Roassal3.0';
				baselineName: 'Roassal3';				
				repository: 'ObjectProfile/Roassal3';
				version: 'af26a56ba8f7c0211894c0d2b5a7cd7ab421fc24';
				summary: 'Roassal is cool. Many classes, but good';
				group: #( 'Core' 'Tests');
				yourself}
]

{ #category : 'instance creation' }
LoadableProject class >> named: aString [

	^ self new name: aString; yourself
]

{ #category : 'accessing' }
LoadableProject >> baselineName [
	
	^ baselineName
]

{ #category : 'accessing' }
LoadableProject >> baselineName: aString [
 
	baselineName := aString
]

{ #category : 'accessing' }
LoadableProject >> description [

	^ description ifNil: [ description := self fetchDescription ]
]

{ #category : 'private' }
LoadableProject >> fetchDescription [

	| request |
	request := ZnEasy get: self readMeUrl.
	
	^ request isError
		ifTrue: [ nil ]
		ifFalse: [ request contents ]
]

{ #category : 'accessing' }
LoadableProject >> group [
	^ group
]

{ #category : 'accessing' }
LoadableProject >> group: anObject [
	group := anObject
]

{ #category : 'actions' }
LoadableProject >> load [

	Metacello new
		baseline: self baselineName;
		repository: self repositoryWithVersion;
		load: self group.
]

{ #category : 'accessing' }
LoadableProject >> name [
	^ name
]

{ #category : 'accessing' }
LoadableProject >> name: anObject [
	name := anObject
]

{ #category : 'private' }
LoadableProject >> readMeUrl [

	^ ('https://raw.githubusercontent.com/{1}/{2}/README.md' format: { repository. version }) asUrl
]

{ #category : 'accessing' }
LoadableProject >> repository [
	^ repository
]

{ #category : 'accessing' }
LoadableProject >> repository: aRepository [

	repository := aRepository 
]

{ #category : 'accessing' }
LoadableProject >> repositoryWithVersion [
	
	^ 'github://' , self repository , ':' , self version 
]

{ #category : 'accessing' }
LoadableProject >> summary [
	^ summary
]

{ #category : 'accessing' }
LoadableProject >> summary: anObject [
	summary := anObject
]

{ #category : 'accessing' }
LoadableProject >> version [
	^ version
]

{ #category : 'accessing' }
LoadableProject >> version: anObject [
	version := anObject
]
