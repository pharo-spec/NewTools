"
I am a widget for the ̀Finder̀ tool. I contain all widgets regarding the search options.

### Matching regular expressions

The ""Match Regular Expression"" checkbox and the ""Match Exact"" checkboxes in the search bar are mutually exclusive. This means that only one of them can be selected at a time. The reason behind this is that both checkboxes serve different purposes and using them simultaneously could lead to contradictory results.

- The ""Match Regular Expression"" checkbox allows users to enter a regular expression (regex) in the search bar. Regex is a powerful tool for pattern matching in strings. For example, if you want to find all words that start with `a`, you could use the regex `^a`.
- On the other hand, the ""Match Exact"" checkbox would cause the search to return only those entries that exactly match the search string.

If both options were allowed to be selected at the same time, it would create confusion and potentially incorrect results. For instance, if a user enters '^a' in the search bar with the ""Match Exact"" checkbox selected, the system would try to find entries that exactly match the regex ^a, which doesn't make sense.

Therefore, to avoid such situations, it's best to keep these two checkboxes mutually exclusive.

### Matching case 

The ""Match Case"" checkbox in a search bar is NOT mutually exclusive with either the ""Match Regular Expression"" or the ""Match Exact"" checkboxes. These checkboxes can be selected together without causing contradictory results. 

- The ""Match Regular Expression"" checkbox allows users to enter a regular expression (regex) in the search bar. The ""Match Case"" checkbox modifies this behavior by making the regex case-sensitive, meaning it distinguishes between uppercase and lowercase letters. So, if you use a regex that includes a case-specific pattern, selecting the ""Match Case"" checkbox will ensure that the search results match that specific case.
-  Similarly, the ""Match Exact"" checkbox causes the search to return only those entries that exactly match the search string. The ""Match Case"" checkbox can be used alongside this to control whether the exact match is case-sensitive. If the ""Match Case"" checkbox is selected, the search will look for an exact match including case. If it's not selected, the search will ignore case.

So, the ""Match Case"" checkbox can be used with either the ""Match Regular Expression"" or the ""Match Exact"" checkbox, depending on whether you want to perform a case-sensitive search with a regex or an exact string.


"
Class {
	#name : 'StFinderSearchOptions',
	#superclass : 'SpPresenter',
	#instVars : [
		'exactRadioButton',
		'caseCheckBox',
		'substringRadioButton',
		'regexRadioButton'
	],
	#category : 'NewTools-Finder-Widgets',
	#package : 'NewTools-Finder',
	#tag : 'Widgets'
}

{ #category : 'accessing' }
StFinderSearchOptions >> caseCheckBox [

	^ caseCheckBox
]

{ #category : 'layout' }
StFinderSearchOptions >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  spacing: 2;
		  add: substringRadioButton width: 95;
		  add: regexRadioButton width: 70;
		  add: exactRadioButton width: 70;
		  add: caseCheckBox width: 70;
		  yourself
]

{ #category : 'initialization' }
StFinderSearchOptions >> disable [
	"Deactivate all the receiver's search options"

	regexRadioButton enabled: false.
	exactRadioButton enabled: false.
	caseCheckBox enabled: false.
	substringRadioButton enabled: false
]

{ #category : 'initialization' }
StFinderSearchOptions >> enable [
	"Activate all the receiver's search options"

	regexRadioButton enabled: true.
	exactRadioButton enabled: true.
	caseCheckBox enabled: true.
	substringRadioButton enabled: true
]

{ #category : 'accessing' }
StFinderSearchOptions >> exactRadioButton [

	^ exactRadioButton
]

{ #category : 'initialization' }
StFinderSearchOptions >> initializePresenters [

	regexRadioButton := self newRadioButton
		                    label: 'Regex';
		                    help: 'Use regular expression';
		                    yourself.

	exactRadioButton := self newRadioButton
		                    label: 'Exact';
		                    help: 'Use exact match';
		                    yourself.

	substringRadioButton := self newRadioButton
		                        label: 'Substring';
		                        help: 'Use substring search';
		                        yourself.

	substringRadioButton associatedRadioButtons: {
			regexRadioButton.
			exactRadioButton }.

	caseCheckBox := self newCheckBox
		                label: 'Case';
		                help: 'Use match case';
		                yourself
]

{ #category : 'accessing' }
StFinderSearchOptions >> regexRadioButton [

	^ regexRadioButton
]

{ #category : 'accessing' }
StFinderSearchOptions >> substringRadioButton [

	^ substringRadioButton
]

{ #category : 'events' }
StFinderSearchOptions >> whenCaseActivatedDo: aBlock [

	caseCheckBox whenActivatedDo: aBlock.

]

{ #category : 'events' }
StFinderSearchOptions >> whenCaseDeactivatedDo: aBlock [

	caseCheckBox whenDeactivatedDo: aBlock.

]

{ #category : 'events' }
StFinderSearchOptions >> whenExactActivatedDo: aBlock [

	exactRadioButton whenActivatedDo: aBlock
]

{ #category : 'events' }
StFinderSearchOptions >> whenExactDeactivatedDo: aBlock [

	exactRadioButton whenDeactivatedDo: aBlock
]

{ #category : 'events' }
StFinderSearchOptions >> whenRegexActivatedDo: aBlock [

	regexRadioButton whenActivatedDo: aBlock
]

{ #category : 'events' }
StFinderSearchOptions >> whenRegexDeactivatedDo: aBlock [

	regexRadioButton whenDeactivatedDo: aBlock
]

{ #category : 'events' }
StFinderSearchOptions >> whenSubstringActivatedDo: aBlock [

	substringRadioButton whenActivatedDo: aBlock
]

{ #category : 'events' }
StFinderSearchOptions >> whenSubstringDeactivatedDo: aBlock [

	substringRadioButton whenDeactivatedDo: aBlock
]
