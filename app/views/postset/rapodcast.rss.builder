xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "Random Access Podcast"
		xml.link "http://www.rapodcast.net"
		xml.description "The Random Access Podcast"
		xml.language "en"
		xml.copyright "David Palay and Andy Low 2006-2010"
		
		for thing in @postset_and_post_array
			xml.item do
				xml.guid "#{if thing.class == Post then 'http://www.rapodcast.net/postset/view/' + thing.postset.id.to_s + '/#post_' + thing.id.to_s else 'http://www.rapodcast.net/postset/view/' + thing.id.to_s end}", :isPermaLink => "true" 
				xml.title "#{if thing.class == Post then thing.user.screen_name.to_s + ": " + thing.postset.title.to_s + " - " end}#{thing.title}"
				xml.description thing.content
				xml.pubDate thing.created_at.to_s(:rfc822)
				xml.link "#{if thing.class == Post then 'http://www.rapodcast.net/postset/view/' + thing.postset.id.to_s + '/#post_' + thing.id.to_s else 'http://www.rapodcast.net/postset/view/' + thing.id.to_s end}"
				if thing.class == Postset
					xml.enclosure :url => "http://www.rapodcast.net/podcasts/#{thing.podcast_link}".gsub(" ", "%20"), :length => "0", :type => "audio/x-mpeg"
				end
			end
		end
	end
end