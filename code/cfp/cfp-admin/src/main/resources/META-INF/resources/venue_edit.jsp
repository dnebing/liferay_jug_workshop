<%@ include file="/META-INF/resources/init.jspf" %>

<%
	String namespace = CFPAdminPortletKeys.CFP_ADMIN;
	long venueId = ParamUtil.getLong(request, "venueId");
	Venue venue = null;
	if (venueId > 0) {
		venue = VenueLocalServiceUtil.getVenue(venueId);
	}
%>

<div class="container-fluid-1280 main-content-body">

	<aui:form action="<%= saveVenueURL %>" name="fm">
	
	        <aui:model-context bean="<%= venue %>" model="<%= Venue.class %>" />
	
	        <aui:input 
	        	type="hidden" 
	        	name="venueId"
	            value='<%= venue == null ? "" : venue.getVenueId() %>' />
	
			<%--
				The venue fields 
			 --%>
	        <aui:fieldset>
	             <aui:input name="name" />
	             <aui:input name="address" />
	             <aui:input id="lat" name="latitude" />
	             <aui:input id="lng" name="longitude" />
	        </aui:fieldset>

			<%--
				Display a map to select venue location
			 --%>
			<liferay-map:map-display 
				geolocation="true"
				latitude="<%= venue == null ? 42.66677500000001 : venue.getLatitude() %>"
				longitude="<%= venue == null ? 23.352276999999958 : venue.getLongitude() %>"
				name="venueMap"
			/>
	
			<%--
				Finally the "Save" and "Cancel" buttons
			 --%>
	        <aui:button-row>
	             <aui:button type="submit" />
	             <aui:button onClick="<%= venuesURL %>" type="cancel"  />
	        </aui:button-row>
	</aui:form>
	
	<%--
		Some JavaScript to configure the map
	 --%>
	<aui:script use="liferay-map-common">
		var configureMap = function() {
		    if (typeof Liferay.MapBase !== 'undefined') {
 				Liferay.MapBase.get('_<%=namespace %>_venueMap', function(map){
					map.on('positionChange', function (event) {
						if (typeof event.newVal.address !== 'undefined') {
							document.getElementById('_<%=namespace %>_address').value = event.newVal.address;
						}
						if (typeof event.newVal.location !== 'undefined') {
							document.getElementById('_<%=namespace %>_lat').value = event.newVal.location.lat;
							document.getElementById('_<%=namespace %>_lng').value = event.newVal.location.lng;
						}
					});
				});
		    } else {
		    	setTimeout(function () {configureMap()}, 500);
		    }
		};
		
		configureMap();
	</aui:script>

</div>