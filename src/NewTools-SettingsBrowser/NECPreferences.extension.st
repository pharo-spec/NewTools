Extension { #name : 'NECPreferences' }

{ #category : '*NewTools-SettingsBrowser' }
NECPreferences class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #'Code Completion')
		target: self;
		parentName: #codeBrowsing;
		selector: #enabled;
		default: true;
		iconName: #smallConfiguration;
		description: 'Enable or disable code completion in browsers, debuggers and workspaces.';
		with: [
					| availableControllers availableSorters |
					availableControllers := self availableEngines.
					availableControllers size > 1
						ifTrue: [
							(aBuilder pickOne: #completionEngineClass)
								order: -1;
								label: 'CompletionEngine';
								target: RubSmalltalkEditor;
								getSelector: #completionEngineClass;
								setSelector: #completionEngineClass:;
								default: (Smalltalk at: #CoCompletionEngine);
								domainValues: availableControllers ].
					availableSorters := self availableSorters.
					availableSorters size > 1
						ifTrue: [
							(aBuilder pickOne: #completionSorter)
								order: -1;
								label: 'Sorter';
								target: CompletionContext;
								getSelector: #sorterClass;
								setSelector: #sorterClass:;
								domainValues: availableSorters ].
					(aBuilder setting: #backgroundColor)
						default: (Color
							r: 0.823069403714565
							g: 0.823069403714565
							b: 0.823069403714565 alpha: 1.0);
						label: 'Background Color'.
					(aBuilder setting: #useEnterToAccept)
						label: 'Use ENTER to accept a suggested completion';
						default: self defaultUseEnterToAccept.
					(aBuilder setting: #showCompletionDetails)
						label: 'Show completion details';
						description: 'Show detailed information about completion entries';
						default: self defaultShowCompletionDetails.
					(aBuilder setting: #caseSensitive)
						label: 'Case Sensitive';
						default: true;
						description: 'Decide if you want eCompletion to be case sensitive or not.'.
					(aBuilder setting: #smartCharacters)
						label: 'Smart Characters';
						default: true;
						description: 'Decide if you want eCompletion to use smart characters, e.g, to automatically close brackets.'.
					(aBuilder setting: #smartCharactersWithSingleSpace)
						label: 'Smart Characters with Single Space';
						default: '';
				 		description: 'Enumerate the characters which are automatically inserted with a single space in between.'.
					(aBuilder setting: #smartCharactersWithDoubleSpace)
						label: 'Smart Characters with Double Space';
						default: '[]{}';
				 		description: 'Enumerate the characters which are automatically inserted with a two spaces in between.'.
					(aBuilder setting: #popupShowAutomatic)
						default: self defaultPopupShowAutomatic;
						label: 'Popup is automatic'.
					(aBuilder setting: #popupAutomaticDelay)
						default: self defaultPopupDelay;
						label: 'Popup appearance delay'.
					(aBuilder pickOne: #popupShowWithShortcut)
						target: self;
						default: self defaultPopupShortcut;
						label: 'Popup appears with this shortcut';
						domainValues: self availablePopupShortcuts.
					(aBuilder setting: #spaceAfterCompletion)
						target: NECEntry;
						default: self defaultSpaceAfterCompletion;
						label: 'Put a space after completion'
					 ]
]
