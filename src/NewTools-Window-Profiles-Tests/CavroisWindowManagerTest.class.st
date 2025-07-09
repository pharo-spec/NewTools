Class {
	#name : 'CavroisWindowManagerTest',
	#superclass : 'TestCase',
	#instVars : [
		'manager',
		'virtualFS',
		'systemWindow',
		'presenter',
		'profile',
		'placeHolder'
	],
	#category : 'NewTools-Window-Profiles-Tests',
	#package : 'NewTools-Window-Profiles-Tests'
}

{ #category : 'running' }
CavroisWindowManagerTest >> setUp [

	super setUp.
	CavroisWindowManager reset.
	virtualFS := FileSystem memory root.
	manager := CavroisWindowManager current.
	profile := CavWindowProfile new.
	placeHolder := CavWindowPlaceHolder new
		               position: 10 @ 10;
		               extent: 10 @ 10.
	manager currentProfile: profile.
	systemWindow := SystemWindow new.
	presenter := IceTipRepositoriesBrowser new
]

{ #category : 'running' }
CavroisWindowManagerTest >> tearDown [

	CavroisWindowManager reset.

	super tearDown
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testAddProfileFromWindows [

	| profile |
	profile := manager addProfileFromWindows: 'Profile'.

	self assert: (manager profiles includesKey: 'Profile').
	self assert: manager currentProfile equals: profile
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testCurrentProfile [

	manager addProfileFromWindows: 'Profile'.
	self assert: manager currentProfile name equals: 'Profile'
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testDeleteProfile [

	manager addProfileFromWindows: 'ProfileToKeep'.
	manager addProfileFromWindows: 'ProfileToDelete'.

	manager class removeSelectedProfile: 'ProfileToDelete'.

	self deny: (manager profiles includesKey: 'ProfileToDelete').
	self assert: (manager profiles includesKey: 'ProfileToKeep')
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testGridCellsInitialization [

	manager cellSize: 4.
	manager createPlaceHolderGrid: manager cellSize.
	self assert: manager cells size equals: 16
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testPlaceHoldersStockTheirWindows [

	systemWindow configurePlaceHolder: placeHolder.
	profile add: placeHolder.
	manager placePresenter: systemWindow.
	self assert: placeHolder windows size equals: 1
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testPlacePresenterWithSystemWindowAlreadyPresent [
	"here we add the window so it is already included"

	systemWindow configurePlaceHolder: placeHolder.
	profile add: placeHolder.
	placeHolder windows add: systemWindow. 
	"so this add there wont work"
	manager placePresenter: systemWindow.
	self assert: placeHolder windows size equals: 1
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testRemoveGridDeletePlaceholders [

	manager cellSize: 4.
	manager createPlaceHolderGrid: manager cellSize.
	manager class removeGrid.
	self assert: manager cells size equals: 0
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testRemovingCurrentProfileUpdateCurrentProfile [

	manager addProfileFromWindows: 'Profile1'.
	manager addProfileFromWindows: 'Profile2'.
	"adding Current so the method called gets tricked"
	manager addProfileFromWindows: 'Profile3(Current)'.

	CavroisWindowManager removeSelectedProfile: 'Profile3(Current)'.
	self assert: manager currentProfile name equals: 'Profile1'
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testRemovingLastProfileUpdateCurrentProfile [

	manager addProfileFromWindows: 'Profile1'.
	manager class removeSelectedProfile:
		manager profiles keys first.

	self assert: manager profiles isEmpty.
	self assert: manager currentProfile isNil
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testSaveProfile [

	| profile fileRef |
	profile := manager addProfileFromWindows: 'Test'.
	fileRef := virtualFS / 'Profile:Test.ston'.

	manager class saveProfile: virtualFS.

	self assert: fileRef exists.
	fileRef ensureDelete
]
