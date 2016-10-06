 //https://en.wikipedia.org/wiki/Immediately-invoked_function_expression
 (function () {
        window.Web = window.Web || {};
        window.Web.Feeds = {
            Initialize: initialize
        };

        var client = null;
        var context = null;
        var chatterApi = '/v36.0/chatter';
        var chatterCommunityApi = '/v36.0/connect/communities/%communityId%/chatter';
        var page = null;
        var userId = null;
        var atMentions = [];
        var groupFeeds = [];
        var groupsCount = 0;
        var counter = 0;

        var selectors = {
            Context: '.chatter-container',
            Feeds: '.feeds'
        };

        //Chatter REST API Developer Guide
        //https://developer.salesforce.com/docs/atlas.en-us.200.0.chatterapi.meta/chatterapi

        function initialize() {
            //Setup dom selects
            context = $(selectors.Context);
            page = {
                Feeds: context.find(selectors.Feeds)
            };

            userId = currentUserId;
            client = new forcetk.Client();
            client.setSessionToken(sessionId, null, null, baseUrl);
            chatterApi = chatterCommunityApi.replace('%communityId%', communityID);
            populateGroupFeeds();
        }

        function populateGroupFeeds() {
            getGroups(function(groups) {
                groupsCount = groups.length;
                getGroupFeeds(groups);
            });
        }

        function getGroups(callback) {
            var groups = [];
            client.ajax(chatterApi + '/groups/', function(result) {
                for (var groupIndex = 0; groupIndex < result.groups.length; groupIndex++) {
                    var group = result.groups[groupIndex];
                    if (group.myRole === 'StandardMember' || group.myRole === 'GroupOwner') {
                        groups.push(group);
                    }
                }

                callback(groups);
            });
        }

        function getGroupFeeds(groups) {
            if(counter < groups.length) {
                client.ajax(chatterApi + '/feeds/record/' + groups[counter].id + '/feed-elements', function(result) {
                    if (result.elements.length > 0) {
                        groupFeeds.push(result);
                    }
                    buildGroupFeeds(result);
                    counter++;
                    getGroupFeeds(groups);
                });
            }
        }

        function buildGroupFeeds(feeds) {
			var source = $( "#feed-template" ).html();
			Handlebars.registerPartial("commentsList", $("#comments-template").html());
			var template = Handlebars.compile(source);
			var feedItems = {items: fillFeedsTemplate(feeds)};
			var output = template(feedItems);
			if(page.Feeds.html() === '') {
			    page.Feeds.html(output);
            } else {
			    page.Feeds.append(output);
            }
        }

        function fillFeedsTemplate(json) {
            var tempItems = [];
            var feedItem = null;
            var feedItemText = null;
            var headerText = null;
            var commentText = null;
            var elements = null;
            if(json.elements === undefined) {
                elements = json;
            } else {
                elements = json.elements
            }
            for (var i = 0; i < elements.length; i++) {
                var item = null;
                var capabilities = null;
                feedItemText = '';
                headerText = '';
                item = elements[i];
                if(item.feedElementType !== 'FeedItem') {
                    continue;
                }
                if (item !== undefined && item !== null) {
                    capabilities = item.capabilities;

                    for (var h = 0; h < item.header.messageSegments.length; h++) {
                        var headerMessageSegment = item.header.messageSegments[h];

                        if(headerMessageSegment.type === 'EntityLink')
                        {
                            headerText += '<a href="" class="header-tag">' + headerMessageSegment.text + '</a>';
                        } else {
                            headerText += headerMessageSegment.text;
                        }
                    }

                    for (var q = 0; q < item.body.messageSegments.length; q++) {
                        var messageSegment = item.body.messageSegments[q];

                        if(messageSegment.type === 'Mention' && messageSegment.accessible === true)
                        {
                            feedItemText += '<a href="" class="mention-tag">' + messageSegment.text + '</a>';
                        } else {
                            feedItemText += messageSegment.text;
                        }
                    }

                    feedItem = {photoUrl: location.origin + item.photoUrl,
                                displayname: headerText,
                                feedItemText: feedItemText,
                                releativeCreatedDate: item.relativeCreatedDate,
                                comments: []};
                }

                if (item.capabilities.comments.page.items.length > 0) {
                    var comments = item.capabilities.comments.page;
                    for (var j = 0; j < comments.items.length; j++) {
                        var commentItem = comments.items[j];
                        commentText = '';

                        for (var c = 0; c < commentItem.body.messageSegments.length; c++) {
                            var commentMessageSegment = commentItem.body.messageSegments[c];

                            if(commentMessageSegment.type === 'Mention' && commentMessageSegment.accessible === true)
                            {
                                commentText += '<a href="" class="mention-tag">' + commentMessageSegment.text + '</a>';
                            } else {
                                commentText += commentMessageSegment.text;
                            }
                        }

                        feedItem.comments.push({photoUrl: commentItem.user.photo.smallPhotoUrl,
                                                displayname: commentItem.user.name,
                                                feedItemText: commentText,
                                                releativeCreatedDate: commentItem.relativeCreatedDate});
                    }
                }
                if (feedItem !== null) {
                    tempItems.push(feedItem);
                }
            }

            return tempItems;
        }
    }());

    $(document).ready(function () {
        Web.Feeds.Initialize();
    });