<%@ page errorPage="../ErrorPage.jsp" %>
<jsp:include page="../AdminHeader.jsp" />

<link rel="stylesheet" href="js/shepherd/shepherd.css"/>
<script src="js/shepherd/shepherd.min.js"></script>

<jsp:useBean id="rbac" scope="session" class="fr.paris.lutece.portal.web.rbac.RoleManagementJspBean" />

<% rbac.init( request,  rbac.RIGHT_MANAGE_ROLES ) ; %>
<%= rbac.getManageRoles( request )%>

<%@ include file="../AdminFooter.jsp" %>