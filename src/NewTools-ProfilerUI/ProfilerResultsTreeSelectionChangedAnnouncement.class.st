"
I prevent my subscribers that the selected node in the results tree has changed
"
Class {
	#name : 'ProfilerResultsTreeSelectionChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'item'
	],
	#category : 'NewTools-ProfilerUI-Announcements',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
ProfilerResultsTreeSelectionChangedAnnouncement >> item [
	^ item
]

{ #category : 'accessing' }
ProfilerResultsTreeSelectionChangedAnnouncement >> item: aTallyModel [
	item := aTallyModel
]
