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
		'regexpCheckBox',
		'exactCheckBox',
		'caseCheckBox'
	],
	#category : 'NewTools-Finder-Widgets',
	#package : 'NewTools-Finder',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StFinderSearchOptions >> activateAll [
	"Deactivate all the receiver's search options"

	regexpCheckBox enabled: true.
	exactCheckBox enabled: true.
	caseCheckBox enabled: true.
]

{ #category : 'accessing' }
StFinderSearchOptions >> caseCheckBox [

	^ caseCheckBox
]

{ #category : 'initialization' }
StFinderSearchOptions >> deactivateAll [
	"Deactivate all the receiver's search options"

	regexpCheckBox enabled: false.
	exactCheckBox enabled: false.
	caseCheckBox enabled: false.
]

{ #category : 'layout' }
StFinderSearchOptions >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 2;
		add: regexpCheckBox width: 70;
		add: exactCheckBox width: 70;
		add: caseCheckBox width: 70;
		yourself
]

{ #category : 'accessing' }
StFinderSearchOptions >> disableExact [

	exactCheckBox enabled: false.
]

{ #category : 'accessing' }
StFinderSearchOptions >> disableRegex [

	regexpCheckBox enabled: false.
]

{ #category : 'accessing' }
StFinderSearchOptions >> enableExact [

	exactCheckBox enabled: true.
]

{ #category : 'accessing' }
StFinderSearchOptions >> enableRegex [

	regexpCheckBox enabled: true.
]

{ #category : 'accessing' }
StFinderSearchOptions >> exactCheckBox [

	^ exactCheckBox
]

{ #category : 'initialization' }
StFinderSearchOptions >> initializePresenters [

	regexpCheckBox := self newCheckBox 
		label: 'Regexp';
		help: 'Use regular expression';
		yourself.
		
	exactCheckBox := self newCheckBox 
		label: 'Exact';
		help: 'Use exact match';
		yourself.
		
	caseCheckBox := self newCheckBox 
		label: 'Case';
		help: 'Use match case';
		yourself
]

{ #category : 'accessing' }
StFinderSearchOptions >> regexpCheckBox [

	^ regexpCheckBox
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

	exactCheckBox whenActivatedDo: aBlock.

]

{ #category : 'events' }
StFinderSearchOptions >> whenExactDeactivatedDo: aBlock [

	exactCheckBox whenDeactivatedDo: aBlock.
]

{ #category : 'events' }
StFinderSearchOptions >> whenRegexActivatedDo: aBlock [

	regexpCheckBox whenActivatedDo: aBlock
]

{ #category : 'events' }
StFinderSearchOptions >> whenRegexDeactivatedDo: aBlock [

	regexpCheckBox whenDeactivatedDo: aBlock
]
