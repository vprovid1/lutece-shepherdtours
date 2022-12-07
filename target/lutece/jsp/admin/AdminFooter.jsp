<jsp:useBean id="adminFooter" scope="request" class="fr.paris.lutece.portal.web.admin.AdminMenuJspBean" />
<%-- Display the admin footer --%>
<%= adminFooter.getAdminMenuFooter( request ) %>

<%@ include file="TourCheck.jsp" %>

</body>
</html>