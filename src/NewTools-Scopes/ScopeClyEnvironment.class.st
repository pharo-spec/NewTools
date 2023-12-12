"
I an environment to be used when browsing scopes on Calypso
"
Class {
	#name : 'ScopeClyEnvironment',
	#superclass : 'Object',
	#instVars : [
		'environment',
		'name',
		'packageOrganizer',
		'projectManager',
		'scope',
		'changesAnnouncer'
	],
	#category : 'NewTools-Scopes-Calypso',
	#package : 'NewTools-Scopes',
	#tag : 'Calypso'
}

{ #category : 'converting' }
ScopeClyEnvironment >> asGlobalScopeIn: aNavigationEnvironment [ 

	^ClySystemEnvironmentScope of: self in: aNavigationEnvironment named: name
]

{ #category : 'accessing' }
ScopeClyEnvironment >> changesAnnouncer: anObject [
	changesAnnouncer := anObject
]

{ #category : 'class management' }
ScopeClyEnvironment >> definedClassesInPackage: aRPackage [ 
	"ToDo: Consider orphan classes"
	^ aRPackage definedClasses
]

{ #category : 'accessing' }
ScopeClyEnvironment >> environment [

	^ environment
]

{ #category : 'accessing' }
ScopeClyEnvironment >> environment: anObject [

	environment := anObject
]

{ #category : 'method management' }
ScopeClyEnvironment >> extensionMethodsInPackage: aRBPackage [

 	^ aRBPackage extensionMethods
]

{ #category : 'accessing' }
ScopeClyEnvironment >> name [
	^ 'aScopeEnv (',scope label, ')'
]

{ #category : 'accessing' }
ScopeClyEnvironment >> packageOrganizer1 [

	^ packageOrganizer
]

{ #category : 'accessing' }
ScopeClyEnvironment >> packageOrganizer: anObject [

	packageOrganizer := anObject
]

{ #category : 'accessing' }
ScopeClyEnvironment >> packages [
	^ scope packages
]

{ #category : 'accessing' }
ScopeClyEnvironment >> projectManager [

	^ projectManager
]

{ #category : 'accessing' }
ScopeClyEnvironment >> projectManager: anObject [

	projectManager := anObject
]

{ #category : 'accessing' }
ScopeClyEnvironment >> scope: aRBEnvironment [ 
	scope := aRBEnvironment
]

{ #category : 'system changes' }
ScopeClyEnvironment >> subscribe: aClyNavigationEnvironment [

	self subscribe: aClyNavigationEnvironment for: SystemAnnouncement
]

{ #category : 'initialization' }
ScopeClyEnvironment >> subscribe: anObject for: anAnnouncementClass [
	
	self when: anAnnouncementClass send: #systemChanged: to: anObject.
	
]

{ #category : 'initialization' }
ScopeClyEnvironment >> unsubscribe: anObject [
	changesAnnouncer unsubscribe: anObject
]

{ #category : 'announcer' }
ScopeClyEnvironment >> when: anAnnouncementClass send: aSelector to: anObject [
	changesAnnouncer weak  when: anAnnouncementClass send: aSelector to: anObject
]
