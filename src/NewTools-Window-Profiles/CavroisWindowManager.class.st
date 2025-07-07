"
I scan the current windows and build a profile from the presenters or tools inside them. 
A profile is set of window configurations also called place holders.
A place holder is a description of the window on the screen (extent, position, kind, strategy).
A strategy is the way the window will be placed on the screen, such as replace the previous one, stacking...

To fully understand my fonctionnalities, you can:

- Click on 'New Profile' in the Profiles menu.

- Select 'Show/hide current profile' to display visual placeholders of the current profile
( - Left click on one of them allows to change the strategy associated with the window 
  - Right click on one of them to remove a registered window from the current profile ).

- You can update your profile without recreating a new one by using the 'Update current profile' option.

- When selecting an other profile, it becomes the current and all current windows on the screen are moved according to placeholders.

- If you want to reorganize your windows based on your current profile, 'Reset Windows' will do the same behavior said as above.

- Lastly, with 'Export Profile', current profile will be saved in a STON file in the Preferences folder as ""Profile:YourProfileName.ston"".
Any profile can be load with 'Import Profile', make sure your file has 'Profile' in it to work.
A profile can be loaded in the StartUp Preferences files, just add this piece of code in it:   StartupAction
        name: 'Load Profile'
        code: [
			CavroisWindowManager current makeProfileCurrent: profileName
        ].
"
Class {
	#name : 'CavroisWindowManager',
	#superclass : 'Object',
	#instVars : [
		'profiles',
		'classToolMapping',
		'currentProfile',
		'defaultLocation',
		'placeHolderIndices'
	],
	#classVars : [
		'Current'
	],
	#category : 'NewTools-Window-Profiles-Model',
	#package : 'NewTools-Window-Profiles',
	#tag : 'Model'
}

{ #category : 'adding' }
CavroisWindowManager class >> addProfileDeletionItem: aBuilder [
	"Add menu item for deleting a profile"
	(aBuilder item: #'Delete Profile')
		parent: #ProfileAction;
		order: 5;
		action: [ self deleteProfile ];
		help: 'Remove a profile';
		iconName: #trash
]

{ #category : 'adding' }
CavroisWindowManager class >> addProfileHelpItem: aBuilder [

	(aBuilder item: #'Tutorial')
		parent: #ProfileTutorial;
		order: 9;
		action: [ self openTutorial ];
		help: 'Tutorial about profiles';
		iconName: #smallHelp.
]

{ #category : 'adding' }
CavroisWindowManager class >> addProfileImportExportItems: aBuilder [

	(aBuilder item: #'Import Profile')
		parent: #ImportExport;
		order: 7;
		action: [ self loadProfile ];
		help: 'Import a profile';
		iconName: #smallUndo.

	(aBuilder item: #'Export Profile')
		parent: #ImportExport;
		order: 8;
		action: [ self saveProfile: self current defaultLocation];
		help: 'Export a profile';
		iconName: #smallRedo
]

{ #category : 'adding' }
CavroisWindowManager class >> addProfileItem: aBuilder [

	(aBuilder item: #'New Profile')
		parent: #ProfileAction;
		order: 1;
		action: [ self createProfile ];
		help: 'Creates a local profile based on your image';
		iconName: #add
]

{ #category : 'adding' }
CavroisWindowManager class >> addProfileSwitchingItems: aBuilder [

	self current profiles keysDo: [ :k |
		(aBuilder item: k)
			parent: #UserProfiles;
			action: [ self switchToProfile: k ];
			order: 0;
			help: 'Profile';
			iconName: #userProfile ]
]

{ #category : 'adding' }
CavroisWindowManager class >> addProfileVisibilityItem: aBuilder [

	(aBuilder item: #'Show/Hide current profile')
		parent: #ProfileAction;
		order: 3;
		action: [ self toggleProfilePlaceholders ];
		help: 'Show the placeholders of the current profile in the World';
		iconName: #haloView
]

{ #category : 'instance creation' }
CavroisWindowManager class >> createProfile [

	| presenter |
	presenter := SpRequestDialog new
		             title: 'Snapshot Profile';
		             label: 'What is the name of your profile?';
		             text: '';
		             acceptLabel: 'Confirm';
		             cancelLabel: 'Cancel';
		             onAccept: [ :dialog |
				             self current updatePreviousCurrentProfile.
				             self current addProfileFromWindows:
						             dialog presenter text , ' (Current)'.
				             MenubarMorph reset ];
		             openDialog
]

{ #category : 'accessing' }
CavroisWindowManager class >> current [ 

	^ Current ifNil: [ Current := self new ]
]

{ #category : 'deleting' }
CavroisWindowManager class >> deleteProfile [

	| collection presenter |
	self current profiles isNotEmpty ifFalse: [ ^ self ].
	collection := self current profiles keys asOrderedCollection.
	presenter := SpSelectDialog new
		             title: 'Delete profile';
		             label: 'Select the profile you want to remove';
		             items: collection;
		             onAccept: [ :dialog |
			             self removeSelectedProfile:
					             dialog presenter selectedItem.
			             MenubarMorph reset ];
		             openDialog
]

{ #category : 'class initialization' }
CavroisWindowManager class >> initialize [

	SessionManager default registerUserClassNamed: self name
]

{ #category : 'action' }
CavroisWindowManager class >> loadProfile [

	| file profile presenter oldProfile oldKey baseName |
	presenter := StOpenFilePresenter new
		             openFolder:
			             FileLocator preferences asFileReference / 'pharo';
		             title: 'Select Profile to load'.
	presenter okAction: [ :fileReference |
			(fileReference basename includesSubstring: 'Profile')
				ifTrue: [
						file := fileReference.
						profile := STON fromString: file.
						self current currentProfile ifNotNil: [
								oldProfile := self current currentProfile.
								oldKey := self current profiles keyAtValue: oldProfile.
								baseName := oldKey copyReplaceAll: '(Current)' with: ''.
								self current profiles
									at: baseName put: oldProfile;
									removeKey: oldKey ].
						self current profiles
							at:
							(profile name copyReplaceAll: '(Current)' with: '')
							, ' (Current)'
							put: profile.
						self current currentProfile: profile.
						MenubarMorph reset ]
				ifFalse: [ self inform: ' File selected is not a profile' ] ].
	presenter openDialog
]

{ #category : 'open' }
CavroisWindowManager class >> openTutorial [

	<script>
	| presenter |
	presenter := SpTextPresenter new
		             text: self comment;
		             open.

	presenter withWindowDo: [ :w |
		w title: 'Profile Tutorial' translated ]
]

{ #category : 'menu' }
CavroisWindowManager class >> profileMenu: aBuilder [

	<worldMenu>
	(aBuilder item: #Profiles)
		parent: #Windows;
		order: 0;
		help:
			'Profiles lets you define places where your windows will automatically be placed.';
		with: [
			(aBuilder group: #UserProfiles)
				order: 1;
				help: 'Group the user profiles.';
				withSeparatorAfter.
			(aBuilder group: #ProfileAction)
				order: 2;
				help: 'Group the actions for the user profiles.';
				withSeparatorAfter.
			(aBuilder group: #ImportExport)
				order: 3;
				help: 'Actions of import/export of profiles.';
				withSeparatorAfter.
			(aBuilder group: #ProfileTutorial)
				order: 4;
				help: 'Tutorial about profiles' ]
]

{ #category : 'menu items' }
CavroisWindowManager class >> profileMenuItems: aBuilder [

	<worldMenu>
	self
		addProfileSwitchingItems: aBuilder;
		addProfileItem: aBuilder;
		updateProfileItem: aBuilder;
		addProfileDeletionItem: aBuilder;
		addProfileVisibilityItem: aBuilder;
		renameProfileItem: aBuilder;
		resetWindowsToCurrentProfile: aBuilder;
		addProfileImportExportItems: aBuilder;
		addProfileHelpItem: aBuilder
]

{ #category : 'removing' }
CavroisWindowManager class >> removeSelectedProfile: selectedProfileKey [

	self current profiles removeKey: selectedProfileKey.
	self current profiles isEmpty
		ifTrue: [ self current currentProfile: nil ]
		ifFalse: [
		self updateCurrentProfileAfterDeletion: selectedProfileKey ]
]

{ #category : 'action' }
CavroisWindowManager class >> renameProfile [

	| presenter profile |
	presenter := SpSelectDialog new
		             title: 'Rename a profile';
		             label: 'Select the profile you want to rename';
		             items: self current profiles associations;
		             display: [ :each | each key ];
		             onAccept: [ :dialog |
				             profile := dialog presenter selectedItem.
				             dialog presenter delete ].
	presenter openModal.
	profile ifNotNil: [
			presenter := SpRequestDialog new
				             title: 'Rename ' , profile key;
				             label: 'What is the new name of your profile ?';
				             text: '';
				             acceptLabel: 'Confirm';
				             cancelLabel: 'Cancel';
				             onAccept: [ :dialog |
						             self
							             updateProfile: profile
							             withName: dialog presenter text.
						             MenubarMorph reset ];
				             openDialog ]
]

{ #category : 'actions' }
CavroisWindowManager class >> renameProfileItem: aBuilder [

	(aBuilder item: #'Rename profile')
		parent: #ProfileAction;
		order: 4;
		action: [ self current profiles ifNotEmpty: [ self renameProfile ] ];
		help: 'Rename a profile';
		iconName: #edit
]

{ #category : 'class initialization' }
CavroisWindowManager class >> reset [

	<script>
	Current := nil.
	MenubarMorph reset
]

{ #category : 'initialization' }
CavroisWindowManager class >> resetWindowsToCurrentProfile: aBuilder [

	(aBuilder item: #'Reset Windows')
		parent: #ProfileAction;
		order: 6;
		action: [
				self current currentProfile ifNotNil: [
						self current transitionToProfile ] ];
		help:
			'Reset the state of all current windows to their placeHolder state';
		iconName: #refreshCircling
]

{ #category : 'saving' }
CavroisWindowManager class >> saveProfile: aLocation [

	| fileString fileName file saveName |
	self current currentProfile ifNil: [
			self inform: 'No profile registered'.
			^ self ].
	saveName := self current currentProfile name
		            copyReplaceAll: '(Current)'
		            with: ''.
	fileString := STON toString: self current currentProfile.
	fileName := 'Profile:' , saveName trimBoth , '.ston'.
	file := aLocation / fileName.

	file writeStreamDo: [ :stream | stream nextPutAll: fileString ].
	self inform: 'Profile saved !'
]

{ #category : 'system startup' }
CavroisWindowManager class >> startUp: isImageStarting [

	isImageStarting ifTrue: [ self reset ]
]

{ #category : 'actions' }
CavroisWindowManager class >> switchToProfile: profileKey [

	| oldProfile newProfile oldKey newKey baseName presenter |
	self current currentProfile = (self current profiles at: profileKey)
		ifTrue: [ ^ self ].
	presenter := SpConfirmDialog new
		             title: 'Switch Profile';
		             label: profileKey , 'will become the current profile';
		             acceptLabel: 'Confirm';
		             cancelLabel: 'Cancel';
		             onAccept: [ :dialog |
				             oldProfile := self current currentProfile.
				             newProfile := self current profiles at: profileKey.
				             oldKey := self current profiles keyAtValue:
						                       oldProfile.
				             baseName := oldKey
					                         copyReplaceAll: '(Current)'
					                         with: ''.
				             self current profiles
					             at: baseName put: oldProfile;
					             removeKey: oldKey.

				             newKey := profileKey , '(Current)'.
				             self current profiles
					             at: newKey put: newProfile;
					             removeKey: profileKey.
				             self current currentProfile: newProfile.
				             self current transitionToProfile.
				             MenubarMorph reset ];
		             openDialog
]

{ #category : 'actions' }
CavroisWindowManager class >> toggleProfilePlaceholders [

	(World submorphs anySatisfy: [ :morph |
		 morph isKindOf: CavVisualPlaceHolderMorph ])
		ifTrue: [ self current removeVisualPlaceholders ]
		ifFalse: [
				self current currentProfile ifNotNil: [
						| allWindows |
						allWindows := self currentWorld windowsSatisfying: [ :w |
							              w isCollapsed not ].
						self current currentProfile placeHolders do: [ :each |
							each display ].
						allWindows do: [ :w | w hide ] ] ]
]

{ #category : 'updating' }
CavroisWindowManager class >> updateCurrentProfileAfterDeletion: deletedProfileKey [

	| newKey oldKey |
	(deletedProfileKey includesSubstring: 'Current') ifFalse: [ ^ self ].
	oldKey := self current profiles keys first.
	newKey := oldKey , '(Current)'.
	self current profiles
		at: newKey
		put: self current profiles values first.
	self current profiles removeKey: oldKey.
	self current currentProfile: (self current profiles at: newKey)
]

{ #category : 'updating' }
CavroisWindowManager class >> updateProfile [

	self current updateProfile
]

{ #category : 'updating' }
CavroisWindowManager class >> updateProfile: aProfile withName: aName [

	self current profiles removeKey:
		(self current profiles keyAtValue: aProfile value).
	aProfile value named: aName.
	self current currentProfile = aProfile value
		ifTrue: [
		self current profiles at: aName , ' (Current)' put: aProfile value ]
		ifFalse: [ self current profiles at: aName put: aProfile value ]
]

{ #category : 'updating' }
CavroisWindowManager class >> updateProfileItem: aBuilder [

	(aBuilder item: #'Update current profile')
		parent: #ProfileAction;
		order: 2;
		action: [
			self current currentProfile
				ifNil: [ self inform: 'No profile has been created yet' ]
				ifNotNil: [
					self updateProfile.
					self inform: 'Profile has been updated' ] ];
		help:
			'Allows you to register new window(s) in profile or to modify previous ones';
		iconName: #save
]

{ #category : 'recording' }
CavroisWindowManager >> addProfileFromWindows: aProfileName [
	"self new profileFromWindows"

	| profile |
	profile := CavWindowProfile new named: aProfileName.
	self allCurrentWindows do: [ :each |
		profile add: (self placeHolderFromWindow: each) ].
	profiles at: profile name put: profile.
	self currentProfile: profile.
	^ profile
]

{ #category : 'accessing' }
CavroisWindowManager >> allCurrentWindows [

	5 timesRepeat: [ Smalltalk garbageCollect ].
	^ self currentWorld windowsSatisfying: [ :w |
			  (w hasProperty: #isClosed) not and:
				  (w isCollapsed not and: (w isKindOf: SpDialogWindowMorph) not) ]
]

{ #category : 'accessing' }
CavroisWindowManager >> currentProfile [

	^ currentProfile 
]

{ #category : 'accessing' }
CavroisWindowManager >> currentProfile: aProfile [

	currentProfile := aProfile
]

{ #category : 'accessing' }
CavroisWindowManager >> defaultLocation [

	^ defaultLocation
]

{ #category : 'accessing' }
CavroisWindowManager >> defaultLocation: aLocation [

	defaultLocation := aLocation
]

{ #category : 'initialization' }
CavroisWindowManager >> initialize [

	super initialize.
	classToolMapping := Dictionary new.
	defaultLocation := FileLocator preferences asFileReference / 'pharo'.
	placeHolderIndices := Dictionary new.
	ClyBrowserMorph postOpeningBlock: [ :w | self placePresenter: w ].
	self resetProfiles
]

{ #category : 'internals' }
CavroisWindowManager >> kindFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'action' }
CavroisWindowManager >> makeProfileCurrent: aProfileName [

	| profile |
	profile := STON fromString:
		           FileLocator preferences asFileReference / 'pharo'
		           / ('Profile:{1}.ston' format: { aProfileName }).
	self updatePreviousCurrentProfile.
	self profiles at: aProfileName , ' (Current)' put: profile.
	self currentProfile: profile.
	MenubarMorph reset
]

{ #category : 'actions' }
CavroisWindowManager >> nextPlaceHolderIndexFor: aWindowType ifAbsent: aBlock [

	^ placeHolderIndices at: aWindowType ifAbsent: aBlock
]

{ #category : 'recording' }
CavroisWindowManager >> placeHolderFromWindow: aWindowPresenter [ 
	
	| placeHolder |
	placeHolder := CavWindowPlaceHolder new
			extent: aWindowPresenter extent ;
			position: aWindowPresenter bounds origin ;
			yourself.
	placeHolder configureStrategy.
	aWindowPresenter configurePlaceHolder: placeHolder.
	^ placeHolder 
			
]

{ #category : 'operations' }
CavroisWindowManager >> placePresenter: aPresenter [

	| placeHolders windowType nextPlaceHolderIndex |
	self currentProfile ifNotNil: [
			placeHolders := self currentProfile placeHoldersFor:
				                aPresenter class.
			windowType := aPresenter class.
			(placeHolders first isKindOf: CavNullWindowPlaceHolder) ifTrue: [
					placeHolders := self currentProfile placeHoldersFor:
						                aPresenter model class.
					windowType := aPresenter model class ].
			nextPlaceHolderIndex := self
				                        nextPlaceHolderIndexFor: windowType
				                        ifAbsent: [
						                        self
							                        setNextPlaceHolderIndex: 1
							                        for: windowType.
						                        1 ].

			self
				setNextPlaceHolderIndex:
				nextPlaceHolderIndex % placeHolders size + 1
				for: windowType.
			(placeHolders at: nextPlaceHolderIndex) placePresenter: aPresenter ]
]

{ #category : 'accessing' }
CavroisWindowManager >> profileNamed: aString [ 
	"may be a dict should be better"	

	^ profiles at: aString
]

{ #category : 'accessing' }
CavroisWindowManager >> profiles [
	^ profiles ifNil: [ self resetProfiles. profiles ]
]

{ #category : 'removing' }
CavroisWindowManager >> removeVisualPlaceholders [

	World submorphs
		select: [ :morph | morph isKindOf: CavVisualPlaceHolderMorph ]
		thenDo: [ :morph | morph delete ].
	World submorphs
		select: [ :morph |
			morph visible = false and: (morph hasProperty: #isClosed) not ]
		thenDo: [ :morph | morph visible: true ]
]

{ #category : 'internals' }
CavroisWindowManager >> resetProfiles [

	profiles := Dictionary new
]

{ #category : 'initialization' }
CavroisWindowManager >> setNextPlaceHolderIndex: anInteger for: aWindowType [

	placeHolderIndices at: aWindowType put: anInteger.
	^ anInteger
]

{ #category : 'transitions' }
CavroisWindowManager >> transitionToProfile [

	| allWindows |
	allWindows := self currentWorld windowsSatisfying: [ :w |
		              w isCollapsed not and:
			              (w isKindOf: SpDialogWindowMorph) not ].

	self currentProfile placeHolders do: [ :placeHolder |
		allWindows do: [ :w |
			(w model class = placeHolder kind or:
				 w model presenter class = placeHolder kind) ifTrue: [
				w position: placeHolder position.
				w extent: placeHolder extent ] ] ]
]

{ #category : 'update' }
CavroisWindowManager >> updatePreviousCurrentProfile [

	| oldProfile oldKey newKey |
	currentProfile ifNotNil: [
			oldProfile := currentProfile.
			oldKey := profiles keyAtValue: oldProfile.
			newKey := oldKey copyReplaceAll: '(Current)' with: ''.
			profiles
				at: newKey put: oldProfile;
				removeKey: oldKey ]
]

{ #category : 'updating' }
CavroisWindowManager >> updateProfile [

	self currentProfile reset.
	self allCurrentWindows do: [ :each |
		self currentProfile add: (self placeHolderFromWindow: each) ]
]
